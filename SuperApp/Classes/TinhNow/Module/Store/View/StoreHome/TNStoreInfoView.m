//
//  TNStoreView.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreInfoView.h"
#import "TNActionImageModel.h"
#import "TNStoreBannerCollectionViewCell.h"
#import "TNStoreInfoRspModel.h"
#import "TNStoreIntroductionView.h"


@interface TNStoreInfoView () <HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>
/// 轮播
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// dataSoruce
@property (nonatomic, strong) NSArray<TNActionImageModel *> *dataSource;
/// 全部商品
@property (strong, nonatomic) UIButton *allProductBtn;
/// 线条
@property (strong, nonatomic) UIView *allLineView;
/// 商家实景
@property (strong, nonatomic) UIButton *storeInfoBtn;
/// 线条
@property (strong, nonatomic) UIView *storeLineView;
/// 门头照
@property (strong, nonatomic) UIImageView *storeDoorShotImageView;
/// 菜单栏分割段
@property (strong, nonatomic) UIView *sectionView;
/// 店铺介绍
@property (strong, nonatomic) TNStoreIntroductionView *storeIntroductionView;
/// 用于限制重建次数
@property (nonatomic, strong) TNStoreInfoRspModel *oldModel;
@end


@implementation TNStoreInfoView

- (void)hd_setupViews {
    self.dataSource = @[];
    [self addSubview:self.storeIntroductionView];
    [self addSubview:self.storeDoorShotImageView];
    [self addSubview:self.bannerView];
    [self addSubview:self.allProductBtn];
    [self addSubview:self.storeInfoBtn];
    [self.allProductBtn addSubview:self.allLineView];
    [self.storeInfoBtn addSubview:self.storeLineView];
    [self addSubview:self.sectionView];

    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeDoorShotClick)];
    [self.storeDoorShotImageView addGestureRecognizer:imageTap];

    [self allProductClick]; //默认选中全部商品
}

- (void)updateConstraints {
    [self.storeIntroductionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.model.storeIntroductionViewHeight);
    }];

    if (!self.storeDoorShotImageView.hidden) {
        [self.storeDoorShotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.storeIntroductionView.mas_bottom).offset(HDIsStringNotEmpty(self.model.address) ? kRealWidth(10) : kRealWidth(15));
            make.height.mas_equalTo(kRealWidth(140));
        }];
    }
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kRealWidth(10));
        if (!self.storeDoorShotImageView.hidden) {
            make.top.equalTo(self.self.storeDoorShotImageView.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.storeIntroductionView.mas_bottom).offset(HDIsStringEmpty(self.model.address) ? 0 : kRealWidth(15));
        }
    }];

    if (!self.bannerView.hidden) {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.sectionView.mas_bottom).offset(kRealWidth(10));
            make.height.mas_equalTo(kRealWidth(140));
        }];
    }
    if (self.model.hasStoreLive) {
        [self.allProductBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.bannerView.isHidden) {
                make.top.equalTo(self.bannerView.mas_bottom).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.sectionView.mas_bottom);
            }
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(kRealWidth(50));
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
        [self.storeInfoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.allProductBtn.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(kRealWidth(50));
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
        [self.allLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.allProductBtn.mas_centerX);
            make.bottom.equalTo(self.allProductBtn.mas_bottom).offset(-kRealWidth(2));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(2)));
        }];
        [self.storeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.storeInfoBtn.mas_centerX);
            make.bottom.equalTo(self.storeInfoBtn.mas_bottom).offset(-kRealWidth(2));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(2)));
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(TNStoreInfoRspModel *)model {
    _model = model;
    if (HDIsObjectNil(self.oldModel) || ![self.oldModel isEqual:model]) {
        [self updateInfoWithStoreInfoModel:_model];
        [self setNeedsUpdateConstraints];
    }
}
#pragma mark - private methods
- (void)updateInfoWithStoreInfoModel:(TNStoreInfoRspModel *)model {
    //    if (model.storeViewShowType == TNStoreViewShowTypeSellerToAdd) {
    //        [self.storeIntroductionView hiddenFavoriteButton];
    //    }
    self.storeIntroductionView.storeInfo = model;
    if (HDIsStringNotEmpty(model.images)) {
        self.storeDoorShotImageView.hidden = NO;
        [HDWebImageManager setImageWithURL:model.images placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, 140) logoWidth:100] imageView:self.storeDoorShotImageView];
    } else {
        self.storeDoorShotImageView.hidden = YES;
    }
    if (model.adImages.count > 0) {
        [self.bannerView setHidden:NO];
        self.dataSource = [NSArray arrayWithArray:model.adImages];
        [self.bannerView reloadData];
    } else {
        [self.bannerView setHidden:YES];
    }
    self.allProductBtn.hidden = !model.hasStoreLive;
    self.storeInfoBtn.hidden = !model.hasStoreLive;
    [self setNeedsUpdateConstraints];
}
- (void)clickOnStoreName:(UITapGestureRecognizer *)tap {
    if (HDIsStringEmpty(self.model.storeNo)) {
        return;
    }
    [HDMediator.sharedInstance navigaveToTinhNowStoreDetailsPage:@{@"storeNo": self.model.storeNo}];
}
///全部商品点击
- (void)allProductClick {
    if (self.allProductBtn.isSelected) {
        return;
    }
    self.allProductBtn.selected = !self.allProductBtn.selected;
    self.storeInfoBtn.selected = NO;
    self.storeLineView.hidden = YES;
    self.allLineView.hidden = NO;
    if (self.changeMenuCallBack) {
        self.changeMenuCallBack(YES);
    }
}
///商品实景点击
- (void)storeInfoClick {
    if (self.storeInfoBtn.isSelected) {
        return;
    }
    self.storeInfoBtn.selected = !self.storeInfoBtn.selected;
    self.allProductBtn.selected = NO;
    self.allLineView.hidden = YES;
    self.storeLineView.hidden = NO;
    if (self.changeMenuCallBack) {
        self.changeMenuCallBack(NO);
    }
}

//门头照点击
- (void)storeDoorShotClick {
    [self showImageBrowserWithInitialProjectiveView:self.storeDoorShotImageView index:0];
}
/// 展示图片浏览器
/// @param projectiveView 默认投影 View
/// @param index 默认起始索引
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:self.model.images];
    // 这里固定只是从此处开始投影，滑动时会更新投影控件
    data.projectiveView = projectiveView;
    [datas addObject:data];

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.storeDoorShotImageView;
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
#pragma mark - HDCylePageViewDataSoruce
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSString *url = self.dataSource[index].source;
    TNStoreBannerCollectionViewCell *cell = [TNStoreBannerCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    cell.url = url;
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = kScreenWidth;
    const CGFloat height = kScreenWidth * 0.37;
    layout.itemSize = CGSizeMake(width, height);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    NSString *action = self.dataSource[index].action;
    if (HDIsStringNotEmpty(action)) {
        [SAWindowManager openUrl:action withParameters:nil];
    }
}

#pragma mark - lazy load
/** @lazy bannerView */
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[HDCyclePagerView alloc] init];
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.isInfiniteLoop = YES;
        _bannerView.autoScrollInterval = 5;
        _bannerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _bannerView;
}
- (UIButton *)allProductBtn {
    if (!_allProductBtn) {
        _allProductBtn = [[UIButton alloc] init];
        _allProductBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [_allProductBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FF9623"] forState:UIControlStateSelected];
        [_allProductBtn setTitle:TNLocalizedString(@"tn_store_all_product", @"全部商品") forState:UIControlStateNormal];
        [_allProductBtn setTitleColor:[UIColor hd_colorWithHexString:@"#ADB6C8"] forState:UIControlStateNormal];
        [_allProductBtn addTarget:self action:@selector(allProductClick) forControlEvents:UIControlEventTouchUpInside];
        _allProductBtn.hidden = YES;
    }
    return _allProductBtn;
}
- (UIButton *)storeInfoBtn {
    if (!_storeInfoBtn) {
        _storeInfoBtn = [[UIButton alloc] init];
        _storeInfoBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [_storeInfoBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FF9623"] forState:UIControlStateSelected];
        [_storeInfoBtn setTitleColor:[UIColor hd_colorWithHexString:@"#ADB6C8"] forState:UIControlStateNormal];
        [_storeInfoBtn setTitle:TNLocalizedString(@"tn_store_live_photo", @"商家实景") forState:UIControlStateNormal];
        [_storeInfoBtn addTarget:self action:@selector(storeInfoClick) forControlEvents:UIControlEventTouchUpInside];
        _storeInfoBtn.hidden = YES;
    }
    return _storeInfoBtn;
}
- (UIView *)allLineView {
    if (!_allLineView) {
        _allLineView = [[UIView alloc] init];
        _allLineView.backgroundColor = [UIColor hd_colorWithHexString:@"#FF9623"];
        _allLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _allLineView;
}
- (UIView *)storeLineView {
    if (!_storeLineView) {
        _storeLineView = [[UIView alloc] init];
        _storeLineView.backgroundColor = [UIColor hd_colorWithHexString:@"#FF9623"];
        _storeLineView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _storeLineView;
}
- (UIImageView *)storeDoorShotImageView {
    if (!_storeDoorShotImageView) {
        _storeDoorShotImageView = [[UIImageView alloc] init];
        _storeDoorShotImageView.userInteractionEnabled = YES;
    }
    return _storeDoorShotImageView;
}
- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _sectionView;
}
/** @lazy  storeIntroductionView*/
- (TNStoreIntroductionView *)storeIntroductionView {
    if (!_storeIntroductionView) {
        _storeIntroductionView = [[TNStoreIntroductionView alloc] init];
    }
    return _storeIntroductionView;
}
@end
