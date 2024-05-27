//
//  SAOrderViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderViewController.h"
#import "LKDataRecord.h"
#import "NSDate+SAExtension.h"
#import "SADatePickerViewController.h"
#import "SAMessageButton.h"
#import "SAOrderCenterListViewController.h"
#import "SAOrderListChildViewControllerConfig.h"
#import "SAOrderListDTO.h"
#import "SAOrderListFilterDownView.h"
#import "SAOrderListRspModel.h"
#import "SAOrderNotLoginView.h"
#import "SAOrderSearchViewController.h"


@interface SAOrderViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, SADatePickerViewDelegate>

@property (nonatomic, strong) UIView *topContainer;
///< searchContainer
@property (nonatomic, strong) UIView *searchContainer;
///< searchImage
@property (nonatomic, strong) UIImageView *searchLogo;
///< search text
@property (nonatomic, strong) SALabel *searchPlaceholder;
/// 筛选按钮
@property (nonatomic, strong) HDUIButton *fliterBTN;

/// 标题滚动 View
@property (nonatomic, strong) HDCategoryDotView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<SAOrderCenterListChildViewControllerConfig *> *configList;
/// 标题栏阴影图层
//@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
/// DTO
@property (nonatomic, strong) SAOrderListDTO *orderListDTO;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// 筛选框
@property (nonatomic, strong) SAOrderListFilterDownView *downView;
/// 是否选择结束日期，默认是开始日期
@property (nonatomic, assign) BOOL isEndDate;

/// 筛选开始时间
@property (nonatomic, copy) NSString *orderTimeStart;
/// 筛选结束时间
@property (nonatomic, copy) NSString *orderTimeEnd;

@property (nonatomic, copy) SAClientType businessline;

@end


@implementation SAOrderViewController

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 3;

    self.orderTimeStart = 0;
    self.orderTimeEnd = 0;

    self.businessline = SAClientTypeMaster;

    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    [self.view addSubview:self.topContainer];
    [self.topContainer addSubview:self.searchContainer];
    [self.searchContainer addSubview:self.searchLogo];
    [self.searchContainer addSubview:self.searchPlaceholder];
    [self.topContainer addSubview:self.fliterBTN];
    UITapGestureRecognizer *searchGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnSearch:)];
    [self.searchContainer addGestureRecognizer:searchGes];

    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.notSignInView];

    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(clearFilterData) name:kNotificationNameSATabBarControllerChangeSelectedIndex object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSATabBarControllerChangeSelectedIndex object:nil];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    //    self.boldTitle = SALocalizedString(@"my_order", @"我的订单");
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];

    @HDWeakify(self);
    // 查询未评价订单数量
    [self getOrderCountWithOrderState:SAOrderStateWatingEvaluation success:^(NSUInteger totalCount) {
        @HDStrongify(self);
        self.categoryTitleView.dotStates = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderCenterListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return (obj.vc.orderState == SAOrderStateWatingEvaluation && totalCount > 0) ? @(1) : @(0);
        }];
        [self.categoryTitleView reloadDataWithoutListContainer];
    } failure:nil];
}

- (void)updateViewConstraints {
    [self.topContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HDAppTheme.value.statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.searchContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainer.mas_left).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self.topContainer.mas_centerY);
        make.height.mas_equalTo(36);
        //        make.right.equalTo(self.topContainer.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.searchLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchContainer.mas_left).offset(12);
        make.centerY.equalTo(self.searchContainer.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.searchPlaceholder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchLogo.mas_right).offset(8);
        make.centerY.equalTo(self.searchContainer.mas_centerY);
        make.right.equalTo(self.searchContainer.mas_right).offset(-8);
    }];

    [self.fliterBTN sizeToFit];
    [self.fliterBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContainer.mas_right).offset(-HDAppTheme.value.padding.right);
        make.left.equalTo(self.searchContainer.mas_right).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self.topContainer.mas_centerY);
        make.width.mas_equalTo(self.fliterBTN.width);
    }];

    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topContainer.mas_bottom);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.listContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.categoryTitleView);
        make.top.equalTo(self.categoryTitleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [self.notSignInView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    self.categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderCenterListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
        return obj.title.desc;
    }];
    [self.categoryTitleView reloadDataWithoutListContainer];
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = SALocalizedString(@"view_order_after_sign_in", @"登录后可查看订单");
        [self.notSignInView.signInSignUpBTN setTitle:SALocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
    self.searchPlaceholder.text = SALocalizedString(@"oc_search", @"搜索");
    [self.fliterBTN setTitle:SALocalizedString(@"oc_filter", @"筛选") forState:UIControlStateNormal];

    [self updateViewConstraints];
}

#pragma mark - Action
- (void)clickedOnSearch:(UITapGestureRecognizer *)tap {
    [HDMediator.sharedInstance navigaveToOrderSearch:@{
        @"source" : @"订单列表"
    }];
}

- (void)fliterBtnClick:(UIButton *)btn {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    if (!self.downView) {
        SAOrderListFilterDownView *downView = [[SAOrderListFilterDownView alloc] initWithStartOffsetY:HDAppTheme.value.statusBarHeight + kRealWidth(44)];
        self.downView = downView;
        [downView showInView:self.tabBarController.view];
        @HDWeakify(self);

        downView.chooseDateBlock = ^(BOOL isEndDate) {
            @HDStrongify(self);

            self.isEndDate = isEndDate; //记录是否选择结束时间

            SADatePickerViewController *vc = [[SADatePickerViewController alloc] init];
            vc.datePickStyle = SADatePickerStyleDMY;

            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            [fmt setDateFormat:@"yyyyMMdd"];
            [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];

            // 生日不要超过今天
            NSDate *maxDate = [NSDate date];
            // 年龄不超过 130

            NSDate *minDate = [maxDate dateByAddingTimeInterval:-130 * 365 * 24 * 60 * 60.0];

            vc.maxDate = maxDate;
            vc.minDate = minDate;
            vc.delegate = self;

            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

            [self.tabBarController presentViewController:vc animated:YES completion:^{
                [vc setTitleText:isEndDate ? SALocalizedString(@"oc_end_time", @"结束时间") : SALocalizedString(@"oc_start_time", @"起始时间")];
            }];
        };

        downView.submitBlock = ^(SAClientType _Nullable businessline, NSString *_Nullable startDate, NSString *_Nullable endDate) {
            HDLog(@"业务线：%@ 开始日期：%@ 结束日期：%@", businessline, startDate, endDate);
            @HDStrongify(self);
            self.businessline = businessline;

            self.orderTimeStart = startDate;

            self.orderTimeEnd = endDate;

            for (SAOrderCenterListChildViewControllerConfig *config in self.configList) {
                config.vc.orderTimeStart = self.orderTimeStart;
                config.vc.orderTimeEnd = self.orderTimeEnd;
                config.vc.businessLine = self.businessline;
            }

            SAOrderCenterListViewController *listVC = self.configList[self.categoryTitleView.selectedIndex].vc;
            [listVC getNewData];
        };
        downView.dismissBlock = ^{
            self.fliterBTN.userInteractionEnabled = YES;
        };
        self.fliterBTN.userInteractionEnabled = NO;
    } else {
        [self.downView showInView:self.tabBarController.view];
        self.fliterBTN.userInteractionEnabled = NO;
    }
}

#pragma mark - SADatePickerViewDelegate
/// 点击确定选中日期
- (void)datePickerView:(SADatePickerView *)pickView didSelectDate:(NSString *)date {
    if (!self.downView)
        return;

    [self.downView updateDate:date isEndDate:self.isEndDate];
}

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    // 获取到当前显示的控制器，触发其 viewWillAppear:
    SAOrderCenterListViewController *currentVC = self.configList[self.categoryTitleView.selectedIndex].vc;
    if (currentVC) {
        [currentVC beginAppearanceTransition:YES animated:NO];
    }
    // 也触发当前界面的 viewWillAppear:
    [self beginAppearanceTransition:YES animated:NO];
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}

- (void)clearFilterData {
    if (self.downView) {
        self.downView = nil;

        self.orderTimeStart = 0;
        self.orderTimeEnd = 0;
        self.businessline = SAClientTypeMaster;

        for (SAOrderCenterListChildViewControllerConfig *config in self.configList) {
            config.vc.orderTimeStart = self.orderTimeStart;
            config.vc.orderTimeEnd = self.orderTimeEnd;
            config.vc.businessLine = self.businessline;
        }

        SAOrderCenterListViewController *listVC = self.configList[self.categoryTitleView.selectedIndex].vc;
        [listVC getNewData];
    }
}

#pragma mark - Data
/// 获取不同状态订单数量
/// @param orderState 状态
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderCountWithOrderState:(SAOrderState)orderState success:(void (^)(NSUInteger totalCount))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderListDTO getOrderListWithBusinessType:SAClientTypeMaster orderState:orderState pageNum:1 pageSize:1 orderTimeStart:nil orderTimeEnd:nil
                                            success:^(SAOrderListRspModel *_Nonnull rspModel) {
                                                !successBlock ?: successBlock(rspModel.total);
                                            }
                                            failure:failureBlock];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    SAOrderCenterListViewController *listVC = self.configList[index].vc;
    listVC.businessLine = self.businessline;
    listVC.orderTimeStart = self.orderTimeStart;
    listVC.orderTimeEnd = self.orderTimeEnd;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
    SAOrderCenterListChildViewControllerConfig *config = self.configList[index];
    [LKDataRecord.shared traceEvent:@"click_on_orderList_category" name:config.title.zh_CN parameters:nil SPM:[LKSPM SPMWithPage:@"SAOrderViewController" area:@""
                                                                                                                            node:[NSString stringWithFormat:@"node@%zd", index]]];
}

#pragma mark - lazy load
- (UIView *)topContainer {
    if (!_topContainer) {
        _topContainer = UIView.new;
        _topContainer.backgroundColor = HDAppTheme.color.sa_backgroundColor;
    }
    return _topContainer;
}

- (UIView *)searchContainer {
    if (!_searchContainer) {
        _searchContainer = UIView.new;
        _searchContainer.backgroundColor = UIColor.whiteColor;
        _searchContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18];
        };
    }
    return _searchContainer;
}

- (UIImageView *)searchLogo {
    if (!_searchLogo) {
        _searchLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_oc_search"]];
    }
    return _searchLogo;
}

- (SALabel *)searchPlaceholder {
    if (!_searchPlaceholder) {
        _searchPlaceholder = SALabel.new;
        _searchPlaceholder.font = [UIFont systemFontOfSize:14];
        _searchPlaceholder.textColor = HDAppTheme.color.sa_searchBarTextColor;
    }
    return _searchPlaceholder;
}

- (HDUIButton *)fliterBTN {
    if (!_fliterBTN) {
        _fliterBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_fliterBTN setImage:[UIImage imageNamed:@"icon_oc_filter"] forState:UIControlStateNormal];
        [_fliterBTN setTitle:SALocalizedString(@"oc_filter", @"筛选") forState:UIControlStateNormal];
        [_fliterBTN setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        _fliterBTN.spacingBetweenImageAndTitle = 4;
        _fliterBTN.titleLabel.font = HDAppTheme.font.sa_standard14M;
        [_fliterBTN addTarget:self action:@selector(fliterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fliterBTN;
}

- (HDCategoryDotView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryDotView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderCenterListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title.desc;
        }];
        _categoryTitleView.titleLabelVerticalOffset = -4;
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.color.sa_C1;
        lineView.indicatorWidth = 20;
        lineView.verticalMargin = 8;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = HDAppTheme.color.sa_backgroundColor;
        _categoryTitleView.titleSelectedColor = HDAppTheme.color.sa_C1;
        _categoryTitleView.titleColor = HDAppTheme.color.sa_C999;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<SAOrderCenterListChildViewControllerConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<SAOrderCenterListChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:4];
        SAInternationalizationModel *title = [SAInternationalizationModel modelWithInternationalKey:@"order_all" value:@"全部" table:nil];
        SAOrderCenterListViewController *vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{@"source" : @"订单列表.全部"}];
        vc.orderState = SAOrderStateAll;
        vc.pageIdentify = CMSPageIdentifyOrderListAll;
        SAOrderCenterListChildViewControllerConfig *config = [SAOrderCenterListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"oc_pending_payment" value:@"待付款" table:nil];
        vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{@"source" : @"订单列表.待付款"}];;
        vc.orderState = SAOrderStateWatingPay;
        vc.pageIdentify = CMSPageIdentifyOrderListWaitingPay;
        config = [SAOrderCenterListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"order_processing" value:@"处理中" table:nil];
        vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{@"source" : @"订单列表.处理中"}];;
        vc.orderState = SAOrderStateProcessing;
        vc.pageIdentify = CMSPageIdentifyOrderListProcessing;
        config = [SAOrderCenterListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"order_unevaluate" value:@"待评价" table:nil];
        vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{@"source" : @"订单列表.待评价"}];;
        vc.orderState = SAOrderStateWatingEvaluation;
        vc.pageIdentify = CMSPageIdentifyOrderListWaitingEvaluation;
        config = [SAOrderCenterListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"order_list_title_refund" value:@"退款/售后" table:nil];
        vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{@"source" : @"订单列表.退款售后"}];;
        vc.orderState = SAOrderStateWatingRefund;
        vc.pageIdentify = CMSPageIdentifyOrderListWatingRefund;
        config = [SAOrderCenterListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        _configList = configList;
    }
    return _configList;
}

- (SAOrderListDTO *)orderListDTO {
    if (!_orderListDTO) {
        _orderListDTO = SAOrderListDTO.new;
    }
    return _orderListDTO;
}

- (SAOrderNotLoginView *)notSignInView {
    if (!_notSignInView) {
        _notSignInView = SAOrderNotLoginView.new;
        _notSignInView.hidden = SAUser.hasSignedIn;
        _notSignInView.clickedSignInSignUpBTNBlock = ^{
            [SAWindowManager switchWindowToLoginViewController];
        };
    }
    return _notSignInView;
}

@end
