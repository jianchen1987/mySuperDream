//
//  TNOrderViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderViewController.h"
#import "SAMessageButton.h"
#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "TNOrderListCategoryConfig.h"
//#import "SAOrderListViewController.h"
#import "SAOrderNotLoginView.h"
#import "TNMenuNavView.h"
#import "TNOrderDTO.h"
#import "TNOrderListView.h"
#import "TNQueryProcessingOrderRspModel.h"


@interface TNOrderViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate>

/// 标题滚动 View
@property (nonatomic, strong) HDCategoryNumberView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<TNOrderListCategoryConfig *> *configList;
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
/// DTO
@property (nonatomic, strong) SAOrderListDTO *orderListDTO;
/// DTO
@property (nonatomic, strong) TNOrderDTO *orderDTO;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
///  是否需要pop回去上个页面  默认订单列表是一级tab页面
@property (nonatomic, assign) BOOL isNeedPopLastVC;
@end


@implementation TNOrderViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSNumber *isNeedPop = parameters[@"isNeedPop"];
    if (!HDIsObjectNil(isNeedPop)) {
        self.isNeedPopLastVC = [isNeedPop boolValue];
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"fQZWeiLL", @"我的订单");
}
- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 10;

    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.notSignInView];

    @HDWeakify(self);
    self.categoryTitleView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.categoryTitleViewShadowLayer) {
            [self.categoryTitleViewShadowLayer removeFromSuperlayer];
            self.categoryTitleViewShadowLayer = nil;
        }
        self.categoryTitleViewShadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                                        shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                                          fillColor:UIColor.whiteColor.CGColor
                                                       shadowOffset:CGSizeMake(0, 3)];
    };
    // 监听用户登录登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginHandler) name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];

    if ([SAUser hasSignedIn]) {
        [self getUserProcessingOrderNum];
    }
}

- (void)updateViewConstraints {
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(40));
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

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
}

#pragma mark - Data
- (void)getUserProcessingOrderNum {
    @HDWeakify(self);
    [self.orderDTO queryTinhNowProcessOrdersNumberWithOperateNo:SAUser.shared.operatorNo success:^(TNQueryProcessingOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsObjectNil(rspModel)) {
            return;
        }
        self.configList[1].orderNum = rspModel.reviewCount;
        self.configList[2].orderNum = rspModel.paymentCount;
        self.configList[3].orderNum = rspModel.shipmentCount;
        self.configList[4].orderNum = rspModel.shippedCount;
        self.categoryTitleView.counts = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNOrderListCategoryConfig *_Nonnull obj, NSUInteger idx) {
            return obj.orderNum != nil ? obj.orderNum : @(0);
        }];
        [self.categoryTitleView reloadDataWithoutListContainer];
        //总数量
        NSInteger totalCount = [rspModel getTotalOrderNum];
        NSInteger index = [self getIndexOfOrder];
        if (totalCount == 0) {
            [self.tabBarController updateBadgeValue:@"" atIndex:index];
        } else if (totalCount <= 99) {
            [self.tabBarController updateBadgeValue:[NSString stringWithFormat:@"%ld", totalCount] atIndex:index];
        } else {
            [self.tabBarController updateBadgeValue:@"99+" atIndex:index];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
- (NSUInteger)getIndexOfOrder {
    __block NSUInteger index = 99;
    [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIViewController *trueVC = obj;
        if ([obj isKindOfClass:UINavigationController.class]) {
            UINavigationController *nav = obj;
            trueVC = nav.hd_rootViewController;
        }
        if (self == trueVC) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNOrderListCategoryConfig *config = self.configList[index];
    TNOrderListView *listView = [[TNOrderListView alloc] initWithState:config.state];
    @HDWeakify(self);
    listView.reloadOrderCountCallBack = ^{
        @HDStrongify(self);
        [self getUserProcessingOrderNum];
    };
    return listView;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    // 侧滑手势处理
    self.hd_interactivePopDisabled = index > 0;
}

- (HDCategoryNumberView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryNumberView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(TNOrderListCategoryConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title;
        }];
        _categoryTitleView.numberBackgroundColor = HDAppTheme.TinhNowColor.cFF2323;
        _categoryTitleView.numberLabelOffset = CGPointMake(0, -10);
        _categoryTitleView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
            if (number > 99) {
                return @"···";
            }
            return [NSString stringWithFormat:@"%ld", number];
        };
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 20;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        _categoryTitleView.contentEdgeInsetRight = kRealWidth(15);
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}

- (NSArray<TNOrderListCategoryConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<TNOrderListCategoryConfig *> *configList = [NSMutableArray arrayWithCapacity:7];

        TNOrderListCategoryConfig *config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_title_all", @"全部") state:@"" num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"yrT0b3vt", @"待审核") state:TNOrderStatePendingReview num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_pending_payment", @"待付款") state:TNOrderStatePendingPayment num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_pending_shipment", @"待发货") state:TNOrderStatePendingShipment num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_shipped", @"待收货") state:TNOrderStateShipped num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_order_completed", @"已完成") state:TNOrderStateCompleted num:@(0)];
        [configList addObject:config];

        config = [TNOrderListCategoryConfig configWithTitle:TNLocalizedString(@"tn_order_canced", @"已取消") state:TNOrderStateCanceled num:@(0)];
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
/** @lazy orderDTO */
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
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
