//
//  PNMSVoucherDetailView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherDetailView.h"
#import "PNCommonUtils.h"
#import "PNInfoView.h"
#import "PNMSVoucherInfoModel.h"
#import "PNMSVoucherViewModel.h"
#import "SASingleImageCollectionViewCell.h"
#import "YBImageBrowser.h"


@interface PNMSVoucherDetailView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView;
@property (nonatomic, strong) SALabel *pageLabel;
@property (nonatomic, strong) PNInfoView *createTimeInfoView;
@property (nonatomic, strong) PNInfoView *storeNameInfoView;
@property (nonatomic, strong) PNInfoView *operatorNameInfoView;
@property (nonatomic, strong) PNInfoView *remarkInfoView;
@property (nonatomic, strong) PNMSVoucherViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNMSVoucherDetailView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.voucherInfoModel)) {
            PNMSVoucherInfoModel *infoModel = self.viewModel.voucherInfoModel;

            self.createTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm:ss" withDate:[NSDate dateWithTimeIntervalSince1970:infoModel.createDate.floatValue / 1000]];
            [self.createTimeInfoView setNeedsUpdateContent];

            self.storeNameInfoView.model.valueText = infoModel.storeName ?: @" ";
            [self.storeNameInfoView setNeedsUpdateContent];

            self.operatorNameInfoView.model.valueText = [NSString stringWithFormat:@"%@ %@", infoModel.surname, infoModel.name];
            [self.operatorNameInfoView setNeedsUpdateContent];

            self.remarkInfoView.model.valueText = infoModel.remark ?: @" ";
            [self.remarkInfoView setNeedsUpdateContent];

            [self.dataSource removeAllObjects];
            for (int i = 0; i < infoModel.imgUrl.count; i++) {
                NSString *url = [infoModel.imgUrl objectAtIndex:i];

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

    [self.viewModel getVoucherDetail];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.bannerView];
    [self.bannerView addSubview:self.pageLabel];
    [self.scrollViewContainer addSubview:self.createTimeInfoView];
    [self.scrollViewContainer addSubview:self.storeNameInfoView];
    [self.scrollViewContainer addSubview:self.operatorNameInfoView];
    [self.scrollViewContainer addSubview:self.remarkInfoView];
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

    [self.createTimeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.bannerView.mas_bottom);
    }];

    [self.storeNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.createTimeInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.operatorNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeNameInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
    }];

    [self.remarkInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.operatorNameInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

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

- (PNInfoView *)createTimeInfoView {
    if (!_createTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_upload_datetime", @"上传时间")];
        view.model = model;
        _createTimeInfoView = view;
    }
    return _createTimeInfoView;
}

- (PNInfoView *)storeNameInfoView {
    if (!_storeNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_store_name", @"门店名称")];
        view.model = model;
        _storeNameInfoView = view;
    }
    return _storeNameInfoView;
}

- (PNInfoView *)operatorNameInfoView {
    if (!_operatorNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_Operator", @"操作人")];
        view.model = model;
        _operatorNameInfoView = view;
    }
    return _operatorNameInfoView;
}

- (PNInfoView *)remarkInfoView {
    if (!_remarkInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"remark", @"备注")];
        view.model = model;
        _remarkInfoView = view;
    }
    return _remarkInfoView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
