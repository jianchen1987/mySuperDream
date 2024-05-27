//
//  TNSpecialActivityViewController.m
//  SuperApp
//
//  Created by luyan on 2020/9/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSpecialActivityViewController.h"
#import "SAAddressModel.h"
#import "SACommonConst.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressModel.h"
#import "SASingleImageCollectionViewCell.h"
#import "TNActivityCarouselView.h"
#import "TNAdressChangeTipsAlertView.h"
#import "TNCategoryFilterView.h"
#import "TNGlobalData.h"
#import "TNNotificationConst.h"
#import "TNRedZoneSaleAreaAlertView.h"
#import "TNScrollerView.h"
#import "TNShareManager.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNSpecialActivityContentView.h"
#import "TNSpecialHorizontalStyleView.h"
#import "TNSpecialVerticalStyleView.h"
#import "TNTabBarViewController.h"
#import <HDUIKit/HDActionAlertView.h>
#import "SAAddressCacheAdaptor.h"
#import "TNCartBarView.h"
#import "TNShoppingCar.h"
// #define kBannerViewHeight kRealWidth(236)
@interface TNSpecialActivityViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) TNSpeciaActivityViewModel *viewModel;
/// 滚动容器
@property (nonatomic, strong) TNScrollerView *baseScrollView;
/// banner
@property (strong, nonatomic) TNActivityCarouselView *bannerView;
/// 样式1
@property (strong, nonatomic) TNSpecialHorizontalStyleView *horizontalStyleView;
/// 样式2
@property (strong, nonatomic) TNSpecialVerticalStyleView *verticalStyleView;
///// 是否能滚动
@property (nonatomic) BOOL cannotScroll;
/// 点击到顶按钮
@property (strong, nonatomic) HDUIButton *scrollTopBtn;
/// 导航栏按钮数组
@property (strong, nonatomic) NSMutableArray<UIBarButtonItem *> *rightItems;
/// 专题类型
@property (nonatomic, assign) TNSpecialActivityType speciaActivityType;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);
/// 选择地址回调
@property (nonatomic, copy) void (^chooseAdressCallback)(SAShoppingAddressModel *adressModel, SAAddressModelFromType fromType);
/// 地址管理dto
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 底部提示视图
@property (strong, nonatomic) UIView *bottomTipsView;
/// 底部提示文本
@property (strong, nonatomic) UILabel *deleveryAreaTipsLabel;
/// 查看配送区域按钮
//@property (strong, nonatomic) HDUIButton *watchAreaBtn;
/// 选择图片
@property (nonatomic, strong) UIImageView *arrowIV;
/// 是否需要继续弹出推荐专题列表弹出
@property (nonatomic, assign) BOOL isNeedShowRecommndActivityListAlert;
/// 地址是否可以配送   用于从地图进入酒水地图
@property (nonatomic, assign) BOOL deliveryValid;
///  用户处理 用户不在此专题  但是重新登录 需要重新刷新页面
@property (nonatomic, assign) BOOL isNeedRefrshRedZoneData;
/// 购物车
@property (strong, nonatomic) TNCartBarView *cartBarView;
@end


@implementation TNSpecialActivityViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTNNotificationNameChangedSpecialStyle object:nil];
    if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    }
}
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    if (parameters.allKeys.count) {
        NSString *activityId = parameters[@"activityNo"];
        NSString *funnel = parameters[@"funnel"];                           // 埋点
        NSNumber *canDelivery = parameters[@"deliveryValid"];               // 所传地址是否在配送区域
        SAShoppingAddressModel *addressModel = parameters[@"addressModel"]; // 红区专题 上层带入的地址模型
        if (!HDIsObjectNil(addressModel)) {
            self.viewModel.addressModel = addressModel;
        } else { // 获取上次选中的地址
            self.viewModel.addressModel = [TNGlobalData shared].orderAdress;
        }
        if (canDelivery != nil) {
            self.deliveryValid = [canDelivery boolValue];
        }
        if (HDIsStringNotEmpty(funnel)) {
            self.viewModel.funnel = funnel;
        }
        if (HDIsStringNotEmpty(activityId)) {
            self.viewModel.activityId = activityId;
        }
        NSNumber *type = parameters[@"type"];
        if (type) {
            self.speciaActivityType = [type integerValue];
        } else {
            self.speciaActivityType = TNSpecialActivityTypeDefault;
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNeedRefrshRedZoneData) {
        [self initRedZoneSpecialActivityData];
        self.isNeedRefrshRedZoneData = NO;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [[TNShoppingCartEntryWindow sharedInstance] show];
    if (self.speciaActivityType == TNSpecialActivityTypeRedZone && self.isNeedShowRecommndActivityListAlert) {
        [self showAlertViewByAlertType:TNAdressTipsAlertTypeActivityList];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
    //        [[TNShoppingCartEntryWindow sharedInstance] resetShoppintCarOffsetY];
    //    }
    //    [[TNShoppingCartEntryWindow sharedInstance] dismiss];

    [TNEventTrackingInstance trackExposureScollProductsEventWithProperties:@{@"specialId": self.viewModel.activityId}];
}
// 埋点
- (void)trackingPage {
    if (HDIsStringNotEmpty(self.viewModel.activityId)) {
        [TNEventTrackingInstance trackPage:@"special" properties:@{@"specialId": self.viewModel.activityId}];
    }
}
- (void)hd_setupViews {
    CGFloat cartBarHeight = 52;

    // 设置高度
    self.viewModel.kProductsListViewHeight = kScreenHeight - kNavigationBarH - kiPhoneXSeriesSafeBottomHeight - cartBarHeight;

    HDLog(@"cartBarHeight = %f    kProductsListViewHeight = %f ", cartBarHeight, self.viewModel.kProductsListViewHeight);
    if (self.navigationController.viewControllers.count == 1) {
        self.viewModel.kProductsListViewHeight = kScreenHeight - kNavigationBarH - kiPhoneXSeriesSafeBottomHeight - [HDHelper hd_tabBarHeight] - cartBarHeight;
        // kTabBarH  高度不准
    }

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.bannerView];

    [self.view addSubview:self.scrollTopBtn];
    [self.view addSubview:self.cartBarView];


    if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        @HDWeakify(self);
        self.chooseAdressCallback = ^(SAShoppingAddressModel *adressModel, SAAddressModelFromType fromType) {
            @HDStrongify(self);
            if (fromType == SAAddressModelFromTypeAddressList) {
                self.viewModel.activityId = nil;
                self.viewModel.addressModel = adressModel;
                [self getRedZoneActivityId];
            }
        };
        self.bannerView.showChangeAdressBtn = YES;
        self.bannerView.chooseAdressCallback = self.chooseAdressCallback;
        [self.view addSubview:self.bottomTipsView];
        [self.bottomTipsView addSubview:self.deleveryAreaTipsLabel];
        [self.bottomTipsView addSubview:self.arrowIV];

        // 红区监听登录成功
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
    }

    //    bottomHeight += kRealWidth(52);

    /// 监听样式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSpecialStyleNoti:) name:kTNNotificationNameChangedSpecialStyle object:nil];
}
#pragma mark -设置样式的view
- (void)setUpStyleView {
    if (self.viewModel.styleType == TNSpecialStyleTypeVertical) {
        [self.scrollViewContainer addSubview:self.verticalStyleView];
    } else {
        [self.scrollViewContainer addSubview:self.horizontalStyleView];
    }
    [self.view setNeedsUpdateConstraints];
}
#pragma mark -样式切换通知
- (void)changeSpecialStyleNoti:(NSNotification *)noti {
    NSNumber *type = noti.userInfo[@"type"];
    if (type != nil) {
        self.viewModel.styleType = [type integerValue];
    }
    // 重置分类选中状态
    [self.viewModel resetCategoryDataSelectedState];
    if (self.viewModel.styleType == TNSpecialStyleTypeVertical) {
        [self.horizontalStyleView removeFromSuperview];
        self.horizontalStyleView = nil;
        [self.verticalStyleView layoutIfNeeded];
        [self.scrollViewContainer addSubview:self.verticalStyleView];
        [self.view setNeedsUpdateConstraints];
        [self.verticalStyleView refreshListData];
        [self.verticalStyleView refreshCategory];
    } else {
        [self.verticalStyleView removeFromSuperview];
        self.verticalStyleView = nil;
        [self.horizontalStyleView layoutIfNeeded];
        [self.scrollViewContainer addSubview:self.horizontalStyleView];
        [self.view setNeedsUpdateConstraints];
        [self.horizontalStyleView resetView];
    }
}
#pragma mark -登录成功通知
- (void)userLoginSuccessHandler {
    if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        UIViewController *currentVC = self.navigationController.viewControllers.lastObject;
        if (currentVC == self) {
            // 重新拉取红区专题数据
            [self initRedZoneSpecialActivityData];
        } else {
            self.isNeedRefrshRedZoneData = YES;
        }
    }
}
- (void)hd_getNewData {
    [super hd_getNewData];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    if (self.speciaActivityType == TNSpecialActivityTypeDefault) {
        [self initDefalutSpecialActivityData];
    } else if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        [self initRedZoneSpecialActivityData];
    }
}
#pragma mark - 初始化默认专题数据
- (void)initDefalutSpecialActivityData {
    // 获取专题配置数据 banner及标题 分享url数据  以及是否已下架
    [self getSpecialActivityConfigData];
}

#pragma mark - 初始化红区专题数据
- (void)initRedZoneSpecialActivityData {
    if ([SAUser hasSignedIn]) {
        if (!HDIsObjectNil(self.viewModel.addressModel) && HDIsStringNotEmpty(self.viewModel.addressModel.addressNo)) {
            // 如果有地址就直接获取专题id
            if (HDIsStringNotEmpty(self.viewModel.activityId)) {
                [self getSpecialActivityConfigData];
                [self showBottomViewTips:self.deliveryValid];
                // 保存拉取到酒水专题数据的 地址
                [TNGlobalData shared].orderAdress = self.viewModel.addressModel;
            } else {
                [self getRedZoneActivityId];
            }
        } else {
            [self getDefaultAddress];
        }

    } else {
        // 选择定位的
        [self getLocationAdress];
    }
}
#pragma mark - 获取默认收货地址
- (void)getDefaultAddress {
    @HDWeakify(self);
    [self.view showloading];
    [self.addressDTO getDefaultAddressSuccess:^(SAShoppingAddressModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsObjectNil(rspModel)) {
            self.viewModel.addressModel = rspModel;
            // 获取红区专题id
            [self getRedZoneActivityId];
        } else {
            // 没有默认地址  获取定位的
            [self getLocationAdress];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self getLocationAdress];
    }];
}
/// 获取定位地点
- (void)getLocationAdress {
    SAAddressModel *currentlyAddress = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeMaster];
    self.viewModel.addressModel.latitude = currentlyAddress.lat;
    self.viewModel.addressModel.longitude = currentlyAddress.lon;
    [self getRedZoneActivityId];
}
#pragma mark - 获取红区专题id
- (void)getRedZoneActivityId {
    if (!self.bottomTipsView.isHidden) {
        [self hiddenBottmViewTips];
    }
    @HDWeakify(self);
    self.viewModel.redZoneModel = nil;
    self.viewModel.activityId = nil;
    self.viewModel.configModel = nil;
    [self.view showloading];
    [self.viewModel getRedZoneSpecialActivityIdSuccessBlock:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (HDIsStringNotEmpty(self.viewModel.redZoneModel.specialId)) {
            self.viewModel.activityId = self.viewModel.redZoneModel.specialId;
            [self.viewModel clearCacheData];
            [self getSpecialActivityConfigData];
            if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal) {
                [self.horizontalStyleView refreshListData];
            } else {
                [self.verticalStyleView refreshListData];
            }
            [self showBottomViewTips:YES];
            // 保存拉取到酒水专题数据的 地址
            [TNGlobalData shared].orderAdress = self.viewModel.addressModel;
            // 重新拿到红区专题id 埋点一次
            [self trackingPage];
        } else {
            // 没有获取到专题  显示全部专题
            [self showAlertViewByAlertType:TNAdressTipsAlertTypeActivityList];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self getRedZoneActivityId];
        }];
    }];
}
#pragma mark - 获取砍价专题配置数据  banner 标题  分享url
- (void)getSpecialActivityConfigData {
    if (self.speciaActivityType == TNSpecialActivityTypeRedZone && !HDIsObjectNil(self.viewModel.addressModel)) {
        [self.bannerView updateAdressText:self.viewModel.addressModel.address];
    }
    @HDWeakify(self);
    [self.view showloading];
    [self.viewModel getSpecialActivityConfigDataSuccessBlock:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsArrayEmpty(self.viewModel.configModel.productSpecialAdvs)) {
            self.bannerView.hidden = NO;
            self.bannerView.speciaTrackPrefixName = self.viewModel.speciaTrackPrefixName;
            self.bannerView.model = self.viewModel.configModel;
        } else {
            self.bannerView.hidden = YES;
        }
        // 设置样式视图
        [self setUpStyleView];
        if (self.viewModel.configModel != nil) {
            self.boldTitle = self.viewModel.configModel.name;
            if (HDIsStringNotEmpty(self.viewModel.configModel.shareUrl)) {
                self.hd_navigationItem.rightBarButtonItems = self.rightItems;
            }
        }
        // 获取广告以及分类数据
        [self getadsAndCategoryData];
        // 埋点
        [SATalkingData trackEvent:[NSString stringWithFormat:@"%@%@", self.viewModel.speciaTrackPrefixName, @"进入商品专题"] label:@"" parameters:@{@"样式": self.viewModel.specialTrackStyleParamete}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if ([rspModel.code isEqualToString:@"TN1017"]) {
            UIViewPlaceholderViewModel *placeHolderModel = UIViewPlaceholderViewModel.new;
            placeHolderModel.image = @"tinhnow_product_failure";
            placeHolderModel.imageSize = CGSizeMake(kRealWidth(280), kRealHeight(200));
            placeHolderModel.title = TNLocalizedString(@"tn_topic_expired_tips", @"专题已失效，去首页看看吧");
            placeHolderModel.titleFont = HDAppTheme.TinhNowFont.standard15;
            placeHolderModel.titleColor = HDAppTheme.TinhNowColor.G3;
            placeHolderModel.needRefreshBtn = YES;
            placeHolderModel.refreshBtnTitle = TNLocalizedString(@"tn_go_home_page", @"去首页");
            placeHolderModel.refreshBtnBackgroundColor = HDAppTheme.TinhNowColor.C1;
            placeHolderModel.backgroundColor = [UIColor whiteColor];
            [self showPlaceHolder:placeHolderModel NeedRefrenshBtn:YES refrenshCallBack:^{
                [[HDMediator sharedInstance] navigaveToTinhNowController:nil];
            }];
        } else {
            @HDWeakify(self);
            [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
                @HDStrongify(self);
                [self getSpecialActivityConfigData];
            }];
        }
    }];
}
#pragma mark - 获取分类标题及广告数据
- (void)getadsAndCategoryData {
    [self.viewModel requestAdsAndCategoryDataCompletion:^{

    }];
}
#pragma mark -查看配送区域
- (void)clickDeliverMap {
    @HDWeakify(self);
    void (^callBack)(NSString *, SAShoppingAddressModel *, BOOL) = ^(NSString *activityId, SAShoppingAddressModel *adressModel, BOOL deliverValid) {
        @HDStrongify(self);
        self.isNeedShowRecommndActivityListAlert = NO;
        self.viewModel.activityId = activityId;
        self.viewModel.addressModel = adressModel;
        [self.viewModel clearCacheData];
        [self getSpecialActivityConfigData];
        if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal) {
            [self.horizontalStyleView refreshListData];
        } else {
            [self.verticalStyleView refreshListData];
        }
        [self showBottomViewTips:deliverValid];
        // 保存拉取到酒水专题数据的 地址
        [TNGlobalData shared].orderAdress = self.viewModel.addressModel;
    };
    // 地址是如果有全局存储的 就用全局存储的
    SAShoppingAddressModel *model = [TNGlobalData shared].orderAdress;
    if (HDIsObjectNil(model)) {
        model = self.viewModel.addressModel;
    }
    [HDMediator.sharedInstance navigaveToTinhNowDeliveryAreaMapViewController:@{@"addressModel": model, @"callBack": callBack, @"isFromRedZone": @(1)}];
}
#pragma mark -显示弹窗
- (void)showAlertViewByAlertType:(TNAdressTipsAlertType)alertType {
    if (alertType == TNAdressTipsAlertTypeActivityList && [SAWindowManager visibleViewController] == self) {
        TNRedZoneSaleAreaAlertView *alertView = [[TNRedZoneSaleAreaAlertView alloc] initWithDataArr:self.viewModel.redZoneModel.addressSpecialDTOList];
        @HDWeakify(self);
        alertView.clickActivityCallBack = ^(TNRedZoneAdressForActivityModel *_Nonnull model) {
            @HDStrongify(self);
            self.viewModel.activityId = model.specialId;
            self.viewModel.addressModel.addressNo = model.addressNo;
            self.viewModel.addressModel.address = model.address;
            self.viewModel.addressModel.latitude = model.latitude;
            self.viewModel.addressModel.longitude = model.longitude;
            self.viewModel.addressModel.consigneeName = model.consigneeName;
            self.viewModel.addressModel.gender = model.gender;
            self.viewModel.addressModel.mobile = model.mobile;
            // 保存拉取到酒水专题数据的 地址
            [TNGlobalData shared].orderAdress = self.viewModel.addressModel;
            [self.viewModel clearCacheData];
            [self getSpecialActivityConfigData];
            if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal) {
                [self.horizontalStyleView refreshListData];
            } else {
                [self.verticalStyleView refreshListData];
            }
            [self showBottomViewTips:YES];
        };
        alertView.addNewAdressCallBack = ^{
            @HDStrongify(self);
            void (^cancelCallBack)(void) = ^{
                if (HDIsObjectNil(self.viewModel.addressModel) || HDIsStringEmpty(self.viewModel.addressModel.addressNo)) {
                    // 定位点的
                    [self getLocationAdress];
                } else {
                    [self showAlertViewByAlertType:TNAdressTipsAlertTypeActivityList];
                }
            };
            [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": self.chooseAdressCallback, @"cancelCallBack": cancelCallBack}];
        };
        alertView.watchDeliverAreaCallBack = ^{
            @HDStrongify(self);
            self.isNeedShowRecommndActivityListAlert = YES;
            [self clickDeliverMap];
        };
        alertView.backHomeCallBack = ^{
            @HDStrongify(self);
            self.isNeedShowRecommndActivityListAlert = YES;
            TNTabBarViewController *tab = [[TNTabBarViewController alloc] init];
            [SAWindowManager navigateToViewController:tab removeSpecClass:@"TNSpecialActivityViewController"];
            //            [HDMediator.sharedInstance navigaveToTinhNowController:nil];
        };
        [alertView show];
        // 弹过就还原
        self.isNeedShowRecommndActivityListAlert = NO;
    }

    //    if (alertType == TNAdressTipsAlertTypeChooseAdress) {
    //        //选择地址弹窗
    //        TNAdressChangeTipsAlertConfig *config = [[TNAdressChangeTipsAlertConfig alloc] init];
    //        config.alertType = TNAdressTipsAlertTypeChooseAdress;
    //        config.title = TNLocalizedString(@"XDIeNGvw", @"请先选择收货地址，以便查看商品的配送范围");
    //        @HDWeakify(self);
    //        TNAlertAction *chooseAdressAction =
    //            [TNAlertAction actionWithTitle:TNLocalizedString(@"lps6Jl61", @"选择收货地址")
    //                                   handler:^(TNAlertAction *_Nonnull action) {
    //                                       @HDStrongify(self);
    //                                       void (^cancelCallBack)(void) = ^{
    //                                           if (HDIsObjectNil(self.viewModel.addressModel) || HDIsStringEmpty(self.viewModel.addressModel.addressNo)) {
    //                                               [self showAlertViewByAlertType:TNAdressTipsAlertTypeChooseAdress];
    //                                           }
    //                                       };
    //                                       [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback" : self.chooseAdressCallback, @"cancelCallBack" : cancelCallBack}];
    //                                   }];
    //        TNAlertAction *backHomeAction = [TNAlertAction actionWithTitle:TNLocalizedString(@"SW1eoWUt", @"返回商城")
    //                                                               handler:^(TNAlertAction *_Nonnull action) {
    //                                                                   @HDStrongify(self);
    //                                                                   self.isClickBackToHomeWithOutSelectedAdress = YES;
    //                                                                   [HDMediator.sharedInstance navigaveToTinhNowController:nil];
    //                                                               }];
    //        backHomeAction.textColor = HexColor(0x5D667F);
    //        config.actions = @[ chooseAdressAction, backHomeAction ];
    //        TNAdressChangeTipsAlertView *alertView = [TNAdressChangeTipsAlertView alertViewWithConfig:config];
    //        [alertView show];
    //    } else
}
#pragma mark - 显示底部提示
- (void)showBottomViewTips:(BOOL)canDelivery {
    self.bottomTipsView.hidden = NO;
    if (canDelivery) {
        self.deleveryAreaTipsLabel.text = TNLocalizedString(@"L0DSj30d", @"查看店铺配送范围");
    } else {
        self.deleveryAreaTipsLabel.text = TNLocalizedString(@"tn_activity_not_delivery_tip", @"收货地址不在配送区域");
    }
    [self.bottomTipsView layoutIfNeeded];
    [self.bottomTipsView setNeedsLayout];
}
- (void)hiddenBottmViewTips {
    self.bottomTipsView.hidden = YES;
}
- (void)updateViewConstraints {
    [self.baseScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        //        if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        //            make.bottom.equalTo(self.bottomTipsView.mas_top);
        //        } else {
        make.bottom.equalTo(self.cartBarView.mas_top);
        //        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseScrollView);
        make.width.equalTo(self.baseScrollView);
        //        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    if (!self.bannerView.isHidden) {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.scrollViewContainer);
        }];
    }
    UIView *topView = self.bannerView.isHidden ? self.hd_navigationBar : self.bannerView;
    if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal) {
        [self.horizontalStyleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.scrollViewContainer);
            make.top.equalTo(topView.mas_bottom);
        }];
    } else if (self.viewModel.styleType == TNSpecialStyleTypeVertical) {
        [self.verticalStyleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.scrollViewContainer);
            make.top.equalTo(topView.mas_bottom);
        }];
    }

    [self.scrollTopBtn sizeToFit];
    [self.scrollTopBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
            make.bottom.equalTo(self.bottomTipsView.mas_top).offset(-kRealWidth(10));
        } else {
            make.bottom.equalTo(self.cartBarView.mas_bottom).offset(-kRealWidth(70));
        }
        make.right.equalTo(self.view.mas_right);
    }];

    if (self.speciaActivityType == TNSpecialActivityTypeRedZone) {
        [self.bottomTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.cartBarView.mas_top);
        }];
        [self.arrowIV sizeToFit];
        [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomTipsView.mas_right).offset(-kRealWidth(12));
            make.centerY.equalTo(self.bottomTipsView.mas_centerY);
        }];
        [self.deleveryAreaTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomTipsView.mas_top).offset(kRealWidth(6));
            make.bottom.equalTo(self.bottomTipsView.mas_bottom).offset(-kRealWidth(6));
            make.left.equalTo(self.bottomTipsView.mas_left).offset(kRealWidth(12));
            make.right.lessThanOrEqualTo(self.arrowIV.mas_left).offset(-kRealWidth(10));
        }];

        [self.arrowIV setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.deleveryAreaTipsLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.cartBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];


    [super updateViewConstraints];

    [[TNShoppingCar share] convertCartPointByTargetView:self.cartBarView.cartBtn];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}
#pragma mark - 分享点击
#pragma mark - method
- (void)shareClick {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    if (!HDIsArrayEmpty(self.viewModel.configModel.productSpecialAdvs)) {
        TNSpeciaActivityAdModel *adModel = self.viewModel.configModel.productSpecialAdvs.firstObject;
        shareModel.shareImage = adModel.adv;
    }
    shareModel.shareTitle = self.viewModel.configModel.name;
    shareModel.shareContent = TNLocalizedString(@"tn_share_default_desc", @"商品品类多，质量好，价格低，快来一起WOWNOW吧");
    shareModel.shareLink = self.viewModel.configModel.shareUrl;
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];

    [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击分享"]];
}
- (void)searchClick {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:@{@"specialId": self.viewModel.configModel.activityId}];
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat kBannerViewHeight = self.bannerView.height;
    if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal && !self.horizontalStyleView.isHidden) {
        if (self.bannerView.isHidden) {
            self.horizontalStyleView.canScroll = YES;
            return;
        }
        CGFloat offsetY = scrollView.contentOffset.y;

        if (offsetY >= kBannerViewHeight) {
            self.cannotScroll = YES;
            self.horizontalStyleView.canScroll = YES;
            scrollView.contentOffset = CGPointMake(0, kBannerViewHeight);
            [self.horizontalStyleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.hd_navigationBar.mas_bottom);
            }];
        } else {
            if (self.cannotScroll) {
                scrollView.contentOffset = CGPointMake(0, kBannerViewHeight);
            } else {
                [self.horizontalStyleView scrollerToTop];
            }
            [self.horizontalStyleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.scrollViewContainer);
                make.top.equalTo(self.bannerView.mas_bottom);
            }];
        }
    } else if (self.viewModel.styleType == TNSpecialStyleTypeVertical && !self.verticalStyleView.isHidden) {
        if (self.bannerView.isHidden) {
            self.verticalStyleView.canScroll = YES;
            return;
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY >= kBannerViewHeight) {
            self.cannotScroll = YES;
            self.verticalStyleView.canScroll = YES;
            scrollView.contentOffset = CGPointMake(0, kBannerViewHeight);
            [self.verticalStyleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.hd_navigationBar.mas_bottom);
            }];
        } else {
            if (self.cannotScroll) {
                scrollView.contentOffset = CGPointMake(0, kBannerViewHeight);
            } else {
                [self.verticalStyleView keepScollerContentOffset];
            }
            [self.verticalStyleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.scrollViewContainer);
                make.top.equalTo(self.bannerView.mas_bottom);
            }];
        }
    }
    //    [[TNShoppingCartEntryWindow sharedInstance] shrink];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    [[TNShoppingCartEntryWindow sharedInstance] performSelector:@selector(expand) withObject:nil afterDelay:1];
}

- (TNScrollerView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[TNScrollerView alloc] init];
        _baseScrollView.showsVerticalScrollIndicator = false;
        _baseScrollView.alwaysBounceVertical = true;
        _baseScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _baseScrollView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _baseScrollView;
}
/** @lazy horizontalStyleView */
- (TNSpecialHorizontalStyleView *)horizontalStyleView {
    if (!_horizontalStyleView) {
        _horizontalStyleView = [[TNSpecialHorizontalStyleView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _horizontalStyleView.scrollerViewScrollerToTopCallBack = ^{
            @HDStrongify(self);
            self.cannotScroll = NO;
        };
        _horizontalStyleView.scrollerShowTopBtnCallBack = ^(BOOL isShow) {
            @HDStrongify(self);
            self.scrollTopBtn.hidden = !isShow;
        };
    }
    return _horizontalStyleView;
}
/** @lazy verticalStyleView */
- (TNSpecialVerticalStyleView *)verticalStyleView {
    if (!_verticalStyleView) {
        _verticalStyleView = [[TNSpecialVerticalStyleView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _verticalStyleView.scrollerViewScrollerToTopCallBack = ^{
            @HDStrongify(self);
            self.cannotScroll = NO;
        };
        _verticalStyleView.scrollerShowTopBtnCallBack = ^(BOOL isShow) {
            @HDStrongify(self);
            self.scrollTopBtn.hidden = !isShow;
        };
    }
    return _verticalStyleView;
}
/** @lazy bannerView */
- (TNActivityCarouselView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[TNActivityCarouselView alloc] init];
    }
    return _bannerView;
}
/** @lazy viewModel */
- (TNSpeciaActivityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNSpeciaActivityViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy scrollTopBtn */
- (HDUIButton *)scrollTopBtn {
    if (!_scrollTopBtn) {
        _scrollTopBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_scrollTopBtn setImage:[UIImage imageNamed:@"tn_scroller_top"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_scrollTopBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            //            //置顶
            if (self.viewModel.styleType == TNSpecialStyleTypeVertical) {
                [self.verticalStyleView scrollerToTop];
            } else if (self.viewModel.styleType == TNSpecialStyleTypeHorizontal) {
                [self.horizontalStyleView scrollerToTop];
            }
            [self.baseScrollView setContentOffset:CGPointZero animated:YES];
        }];
        _scrollTopBtn.hidden = YES;
        //        _scrollTopBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            @HDStrongify(self);
        //            [[TNShoppingCartEntryWindow sharedInstance] setShoppintCarOffsetY:self.scrollTopBtn.top - kRealWidth(10)];
        //        };
    }
    return _scrollTopBtn;
}
- (NSMutableArray<UIBarButtonItem *> *)rightItems {
    if (!_rightItems) {
        _rightItems = [NSMutableArray array];
        HDUIButton *shareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

        HDUIButton *searchButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:[UIImage imageNamed:@"tinhnow_nav_search"] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        [_rightItems addObject:shareItem];
        [_rightItems addObject:searchItem];
    }
    return _rightItems;
}
/** @lazy addressDTO */
- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = [[SAShoppingAddressDTO alloc] init];
    }
    return _addressDTO;
}
/** @lazy bottomTipsView */
- (UIView *)bottomTipsView {
    if (!_bottomTipsView) {
        _bottomTipsView = [[UIView alloc] init];
        _bottomTipsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bottomTipsView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDeliverMap)];
        [_bottomTipsView addGestureRecognizer:tap];

        //        _bottomTipsView.hd_borderPosition = HDViewBorderPositionBottom;
    }
    return _bottomTipsView;
}
/** @lazy _deleveryAreaTipsLabel */
- (UILabel *)deleveryAreaTipsLabel {
    if (!_deleveryAreaTipsLabel) {
        // 提示文本
        _deleveryAreaTipsLabel = [[UILabel alloc] init];
        _deleveryAreaTipsLabel.textColor = [UIColor whiteColor];
        _deleveryAreaTipsLabel.font = [UIFont systemFontOfSize:12];
        _deleveryAreaTipsLabel.numberOfLines = 0;
    }
    return _deleveryAreaTipsLabel;
}
///** @lazy watchAreaBtn */
//- (HDUIButton *)watchAreaBtn {
//    if (!_watchAreaBtn) {
//        _watchAreaBtn = [[HDUIButton alloc] init];
//        _watchAreaBtn.backgroundColor = [UIColor whiteColor];
//        [_watchAreaBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
//        [_watchAreaBtn setTitle:TNLocalizedString(@"L0DSj30d", @"查看店铺配送范围") forState:UIControlStateNormal];
//        _watchAreaBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        _watchAreaBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
//        _watchAreaBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
//            [view setRoundedCorners:UIRectCornerAllCorners radius:13];
//        };
//        @HDWeakify(self);
//        [_watchAreaBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
//            @HDStrongify(self);
//            [self clickDeliverMap];
//        }];
//    }
//    return _watchAreaBtn;
//}
/** @lazy arrowIV */
- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_white_back_arrow"]];
    }
    return _arrowIV;
}
/** @lazy bottomTipsView */
- (TNCartBarView *)cartBarView {
    if (!_cartBarView) {
        _cartBarView = [[TNCartBarView alloc] init];
        _cartBarView.backgroundColor = [UIColor whiteColor];
        _cartBarView.hd_borderPosition = HDViewBorderPositionTop;
    }
    return _cartBarView;
}
#pragma mark - 允许连续push
- (BOOL)allowContinuousBePushed {
    return YES;
}
@end
