//
//  PNMSStoreInfoView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreInfoView.h"
#import "PNInfoView.h"
#import "PNMSStoreManagerViewModel.h"
#import "SASingleImageCollectionViewCell.h"
#import "YBImageBrowser.h"


@interface PNMSStoreInfoView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView;
@property (nonatomic, strong) SALabel *pageLabel;
@property (nonatomic, strong) PNInfoView *storeStatusInfoView;
@property (nonatomic, strong) PNInfoView *storeNumInfoView;
@property (nonatomic, strong) PNInfoView *storePhoneInfoView;
@property (nonatomic, strong) PNInfoView *storeTimeInfoView;
@property (nonatomic, strong) PNInfoView *storeAddressInfoView;
@property (nonatomic, strong) PNOperationButton *editBtn;
@property (nonatomic, strong) PNMSStoreManagerViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNMSStoreInfoView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.storeInfoModel)) {
            PNMSStoreInfoModel *infoModel = self.viewModel.storeInfoModel;

            self.storeStatusInfoView.model.valueText = infoModel.statusStr;
            [self.storeStatusInfoView setNeedsUpdateContent];

            self.storeNumInfoView.model.valueText = infoModel.storeNo;
            [self.storeNumInfoView setNeedsUpdateContent];

            self.storePhoneInfoView.model.valueText = infoModel.storePhone;
            [self.storePhoneInfoView setNeedsUpdateContent];

            self.storeTimeInfoView.model.valueText = [NSString stringWithFormat:@"%@ - %@", infoModel.businessHoursStart, infoModel.businessHoursEnd];
            [self.storeTimeInfoView setNeedsUpdateContent];

            self.storeAddressInfoView.model.valueText = infoModel.address;
            self.storeAddressInfoView.model.valueNumbersOfLines = 0;
            [self.storeAddressInfoView setNeedsUpdateContent];

            [self.dataSource removeAllObjects];
            for (int i = 0; i < infoModel.storeImages.count; i++) {
                NSString *url = [infoModel.storeImages objectAtIndex:i];

                SASingleImageCollectionViewCellModel *bannerModel = SASingleImageCollectionViewCellModel.new;
                bannerModel.url = url;
                bannerModel.associatedObj = url;
                bannerModel.isLocal = NO;
                bannerModel.placholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G5 cornerRadius:0 size:CGSizeMake(kScreenWidth, 2)
                                                                          logoImage:[UIImage imageNamed:@"sa_placeholder_image"]
                                                                           logoSize:CGSizeMake(100, 100)];
                bannerModel.cornerRadius = 0;
                [self.dataSource addObject:bannerModel];
            }
            [self.bannerView reloadData];
            [self setPageNoWithIndex:1];
        }
    }];

    [self.viewModel getStoreInfo];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.bannerView];
    [self.bannerView addSubview:self.pageLabel];
    [self.scrollViewContainer addSubview:self.storeStatusInfoView];
    [self.scrollViewContainer addSubview:self.storeNumInfoView];
    [self.scrollViewContainer addSubview:self.storePhoneInfoView];
    [self.scrollViewContainer addSubview:self.storeTimeInfoView];
    [self.scrollViewContainer addSubview:self.storeAddressInfoView];

    //    [self addSubview:self.editBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollViewContainer);
        /// 375 : 211
        make.height.equalTo(@(kScreenWidth * 211 / 375.f));
    }];

    [self.pageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bannerView.mas_right).offset(-kRealWidth(8));
        make.bottom.mas_equalTo(self.bannerView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.storeStatusInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        //        make.height.equalTo(@(52));
    }];

    [self.storeNumInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeStatusInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        //        make.height.equalTo(@(52));
    }];

    [self.storePhoneInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeNumInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        //        make.height.equalTo(@(52));
    }];

    [self.storeTimeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storePhoneInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        //        make.height.equalTo(@(52));
    }];

    [self.storeAddressInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeTimeInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        //        make.height.equalTo(@(52));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    //    [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self).offset(kRealWidth(12));
    //        make.right.equalTo(self).offset(-kRealWidth(12));
    //        make.bottom.mas_equalTo(self).offset(-(kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight));
    //    }];

    [super updateConstraints];
}

#pragma mark - HDCylePageViewDelegate
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    id model = self.dataSource[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if ([cell isKindOfClass:[SASingleImageCollectionViewCell class]]) {
        SASingleImageCollectionViewCell *trueCell = (SASingleImageCollectionViewCell *)cell;
        [self showImageBrowserWithInitialProjectiveView:trueCell.imageView index:index];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = self.bannerView.size.width;
    const CGFloat height = self.bannerView.size.height;
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);

    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.pageLabel.isHidden) {
        [self setPageNoWithIndex:toIndex + 1];
    }
}

#pragma mark
// 设置页码
- (void)setPageNoWithIndex:(NSUInteger)index {
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", index, self.dataSource.count];
}

- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (SASingleImageCollectionViewCellModel *model in self.dataSource) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:model.url];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.bannerView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };

    browser.toolViewHandlers = @[toolViewHandler];

    [browser show];
}

#pragma mark
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 0;
        _bannerView.isInfiniteLoop = NO;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _bannerView;
}

- (SALabel *)pageLabel {
    if (!_pageLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.backgroundColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.2];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.layer.cornerRadius = 2;
        label.text = @"0/0";
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(2), kRealWidth(8), kRealWidth(2), kRealWidth(8));
        _pageLabel = label;
    }
    return _pageLabel;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = [UIColor whiteColor];
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.rightButtonaAlignKey = YES;
    model.keyTitletEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), 0, kRealWidth(10), 0);
    return model;
}

- (PNInfoView *)storeStatusInfoView {
    if (!_storeStatusInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_status", @"门店状态")];
        view.model = model;
        _storeStatusInfoView = view;
    }
    return _storeStatusInfoView;
}

- (PNInfoView *)storeNumInfoView {
    if (!_storeNumInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Store_NO", @"门店编号")];
        view.model = model;
        _storeNumInfoView = view;
    }
    return _storeNumInfoView;
}

- (PNInfoView *)storePhoneInfoView {
    if (!_storePhoneInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_phone", @"门店电话")];
        view.model = model;
        _storePhoneInfoView = view;
    }
    return _storePhoneInfoView;
}

- (PNInfoView *)storeTimeInfoView {
    if (!_storeTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Operation_time", @"营业时间")];
        view.model = model;
        _storeTimeInfoView = view;
    }
    return _storeTimeInfoView;
}

- (PNInfoView *)storeAddressInfoView {
    if (!_storeAddressInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_address", @"门店地址")];
        model.valueNumbersOfLines = 0;
        view.model = model;

        _storeAddressInfoView = view;
    }
    return _storeAddressInfoView;
}

- (PNOperationButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_editBtn setTitle:PNLocalizedString(@"pn_edit", @"编辑") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_editBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddOrEditStoreVC:@{
                @"model": [self.viewModel.storeInfoModel yy_modelToJSONObject],
            }];
        }];
    }
    return _editBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
