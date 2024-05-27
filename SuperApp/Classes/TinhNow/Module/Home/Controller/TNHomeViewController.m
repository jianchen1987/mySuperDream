//
//  TNHomeViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeViewController.h"
#import "Mixpanel.h"
#import "SAAddressModel.h"
#import "SAAppConfigDTO.h"
#import "SALocationUtil.h"
#import "SATalkingData.h"
#import "TNCategoryChildControllerConfig.h"
#import "TNHomeCategoryView.h"
#import "TNHomeNavView.h"
#import "TNHomeRecommendView.h"
#import "TNHomeViewModel.h"
#import "TNShoppingCar.h"
#import "SAAddressCacheAdaptor.h"

@interface TNHomeViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 导航栏视图
@property (nonatomic, strong) TNHomeNavView *navBarView;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 标题数组
@property (strong, nonatomic) NSMutableArray<TNCategoryChildControllerConfig *> *configList;
/// VM
@property (nonatomic, strong) TNHomeViewModel *viewModel;
/// 弹窗广告DTO
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
/// 缓存首页
@property (strong, nonatomic) TNHomeRecommendView *recommendView;
@end


@implementation TNHomeViewController
- (void)hd_setupViews {
    [super hd_setupViews];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.listContainerView];
}
- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)hd_getNewData {
    //刷新消息数据
    [super hd_getNewData];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self queryCategoryData];
    [self queryAppMarketingAlert];
}
- (void)updateViewConstraints {
    [self.navBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kStatusBarH + kRealWidth(54));
    }];
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - 首页弹窗广告
// 获取弹窗广告
- (void)queryAppMarketingAlert {
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
    @HDWeakify(self);
    [self.appConfigDTO queryAppMarketingAlertWithType:SAClientTypeTinhNow province:addressModel.city district:addressModel.subLocality latitude:addressModel.lat longitude:addressModel.lon
                                              success:^(NSArray<SAMarketingAlertViewConfig *> *_Nonnull list) {
                                                  @HDStrongify(self);
                                                  [self activityAlertShowWithList:list];
                                              }
                                              failure:nil];
}

// 展示弹窗广告
- (void)activityAlertShowWithList:(NSArray<SAMarketingAlertViewConfig *> *)marketingAlertConfigs {
    // 当前展示页面不是本页面，不展示广告
    if (SAWindowManager.visibleViewController != self) {
        return;
    }
    NSMutableArray<SAMarketingAlertViewConfig *> *shouldShow = [[NSMutableArray alloc] initWithCapacity:1];
    for (SAMarketingAlertViewConfig *config in marketingAlertConfigs) {
        if ([config isValidWithLocation:@"10"]) {
            config.showInClass = [self class];
            [shouldShow addObject:config];
        }
    }
    
    if(shouldShow.count) {
        SAMarketingAlertView *alertView = [SAMarketingAlertView alertViewWithConfigs:shouldShow];
        // 跳转前拦截 埋点
        alertView.willJumpTo = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"TinhNow" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationTinhNowAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"enter",
                @"businessLine": SAClientTypeTinhNow
            }];
        };
        // 关闭前拦截 埋点
        alertView.willClose = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"TinhNow" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationTinhNowAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"close",
                @"businessLine": SAClientTypeTinhNow
            }];
        };
        [alertView show];
    }
}
#pragma mark - 获取分类数据
- (void)queryCategoryData {
    @HDWeakify(self);
    [self.viewModel requestHomeCategoryDataCompletion:^(NSArray<TNHomeCategoryModel *> *_Nonnull list) {
        @HDStrongify(self);
        if (!HDIsArrayEmpty(list)) {
            [self reloadCategoryViewByList:list];
        }
    }];
}
#pragma mark - 刷新分类数据
- (void)reloadCategoryViewByList:(NSArray<TNHomeCategoryModel *> *)list {
    for (TNHomeCategoryModel *model in list) {
        TNCategoryChildControllerConfig *config = [TNCategoryChildControllerConfig configWithModel:model]; // 控制器 需要时再创建
        [self.configList addObject:config];
    }
    NSArray *titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNCategoryChildControllerConfig *_Nonnull obj, NSUInteger idx) {
        return obj.model.name;
    }];
    self.categoryTitleView.titles = titles;
    [self.categoryTitleView reloadData];
}
#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNHomeCategoryModel *model = self.configList[index].model;
    if (index == 0) {
        return self.recommendView;
    } else {
        TNHomeCategoryView *categoryView = [[TNHomeCategoryView alloc] initWithCategoryId:model.categoryId];
        return categoryView;
    }
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    TNHomeCategoryModel *model = self.configList[index].model;
    [SATalkingData trackEvent:@"[电商]首页_点击分类tab" label:@"" parameters:@{@"分类ID": HDIsStringNotEmpty(model.categoryId) ? model.categoryId : @"推荐"}];
    //分类切换
    [TNEventTrackingInstance trackEvent:@"switch_category" properties:@{@"categoryId": HDIsStringNotEmpty(model.categoryId) ? model.categoryId : @"推荐"}];
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}

#pragma mark - lazy load

- (TNHomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNHomeViewModel alloc] init];
        _viewModel.hideBackButton = [self.parameters[@"hideBackButton"] boolValue];
    }
    return _viewModel;
}
- (TNHomeNavView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[TNHomeNavView alloc] initWithViewModel:self.viewModel];
        _navBarView.searchBarClickedHandler = ^{
            [SATalkingData trackEvent:@"[电商]点击搜索框"];
            [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:@{@"funnel": @"[电商]首页_点击搜索"}];
        };
    }
    return _navBarView;
}
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNCategoryChildControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.model.name;
        }];
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 10;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = 4;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        _categoryTitleView.contentEdgeInsetRight = kRealWidth(15);
        _categoryTitleView.cellSpacing = kRealWidth(20);
        _categoryTitleView.averageCellSpacingEnabled = NO;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
- (NSMutableArray<TNCategoryChildControllerConfig *> *)configList {
    if (!_configList) {
        _configList = [NSMutableArray array];
        TNHomeCategoryModel *model = [[TNHomeCategoryModel alloc] init];
        model.name = TNLocalizedString(@"tn_recommend", @"推荐");
        TNCategoryChildControllerConfig *config = [TNCategoryChildControllerConfig configWithModel:model];
        [_configList addObject:config];
    }
    return _configList;
}
- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}
/** @lazy recommendView */
- (TNHomeRecommendView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[TNHomeRecommendView alloc] initWithViewModel:self.viewModel];
    }
    return _recommendView;
}
@end
