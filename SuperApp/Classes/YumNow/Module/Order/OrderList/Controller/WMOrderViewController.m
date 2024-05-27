//
//  WMOrderViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderViewController.h"
#import "SAMessageButton.h"
#import "SAOrderListChildViewControllerConfig.h"
#import "SAOrderListDTO.h"
#import "SAOrderListRspModel.h"
#import "SAOrderListViewController.h"
#import "SAOrderNotLoginView.h"
#import "WMCategoryIndicatorLineView.h"
#import "WMMenuNavView.h"


@interface WMOrderViewController () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, WMViewControllerProtocol>
/// 消息按钮
@property (nonatomic, strong) SAMessageButton *messageBTN;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryDotView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;
/// 所有标题
@property (nonatomic, copy) NSArray<SAOrderListChildViewControllerConfig *> *configList;
/// 标题栏阴影图层
@property (nonatomic, strong) CAShapeLayer *categoryTitleViewShadowLayer;
/// DTO
@property (nonatomic, strong) SAOrderListDTO *orderListDTO;
/// 未登录界面
@property (nonatomic, strong) SAOrderNotLoginView *notSignInView;
/// nav
@property (nonatomic, strong) WMMenuNavView *menuView;
/// 跳转来源
@property (nonatomic, copy) NSString *fromSource;

///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation WMOrderViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.fromSource = parameters[@"fromSource"];
    }
    return self;
}

- (void)hd_setupViews {
    self.hd_interactivePopDisabled = self.navigationController.viewControllers.count <= 1;
    self.clientType = SAClientTypeYumNow;
    self.miniumGetNewDataDuration = 3;

    self.hd_statusBarStyle = UIStatusBarStyleDefault;

    [self.view addSubview:self.menuView];
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

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];

    @HDWeakify(self);
    // 查询未评价订单数量
    [self getOrderCountWithOrderState:SAOrderStateWatingEvaluation success:^(NSUInteger totalCount) {
        @HDStrongify(self);
        self.categoryTitleView.dotStates = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return (obj.vc.orderState == SAOrderStateWatingEvaluation && totalCount > 0) ? @(1) : @(0);
        }];
        [self.categoryTitleView reloadDataWithoutListContainer];
    } failure:nil];
}

- (void)updateViewConstraints {
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarH);
    }];
    [self.categoryTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
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

- (void)hd_languageDidChanged {
    self.categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
        return obj.title.desc;
    }];
    [self.categoryTitleView reloadDataWithoutListContainer];
    if (!self.notSignInView.isHidden) {
        self.notSignInView.descLB.text = WMLocalizedString(@"view_order_after_sign_in", @"登录后可查看订单");
        [self.notSignInView.signInSignUpBTN setTitle:WMLocalizedString(@"signIn_signUp", @"登录/注册") forState:UIControlStateNormal];
    }
}

#pragma mark - Notification
- (void)userLoginHandler {
    self.notSignInView.hidden = true;
    // 获取到当前显示的控制器，触发其 viewWillAppear:
    SAOrderListViewController *currentVC = self.configList[self.categoryTitleView.selectedIndex].vc;
    if (currentVC) {
        [currentVC beginAppearanceTransition:YES animated:NO];
    }
    // 也触发当前界面的 viewWillAppear:
    [self beginAppearanceTransition:YES animated:NO];
}

- (void)userLogoutHandler {
    self.notSignInView.hidden = false;
    [self.messageBTN showMessageCount:0];
}

#pragma mark - Data
/// 获取不同状态订单数量
/// @param orderState 状态
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderCountWithOrderState:(SAOrderState)orderState success:(void (^)(NSUInteger totalCount))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderListDTO getOrderListWithBusinessType:SAClientTypeYumNow orderState:orderState pageNum:1 pageSize:1 orderTimeStart:nil orderTimeEnd:nil
                                            success:^(SAOrderListRspModel *_Nonnull rspModel) {
                                                !successBlock ?: successBlock(rspModel.total);
                                            }
                                            failure:failureBlock];
}

#pragma mark - override
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDCategoryListContainerViewDelegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    SAOrderListViewController *listVC = self.configList[index].vc;
    listVC.businessLine = SAClientTypeYumNow;
    return listVC;
}

- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.configList.count;
}

#pragma mark - HDCategoryViewDelegate
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark - lazy load
- (WMMenuNavView *)menuView {
    if (!_menuView) {
        @HDWeakify(self)
        _menuView = [[WMMenuNavView alloc] init];
        _menuView.title = WMLocalizedString(@"my_order", @"我的订单");
        _menuView.rightView = self.messageBTN;

        if ((self.fromSource && [self.fromSource isEqualToString:@"WMHomeViewController"]) || (self.fromSource && [self.fromSource isEqualToString:@"WMNewHomeViewController"])
            || self.navigationController.viewControllers.count > 1) {
            _menuView.leftImage = @"icon_back_black";
            _menuView.leftImageInset = 15.0f;
            _menuView.clickedLeftViewBlock = ^{
                @HDStrongify(self)[self.navigationController popViewControllerAnimated:YES];
            };
        }
        _menuView.rightImageInset = HDAppTheme.value.padding.right;
        _menuView.clickedRightViewBlock = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{
                @"clientType": SAClientTypeYumNow,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单列表.消息"] : @"订单列表.消息",
                @"associatedId" : self.viewModel.associatedId
            }];
        };
        [_menuView updateConstraintsAfterSetInfo];
    }
    return _menuView;
}

- (SAMessageButton *)messageBTN {
    if (!_messageBTN) {
        SAMessageButton *button = [SAMessageButton buttonWithType:UIButtonTypeCustom clientType:SAClientTypeYumNow];
        [button setImage:[UIImage imageNamed:@"sa_home_message"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 0);
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{
                @"clientType": SAClientTypeYumNow,
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单列表.消息"] : @"订单列表.消息",
                @"associatedId" : self.viewModel.associatedId
            }];
        }];
        _messageBTN = button;
    }
    return _messageBTN;
}

- (HDCategoryDotView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = HDCategoryDotView.new;
        _categoryTitleView.titles = [self.configList mapObjectsUsingBlock:^id _Nonnull(SAOrderListChildViewControllerConfig *_Nonnull obj, NSUInteger idx) {
            return obj.title.desc;
        }];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.delegate = self;
        WMCategoryIndicatorLineView *lineView = [[WMCategoryIndicatorLineView alloc] init];
        lineView.titles = _categoryTitleView.titles;
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorColor = HDAppTheme.color.mainColor;
        lineView.indicatorWidthIncrement = 10;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = UIColor.whiteColor;
        _categoryTitleView.titleSelectedColor = HDAppTheme.color.mainColor;
        _categoryTitleView.cellWidth = (SCREEN_WIDTH - _categoryTitleView.cellSpacing * (_categoryTitleView.titles.count + 1)) / _categoryTitleView.titles.count;
    }
    return _categoryTitleView;
}

- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
        _listContainerView.scrollView.hd_gestureHandleDisabled = true;
    }
    return _listContainerView;
}

- (NSArray<SAOrderListChildViewControllerConfig *> *)configList {
    if (!_configList) {
        NSMutableArray<SAOrderListChildViewControllerConfig *> *configList = [NSMutableArray arrayWithCapacity:4];
        SAInternationalizationModel *title = [SAInternationalizationModel modelWithInternationalKey:@"order_all" value:@"全部" table:nil];
        SAOrderListViewController *vc = [[SAOrderListViewController alloc] initWithRouteParameters:@{
            @"source" : self.viewModel.source,
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.orderState = SAOrderStateAll;
        vc.hd_interactivePopDisabled = true;
        SAOrderListChildViewControllerConfig *config = [SAOrderListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithInternationalKey:@"order_unevaluate" value:@"待评价" table:nil];
        vc = [[SAOrderListViewController alloc] initWithRouteParameters:@{
            @"source" : self.viewModel.source,
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.orderState = SAOrderStateWatingEvaluation;
        vc.hd_interactivePopDisabled = true;
        config = [SAOrderListChildViewControllerConfig configWithTitle:title vc:vc];
        [configList addObject:config];

        title = [SAInternationalizationModel modelWithWMInternationalKey:@"wm_order_refund_and_afterSale" value:@"退款" table:@""];
        vc = [[SAOrderListViewController alloc] initWithRouteParameters:@{
            @"source" : self.viewModel.source,
            @"associatedId" : self.viewModel.associatedId
        }];
        vc.orderState = SAOrderStateWatingRefund;
        vc.hd_interactivePopDisabled = true;
        config = [SAOrderListChildViewControllerConfig configWithTitle:title vc:vc];
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

- (BOOL)needLogin {
    return YES;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeOther;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
