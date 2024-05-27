//
//  WMSpecialActivesViewController.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesViewController.h"
#import "LKDataRecord.h"
#import "SAInternationalizationModel.h"
#import "WMEatOnTimeActivesProductView.h"
#import "WMSpecialActivesPictureView.h"
#import "WMSpecialActivesProductView.h"
#import "WMSpecialActivesStoreListView.h"
#import "WMSpecialActivesViewModel.h"
#import "WMSpecialSkeletonView.h"
#import "WMThemeBrandProductView.h"
#import "WMStoreListViewModel.h"
#import "WMNewSpecialActivesProductView.h"


@interface WMSpecialActivesViewController ()
/// viewmodel
@property (nonatomic, strong) WMSpecialActivesViewModel *viewModel;
/// 图片
@property (nonatomic, strong) WMSpecialActivesPictureView *pictureView;
/// 商品列表
//@property (nonatomic, strong) WMSpecialActivesProductView *productView;
@property (nonatomic, strong) WMNewSpecialActivesProductView *productView;
/// 门店列表
@property (nonatomic, strong) WMSpecialActivesStoreListView *storeView;
/// 品牌列表
@property (nonatomic, strong) WMThemeBrandProductView *brandView;
/// 按时吃饭
@property (nonatomic, strong) WMEatOnTimeActivesProductView *eatOnTimeView;
/// 图片
@property (nonatomic, strong) WMSpecialSkeletonView *skeletonView;
/// 透明度
@property (nonatomic, assign) CGFloat naviAlpah;
/// top
@property (nonatomic, assign) CGFloat topOffset;
/// 刷新时间标记
@property (nonatomic, assign) long timeFlag;
/// 刷新时长范围
@property (nonatomic, assign) long associateTimeout;

@end


@implementation WMSpecialActivesViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.plateId = parameters[@"plateId"];
        self.type = parameters[@"type"];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(!self.storeView.hidden) {
        self.storeView.isShowingInWindow = false;
    }
    
}

- (void)hd_setupViews {
    self.topOffset = kNavigationBarH;
    ///计算页面停留时长
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970] forKey:@"SpecialActivesTime"];

    [self.view addSubview:self.pictureView];
    [self.view addSubview:self.productView];
    [self.view addSubview:self.storeView];
    [self.view addSubview:self.brandView];
    [self.view addSubview:self.eatOnTimeView];
    [self.view addSubview:self.skeletonView];
    self.naviAlpah = 1;

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 监听从前台进入后台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)hd_setupNavigation {
    if (![self.type isEqualToString:WMSpecialActiveTypeEat]) {
        self.hd_navTitleColor = [UIColor colorWithRed:10 / 255.0 green:10 / 255.0 blue:20 / 255.0 alpha:_naviAlpah];
    } else {
        self.hd_navTitleColor = [UIColor colorWithRed:((1 - _naviAlpah) * 255) / 255.0 green:((1 - _naviAlpah) * 255) / 255.0 blue:((1 - _naviAlpah) * 255) / 255.0 alpha:1];
    }
    self.hd_navigationBar.hd_navBarBackgroundAlpha = _naviAlpah;
    self.hd_backButtonImage = [UIImage imageNamed:(_naviAlpah < 0.5) ? @"icon_back_white" : @"yn_home_back" inBundle:NSBundle.mainBundle compatibleWithTraitCollection:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self);
    NSDictionary *info = @{
        WMSpecialActiveTypeStore: self.storeView,
        WMSpecialActiveTypeProduct: self.productView,
        WMSpecialActiveTypeBrand: self.brandView,
        WMSpecialActiveTypeEat: self.eatOnTimeView,
        WMSpecialActiveTypeImage: self.pictureView,
        @"error": self.skeletonView,
        @"noData": self.skeletonView,
    };
    NSArray *subView = @[self.storeView, self.productView, self.brandView, self.pictureView, self.eatOnTimeView, self.skeletonView];

    [self.KVOController hd_observe:self.viewModel keyPath:@"type" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeEat])
            return;
        if (![self.viewModel.type isEqualToString:@"error"] && ![self.viewModel.type isEqualToString:@"noData"]) {
            self.naviAlpah = 0;
        }
        UIView *currentView = info[self.viewModel.type];
        for (UIView *view in subView) {
            view.hidden = (view != currentView);
        }
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        [currentView updateConstraints];
        [currentView layoutIfNeeded];
        [self addCollectionData];
    }];

    ///按时吃饭
    [self.KVOController hd_observe:self.viewModel keyPath:@"onTimeModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.naviAlpah = 0;
        for (UIView *view in subView) {
            view.hidden = (view != self.eatOnTimeView);
        }
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        [self.eatOnTimeView updateConstraints];
        [self.eatOnTimeView layoutIfNeeded];
        self.hd_navigationItem.title = self.viewModel.onTimeModel.title;
        [self addCollectionData];
    }];

    [self.KVOController hd_observe:self.productView keyPath:@"offset" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!self.topOffset)
            self.naviAlpah = MIN(1, MAX(0, ([change[@"new"] floatValue] + self.viewModel.imageHeight) / kNavigationBarH));
    }];

    [self.KVOController hd_observe:self.storeView keyPath:@"offset" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!self.topOffset)
            self.naviAlpah = MIN(1, MAX(0, [change[@"new"] floatValue] / kNavigationBarH));
    }];

    [self.KVOController hd_observe:self.brandView keyPath:@"offset" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!self.topOffset)
            self.naviAlpah = MIN(1, MAX(0, ([change[@"new"] floatValue] + self.viewModel.imageHeight) / kNavigationBarH));
    }];

    [self.KVOController hd_observe:self.eatOnTimeView keyPath:@"offset" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        CGFloat aplah = MIN(1, MAX(0, ([change[@"new"] floatValue] + self.viewModel.imageHeight) / kNavigationBarH));
        self.naviAlpah = aplah;
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"backgroundImageUrl" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (![self.viewModel.backgroundImageUrl isKindOfClass:NSString.class] || !self.viewModel.backgroundImageUrl.length || [self.viewModel.type isEqualToString:WMSpecialActiveTypeProduct]) {
            self.naviAlpah = 1;
            self.topOffset = kNavigationBarH;
        } else {
            self.topOffset = 0;
        }
        [self.view setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"activeName" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.hd_navigationItem.title = self.viewModel.activeName.desc;
    }];

    if (!self.type) {
        self.viewModel.topicPageId = self.parameters[@"activityNo"];
        [self.viewModel getNewData];
    } else {
        if ([self.type isEqualToString:WMSpecialActiveTypeEat]) {
            self.naviAlpah = 1;
            self.viewModel.type = self.type;
            [self hd_setupNavigation];
            [self.viewModel getEatOnTimeWithId:self.viewModel.activeNo pageNo:1 success:nil failure:nil];
        }
    }
}

///埋点
- (void)addCollectionData {
    if (self.viewModel.plateId) {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{
            @"type": self.viewModel.collectType,
            @"plateId": self.viewModel.plateId,
            @"content": self.viewModel.collectContent ?: @[self.viewModel.activeNo]
        }];
        
        if (![self.type isEqualToString:WMHomeLayoutTypeEatOnTime])
            info[@"topicPageId"] = self.viewModel.topicPageId;

        if (self.parameters[@"from"]) {
            info[@"from"] = self.parameters[@"from"];
        }

        [LKDataRecord.shared traceEvent:@"browseTopicPage" name:@"browseTopicPage" parameters:info SPM:[LKSPM SPMWithPage:@"WMSpecialActivesViewController" area:@"" node:@""]];
    }
}

- (void)updateViewConstraints {
    [self.pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pictureView.isHidden) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_offset(self.topOffset);
        }
    }];

    [self.storeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeView.isHidden) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_offset(self.topOffset);
        }
    }];

    [self.productView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.productView.isHidden) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_offset(self.topOffset);
        }
    }];

    [self.brandView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.brandView.isHidden) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_offset(self.topOffset);
        }
    }];

    [self.eatOnTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.eatOnTimeView.isHidden) {
            make.edges.mas_equalTo(0);
        }
    }];

    [self.skeletonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.skeletonView.isHidden) {
            make.edges.mas_equalTo(0);
        }
    }];
    [super updateViewConstraints];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

#pragma mark - noti
- (void)applicationBecomeActive {
    //处理页面刷新判断
    if (self.timeFlag > 0 && time(0) - self.timeFlag > self.associateTimeout) {
        if (!self.productView.hidden)
            [self.viewModel getNewData];
        if (!self.storeView.hidden && self.storeView.tableView.requestNewDataHandler)
            self.storeView.tableView.requestNewDataHandler();
        if (!self.brandView.hidden && self.brandView.collectionView.requestNewDataHandler)
            self.brandView.collectionView.requestNewDataHandler();
        if (!self.eatOnTimeView.hidden && self.eatOnTimeView.collectionView.requestNewDataHandler)
            self.eatOnTimeView.collectionView.requestNewDataHandler();
    }
    self.timeFlag = 0;
}

- (void)applicationEnterBackground {
    self.timeFlag = time(0);
    @HDWeakify(self);
    [WMStoreListViewModel getSystemConfigWithKey:@"userapp_refresh_interval" success:^(NSString *_Nonnull value) {
        @HDStrongify(self);
        long time = value.integerValue;
        if (time > 0) {
            self.associateTimeout = time;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

#pragma mark - lazy load
/** @lazy bgiv */
- (WMSpecialActivesPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[WMSpecialActivesPictureView alloc] initWithViewModel:self.viewModel];
        [_pictureView setHidden:YES];
    }
    return _pictureView;
}
/** @lazy storeView */
- (WMSpecialActivesStoreListView *)storeView {
    if (!_storeView) {
        _storeView = [[WMSpecialActivesStoreListView alloc] initWithViewModel:self.viewModel];
        [_storeView setHidden:YES];
    }
    return _storeView;
}
/** @lazy productView */
- (WMNewSpecialActivesProductView *)productView {
    if (!_productView) {
        _productView = [[WMNewSpecialActivesProductView alloc] initWithViewModel:self.viewModel];
        [_productView setHidden:YES];
    }
    return _productView;
}
/** @lazy brandView */
- (WMThemeBrandProductView *)brandView {
    if (!_brandView) {
        _brandView = [[WMThemeBrandProductView alloc] initWithViewModel:self.viewModel];
        [_brandView setHidden:YES];
    }
    return _brandView;
}

/** @lazy eatOnTimeView */
- (WMEatOnTimeActivesProductView *)eatOnTimeView {
    if (!_eatOnTimeView) {
        _eatOnTimeView = [[WMEatOnTimeActivesProductView alloc] initWithViewModel:self.viewModel];
        [_eatOnTimeView setHidden:YES];
    }
    return _eatOnTimeView;
}

- (WMSpecialSkeletonView *)skeletonView {
    if (!_skeletonView) {
        _skeletonView = [[WMSpecialSkeletonView alloc] initWithViewModel:self.viewModel];
    }
    return _skeletonView;
}

/** @lazy viewModel */
- (WMSpecialActivesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMSpecialActivesViewModel alloc] init];
        _viewModel.activeNo = self.parameters[@"activityNo"];
        _viewModel.plateId = self.parameters[@"plateId"];
        _viewModel.collectType = self.parameters[@"collectType"];
        _viewModel.collectContent = self.parameters[@"collectContent"];
        
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (void)setNaviAlpah:(CGFloat)naviAlpah {
    _naviAlpah = naviAlpah;
    [self hd_setupNavigation];
}

- (void)dealloc {
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SpecialActivesTime"] doubleValue];
    if (currentTime > oldTime) {
        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"TOPIC_STAY", @"time": @(currentTime - oldTime).stringValue}
                                    SPM:[LKSPM SPMWithPage:@"WMSpecialActivesViewController" area:@"" node:@""]];
    }

    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (WMSourceType)currentSourceType {
    if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeStore]) {
        return WMSourceTypeTopicsStore;
    } else if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeProduct]) {
        return WMSourceTypeTopicsProduct;
    } else if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeBrand]) {
        return WMSourceTypeTopicsBrands;
    } else if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeEat]) {
        return WMSourceTypeTopicsEat;
    }
    return WMSourceTypeOther;
}

- (long)associateTimeout {
    if (!_associateTimeout) {
        _associateTimeout = 15 * 60;
    }
    return _associateTimeout;
}

@end
