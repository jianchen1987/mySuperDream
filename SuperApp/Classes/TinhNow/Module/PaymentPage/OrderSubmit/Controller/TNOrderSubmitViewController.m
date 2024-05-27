//
//  TNOrderSubmitViewController.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitViewController.h"
#import "HDCheckStandViewController.h"
#import "LKDataRecord.h"
#import "SAAddressListViewController.h"
#import "SAAddressModel.h"
#import "SAApolloManager.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "SAEnum.h"
#import "SAGoodsModel.h"
#import "SAInfoTableViewCell.h"
#import "SAShoppingAddressModel.h"
#import "SATableView.h"
#import "SAWindowManager.h"
#import "TNAdressChangeTipsAlertView.h"
#import "TNAlertView.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNCheckRegionModel.h"
#import "TNCheckSumitOrderModel.h"
#import "TNCustomerServiceView.h"
#import "TNFillMemoViewController.h"
#import "TNInvalidProductAlertView.h"
#import "TNNoticeScrollerAlertView.h"
#import "TNOrderDetailsViewController.h"
#import "TNOrderSkuSpecifacationCell.h"
#import "TNOrderStoreHeaderView.h"
#import "TNOrderSubmitAddressChooseTableViewCell.h"
#import "TNOrderSubmitBottomBarView.h"
#import "TNOrderSubmitGoodsSectionModel.h"
#import "TNOrderSubmitGoodsTableViewCell.h"
#import "TNOrderSubmitSkeletonTableViewCell.h"
#import "TNOrderSubmitTermsCell.h"
#import "TNOrderSubmitViewModel.h"
#import "TNOrderTipCell.h"
#import "TNOrderViewController.h"
#import "TNPaymentDTO.h"
#import "TNPaymentMethodCell.h"
#import "TNPaymentMethodModel.h"
#import "TNPaymentResultViewController.h"
#import "TNPhoneActionAlertView.h"
#import "TNPromoCodeRspModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNSubmitOrderNoticeModel.h"
#import "TNTool.h"
#import "UIViewController+NavigationController.h"
#import "WMOrderSubmitRspModel.h"
#import <HDUIKit/HDUIKit.h>
#import "TNDeliveryCompanyCell.h"


@interface TNOrderSubmitViewController () <UITableViewDelegate, UITableViewDataSource, HDCheckStandViewControllerDelegate, TNFillMemoProtocol>
/// viewmodel
@property (nonatomic, strong) TNOrderSubmitViewModel *viewModel;
/// tableview
@property (nonatomic, strong) SATableView *tableView;
/// dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 底部工具类
@property (nonatomic, strong) TNOrderSubmitBottomBarView *bottomView;

@property (nonatomic, strong) TNShoppingCarStoreModel *shoppingCarStoreModel;
/// 下单结果
@property (nonatomic, strong) WMOrderSubmitRspModel *submitOrderRspModel;
/// 埋点 订单模型
@property (strong, nonatomic) TalkingDataOrder *dataOrder;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
///  上个页面回调
@property (nonatomic, copy) void (^callBack)(void);
@end


@implementation TNOrderSubmitViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    TNShoppingCarStoreModel *storeModel = [parameters objectForKey:@"shoppingCarStoreModel"];
    self.viewModel.storeModel = [storeModel yy_modelCopy];
    NSString *funnel = parameters[@"funnel"]; // 埋点
    self.callBack = parameters[@"callBack"];
    if (HDIsStringNotEmpty(funnel)) {
        self.viewModel.funnel = funnel;
    }
    self.viewModel.source = [parameters objectForKey:@"source"];
    self.viewModel.associatedId = [parameters objectForKey:@"associatedId"];

    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    // 获取公告数据
    [self.viewModel queryNoticeInfo];
    // 获取提交订单需要数据
    [self.viewModel querySubmitOrderDependData];
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_page_ordersubmit_title", @"订单提交");
}
- (void)hd_bindViewModel {
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    [self.viewModel hd_bindView:self.view];
    @HDWeakify(self);
    self.viewModel.networkFailBlock = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self refreshNewData];
        }];
    };

    self.viewModel.calcPayFeeFailBlock = ^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        if ([rspModel.code isEqualToString:@"TN1055"] || [rspModel.code isEqualToString:@"TN1056"]) {
            //            [self.tableView successGetNewDataWithNoMoreData:YES];
            //            //展示失效商品列表
            //            [self showInvalidProductListAlertView:rspModel];
            // 已改版  有失效的
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        } else if ([rspModel.code isEqualToString:@"TN2004"] || [rspModel.code isEqualToString:@"TN2005"]) {
            //            TN2004("TN2004", "优惠码不可使用"),TN2005("TN2005", "优惠码已过期"),
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        } else {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
            @HDWeakify(self);
            [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
                @HDStrongify(self);
                [self refreshNewData];
            }];
        }
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"dataSource" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataSource = [NSArray arrayWithArray:self.viewModel.dataSource];
        [self.tableView successGetNewDataWithNoMoreData:YES];
        [self showTipsAlertView];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController == nil && !HDIsArrayEmpty(self.viewModel.calcResult.cartItemDTOS)) {
        !self.callBack ?: self.callBack();
    }
}

- (void)updateViewConstraints {
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        //        make.height.mas_equalTo(kRealHeight(50));
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [super updateViewConstraints];
}

// #pragma mark - private methods
//- (void)showInvalidProductListAlertView:(SARspModel *)rspModel {
//     NSDictionary *invalidDict = @{};
//     NSArray *invalidList = @[];
//     id object = rspModel.data;
//     if ([object isKindOfClass:[NSDictionary class]]) {
//         invalidDict = (NSDictionary *)object;
//         invalidList = invalidDict[@"ids"];
//     }
//     if (HDIsArrayEmpty(invalidList)) {
//         [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg]
//                       buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
//                           handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
//                               [alertView dismiss];
//                           }];
//         return;
//     }
//
//     NSString *title;
//     if ([rspModel.code isEqualToString:@"TN1055"]) {
//         title = TNLocalizedString(@"SiUlE434", @"以下商品已失效");
//     } else if ([rspModel.code isEqualToString:@"TN1056"]) {
//         title = TNLocalizedString(@"ZPPi9yx1", @"以下商品库存不足");
//     }
//     NSMutableArray *dataArr = [NSMutableArray array];
//     for (NSString *productId in invalidList) {
//         for (TNOrderSubmitGoodsTableViewCellModel *model in self.viewModel.goodCellModelArr) {
//             if ([model.productId isEqualToString:productId]) {
//                 [dataArr addObject:model];
//             }
//         }
//     }
//     TNInvalidProductAlertView *alertView = [[TNInvalidProductAlertView alloc] initWithTitle:title DataArr:dataArr];
//     @HDWeakify(self);
//     alertView.backChangeBlock = ^{
//         @HDStrongify(self);
//         !self.callBack ?: self.callBack();
//         [self.navigationController popViewControllerAnimated:YES];
//     };
//     [alertView show];
// }
/// 试算失败后  重新刷新数据
- (void)refreshNewData {
    [self removePlaceHolder];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];
    if (!HDIsObjectNil(self.viewModel.addressModel) && !HDIsObjectNil(self.viewModel.paymentMethodModel) && HDIsStringNotEmpty(self.viewModel.merchantNo)) {
        [self.viewModel calcTotalPayFee];
    } else {
        [self.viewModel querySubmitOrderDependData];
    }
}
#pragma mark - 检查是否有失效或者无货商品
- (void)checkInvalidProducts {
    if (!HDIsArrayEmpty(self.viewModel.calcResult.invalidProducts)) {
        TNInvalidProductAlertView *alertView;
        if (self.viewModel.canSubmitOrder) {
            __block NSMutableArray *dataArr = [NSMutableArray array];
            [self.viewModel.storeModel.selectedItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (HDIsStringEmpty(obj.invalidMsg)) {
                    [dataArr addObject:obj];
                }
            }];
            alertView = [[TNInvalidProductAlertView alloc] initWithTitle:TNLocalizedString(@"tn_current_order", @"本次下单商品") invalidType:TNSubmitInvalidTypeCanBuy DataArr:dataArr];
        } else {
            alertView = [[TNInvalidProductAlertView alloc] initWithTitle:TNLocalizedString(@"SiUlE434", @"以下商品已失效") invalidType:TNSubmitInvalidTypeAllInvalid
                                                                 DataArr:self.viewModel.storeModel.selectedItems];
        }

        @HDWeakify(self);
        alertView.backChangeBlock = ^{
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        alertView.continueSubmitOrderBlock = ^(NSArray<TNShoppingCarItemModel *> *_Nonnull list) {
            @HDStrongify(self);
            [self checkOrderCanBuy];
        };
        alertView.closeBlock = ^{
            @HDStrongify(self);
            [self.bottomView setSubmitBtnEnable:YES];
        };
        [alertView show];
    } else {
        // 没有无效商品 继续下个流程
        [self checkOrderCanBuy];
    }
}

#pragma mark - 检验是否可以下单
- (void)checkOrderCanBuy {
    [self.view showloading];
    @HDWeakify(self);
    [self.viewModel checkBeforeSubmitOrder:^(TNCheckSumitOrderModel *_Nonnull checkModel) {
        @HDStrongify(self);
        if (checkModel.regionStoreRespDTO.deliveryValid == YES) {
            // 查看是否重复下单
            if (!checkModel.createOrderDuplicateCheckRes.result) {
                // 没有重复下单 直接去下单
                [self submitOrder];
            } else {
                @HDWeakify(self);
                TNAlertView *alertView = [TNAlertView alertViewWithTitle:nil message:TNLocalizedString(@"tn_duplicate_order_tips", @"您刚刚已经下过该订单了，请勿重复下单") config:nil];
                alertView.identitableString = TNLocalizedString(@"tn_duplicate_order_tips", @"您刚刚已经下过该订单了，请勿重复下单");

                HDAlertViewButton *confirmButton = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_check_order", @"查看订单") type:HDAlertViewButtonTypeCustom
                                                                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                                  [alertView dismiss];
                                                                                  @HDStrongify(self);
                                                                                  [self getRepeatOrderNoAndNavigatitonToOrderVC];
                                                                              }];
                HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_buy_again", @"再来一单") type:HDAlertViewButtonTypeCancel
                                                                             handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                                                 @HDStrongify(self);
                                                                                 [self submitOrder];
                                                                                 [alertView dismiss];
                                                                             }];

                [alertView addButtons:@[cancelButton, confirmButton]];
                alertView.closeBtnClickCallBack = ^{
                    @HDStrongify(self);
                    [self.view dismissLoading];
                    [self.bottomView setSubmitBtnEnable:true];
                };
                [alertView show];
            }

        } else {
            [self.view dismissLoading];
            [self.bottomView setSubmitBtnEnable:true];
            if (checkModel.regionStoreRespDTO.takeawayStore) {
                // 酒水店铺的提示
                TNAdressChangeTipsAlertConfig *config = [TNAdressChangeTipsAlertConfig configWithCheckModel:checkModel.regionStoreRespDTO.regionTipsInfoDTO isJustShow:NO];
                config.addressModel = self.viewModel.addressModel;
                NSString *title;
                if (config.alertType == TNAdressTipsAlertTypeChooseStore) {
                    title = TNLocalizedString(@"GXNehJLg", @"去购买");
                } else if (config.alertType == TNAdressTipsAlertTypeDeliveryArea) {
                    title = TNLocalizedString(@"SugnLs2V", @"查看配送区域");
                }
                TNAlertAction *action = [TNAlertAction actionWithTitle:title handler:^(TNAlertAction *_Nonnull action) {
                    if (config.alertType == TNAdressTipsAlertTypeChooseStore) {
                        if (HDIsStringNotEmpty(config.storeNo)) {
                            [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": config.storeNo}];
                        }
                    } else if (config.alertType == TNAdressTipsAlertTypeDeliveryArea) {
                        [HDMediator.sharedInstance navigaveToTinhNowDeliveryAreaMapViewController:@{@"addressModel": config.addressModel}];
                    }
                }];
                config.actions = @[action];
                TNAdressChangeTipsAlertView *alertView = [TNAdressChangeTipsAlertView alertViewWithConfig:config];
                [alertView show];
            } else {
                [NAT showAlertWithMessage:HDIsStringNotEmpty(checkModel.regionStoreRespDTO.tipsInfo) ? checkModel.regionStoreRespDTO.tipsInfo :
                                                                                                       TNLocalizedString(@"tn_check_region_tip", @"商品仅配送至金边主城区，请修改收货地址")
                              buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
            }
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoadingAfterDelay:1];
        [self.bottomView setSubmitBtnEnable:true];
    }];
}
#pragma mark -  提交订单
- (void)submitOrder {
    if (self.viewModel.hasOverseasGood && HDIsObjectNil(self.viewModel.selectedDeliveryComponyModel) && !HDIsArrayEmpty(self.viewModel.deliveryComponylist)) {
        [HDTips showWithText:TNLocalizedString(@"tn_please_choose_ship_company", @"请选择物流公司") inView:self.view hideAfterDelay:3];
        [self.bottomView setSubmitBtnEnable:YES];
        return;
    }

    NSString *trackEventName = [self.viewModel.trackPrefixName stringByAppendingString:@"填写订单_点击提交订单"];
    if (HDIsStringNotEmpty(self.viewModel.funnel)) {
        trackEventName = [NSString stringWithFormat:@"%@提交订单", self.viewModel.funnel];
    }
    [SATalkingData trackEvent:trackEventName label:@"" parameters:@{@"付款方式": self.viewModel.paymentMethodModel.name.desc}];

    @HDWeakify(self);
    [self.viewModel submitOrderSuccess:^(WMOrderSubmitRspModel *_Nonnull rspModel, TNPaymentMethodModel *paymentType) {
        @HDStrongify(self);
        [self.view dismissLoading];
        // 下单埋点
        [self trackEventOnPlaceOrder:rspModel.orderNo];
        self.submitOrderRspModel = rspModel;
        // 需要审核的订单 先弹窗提示
        if (!self.viewModel.calcResult.needVerify) {
            if ([paymentType.method isEqualToString:TNPaymentMethodOnLine]) {
                if (self.viewModel.calcResult.amountPayable.cent.doubleValue <= 0) {
                    // 支付金额为 0 直接去详情页
                    [self navigationToOnlineResultPageWithParams:@{@"paymentState": @(SAPaymentStatePayed), @"paymentAmount": self.viewModel.calcResult.amountPayable}];
                } else {
                    [self handlingSuccessSubmitOrderWithRspModel:rspModel];
                }
            } else {
                [self gotoPaymentResultWithPaymentType:[paymentType.methodValue integerValue] orderNo:rspModel.orderNo amount:rspModel.paymentAmount paymentState:SAPaymentStatePayed];
            }
        } else {
            // 海外购待审核弹窗提示
            [self showOverseasPurchasePendingReviewAlertView];
        }

        // 首页转化漏斗
        NSString *homeSource = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_source"];
        NSString *homeAssociateId = [NSUserDefaults.standardUserDefaults valueForKey:@"homePage_click_associatedId"];
        NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];

        [LKDataRecord.shared
            traceEvent:@"order_submit"
                  name:[NSString stringWithFormat:@"电商_下单_%@", HDIsStringNotEmpty(self.viewModel.source) ? self.viewModel.source : (HDIsStringNotEmpty(homeSource) ? homeSource : @"other")]
            parameters:@{
                @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : (HDIsStringNotEmpty(homeAssociateId) ? homeAssociateId : @""),
                @"orderNo": rspModel.orderNo,
                @"shortID": HDIsStringNotEmpty(shortID) ? shortID : @""
            }
                   SPM:[LKSPM SPMWithPage:@"TNOrderSubmitViewController" area:@"" node:@""]];

        // 清空缓存
        [NSUserDefaults.standardUserDefaults setObject:@"" forKey:@"homePage_click_source"];
        [NSUserDefaults.standardUserDefaults setObject:@"" forKey:@"homePage_click_associatedId"];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoadingAfterDelay:1];
        [self.bottomView setSubmitBtnEnable:true];                                                    // 失败后可再次提交订单
        if ([rspModel.code isEqualToString:@"TN1050"] || [rspModel.code isEqualToString:@"TN1051"]) { // 风控拒单过多的限制下单
            [self showRejectOrderTipsAlert:nil message:rspModel.msg];
        } else if ([rspModel.code isEqualToString:@"TN1059"]) {
            // 没有预约时间弹窗提示
            [self.viewModel showSelectDeliveryTimeAlertViewWithTitle:TNLocalizedString(@"tn_selected_delivery_time_tips", @"请选择预约时间")];
        } else if ([rspModel.code isEqualToString:@"TN1036"]) {
            // 已经下过单了  请勿重复下单
            [self showRepeatOrdersTipsAlertView];
        } else if ([rspModel.code isEqualToString:@"TN2002"] || [rspModel.code isEqualToString:@"TN2003"]) {
            @HDWeakify(self);
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                                  @HDStrongify(self);
                                  // 超过店铺营业时间  以及商品超重 不能选择立即送达
                                  [self.viewModel processImmediateDeliveryNotAvailable];
                              }];

        } else if ([rspModel.code isEqualToString:@"TN2006"]) {
            // 有失效商品 重新试算
            @HDWeakify(self);
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                                  @HDStrongify(self);
                                  [self.viewModel refreshLoad];
                              }];
        } else {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    }];
}

#pragma mark 下单埋点交易数据
- (void)trackEventOnPlaceOrder:(NSString *)orderId {
    if (HDIsStringNotEmpty(orderId) && !HDIsArrayEmpty(self.viewModel.storeModel.selectedItems)) {
        self.dataOrder = [TalkingDataOrder createOrder:orderId total:[self.viewModel.calcResult.amountPayable.cent intValue] currencyType:self.viewModel.calcResult.amountPayable.cy];
        for (TNShoppingCarItemModel *item in self.viewModel.storeModel.selectedItems) {
            [self.dataOrder addItem:item.goodsId category:@"" name:item.goodsName unitPrice:[item.salePrice.cent intValue] amount:[item.quantity intValue]];
        }
        [TalkingData onPlaceOrder:SAUser.shared.loginName order:self.dataOrder];
    }
}
#pragma mark - 支付成功埋点
- (void)paySuccessOnPlaceOrder {
    if (!HDIsObjectNil(self.dataOrder)) {
        [TalkingData onOrderPaySucc:SAUser.shared.loginName payType:@"在线支付" order:self.dataOrder];
    }
}
#pragma mark - 修改地址
- (void)changeShipingAdress:(SAShoppingAddressModel *)model {
    __block SAShoppingAddressModel *addressCellModel = model;
    @HDWeakify(self);
    void (^callback)(SAShoppingAddressModel *, SAAddressModelFromType) = ^(SAShoppingAddressModel *addressModel, SAAddressModelFromType fromType) {
        addressCellModel = addressModel;
        @HDStrongify(self);
        if (fromType == SAAddressModelFromTypeAdd) {
            // 添加地址
            [TNEventTrackingInstance trackEvent:@"ship_add_addr" properties:@{@"addrId": addressModel.addressNo}];
        } else {
            if (HDIsObjectNil(self.viewModel.addressModel) || HDIsStringEmpty(self.viewModel.addressModel.addressNo)
                || ![self.viewModel.addressModel.addressNo isEqualToString:addressModel.addressNo]) {
                // 切换收货地址埋点
                [TNEventTrackingInstance trackEvent:@"ship_switch_addr" properties:@{@"addrId": addressModel.addressNo}];
            }
        }

        [self.viewModel updateAddressModel:addressModel];
    };

    SAAddressModel *addressModel = SAAddressModel.new;
    addressModel.lat = addressCellModel.latitude;
    addressModel.lon = addressCellModel.longitude;
    addressModel.addressNo = addressCellModel.addressNo;
    addressModel.address = addressCellModel.address;
    addressModel.consigneeAddress = addressCellModel.consigneeAddress;
    addressModel.fromType = SAAddressModelFromTypeOrderSubmit;
    [HDMediator.sharedInstance navigaveToChooseMyAddressViewController:@{@"callback": callback, @"currentAddressModel": addressModel, @"isNeedCompleteAddress": @(self.isNeedCompleteAddress)}];
}
#pragma mark - 下单异常 误重复下单的提示
- (void)showRepeatOrdersTipsAlertView {
    NSString *message = TNLocalizedString(@"6pPdIAun", @"订单已创建，请勿重复下单");
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
    alertView.identitableString = message;
    @HDWeakify(self);
    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_bargain_check_order", @"查看订单") type:HDAlertViewButtonTypeCustom
                                                           handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                               [alertView dismiss];
                                                               @HDStrongify(self);
                                                               [self getRepeatOrderNoAndNavigatitonToOrderVC];
                                                           }];
    button.enabled = NO;
    [button setTitleColor:HDAppTheme.TinhNowColor.G3 forState:UIControlStateDisabled];
    [alertView addButtons:@[button]];
    [alertView show];

    [TNTool startDispatchTimerWithCountDown:5 callBack:^(NSInteger second, dispatch_source_t _Nonnull timer) {
        HDLog(@"倒计时开始 -- %ld", second);
        if (second == 0) {
            button.enabled = YES;
            [button setTitle:TNLocalizedString(@"tn_bargain_check_order", @"查看订单") forState:UIControlStateNormal];
        } else {
            [button setTitle:[NSString stringWithFormat:@"%@ (%ld)", TNLocalizedString(@"tn_bargain_check_order", @"查看订单"), second] forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - 获取重复订单号 并且跳转对应页面
- (void)getRepeatOrderNoAndNavigatitonToOrderVC {
    @HDWeakify(self);
    [self.viewModel getUnifiedOrderNoByRandomStrComplete:^(NSString *_Nonnull orderNo) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(orderNo)) {
            TNOrderDetailsViewController *vc = [[TNOrderDetailsViewController alloc] initWithRouteParameters:@{@"orderNo": orderNo}];
            [self.navigationController pushViewController:vc animated:YES removeSpecClass:self.class onlyOnce:YES];
        } else {
            TNOrderViewController *vc = [[TNOrderViewController alloc] initWithRouteParameters:@{@"isNeedPop": @(YES)}];
            [self.navigationController pushViewController:vc animated:YES removeSpecClass:self.class onlyOnce:YES];
        }
    }];
}
#pragma mark - 选择支付方式
- (void)selectedPaymentMethod:(TNPaymentMethodModel *)model indexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    void (^updatePaymentMethod)(void) = ^(void) {
        @HDStrongify(self);
        model.isSelected = YES;
        for (TNPaymentMethodModel *subModel in self.viewModel.avaliablePaymentMethods) {
            if (![subModel.method isEqualToString:model.method]) {
                subModel.isSelected = NO;
            }
        }
        self.viewModel.paymentMethodModel = model;
        [SACacheManager.shared setObject:model forKey:kCacheKeyTinhNowPaymentMethodLastChoosed type:SACacheTypeDocumentNotPublic];
        [self.viewModel calcTotalPayFee];
        [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"填写订单_选择付款方式"] label:@"" parameters:@{@"付款方式": model.name.desc}];

        [TNEventTrackingInstance trackEvent:@"pay_switch_chnl" properties:@{@"payChnlId": model.paymentMethodId}];

        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };

    if ([model.method isEqualToString:TNPaymentMethodOnLine]) {
        [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                               @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                             SALocalizedString(@"login_new2_Online Shopping Order", @"电商购物")] bindSuccessBlock:^{
            @HDStrongify(self);

            @HDWeakify(self);
            [SAChoosePaymentMethodPresenter showPreChoosePaymentMethodViewWithPayableAmount:self.viewModel.calcResult.amountPayable businessLine:SAClientTypeTinhNow
                                                                    supportedPaymentMethods:@[HDSupportedPaymentMethodOnline]
                                                                                 merchantNo:self.viewModel.merchantNo
                                                                                    storeNo:self.viewModel.storeModel.storeNo
                                                                                      goods:@[]
                                                                      selectedPaymentMethod:model.selectedOnlineMethodType
                                                                 choosedPaymentMethodHander:^(HDPaymentMethodType *_Nonnull paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount) {
                                                                     @HDStrongify(self);
                                                                     [self.viewModel updatePayDiscountAmount:paymentDiscountAmount];
                                                                     model.selectedOnlineMethodType = paymentMethod;
                                                                     updatePaymentMethod();
                                                                 }];
        }
                                                  cancelBindBlock:nil];


    } else {
        if (model.isSelected) {
            return;
        }
        [self.viewModel updatePayDiscountAmount:nil];
        updatePaymentMethod();
    }
}

#pragma mark - 海外购订单 待审核弹窗提示
- (void)showOverseasPurchasePendingReviewAlertView {
    NSString *message = [NSString stringWithFormat:@"%@", self.viewModel.calcResult.verifyMessage];
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:nil message:message config:nil];
    alertView.identitableString = message;
    @HDWeakify(self);
    HDAlertViewButton *button =
        [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCustom handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            @HDStrongify(self);
            // 收到进入待审核后  删除提交订单页面   产品要求插入订单列表页面  进入订单详情页面
            TNOrderViewController *orderListVC = [[TNOrderViewController alloc] initWithRouteParameters:@{@"isNeedPop": @(YES)}];
            TNOrderDetailsViewController *orderDetailVC = [[TNOrderDetailsViewController alloc] initWithRouteParameters:@{@"orderNo": self.submitOrderRspModel.orderNo}];
            NSMutableArray *newVCArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            for (NSInteger i = newVCArr.count - 1; i >= 0; i--) {
                UIViewController *vc = newVCArr[i];
                if ([vc isKindOfClass:self.class]) {
                    [newVCArr removeObject:vc];
                    break;
                }
            }
            [newVCArr addObject:orderListVC];
            [newVCArr addObject:orderDetailVC];
            orderListVC.hidesBottomBarWhenPushed = YES;
            orderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController setViewControllers:newVCArr animated:YES];
        }];
    button.enabled = NO;
    [button setTitleColor:HDAppTheme.TinhNowColor.G3 forState:UIControlStateDisabled];
    [alertView addButtons:@[button]];
    [alertView show];

    [TNTool startDispatchTimerWithCountDown:5 callBack:^(NSInteger second, dispatch_source_t _Nonnull timer) {
        HDLog(@"倒计时开始 -- %ld", second);
        if (second == 0) {
            button.enabled = YES;
            [button setTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") forState:UIControlStateNormal];
        } else {
            [button setTitle:[NSString stringWithFormat:@"%@ (%ld)", TNLocalizedString(@"1GuBJmHn", @"我知道了"), second] forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - 弹窗 提示文案   根据接口字段控制
- (void)showTipsAlertView {
    if (HDIsObjectNil(self.viewModel.noticeModel) || HDIsObjectNil(self.viewModel.noticeModel.payOrderPop) || HDIsStringEmpty(self.viewModel.noticeModel.payOrderPop.noticeMsg)
        || !self.viewModel.noticeModel.payOrderPop.isOpen || self.viewModel.noticeModel.payOrderPop.isShow) {
        return;
    }
    TNNoticeScrollerAlertView *alertView = [TNNoticeScrollerAlertView alertViewWithContentText:self.viewModel.noticeModel.payOrderPop.noticeMsg];
    [alertView show];
    // 记录已经弹过了  不再弹了
    self.viewModel.noticeModel.payOrderPop.isShow = YES;
}
#pragma mark - 展示拒收订单提示
- (void)showRejectOrderTipsAlert:(NSString *)title message:(NSString *)message {
    HDAlertViewConfig *config = [[HDAlertViewConfig alloc] init];
    config.titleFont = [HDAppTheme.TinhNowFont fontSemibold:16];
    config.titleColor = HDAppTheme.TinhNowColor.C1;
    config.messageFont = HDAppTheme.TinhNowFont.standard15;
    config.messageColor = HDAppTheme.TinhNowColor.G1;
    config.marginTitle2Message = kRealWidth(15);
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(40), 0, 0, 0);
    config.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(20), kRealWidth(40), kRealWidth(20));
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:title message:message config:config];
    alertView.identitableString = message;
    @HDWeakify(self);
    HDAlertViewButton *confirmButton = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_customer", @"联系客服") type:HDAlertViewButtonTypeCustom
                                                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                      [alertView dismiss];
                                                                      @HDStrongify(self);
                                                                      [self showPlatform];
                                                                  }];
    confirmButton.backgroundColor = HDAppTheme.TinhNowColor.C1;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
    HDAlertViewButton *cancelButton = [HDAlertViewButton buttonWithTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") type:HDAlertViewButtonTypeCancel
                                                                 handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                     [alertView dismiss];
                                                                 }];
    cancelButton.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [cancelButton setTitleColor:HDAppTheme.TinhNowColor.G3 forState:UIControlStateNormal];
    cancelButton.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
    [alertView addButtons:@[cancelButton, confirmButton]];
    [alertView show];
}
#pragma mark - 联系平台
- (void)showPlatform {
    TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];

    view.dataSource = [view getTinhnowDefaultPlatform];
    [view layoutyImmediately];
    TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
    [actionView show];
}
- (void)handlingSuccessSubmitOrderWithRspModel:(WMOrderSubmitRspModel *)rspModel {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];

    buildModel.orderNo = rspModel.orderNo;
    //    buildModel.outPayOrderNo = rspModel.outPayOrderNo;  // 每次都会创建支付单，不许要传
    buildModel.merchantNo = self.viewModel.merchantNo;
    buildModel.storeNo = self.viewModel.storeModel.storeNo;
    buildModel.payableAmount = rspModel.paymentAmount;
    buildModel.businessLine = SAClientTypeTinhNow;
    buildModel.goods = [self.viewModel.storeModel.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        SAGoodsModel *item = SAGoodsModel.new;
        item.goodsId = obj.goodsId;
        item.skuId = obj.goodsSkuId;
        item.snapshotId = obj.itemDisplayNo;
        item.quantity = obj.quantity.integerValue;
        return item;
    }];
    buildModel.selectedPaymentMethod = self.viewModel.paymentMethodModel.selectedOnlineMethodType;
    HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
    checkStandVC.resultDelegate = self;

    [self presentViewController:checkStandVC animated:YES completion:nil];
}

- (void)gotoPaymentResultWithPaymentType:(SAOrderPaymentType)paymentType orderNo:(NSString *)orderNo amount:(SAMoneyModel *)paymentAmount paymentState:(SAPaymentState)paymentState {
    TNPaymentResultViewController *vc = TNPaymentResultViewController.new;
    TNPaymentResultModel *model = TNPaymentResultModel.new;

    if (SAOrderPaymentTypeCashOnDelivery == paymentType) {
        model.pageName = TNLocalizedString(@"tn_submit_order_result", @"下单结果页");
        model.stateDesc = TNLocalizedString(@"tn_submit_order_result_desc", @"请等待商家确认和联系");
        model.buttonBackgroundColor = HDAppTheme.TinhNowColor.C1;
    } else if (SAOrderPaymentTypeOnline == paymentType) {
        model.pageName = TNLocalizedString(@"tn_payment_result", @"支付结果页");
        model.buttonBackgroundColor = HDAppTheme.TinhNowColor.C3;
    } else if (SAOrderPaymentTypeTransfer == paymentType) {
        model.pageName = TNLocalizedString(@"tn_submit_order_result", @"下单结果页");
        model.stateDesc = TNLocalizedString(@"tn_transfer_result_tip", @"请查看订单，并点击“转账付款”");
        model.buttonBackgroundColor = HDAppTheme.TinhNowColor.C1;
    }

    model.paymentType = paymentType;
    model.orderNo = orderNo;
    model.amount = paymentAmount;
    model.state = paymentState;
    model.merchantNo = self.viewModel.merchantNo;

    vc.model = model;
    vc.backHomeClickedHander = ^(TNPaymentResultModel *_Nonnull model) {
        // 到电商首页
        [HDMediator.sharedInstance navigaveToTinhNowController:nil];
    };
    @HDWeakify(self);
    vc.orderDetailClickedHandler = ^(TNPaymentResultModel *_Nonnull model) {
        @HDStrongify(self);
        [SATalkingData trackEvent:@"[电商]支付结果_点击查看订单"];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": model.orderNo}];
    };
    [SAWindowManager presentViewController:vc parameters:@{}];
}
// 线上支付结果页
- (void)navigationToOnlineResultPageWithParams:(NSDictionary *)params {
    [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:true];
    NSMutableDictionary *resultPageParams = params ? params.mutableCopy : [NSMutableDictionary dictionary];
    resultPageParams[@"businessLine"] = SAClientTypeTinhNow;
    resultPageParams[@"orderNo"] = self.submitOrderRspModel.orderNo;
    resultPageParams[@"merchantNo"] = self.viewModel.merchantNo;
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:resultPageParams];
}
#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:true];

    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.submitOrderRspModel.orderNo}];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:true];

    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.submitOrderRspModel.orderNo}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        // 支付成功 埋点
        [self paySuccessOnPlaceOrder];
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:@{@"businessLine": SAClientTypeTinhNow, @"orderNo": self.submitOrderRspModel.orderNo, @"merchantNo": controller.merchantNo}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [HDMediator.sharedInstance
            navigaveToCheckStandPayResultViewController:
                @{@"businessLine": SAClientTypeTinhNow,
                  @"orderNo": self.submitOrderRspModel.orderNo,
                  @"paymentState": @(SAPaymentStatePayFail),
                  @"merchantNo": controller.merchantNo}];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.submitOrderRspModel.orderNo}];
        [self remoteViewControllerWithSpecifiedClass:self.class];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if ([sectionModel.headerModel isKindOfClass:HDTableHeaderFootViewModel.class]) {
        return 40.0f;
    } else if (sectionModel.commonHeaderModel && [sectionModel.commonHeaderModel isKindOfClass:TNOrderStoreHeaderModel.class]) {
        return 40;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if ([sectionModel.headerModel isKindOfClass:HDTableHeaderFootViewModel.class]) {
        HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
        headView.model = sectionModel.headerModel;
        return headView;
    } else if (sectionModel.commonHeaderModel && [sectionModel.commonHeaderModel isKindOfClass:TNOrderStoreHeaderModel.class]) {
        TNOrderStoreHeaderView *view = [TNOrderStoreHeaderView headerWithTableView:tableView];
        view.model = sectionModel.commonHeaderModel;
        return view;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        TNOrderSubmitAddressChooseTableViewCell *cell = [TNOrderSubmitAddressChooseTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"%ld", indexPath.row]];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:TNOrderSubmitGoodsTableViewCellModel.class]) {
        TNOrderSubmitGoodsTableViewCell *cell = [TNOrderSubmitGoodsTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:[TNPaymentMethodCellModel class]]) {
        TNPaymentMethodCell *cell = [TNPaymentMethodCell cellWithTableView:tableView];
        TNPaymentMethodCellModel *methodModel = (TNPaymentMethodCellModel *)model;
        cell.dataSource = methodModel.methods;
        @HDWeakify(self) cell.selectedItemHandler = ^(TNPaymentMethodModel *_Nonnull payMethodModel) {
            @HDStrongify(self)[self selectedPaymentMethod:payMethodModel indexPath:indexPath];
        };
        return cell;
    } else if ([model isKindOfClass:TNOrderTipCellModel.class]) {
        TNOrderTipCell *cell = [TNOrderTipCell cellWithTableView:tableView];
        cell.model = (TNOrderTipCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNOrderSubmitTermsCellModel.class]) {
        TNOrderSubmitTermsCell *cell = [TNOrderSubmitTermsCell cellWithTableView:tableView];
        cell.model = (TNOrderSubmitTermsCellModel *)model;
        @HDWeakify(self);
        cell.clickAgreeTermsCallBack = ^(BOOL isAgree) {
            @HDStrongify(self);
            self.viewModel.hasAgreeTerms = isAgree;
        };
        return cell;
    } else if ([model isKindOfClass:TNOrderSkuSpecifacationCellModel.class]) {
        TNOrderSkuSpecifacationCell *cell = [TNOrderSkuSpecifacationCell cellWithTableView:tableView];
        cell.cellModel = (TNOrderSkuSpecifacationCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNDeliveryCompanyCellModel.class]) {
        TNDeliveryCompanyCell *cell = [TNDeliveryCompanyCell cellWithTableView:tableView];
        cell.model = (TNDeliveryCompanyCellModel *)model;
        @HDWeakify(self) cell.selectedItemHandler = ^(TNDeliveryComponyModel *_Nonnull model) {
            @HDStrongify(self);
            [self.viewModel setSelectedDeliveryCompany:model];
            [UIView performWithoutAnimation:^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    } else {
        TNOrderSubmitSkeletonTableViewCell *cell = [TNOrderSubmitSkeletonTableViewCell cellWithTableView:tableView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"填写订单_点击收货地址/新建地址"]];
        [self changeShipingAdress:model];
    }
    if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        if ([trueModel.associatedObject isKindOfClass:NSString.class] && [trueModel.associatedObject isEqualToString:@"memo"]) {
            [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"填写订单_点击备注"]];
            TNFillMemoViewController *vc = TNFillMemoViewController.new;
            vc.delegate = self;
            vc.memo = self.viewModel.memo;
            [SAWindowManager navigateToViewController:vc];
        }
    }
}

#pragma mark - private methods
- (BOOL)isNeedCompleteAddress {
    BOOL needCheck = [[SAApolloManager getApolloConfigForKey:ApolloConfigKeyOrderSubmitNeedCheckAddress][SAClientTypeTinhNow] boolValue];
    return needCheck;
}

#pragma mark - TNFillMemoDelegate
- (void)memoDidChanged:(NSString *)memo {
    self.viewModel.memo = memo;
    [self.tableView successGetNewDataWithNoMoreData:YES];
}

#pragma mark - lazy load
/** @lazy viewmodel */
- (TNOrderSubmitViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNOrderSubmitViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _tableView;
}
/** @lazy bottomView */
- (TNOrderSubmitBottomBarView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TNOrderSubmitBottomBarView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _bottomView.confirmButtonClickedHandler = ^{
            @HDStrongify(self);
            if (!self.viewModel.addressModel || HDIsStringEmpty(self.viewModel.addressModel.addressNo)) {
                [HDTips showWithText:TNLocalizedString(@"tn_choose_adress", @"请选择收货地址") inView:self.view hideAfterDelay:3];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }
            if ([self.viewModel.addressModel isNeedCompleteAddressInClientType:SAClientTypeTinhNow]) {
                [HDTips showWithText:SALocalizedString(@"1qlk3HjQ", @"请补充完善收货信息") inView:self.view hideAfterDelay:3];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }
            if (!self.viewModel.paymentMethodModel) {
                [HDTips showWithText:TNLocalizedString(@"tn_choose_pay_method", @"请选择支付方式") inView:self.view hideAfterDelay:3];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }
            if (self.viewModel.needToastEnterPromotionCode) {
                [HDTips showWithText:TNLocalizedString(@"VPdlGdML", @"请输入优惠码") inView:self.view hideAfterDelay:3];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }
            if (self.viewModel.needToastSelectedCoupon) {
                [HDTips showWithText:TNLocalizedString(@"Lj8FNljv", @"请选择优惠券") inView:self.view hideAfterDelay:3];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }
            // 如果是海外购商品没有同意条款 就滑动到最下面
            if (self.viewModel.hasOverseasGood && !HDIsObjectNil(self.viewModel.noticeModel.overseasKnow) && self.viewModel.noticeModel.overseasKnow.isOpen && self.viewModel.hasAgreeTerms == NO
                && self.dataSource.count > 1) {
                [HDTips showWithText:TNLocalizedString(@"PDnJ6R3I", @"请阅读并勾选页面底部条款") inView:self.view hideAfterDelay:3];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.dataSource.count - 1];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }

            if (!HDIsArrayEmpty(self.viewModel.calcResult.deliveryTimeDTOList) && HDIsStringEmpty(self.viewModel.deliveryTime)) {
                [self.viewModel showSelectDeliveryTimeAlertViewWithTitle:TNLocalizedString(@"tn_selected_delivery_time_tips", @"请选择预约时间")];
                [self.bottomView setSubmitBtnEnable:YES];
                return;
            }


            // 增加提交订单前，手机号码判断
            @HDWeakify(self);
            [SAWindowManager
                navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                      @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                    SALocalizedString(@"login_new2_Online Shopping Order", @"电商购物")] bindSuccessBlock:^{
                    @HDStrongify(self);
                    // 先检验订单是否有失效的
                    [self checkInvalidProducts];
                } cancelBindBlock:^{
                    @HDStrongify(self);
                    [self.bottomView setSubmitBtnEnable:YES];
                }];
        };
    }
    return _bottomView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNOrderSubmitSkeletonTableViewCell cellWithTableView:tableview];
            } else if (indexPath.row == 1) {
                return [TNOrderSubmitSkeletonPayMentCell cellWithTableView:tableview];
            } else {
                return [TNOrderSubmitSkeletonGoodsCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNOrderSubmitSkeletonTableViewCell skeletonViewHeight];
            } else if (indexPath.row == 1) {
                return [TNOrderSubmitSkeletonPayMentCell skeletonViewHeight];
            } else {
                return [TNOrderSubmitSkeletonGoodsCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 4;
    }
    return _provider;
}
#pragma mark - navConfig
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return NO;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return NO;
}
@end
