//
//  TNOrderSubmitViewModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "NSDate+SAExtension.h"
#import "NSString+extend.h"
#import "SACacheManager.h"
#import "SAChoosePaymentMethodPresenter.h"
#import "SACouponTicketModel.h"
#import "SAGoodsModel.h"
#import "SAGuardian.h"
#import "SAInfoView.h"
#import "SAMoneyModel.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressModel.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNCheckRegionModel.h"
#import "TNCouponTicketDTO.h"
#import "TNDecimalTool.h"
#import "TNExplanationAlertView.h"
#import "TNFreightDetailAlertView.h"
#import "TNGetPaymentMethodsRspModel.h"
#import "TNGlobalData.h"
#import "TNOrderDTO.h"
#import "TNOrderSkuSpecifacationCell.h"
#import "TNOrderStoreHeaderView.h"
#import "TNOrderSubmitAddressTableViewCell.h"
#import "TNOrderSubmitGoodsSectionModel.h"
#import "TNOrderSubmitGoodsTableViewCell.h"
#import "TNOrderSubmitTermsCell.h"
#import "TNOrderTipCell.h"
#import "TNPaymentDTO.h"
#import "TNPaymentMethodCell.h"
#import "TNPaymentMethodModel.h"
#import "TNProductDTO.h"
#import "TNPromoCodeRspModel.h"
#import "TNQueryUserShoppingCarRspModel.h"
#import "TNSelectDeliveryTimeAlertView.h"
#import "TNShippingMethodModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNStoreDTO.h"
#import "TNStoreInfoRspModel.h"
#import "TNSubmitOrderNoticeModel.h"
#import "TNTextFeildAlertView.h"
#import "WMOrderSubmitCouponModel.h"
#import "WMOrderSubmitRspModel.h"
#import <HDKitCore/HDKitCore.h>
#import "TNDeliveryComponyAlertView.h"
#import "TNDeliveryCompanyCell.h"

@interface TNOrderSubmitViewModel ()
/// dto
@property (nonatomic, strong) TNPaymentDTO *paymentDTO;
///
@property (nonatomic, strong) TNOrderDTO *orderDTO;
/// 地址管理dto
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;

/// 地址模型
@property (nonatomic, strong) HDTableViewSectionModel *addressSection;
/// 支付方式，优惠吗
@property (nonatomic, strong) HDTableViewSectionModel *paymentMethodSection;
/// 商品seciton
@property (nonatomic, strong) TNOrderSubmitGoodsSectionModel *goodsSection;
/// 订单信息
@property (nonatomic, strong) HDTableViewSectionModel *orderInfoSection;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 优惠券DTO
@property (strong, nonatomic) TNCouponTicketDTO *couponDTO;
///< 门店DTO
@property (nonatomic, strong) TNStoreDTO *storeDTO;
/// 当前选中的优惠券数据
@property (strong, nonatomic) WMOrderSubmitCouponModel *selectCouponModel;
/// 是否是第一次试算   第一次试算的话  还需要请求优惠券的数据
@property (nonatomic, assign) BOOL isFirstLoad;
/// 计费标准数据
@property (nonatomic, strong) NSArray<TNDeliveryComponyModel *> *deliveryComponylist;
/// dto
@property (nonatomic, strong) TNProductDTO *productDTO;
/// 可选的配送时间
@property (nonatomic, copy) NSString *deliveryTime;
/// 尽快配送文案展示
@property (nonatomic, copy) NSString *soonDeliveryTimeStr;
/// 预约类型  1立即送达  2 预约
@property (nonatomic, assign) TNOrderAppointmentType appointmentType;
/// 下单随机串
@property (nonatomic, copy) NSString *randomString;
/// 额外运费  预约订单  有额外运费的 弹窗要展示
@property (strong, nonatomic) SAMoneyModel *additionalFreight;
/// 支付营销展示数据
@property (strong, nonatomic) NSArray *marketingInfos;
/// 支付优惠金额 有的要需要处理
@property (strong, nonatomic) SAMoneyModel *paydiscountAmount;
/// 地址模型
@property (nonatomic, strong) SAShoppingAddressModel *addressModel;
/// 选择了使用优惠券
@property (nonatomic, assign) BOOL isSelectedUsePlateCoupon;
/// 选择了使用优惠码
@property (nonatomic, assign) BOOL isSelectedUsePromotionCode;
/// 优惠码模型 临时存储用
@property (nonatomic, strong) TNPromoCodeRspModel *promoCodeRspModel;
/// 选中的物流公司数据
@property (strong, nonatomic) TNDeliveryComponyModel *selectedDeliveryComponyModel;
@end


@implementation TNOrderSubmitViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appointmentType = TNOrderAppointmentTypeDefault;
        self.totalCount = 0;
        self.isFirstLoad = YES;
        self.hasAgreeTerms = [[NSUserDefaults standardUserDefaults] boolForKey:@"overseaTerms"];
        self.randomString = [NSString randonStringWithLength:10];
        self.isSelectedUsePlateCoupon = YES; // 默认使用优惠券
        self.canSubmitOrder = YES;
    }
    return self;
}

#pragma mark 提交订单需要数据 地址 电商支付方式  商户号

/// 获取公告数据
- (void)queryNoticeInfo {
    @HDWeakify(self);
    [self.paymentDTO getSubmitOrderNoticeDataSuccess:^(TNSubmitOrderNoticeModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.noticeModel = rspModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
/// 获取提交订单所需数据
- (void)querySubmitOrderDependData {
    dispatch_group_enter(self.taskGroup);
    @HDWeakify(self);
    [self queryAdressInfoCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    dispatch_group_enter(self.taskGroup);
    [self queryMerchantInfoCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];
    //    dispatch_group_enter(self.taskGroup);
    //    [self queryDeliveryCompanyCompletion:^{
    //        @HDStrongify(self);
    //        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    //    }];
    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(self.merchantNo)) {
            @HDWeakify(self);
            [self queryPaymentInfoCompletion:^{
                @HDStrongify(self);
                if (!HDIsArrayEmpty(self.avaliablePaymentMethods)) {
                    [self calcTotalPayFee];
                } else {
                    !self.networkFailBlock ?: self.networkFailBlock();
                }
            }];
        } else {
            !self.networkFailBlock ?: self.networkFailBlock();
        }
    });
}
/// 获取地址信息
- (void)queryAdressInfoCompletion:(void (^)(void))completion {
    // 本地购订单  且在酒水专题切换了地址的  直接拿酒水店铺切换过地址的下单
    if (!HDIsObjectNil([TNGlobalData shared].orderAdress) && !self.hasOverseasGood) {
        self.addressModel = [TNGlobalData shared].orderAdress;
        !completion ?: completion();
    } else {
        @HDWeakify(self);
        [self.addressDTO getDefaultAddressSuccess:^(SAShoppingAddressModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.addressModel = rspModel;
            !completion ?: completion();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion();
        }];
    }
}
/// 获取电商支付方式数据
- (void)queryPaymentInfoCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.paymentDTO getPaymentMethodsWithStoreNo:self.storeModel.storeNo latitude:self.addressModel.latitude longitude:self.addressModel.longitude
        Success:^(TNGetPaymentMethodsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.avaliablePaymentMethods = rspModel.paymentMethods;
            !completion ?: completion();
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion();
        }];
}
/// 获取商户号
- (void)queryMerchantInfoCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    [self.storeDTO queryStoreInfoWithStoreNo:self.storeModel.storeNo operatorNo:SAUser.shared.operatorNo success:^(TNStoreInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.merchantNo = rspModel.merchantNo;
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion();
    }];
}
/// 获取物流公司
- (void)queryDeliveryCompanyCompletion:(void (^)(BOOL isSuccess))completion {
    @HDWeakify(self);
    NSMutableArray *productIds = [NSMutableArray array];
    for (TNShoppingCarItemModel *obj in self.storeModel.selectedItems) {
        if (HDIsStringEmpty(obj.invalidMsg)) {
            if (![productIds containsObject:obj.goodsId]) {
                [productIds addObject:obj.goodsId];
            }
        }
    }
    if (!HDIsArrayEmpty(productIds)) {
        [self.paymentDTO queryCalculateFreightStandardCostsByStoreNo:self.storeModel.storeNo productIds:productIds success:^(NSArray<TNDeliveryComponyModel *> *_Nonnull list) {
            @HDStrongify(self);
            self.deliveryComponylist = list;
            if (list.count > 0) {
                TNDeliveryComponyModel *tempLastMethedModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowDeliveryCompanyLastChoosed type:SACacheTypeDocumentNotPublic];
                if (tempLastMethedModel) {
                    __block BOOL bingo = NO;
                    [list enumerateObjectsUsingBlock:^(TNDeliveryComponyModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if (obj.deliveryCorpCode == tempLastMethedModel.deliveryCorpCode) {
                            self.selectedDeliveryComponyModel = tempLastMethedModel;
                            obj.isSelected = tempLastMethedModel.isSelected;
                            bingo = YES;
                            *stop = YES;
                        }
                    }];
                    if (bingo == NO && list.count == 1) {
                        list.firstObject.isSelected = YES;
                        self.selectedDeliveryComponyModel = list.firstObject;
                    }

                } else {
                    if (list.count == 1) {
                        list.firstObject.isSelected = YES;
                        self.selectedDeliveryComponyModel = list.firstObject;
                    }
                }
            }

            !completion ?: completion(YES);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion(NO);
        }];
    }
}
/// 通过随机字符串获取订单号
- (void)getUnifiedOrderNoByRandomStrComplete:(void (^)(NSString *_Nonnull))complete {
    [self.view showloading];
    @HDWeakify(self);
    [self.paymentDTO getUnifiedOrderNoByRandomStr:self.randomString success:^(NSString *_Nonnull orderNo) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !complete ?: complete(orderNo);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self.view dismissLoading];
        !complete ?: complete(@"");
    }];
}

// #pragma mark - 获取促销码
//- (void)getPromoCodeInfoWithPromoCode:(NSString *)promoCode {
//     if (HDIsStringEmpty(promoCode)) {
//         self.promoCodeRspModel = nil;
//         [self generateDataSource];
//         return;
//     }
//
//     NSMutableDictionary *params = [NSMutableDictionary dictionary];
//     params[@"amount"] = self.calcResult.price.centFace;
//     params[@"currencyType"] = self.calcResult.price.cy;
//     params[@"packingAmt"] = @"0.00";
//     params[@"paymentType"] = SAMarketingBusinessTypeTinhNow;
//     params[@"promotionCode"] = promoCode;
//
//     self.promoCodeRequest.requestParameter = params;
//
//     [self.view showloading];
//     @HDWeakify(self);
//     [self.promoCodeRequest
//         startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
//             @HDStrongify(self);
//             [self.view dismissLoading];
//             SARspModel *rspModel = response.extraData;
//             TNPromoCodeRspModel *model = [TNPromoCodeRspModel yy_modelWithJSON:rspModel.data];
//             self.promoCodeRspModel = model;
//
//             [self generateDataSource];
//         }
//         failure:^(HDNetworkResponse *_Nonnull response) {
//             @HDStrongify(self);
//             [NAT showToastWithTitle:nil content:response.responseObject[@"rspInf"] type:HDTopToastTypeInfo];
//             [self.view dismissLoading];
//             self.promoCodeRspModel = nil;
//
//             [self generateDataSource];
//         }];
// }
#pragma mark 获取优惠券数据
- (void)getCouponTicket {
    TNCouponParamsModel *params = [[TNCouponParamsModel alloc] init];
    params.storeNo = self.storeModel.storeNo;
    params.currencyType = self.calcResult.amountPayable.cy;
    params.amount = self.calcResult.priceAfterDiscount.centFace;
    params.deliveryAmt = @"0.0";
    params.packingAmt = @"0.0";
    NSMutableArray *skuListArray = [NSMutableArray arrayWithCapacity:self.storeModel.selectedItems.count];
    for (TNShoppingCarItemModel *item in self.storeModel.selectedItems) {
        if (HDIsStringEmpty(item.invalidMsg)) {
            [skuListArray addObject:@{@"productId": item.goodsId, @"skuId": item.goodsSkuId, @"num": item.quantity, @"sp": item.sp}];
        }
    }
    params.skuList = skuListArray;

    self.paramsModel = params;
    @HDWeakify(self);
    [self.couponDTO getCouponByParamsModel:params pageSize:100 // 直接拉取100条 配合H5  不做分页
        pageNum:1 Success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            // 筛选出可用的优惠券
            NSArray<WMOrderSubmitCouponModel *> *list = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return [item.usable isEqualToString:SABoolValueTrue];
            }];
            // 接口返回是按优惠金额排序的  第一条就是默认选中的
            if (!HDIsArrayEmpty(list)) {
                self.selectCouponModel = list.firstObject;
            }
            // 重新试算
            [self calcTotalPayFeeWithCouponModel:self.selectCouponModel];
            // 转换可用优惠券模型
            NSArray<SACouponTicketModel *> *usableList = [list mapObjectsUsingBlock:^id _Nonnull(WMOrderSubmitCouponModel *_Nonnull obj, NSUInteger idx) {
                return [SACouponTicketModel modelWithOrderSubmitCouponModel:obj businessLine:SAMarketingBusinessTypeTinhNow];
            }];
            if (!HDIsObjectNil(self.selectCouponModel)) {
                SACouponTicketModel *firstModel = usableList.firstObject;
                firstModel.isSelected = YES;
            }

            // 不可用优惠券
            NSArray<SACouponTicketModel *> *unusableList = [[rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return [item.usable isEqualToString:SABoolValueFalse];
            }] mapObjectsUsingBlock:^id _Nonnull(WMOrderSubmitCouponModel *_Nonnull obj, NSUInteger idx) {
                return [SACouponTicketModel modelWithOrderSubmitCouponModel:obj businessLine:SAMarketingBusinessTypeTinhNow];
            }];
            HDTableViewSectionModel *usebleSectionModel = [[HDTableViewSectionModel alloc] init];
            HDTableViewSectionModel *unusebleSectionModel = [[HDTableViewSectionModel alloc] init];
            HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            headerModel.title = WMLocalizedString(@"following_not_available", @"以下优惠券不可使用");
            headerModel.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, HDAppTheme.value.padding.right);
            unusebleSectionModel.headerModel = headerModel;
            usebleSectionModel.list = usableList;
            unusebleSectionModel.list = unusableList;
            self.coupons = @[usebleSectionModel, unusebleSectionModel];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
}

- (void)refreshLoad {
    self.isFirstLoad = YES;
    self.selectCouponModel = nil;
    self.isSelectedUsePlateCoupon = NO;

    self.promoCodeRspModel.promotionCode = nil;
    self.calcResult.promotionCode = @"";
    self.isSelectedUsePromotionCode = NO;
    [self calcTotalPayFee];
}
#pragma mark - 商品试算
- (void)calcTotalPayFee {
    [self calcTotalPayFeeWithCouponModel:self.selectCouponModel];
}

- (void)calcTotalPayFeeWithCouponModel:(WMOrderSubmitCouponModel *)couponModel {
    if (!self.storeModel || self.storeModel.selectedItems.count == 0) {
        return;
    }
    if (self.isFirstLoad && self.hasOverseasGood) {
        [self.view showloadingText:TNLocalizedString(@"tn_getNewPrice_loading", @"正在获取最新商品价格")];
    } else {
        [self.view showloading];
    }
    @HDWeakify(self);
    NSString *platformCouponCode = self.isSelectedUsePlateCoupon ? couponModel.couponCode : nil;
    NSString *platformCouponDiscount = self.isSelectedUsePlateCoupon ? couponModel.discountAmount.centFace : nil;
    NSString *promotionCode = self.isSelectedUsePromotionCode ? self.calcResult.promotionCode : nil;

    [self.paymentDTO calculateTotalPayFeeTrialWithCouponCode:@"" shippingMethod:self.shippiingMethodModel groupBuyingId:@"" invoiceId:@"" address:self.addressModel
        paymentMethod:self.paymentMethodModel
        memo:@""
        platformCouponCode:platformCouponCode
        platformCouponDiscount:platformCouponDiscount
        storeShoppingCarModel:self.storeModel
        deliveryTime:self.deliveryTime
        appointment:self.appointmentType
        salesType:self.storeModel.salesType
        promotionCode:promotionCode
        deliveryCorpCode:self.selectedDeliveryComponyModel.deliveryCorpCode success:^(TNCalcTotalPayFeeTrialRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.calcResult = rspModel;
            self.selectCouponModel = couponModel;         // 优惠券试算成功 拿到营销数据 才算可以使用优惠券
            [self oversasProductPriceChangeAndReplace];   // 替换价格
            [self checkCouponAndPromotionCodeOverlayUse]; // 检验优惠码和优惠券是否可以一起用
            [self filterInvalidProducts];                 // 筛选下架失效的商品
            // 没有物流公司数据 就获取
            if (HDIsArrayEmpty(self.deliveryComponylist)) {
                [self queryDeliveryCompanyCompletion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [self generateDataSource];
                    }
                }];
            }
            if (self.isFirstLoad) {
                self.isFirstLoad = NO;
                // 支持在线支付，再查公告
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        NSArray *methods = [self.avaliablePaymentMethods mapObjectsUsingBlock:^id _Nonnull(TNPaymentMethodModel *_Nonnull obj, NSUInteger idx) {
                            return obj.method;
                        }];
                        if (!HDIsArrayEmpty(methods) && [methods containsObject:TNPaymentMethodOnLine]) {
                            [self generatePaymentActivitys]; // 查询营销优惠
                        }
                    }
                });
                [self getCouponTicket];
            } else {
                @HDWeakify(self);
                [self setLastSelectedPaymentMethodCompletion:^(void) {
                    @HDStrongify(self);
                    [self generateDataSource];
                    [self.view dismissLoading];
                }];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            if ([rspModel.code isEqualToString:@"TN1055"] || [rspModel.code isEqualToString:@"TN1056"]) {
                [self generateDataSource];
            } else if ([rspModel.code isEqualToString:@"TN2004"] || [rspModel.code isEqualToString:@"TN2005"]) {
                //            TN2004("TN2004", "优惠码不可使用"),TN2005("TN2005", "优惠码已过期"),
                self.promoCodeRspModel.promotionCode = nil;
                self.calcResult.promotionCode = @"";
                self.isSelectedUsePromotionCode = NO;
                if (!HDIsObjectNil(self.promoCodeRspModel.discountAmount)) {
                    //                   如果上次有输入争取的优惠码  这次输错  清空重新试算
                    [self calcTotalPayFee];
                } else {
                    [self generateDataSource];
                }
                self.promoCodeRspModel.discountAmount = nil;
            }
            !self.calcPayFeeFailBlock ?: self.calcPayFeeFailBlock(rspModel);
        }];
}

/// 获取支付方式数据
- (void)generatePaymentActivitys {
    NSArray<SAGoodsModel *> *goods = [self.storeModel.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        SAGoodsModel *item = SAGoodsModel.new;
        item.goodsId = obj.goodsId;
        item.skuId = obj.goodsSkuId;
        item.snapshotId = obj.itemDisplayNo;
        item.quantity = obj.quantity.integerValue;
        return item;
    }];
    @HDWeakify(self);
    [SAChoosePaymentMethodPresenter queryAvailablePaymentActivityAnnouncementWithMerchantNo:self.merchantNo storeNo:self.storeModel.storeNo businessLine:SAClientTypeTinhNow goods:goods
                                                                              payableAmount:self.calcResult.amountPayable success:^(NSArray<NSString *> *_Nonnull activitys) {
                                                                                  @HDStrongify(self);
                                                                                  self.marketingInfos = activitys;
                                                                                  @HDWeakify(self);
                                                                                  [self setLastSelectedPaymentMethodCompletion:^{
                                                                                      @HDStrongify(self);
                                                                                      [self generateDataSource];
                                                                                  }];
                                                                              } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){
                                                                              }];
}
/// 设置上次选中的支付方式
- (void)setLastSelectedPaymentMethodCompletion:(void (^)(void))completion {
    // 上次记录的支付方式是否存在
    id tempLastMethedModel = [SACacheManager.shared objectForKey:kCacheKeyTinhNowPaymentMethodLastChoosed type:SACacheTypeDocumentNotPublic];
    // 兼容旧版升级上来的  旧版存的是字符串
    if (!HDIsObjectNil(tempLastMethedModel) && ![tempLastMethedModel isKindOfClass:[TNPaymentMethodModel class]]) {
        !completion ?: completion();
        return;
    }
    TNPaymentMethodModel *lastMethedModel = tempLastMethedModel;
    if (!HDIsObjectNil(lastMethedModel) && !HDIsArrayEmpty(self.avaliablePaymentMethods)) {
        @HDWeakify(self);
        // 更新支付方式
        void (^updatePaymentMethod)(void) = ^void {
            @HDStrongify(self);
            // 上次记录的支付方式是否存在
            for (TNPaymentMethodModel *methedModel in self.avaliablePaymentMethods) {
                if ([methedModel.method isEqualToString:lastMethedModel.method]) {
                    methedModel.isSelected = YES;
                    methedModel.selectedOnlineMethodType = lastMethedModel.selectedOnlineMethodType;
                    self.paymentMethodModel = lastMethedModel;
                    break;
                }
            }
        };
        if ([lastMethedModel.method isEqualToString:TNPaymentMethodOnLine] && !HDIsObjectNil(lastMethedModel.selectedOnlineMethodType)) {
            [SAChoosePaymentMethodPresenter trialWithPayableAmount:self.calcResult.amountPayable businessLine:SAClientTypeTinhNow supportedPaymentMethods:@[HDSupportedPaymentMethodOnline]
                                                        merchantNo:self.merchantNo
                                                           storeNo:self.storeModel.storeNo
                                                             goods:@[]
                                             selectedPaymentMethod:lastMethedModel.selectedOnlineMethodType
                                                        completion:^(BOOL available, NSString *_Nullable ruleNo, SAMoneyModel *_Nullable discountAmount) {
                                                            @HDStrongify(self);
                                                            self.paydiscountAmount = discountAmount;
                                                            if (available) {
                                                                lastMethedModel.selectedOnlineMethodType.ruleNo = ruleNo;
                                                                updatePaymentMethod();
                                                                !completion ?: completion();
                                                            } else {
                                                                !completion ?: completion();
                                                            }
                                                        }];
        } else {
            updatePaymentMethod();
            !completion ?: completion();
        }

    } else {
        !completion ?: completion();
    }
}
#pragma mark - 组装数据
- (void)generateDataSource {
    NSMutableArray<HDTableViewSectionModel *> *data = [[NSMutableArray alloc] init];
    HDTableViewSectionModel *section = HDTableViewSectionModel.new;

    NSMutableArray *firstSectionArr = [NSMutableArray array];

    // 置顶提示文案  根据值判断
    if (!HDIsObjectNil(self.noticeModel) && !HDIsObjectNil(self.noticeModel.payOrderTop) && self.noticeModel.payOrderTop.isOpen && HDIsStringNotEmpty(self.noticeModel.payOrderTop.noticeMsg)) {
        TNOrderTipCellModel *tipModel = [[TNOrderTipCellModel alloc] init];
        tipModel.tipText = self.noticeModel.payOrderTop.noticeMsg;
        [firstSectionArr addObject:tipModel];
    }
    // 地址
    section = HDTableViewSectionModel.new;
    SAShoppingAddressModel *addressModel = SAShoppingAddressModel.new;
    if (self.addressModel) {
        addressModel = self.addressModel;
    }
    [firstSectionArr addObject:addressModel];
    section.list = firstSectionArr;
    [data addObject:section];

    // 支付方式
    section = HDTableViewSectionModel.new;
    HDTableHeaderFootViewModel *headViewModel = HDTableHeaderFootViewModel.new;
    headViewModel.image = [UIImage imageNamed:@"tinhnow_product_pay"];
    headViewModel.title = TNLocalizedString(@"tn_page_payments_title", @"Payments");
    headViewModel.titleFont = HDAppTheme.TinhNowFont.standard17B;
    headViewModel.titleColor = HDAppTheme.TinhNowColor.G1;
    headViewModel.lineHeight = [HDHelper pixelOne];
    section.headerModel = headViewModel;

    TNPaymentMethodCellModel *payment = TNPaymentMethodCellModel.new;
    payment.methods = self.avaliablePaymentMethods;
    // 营销文案展示
    if (!HDIsArrayEmpty(self.marketingInfos)) {
        for (TNPaymentMethodModel *methedModel in self.avaliablePaymentMethods) {
            if ([methedModel.method isEqualToString:TNPaymentMethodOnLine]) {
                methedModel.marktingInfos = self.marketingInfos;
                break;
            }
        }
    }

    section.list = @[payment];
    [data addObject:section];

    // 门店数据
    if (self.storeModel) {
        TNOrderSubmitGoodsSectionModel *storeSection = TNOrderSubmitGoodsSectionModel.new;
        TNOrderStoreHeaderModel *gooderHeader = TNOrderStoreHeaderModel.new;
        gooderHeader.storeName = self.storeModel.storeName;
        gooderHeader.isNeedShowStoreRightIV = NO;
        gooderHeader.storeType = self.storeModel.type;
        storeSection.commonHeaderModel = gooderHeader;

        if (self.hasOverseasGood) { // 海外购订单
            // 免邮商品组
            NSMutableArray *freeShippingGoodList = [NSMutableArray array];
            // 到付商品组
            NSMutableArray *cashOnDeliveryGoodList = [NSMutableArray array];
            for (TNShoppingCarItemModel *item in self.storeModel.selectedItems) {
                if (item.freightSetting) {
                    [freeShippingGoodList addObject:item];
                } else {
                    [cashOnDeliveryGoodList addObject:item];
                }
            }
            if (!HDIsArrayEmpty(cashOnDeliveryGoodList)) {
                //                BOOL isNeedHeader = !HDIsArrayEmpty(freeShippingGoodList);
                NSArray *goodSelectList = [self getCashOnDeliveryProductsCellModelsWithGoodArr:cashOnDeliveryGoodList isNeedHeader:YES];
                storeSection.list = goodSelectList;
                [data addObject:storeSection];
            }

            if (!HDIsArrayEmpty(freeShippingGoodList)) {
                section = HDTableViewSectionModel.new;
                if (HDIsArrayEmpty(cashOnDeliveryGoodList)) { //
                    section = storeSection;
                }
                NSArray *goodSelectList = [self getFreeShippingProductsCellModelsWithGoodArr:freeShippingGoodList isNeedHeader:YES];
                section.list = goodSelectList;
                [data addObject:section];
            }

        } else {
            // 普通订单显示
            NSArray *goodSelectList = [self getNomalProductsCellModelsWithGoodArr:self.storeModel.selectedItems];
            storeSection.list = goodSelectList;
            [data addObject:storeSection];
        }
    }

    // 海外购 物流公司选择
    if (self.hasOverseasGood && !HDIsArrayEmpty(self.deliveryComponylist)) {
        section = HDTableViewSectionModel.new;
        NSMutableArray *arr = [NSMutableArray array];
        HDTableHeaderFootViewModel *headViewModel = HDTableHeaderFootViewModel.new;
        //        headViewModel.image = [UIImage imageNamed:@"tinhnow_product_pay"];
        headViewModel.title = TNLocalizedString(@"tn_choose_ship_company", @"选择物流公司");
        headViewModel.titleFont = HDAppTheme.TinhNowFont.standard17B;
        headViewModel.titleColor = HDAppTheme.TinhNowColor.G1;
        headViewModel.lineHeight = [HDHelper pixelOne];
        section.headerModel = headViewModel;


        TNDeliveryCompanyCellModel *cellModel = TNDeliveryCompanyCellModel.new;
        cellModel.dataSource = self.deliveryComponylist;

        [arr addObject:cellModel];


        section.list = @[cellModel];
        [data addObject:section];
    }

    // 订单信息
    section = HDTableViewSectionModel.new;
    NSMutableArray<SAInfoViewModel *> *arr = [[NSMutableArray alloc] initWithCapacity:3];

    if (self.hasOverseasGood) {
        // 运费
        SAInfoViewModel *feeModel = [[SAInfoViewModel alloc] init];
        feeModel.keyText = TNLocalizedString(@"7YWbzBzV", @"国际运费");
        feeModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        feeModel.keyColor = HDAppTheme.TinhNowColor.G2;
        // 运费样式显示
        feeModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(10), kRealWidth(15));
        feeModel.lineWidth = 0;
        [arr addObject:feeModel];

        SAInfoViewModel *tipsModel = SAInfoViewModel.new;
        tipsModel.keyText = [TNLocalizedString(@"2j4L6C52", @"运费到付，点击查看物流计费标准") stringByAppendingString:@" >"];
        tipsModel.keyFont = HDAppTheme.TinhNowFont.standard14;
        tipsModel.keyColor = [UIColor hd_colorWithHexString:@"#FF2323"];
        tipsModel.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        tipsModel.enableTapRecognizer = YES;
        @HDWeakify(self);
        tipsModel.eventHandler = ^{
            @HDStrongify(self);
            [self showFreightCostsAlertView];
        };
        [arr addObject:tipsModel];
    }


    // 中国段运费显示
    if (self.hasOverseasGood && !HDIsObjectNil(self.calcResult.freightPriceChina)) {
        SAInfoViewModel *chinaFreightModel = [[SAInfoViewModel alloc] init];
        chinaFreightModel.keyText = TNLocalizedString(@"LR4nKEjJ", @"中国段运费");
        chinaFreightModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        chinaFreightModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        chinaFreightModel.valueText = self.calcResult.freightPriceChina.thousandSeparatorAmount;
        chinaFreightModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        chinaFreightModel.valueColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:chinaFreightModel];
    }

    // 汇率
    if (self.hasOverseasGood && HDIsStringNotEmpty(self.calcResult.khrExchangeRate)) {
        SAInfoViewModel *khrModel = [[SAInfoViewModel alloc] init];
        khrModel.keyText = TNLocalizedString(@"tn_exchange_rate_k", @"汇率");
        khrModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        khrModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        khrModel.valueText = [NSString stringWithFormat:@"1:%@", self.calcResult.khrExchangeRate];
        khrModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        khrModel.valueColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:khrModel];
    }

    if (!HDIsObjectNil(self.selectCouponModel)) {
        // 平台优惠券
        __block SAInfoViewModel *infoModel = SAInfoViewModel.new;
        infoModel.keyText = TNLocalizedString(@"tn_platfrom_coupon", @"平台优惠券");
        infoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        infoModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        infoModel.keyImagePosition = HDUIButtonImagePositionLeft;
        if (!self.isSelectedUsePlateCoupon) {
            infoModel.keyImage = [UIImage imageNamed:@"tinhnow-unselect_agree_k"];
        } else {
            infoModel.keyImage = [UIImage imageNamed:@"tinhnow-selected_agree_k"];
        }
        infoModel.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        if (HDIsStringNotEmpty(self.selectCouponModel.discountAmount.thousandSeparatorAmount) && HDIsStringNotEmpty(self.selectCouponModel.title)) {
            infoModel.valueText = [NSString stringWithFormat:@"(%@)", self.selectCouponModel.title];
            infoModel.valueColor = HDAppTheme.TinhNowColor.C3;
            infoModel.subValueText = [NSString stringWithFormat:@"-%@", self.selectCouponModel.discountAmount.thousandSeparatorAmount];
            infoModel.subValueFont = HDAppTheme.TinhNowFont.standard15;
            infoModel.subValueColor = HDAppTheme.TinhNowColor.G1;
        } else {
            infoModel.valueText = SALocalizedString(@"not_use", @"不使用");
            infoModel.valueColor = HDAppTheme.TinhNowColor.G2;
        }

        infoModel.needFixedBottom = YES;
        infoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        infoModel.rightButtonImagePosition = HDUIButtonImagePositionRight;
        infoModel.rightButtonTitle = @" ";
        infoModel.enableTapRecognizer = YES;
        @HDWeakify(self);
        @HDWeakify(infoModel);
        infoModel.clickedKeyButtonHandler = ^{
            @HDStrongify(self);
            @HDStrongify(infoModel);
            self.isSelectedUsePlateCoupon = !self.isSelectedUsePlateCoupon;
            if (!self.isSelectedUsePlateCoupon) {
                infoModel.keyImage = [UIImage imageNamed:@"tinhnow-unselect_agree_k"];
            } else {
                infoModel.keyImage = [UIImage imageNamed:@"tinhnow-selected_agree_k"];
            }
            [self calcTotalPayFee];
        };
        infoModel.eventHandler = ^{
            @HDStrongify(self);
            if (self.paramsModel != nil) {
                @HDWeakify(self);
                void (^callBack)(WMOrderSubmitCouponModel *model) = ^void(WMOrderSubmitCouponModel *model) {
                    @HDStrongify(self);
                    [self calcTotalPayFeeWithCouponModel:model]; // 选中回来就重新试算
                };
                NSDictionary *params = @{@"coupons": self.coupons, @"callBack": callBack};
                [[HDMediator sharedInstance] navigaveToTinhNowChooseCouponViewController:params];
            }
        };
        [arr addObject:infoModel];
    }

    // 优惠码
    if (self.calcResult.canUsePromotionCode) {
        __block SAInfoViewModel *infoModel = SAInfoViewModel.new;
        infoModel.keyText = TNLocalizedString(@"OkaO8L5F", @"优惠码");
        infoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        infoModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        infoModel.keyImagePosition = HDUIButtonImagePositionLeft;
        if (!self.isSelectedUsePromotionCode) {
            infoModel.keyImage = [UIImage imageNamed:@"tinhnow-unselect_agree_k"];
        } else {
            infoModel.keyImage = [UIImage imageNamed:@"tinhnow-selected_agree_k"];
        };
        infoModel.keyImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        if (HDIsStringNotEmpty(self.promoCodeRspModel.promotionCode) && HDIsStringNotEmpty(self.promoCodeRspModel.discountAmount.thousandSeparatorAmount)) {
            infoModel.valueText = [NSString stringWithFormat:@"-%@", self.promoCodeRspModel.discountAmount.thousandSeparatorAmount];
            infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
            infoModel.valueFont = HDAppTheme.TinhNowFont.standard12;
            infoModel.subValueText = [NSString stringWithFormat:@"(%@:%@)", TNLocalizedString(@"OkaO8L5F", @"优惠码"), self.promoCodeRspModel.promotionCode];
            infoModel.subValueFont = HDAppTheme.TinhNowFont.standard15;
            infoModel.subValueColor = HDAppTheme.TinhNowColor.G1;
        } else {
            infoModel.valueText = TNLocalizedString(@"VPdlGdML", @"请输入优惠码");
            infoModel.valueColor = HDAppTheme.TinhNowColor.G2;
            infoModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        }

        infoModel.needFixedBottom = YES;
        infoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        infoModel.rightButtonImagePosition = HDUIButtonImagePositionRight;
        infoModel.rightButtonTitle = @" ";
        infoModel.enableTapRecognizer = YES;
        @HDWeakify(self);
        @HDWeakify(infoModel);
        infoModel.clickedKeyButtonHandler = ^{
            @HDStrongify(self);
            @HDStrongify(infoModel);
            self.isSelectedUsePromotionCode = !self.isSelectedUsePromotionCode;
            if (!self.isSelectedUsePromotionCode) {
                infoModel.keyImage = [UIImage imageNamed:@"tinhnow-unselect_agree_k"];
            } else {
                infoModel.keyImage = [UIImage imageNamed:@"tinhnow-selected_agree_k"];
            }
            // 将存储的优惠码赋值
            if (self.isSelectedUsePromotionCode) {
                self.calcResult.promotionCode = self.promoCodeRspModel.promotionCode;
            }
            if (HDIsStringNotEmpty(self.promoCodeRspModel.promotionCode)) {
                [self calcTotalPayFee];
            } else {
                self.refreshFlag = !self.refreshFlag;
            }
        };
        infoModel.eventHandler = ^{
            @HDStrongify(self);
            [self showInputPromoCodeAlert];
        };
        [arr addObject:infoModel];
    }
    // 备注字段
    SAInfoViewModel *memoInfo = SAInfoViewModel.new;
    memoInfo.keyText = TNLocalizedString(@"tn_order_submit_memo_title", @"Note");
    if (HDIsStringNotEmpty(self.memo)) {
        memoInfo.valueText = self.memo;
        memoInfo.valueColor = HDAppTheme.TinhNowColor.G1;
    } else {
        memoInfo.valueText = TNLocalizedString(@"tn_order_submit_memo_placehol", @"选填");
        memoInfo.valueColor = HDAppTheme.TinhNowColor.G2;
    }
    memoInfo.keyToValueWidthRate = 0.6;
    memoInfo.keyFont = HDAppTheme.TinhNowFont.standard15;
    memoInfo.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    memoInfo.valueNumbersOfLines = 1;
    memoInfo.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    memoInfo.rightButtonImagePosition = HDUIButtonImagePositionRight;
    memoInfo.rightButtonTitle = @" ";
    memoInfo.associatedObject = @"memo";
    [arr addObject:memoInfo];

    section.list = [NSArray arrayWithArray:arr];
    [data addObject:section];

    // 海外购条款
    if (self.hasOverseasGood) {
        if (!HDIsObjectNil(self.noticeModel) && !HDIsObjectNil(self.noticeModel.overseasKnow) && self.noticeModel.overseasKnow.isOpen && HDIsStringNotEmpty(self.noticeModel.overseasKnow.noticeMsg)) {
            section = [HDTableViewSectionModel new];
            TNOrderSubmitTermsCellModel *termsModel = [[TNOrderSubmitTermsCellModel alloc] init];
            termsModel.contentTxt = self.noticeModel.overseasKnow.noticeMsg;
            section.list = @[termsModel];
            [data addObject:section];
        }
    }
    self.dataSource = [NSArray arrayWithArray:data];
}
#pragma mark -  普通订单  商品组显示
- (NSArray *)getNomalProductsCellModelsWithGoodArr:(NSArray<TNShoppingCarItemModel *> *)goodsArr {
    NSMutableArray *arr = [NSMutableArray array];
    // 商品数据 及商品总额
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:NO];

    if (!HDIsArrayEmpty(self.calcResult.deliveryTimeDTOList)) {
        // 送货时间
        SAInfoViewModel *sendKeyModel = [[SAInfoViewModel alloc] init];
        sendKeyModel.keyText = TNLocalizedString(@"Tw0pO3zY", @"送货时间");
        sendKeyModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        sendKeyModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        sendKeyModel.lineWidth = 0;
        sendKeyModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), 0, kRealWidth(15));
        [arr addObject:sendKeyModel];

        if (HDIsStringEmpty(self.deliveryTime)) {
            // 第一次取后台的默认配送时间
            self.deliveryTime = self.calcResult.deliveryTime;
        }
        if (self.isFirstLoad || HDIsStringEmpty(self.deliveryTime)) {
            self.soonDeliveryTimeStr = self.calcResult.soonDelivery;
        }
        SAInfoViewModel *sendValueModel = [[SAInfoViewModel alloc] init];
        if (HDIsStringNotEmpty(self.soonDeliveryTimeStr)) {
            sendValueModel.keyText = self.soonDeliveryTimeStr;
        } else if (HDIsStringNotEmpty(self.deliveryTime)) {
            // 时间格式为16/2/2022 8:00~9:00  需要截取  并判断是否为今天
            NSArray *temp = [self.deliveryTime componentsSeparatedByString:@" "];
            if (!HDIsArrayEmpty(temp) && temp.count == 2) {
                NSString *dateStr = temp.firstObject;
                NSString *timeRange = temp.lastObject;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/yyyy"];
                NSDate *date = [formatter dateFromString:dateStr];
                if (date.sa_isToday == YES) {
                    sendValueModel.keyText = [NSString stringWithFormat:TNLocalizedString(@"jGkbvTn5", @"预计在%@送达"), timeRange];
                } else {
                    NSArray *dateArr = [dateStr componentsSeparatedByString:@"/"];
                    if (dateArr.count == 3) {
                        NSString *tempDate = [[dateArr subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@"/"];
                        NSString *showTime = [NSString stringWithFormat:@"%@ %@", tempDate, timeRange];
                        sendValueModel.keyText = [NSString stringWithFormat:TNLocalizedString(@"jGkbvTn5", @"预计在%@送达"), showTime];
                    } else {
                        sendValueModel.keyText = [NSString stringWithFormat:TNLocalizedString(@"jGkbvTn5", @"预计在%@送达"), self.deliveryTime];
                    }
                }
            } else {
                sendValueModel.keyText = [NSString stringWithFormat:TNLocalizedString(@"jGkbvTn5", @"预计在%@送达"), self.deliveryTime];
            }
        }

        sendValueModel.keyFont = HDAppTheme.TinhNowFont.standard14;
        sendValueModel.keyColor = HDAppTheme.TinhNowColor.C1;
        sendValueModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
        sendValueModel.rightButtonImagePosition = HDUIButtonImagePositionRight;
        sendValueModel.rightButtonTitle = @" ";
        sendValueModel.enableTapRecognizer = YES;
        @HDWeakify(self);
        sendValueModel.eventHandler = ^{
            @HDStrongify(self);
            [self showSelectDeliveryTimeAlertViewWithTitle:TNLocalizedString(@"Dl5EYqcs", @"预计送达时间")];
        };
        [arr addObject:sendValueModel];
    }

    // 运费
    NSString *calsFreightStr = nil;                                         // 优惠后的运费
    NSString *freightStr = self.calcResult.freight.thousandSeparatorAmount; // 原运费
    NSMutableAttributedString *showAttr = nil;                              // 有优惠运费的展示
    if (!HDIsObjectNil(self.calcResult.freightDiscount) && [self.calcResult.freightDiscount.cent doubleValue] > 0) {
        double discountCent = [self.calcResult.freightDiscount.cent doubleValue];
        double freightCent = [self.calcResult.freight.cent doubleValue];
        double calcCent = freightCent - discountCent;
        if (calcCent < 0) {
            calcCent = 0; // 最多0运费
        }
        SAMoneyModel *cModel = SAMoneyModel.new;
        cModel.currencySymbol = self.calcResult.freightDiscount.currencySymbol;
        cModel.cy = self.calcResult.freightDiscount.cy;
        cModel.centFace = self.calcResult.freightDiscount.centFace;
        cModel.cent = [NSString stringWithFormat:@"%f", calcCent];
        calsFreightStr = cModel.thousandSeparatorAmount;

        if (HDIsStringNotEmpty(calsFreightStr) && HDIsStringNotEmpty(freightStr)) {
            NSString *showStr = [freightStr stringByAppendingFormat:@"  %@", calsFreightStr];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:showStr];
            [attr addAttributes:@{
                NSFontAttributeName: HDAppTheme.TinhNowFont.standard15,
                NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G3,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSBaselineOffsetAttributeName: @(0), // iOS13 不添加这个属性可能显示不出删除线
                NSStrikethroughColorAttributeName: HDAppTheme.TinhNowColor.G3
            }
                          range:[showStr rangeOfString:freightStr]];
            [attr addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:[showStr rangeOfString:calsFreightStr]];
            showAttr = attr;
        }
    }
    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.keyText = TNLocalizedString(@"tn_page_deliveryfee_title", @"运费");
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    infoModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    infoModel.valueNumbersOfLines = 0;
    infoModel.needFixedBottom = YES;
    if (!HDIsObjectNil(self.calcResult.overSeaFreightPrice)) {
        // 海外购订单 专门显示国际段运费文案
        infoModel.valueText = self.calcResult.freightMessageLocales.desc;
        infoModel.valueColor = HDAppTheme.TinhNowColor.R1;
    } else {
        if (showAttr != nil) {
            infoModel.attrValue = showAttr;
        } else {
            infoModel.valueText = self.calcResult.freight.thousandSeparatorAmount;
        }
    }
    infoModel.lineWidth = 0;
    if (HDIsStringNotEmpty(self.calcResult.freightPromotionTxt)) {
        infoModel.subValueText = self.calcResult.freightPromotionTxt;
        infoModel.subValueFont = HDAppTheme.TinhNowFont.standard12;
        infoModel.subValueColor = HDAppTheme.TinhNowColor.cFF2323;
    }
    // 非海外购的订单 如果基础运费 和额外运费有值 要弹窗
    if (!self.hasOverseasGood) {
        if ((!HDIsObjectNil(self.calcResult.basicFreight) && self.calcResult.basicFreight.cent.integerValue > 0)
            || (!HDIsObjectNil(self.calcResult.addtionalFreight) && self.calcResult.addtionalFreight.cent.integerValue > 0)) {
            infoModel.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
            infoModel.enableTapRecognizer = YES;
            @HDWeakify(self);
            infoModel.eventHandler = ^{
                @HDStrongify(self);
                [self showFreightDetailAlertView];
            };
        } else {
            infoModel.rightButtonImage = nil;
            infoModel.enableTapRecognizer = NO;
        }
    }
    [arr addObject:infoModel];

    // 汇率
    if (HDIsStringNotEmpty(self.calcResult.khrExchangeRate)) {
        SAInfoViewModel *khrModel = [[SAInfoViewModel alloc] init];
        khrModel.keyText = TNLocalizedString(@"tn_exchange_rate_k", @"汇率");
        khrModel.keyFont = HDAppTheme.TinhNowFont.standard15;
        khrModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
        khrModel.valueText = [NSString stringWithFormat:@"1:%@", self.calcResult.khrExchangeRate];
        khrModel.valueFont = HDAppTheme.TinhNowFont.standard15;
        khrModel.valueColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:khrModel];
    }
    return arr;
}

#pragma mark - 免邮 商品组  模型数据
/// 免邮 商品组  模型数据
- (NSArray *)getFreeShippingProductsCellModelsWithGoodArr:(NSArray<TNShoppingCarItemModel *> *)goodsArr isNeedHeader:(BOOL)isNeedHeader {
    NSMutableArray *arr = [NSMutableArray array];
    if (isNeedHeader) {
        // 标题
        SAInfoViewModel *titleModel = [[SAInfoViewModel alloc] init];
        titleModel.keyImagePosition = HDUIButtonImagePositionLeft;
        titleModel.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        titleModel.keyImage = [UIImage imageNamed:@"tn_small_freeshipping"];
        titleModel.keyText = TNLocalizedString(@"0jPkiTIb", @"免邮商品");
        titleModel.keyFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        titleModel.keyColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:titleModel];
    }

    // 商品数据 及商品总额
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:YES];

    // 运费
    SAInfoViewModel *feeModel = [[SAInfoViewModel alloc] init];
    feeModel.keyText = TNLocalizedString(@"7YWbzBzV", @"国际运费");
    feeModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    feeModel.keyColor = HDAppTheme.TinhNowColor.c5E6681;
    feeModel.valueColor = HDAppTheme.TinhNowColor.G1;
    feeModel.valueFont = [HDAppTheme.TinhNowFont fontSemibold:15];
    feeModel.valueNumbersOfLines = 0;
    feeModel.valueText = TNLocalizedString(@"QnZH0Z83", @"免邮");
    feeModel.lineWidth = 0;
    [arr addObject:feeModel];
    return arr;
}
#pragma mark -  到付 商品组  模型数据
- (NSArray *)getCashOnDeliveryProductsCellModelsWithGoodArr:(NSArray<TNShoppingCarItemModel *> *)goodsArr isNeedHeader:(BOOL)isNeedHeader {
    NSMutableArray *arr = [NSMutableArray array];
    if (isNeedHeader) {
        // 标题
        SAInfoViewModel *titleModel = [[SAInfoViewModel alloc] init];
        titleModel.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        titleModel.keyImagePosition = HDUIButtonImagePositionLeft;
        titleModel.keyImage = [UIImage imageNamed:@"tn_cash_delivery"];
        titleModel.keyText = TNLocalizedString(@"SBJwEl0y", @"到付商品");
        titleModel.keyFont = [HDAppTheme.TinhNowFont fontSemibold:15];
        titleModel.keyColor = HDAppTheme.TinhNowColor.G1;
        [arr addObject:titleModel];
    }

    // 商品数据 及商品总额
    [self addProductCellDataWithSectionArr:arr productItemArr:goodsArr isNeedCalculateTotalPrice:YES];


    return arr;
}

/// 添加商品模型数据
- (void)addProductCellDataWithSectionArr:(NSMutableArray *)arr productItemArr:(NSArray<TNShoppingCarItemModel *> *)productItemArr isNeedCalculateTotalPrice:(BOOL)isNeedCalculateTotalPrice {
    // 先排序  将相同的商品放一块
    productItemArr = [productItemArr sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(TNShoppingCarItemModel *_Nonnull obj1, TNShoppingCarItemModel *_Nonnull obj2) {
        return [obj1.goodsId isEqualToString:obj2.goodsId];
    }];
    // 存储商品模型数据
    self.goodCellModelArr = [NSMutableArray array];
    // 商品总额
    NSDecimalNumber *totolCent = NSDecimalNumber.zero;
    SAMoneyModel *totolMoney = nil;
    // 商品行  规格行  也要加
    TNShoppingCarItemModel *lastItem = nil;               // 最新一个item 一个商品可能多规格
    TNOrderSubmitGoodsTableViewCellModel *goodsCellModel; // 商品级别模型
    NSInteger weight = 0;                                 // 计算重量
    BOOL hasInValidItem = NO;                             // 是否有失效的商品
    for (TNShoppingCarItemModel *item in productItemArr) {
        // 添加商品
        if (lastItem == nil || ![lastItem.goodsId isEqualToString:item.goodsId]) {
            hasInValidItem = NO; // 重置
            weight = 0;          // 重置
            goodsCellModel = TNOrderSubmitGoodsTableViewCellModel.new;
            goodsCellModel.logoUrl = item.picture;
            goodsCellModel.goodsName = item.goodsName;
            goodsCellModel.productId = item.goodsId;
            [arr addObject:goodsCellModel];
            [self.goodCellModelArr addObject:goodsCellModel];
        }

        // 没有失效下架的商品才计算总额
        if (HDIsStringEmpty(item.invalidMsg)) {
            totolCent = [TNDecimalTool decimalAddingBy:totolCent num2:[TNDecimalTool stringDecimalMultiplyingBy:item.salePrice.cent num2:item.quantity.stringValue]];
            if (HDIsObjectNil(totolMoney)) {
                totolMoney = [[SAMoneyModel alloc] init];
                totolMoney.currencySymbol = item.salePrice.currencySymbol;
                totolMoney.cy = item.salePrice.cy;
            }
        } else {
            hasInValidItem = YES;
        }
        if (!HDIsObjectNil(goodsCellModel) && hasInValidItem) {
            goodsCellModel.invalidTips = TNLocalizedString(@"hTFG1UDO", @"已失效");
        } else {
            goodsCellModel.invalidTips = @"";
        }

        // 添加规格
        TNOrderSkuSpecifacationCellModel *specModel = [[TNOrderSkuSpecifacationCellModel alloc] init];
        specModel.spec = item.goodsSkuName;
        specModel.skuId = item.goodsSkuId;
        specModel.price = item.salePrice;
        specModel.quantity = item.quantity;
        specModel.thumbnail = item.picture;
        specModel.invalidMsg = item.invalidMsg;
        if (item.weight != nil) {
            NSInteger temp = item.weight.integerValue * item.quantity.integerValue;
            weight += temp;
        }

        if ([item isEqual:productItemArr.lastObject]) {
            specModel.lineHeight = 0.5f;
        }
        goodsCellModel.weight = @(weight);
        [arr addObject:specModel];

        lastItem = item;
    }
    totolMoney.cent = [NSString stringWithFormat:@"%f", totolCent.doubleValue];
    // 商品总额
    SAInfoViewModel *totolModel = [[SAInfoViewModel alloc] init];
    totolModel.keyText = TNLocalizedString(@"tn_page_total_amount_title", @"商品总额");
    totolModel.keyFont = HDAppTheme.TinhNowFont.standard15;
    totolModel.keyColor = HDAppTheme.TinhNowColor.G2;
    if (isNeedCalculateTotalPrice) {
        totolModel.valueText = totolMoney.thousandSeparatorAmount;
    } else {
        totolModel.valueText = self.calcResult.price.thousandSeparatorAmount;
    }
    totolModel.valueFont = HDAppTheme.TinhNowFont.standard15;
    totolModel.valueColor = HDAppTheme.TinhNowColor.R1;
    [arr addObject:totolModel];
}
#pragma mark -展示选择预约时间弹窗
- (void)showSelectDeliveryTimeAlertViewWithTitle:(NSString *)title {
    if (HDIsArrayEmpty(self.calcResult.deliveryTimeDTOList))
        return;
    //    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.calcResult.deliveryTimeDTOList];
    //    if (!HDIsObjectNil(self.calcResult.immediateDeliveryResp)) {
    //        TNCalcDateModel *first = [tempArr.firstObject yy_modelCopy];
    //        NSMutableArray *tempDateArr = [NSMutableArray arrayWithArray:first.deliveryTimeList];
    //        TNCalcTimeModel *model = [[TNCalcTimeModel alloc] init];
    //        model.timeStr = self.calcResult.immediateDeliveryResp.message;
    //        model.immediateDeliveryStr = self.calcResult.immediateDeliveryResp.immediateDeliveryStr;
    //        model.immediateDeliveryFreight = self.calcResult.immediateDeliveryResp.freight;
    //        model.appointmentType = TNOrderAppointmentTypeImmediately;
    //        [tempDateArr insertObject:model atIndex:0];
    //        first.deliveryTimeList = tempDateArr;
    //        [tempArr replaceObjectAtIndex:0 withObject:first];
    //    }
    TNSelectDeliveryTimeAlertView *alertView = [[TNSelectDeliveryTimeAlertView alloc] initWithDataArr:self.calcResult.deliveryTimeDTOList selectedDeliveryTime:self.deliveryTime
                                                                              selectedAppointmentType:self.appointmentType
                                                                                                title:title

                                                                               immediateDeliveryModel:self.calcResult.immediateDeliveryResp];
    @HDWeakify(self);
    alertView.selectedCallBack = ^(NSString *_Nonnull date, NSString *_Nonnull time, NSString *showStr, TNOrderAppointmentType appointmentType) {
        @HDStrongify(self);
        if (appointmentType == TNOrderAppointmentTypeReserve) {
            self.deliveryTime = [NSString stringWithFormat:@"%@ %@", date, time];
        } else {
            self.deliveryTime = time;
        }
        self.appointmentType = appointmentType;
        self.soonDeliveryTimeStr = showStr;
        [self calcTotalPayFee];
    };
    [alertView show];
}
#pragma mark -展示运费明细弹窗
- (void)showFreightDetailAlertView {
    TNFreightDetailAlertView *alertView = [[TNFreightDetailAlertView alloc] initWithBaseFreight:self.calcResult.basicFreight additionalFreight:self.calcResult.addtionalFreight];
    [alertView show];
}
#pragma mark -展示物流计费弹窗
- (void)showFreightCostsAlertView {
    if (self.hasOverseasGood && HDIsObjectNil(self.selectedDeliveryComponyModel)) {
        [HDTips showWithText:TNLocalizedString(@"tn_please_choose_ship_company", @"请选择物流公司") inView:self.view hideAfterDelay:3];
        return;
    }


    if (!HDIsArrayEmpty(self.deliveryComponylist)) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (TNDeliveryComponyModel *obj in self.deliveryComponylist) {
            if ([obj.deliveryCorp isEqualToString:self.selectedDeliveryComponyModel.deliveryCorp]) {
                [tempArr addObject:obj];
            }
        }
        TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:tempArr showTitle:false];
        [alertView show];
    } else {
        [self.view showloading];
        @HDWeakify(self);
        [self.productDTO queryFreightStandardCostsByStoreNo:self.storeModel.storeNo success:^(NSArray<TNDeliveryComponyModel *> *_Nonnull list) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.deliveryComponylist = list;
            if (!HDIsArrayEmpty(self.deliveryComponylist)) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (TNDeliveryComponyModel *obj in self.deliveryComponylist) {
                    if ([obj.deliveryCorp isEqualToString:self.selectedDeliveryComponyModel.deliveryCorp]) {
                        [tempArr addObject:obj];
                    }
                }
                TNDeliveryComponyAlertView *alertView = [[TNDeliveryComponyAlertView alloc] initWithTitle:TNLocalizedString(@"5JiVnZRY", @"物流计费标准") list:tempArr showTitle:false];
                [alertView show];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}
- (void)showInputPromoCodeAlert {
    TNTextFeildAlertView *alertView = [[TNTextFeildAlertView alloc] initAlertWithTitle:TNLocalizedString(@"OkaO8L5F", @"优惠码") valueText:self.promoCodeRspModel.promotionCode
                                                                             placeHold:TNLocalizedString(@"VPdlGdML", @"请输入优惠码")];
    @HDWeakify(self);
    alertView.enterValueCallBack = ^(NSString *_Nonnull valueText) {
        @HDStrongify(self);
        self.calcResult.promotionCode = valueText;
        self.isSelectedUsePromotionCode = YES;
        [self calcTotalPayFee];
    };
    [alertView show];
}

- (void)submitOrderSuccess:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel, TNPaymentMethodModel *paymentType))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self p_submitOrderWithRiskToken:token success:successBlock failure:failureBlock];
    }];
}
#pragma mark - 价格有变动替换
- (void)oversasProductPriceChangeAndReplace {
    if (!HDIsArrayEmpty(self.calcResult.cartItemDTOS)) {
        for (TNCalculateSkuPriceModel *skuModel in self.calcResult.cartItemDTOS) {
            for (TNShoppingCarItemModel *item in self.storeModel.selectedItems) {
                if ([skuModel.skuId isEqualToString:item.goodsSkuId]) {
                    item.salePrice = skuModel.skuPrice;
                    break;
                }
            }
        }
    }
}
#pragma mark - 判断优惠券和优惠码是否能叠加使用
- (void)checkCouponAndPromotionCodeOverlayUse {
    // 先存储当前的优惠码  优惠金额
    if (self.isSelectedUsePromotionCode && HDIsStringNotEmpty(self.calcResult.promotionCode)) {
        self.promoCodeRspModel.promotionCode = self.calcResult.promotionCode;
        self.promoCodeRspModel.discountAmount = self.calcResult.promotionCodeDiscount;
    }
    if (self.isSelectedUsePlateCoupon && self.isSelectedUsePromotionCode) {
        if ((self.selectCouponModel.marketingType == 15 && self.calcResult.voucherCouponLimit) || (self.selectCouponModel.marketingType == 34 && self.calcResult.shippingCouponLimit)) {
            [NAT showAlertWithMessage:TNLocalizedString(@"bUYo9SST", @"与优惠券不可同时使用，已匹配最优惠") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
            // 优惠券和优惠码不能同时使用  帮用户勾选最优惠的
            if ([self.selectCouponModel.discountAmount.cent integerValue] > [self.calcResult.promotionCodeDiscount.cent integerValue]) {
                // 优惠券更优惠
                self.isSelectedUsePlateCoupon = YES;
                self.isSelectedUsePromotionCode = NO;
            } else {
                self.isSelectedUsePlateCoupon = NO;
                self.isSelectedUsePromotionCode = YES;
            }
        }
    }
}
#pragma mark - 筛选下架 失效的商品
- (void)filterInvalidProducts {
    if (!HDIsArrayEmpty(self.calcResult.invalidProducts)) {
        [self.calcResult.invalidProducts enumerateObjectsUsingBlock:^(TNInvalidProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [self.storeModel.selectedItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull itemObj, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([obj.productId isEqualToString:itemObj.goodsId]) {
                    [obj.invalidSkus enumerateObjectsUsingBlock:^(TNInvalidSkuModel *_Nonnull skuObj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([skuObj.skuId isEqualToString:itemObj.goodsSkuId]) {
                            itemObj.invalidMsg = skuObj.invalidMsg;
                        }
                    }];
                }
            }];
        }];
    }
}
#pragma mark -提交订单
- (void)p_submitOrderWithRiskToken:(NSString *)riskToken
                           success:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel, TNPaymentMethodModel *paymentType))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    NSString *platformCouponCode = self.isSelectedUsePlateCoupon ? self.selectCouponModel.couponCode : nil;
    NSString *platformCouponDiscount = self.isSelectedUsePlateCoupon ? self.selectCouponModel.discountAmount.centFace : nil;
    NSString *promotionCode = self.isSelectedUsePromotionCode ? self.calcResult.promotionCode : nil;
    NSString *promotionDisCount = self.isSelectedUsePromotionCode ? self.calcResult.promotionCodeDiscount.centFace : nil;
    [self.paymentDTO orderSubmitWithStoreShoppingCar:self.storeModel payType:self.paymentMethodModel shippingType:self.shippiingMethodModel orderAmount:self.calcResult.amount
                                      discountAmount:self.calcResult.couponDiscount
                                       paymentAmount:self.calcResult.amountPayable
                                          couponCode:@""
                                        addressModel:self.addressModel
                                                memo:self.memo
                                  platformCouponCode:platformCouponCode
                              platformCouponDiscount:platformCouponDiscount
                              verificationPromotions:self.calcResult.verificationPromotions
                                           riskToken:riskToken
                                        deliveryTime:self.deliveryTime
                                         appointment:self.appointmentType
                                           salesType:self.storeModel.salesType
                                        randomString:self.randomString
                                   freightPriceChina:self.calcResult.freightPriceChina
                                       promotionCode:promotionCode
                               promotionCodeDiscount:promotionDisCount
                                    deliveryCorpCode:self.selectedDeliveryComponyModel.deliveryCorpCode success:^(WMOrderSubmitRspModel *_Nonnull rspModel) {
                                        @HDStrongify(self);
                                        rspModel.paymentAmount = self.calcResult.amountPayable;
                                        successBlock(rspModel, self.paymentMethodModel);
                                        if ([self.storeModel.salesType isEqualToString:TNSalesTypeBatch]) {
                                            [[TNShoppingCar share] queryBatchUserShoppingCarSuccess:nil failure:nil];
                                        } else {
                                            [[TNShoppingCar share] querySingleUserShoppingCarSuccess:nil failure:nil];
                                        }
                                        // 更新商品总数
                                        [[TNShoppingCar share] queryUserShoppingTotalCountSuccess:nil failure:nil];
                                    }
                                             failure:failureBlock];
}
#pragma mark -检验经纬度
- (void)checkRegion:(void (^)(TNCheckRegionModel *checkModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.orderDTO checkRegionAreaWithLatitude:self.addressModel.latitude longitude:self.addressModel.longitude storeNo:self.storeModel.storeNo paymentMethod:self.paymentMethodModel.method scene:@""
                                       Success:successBlock
                                       failure:failureBlock];
}
#pragma mark -下单前校验是否可以下单
- (void)checkBeforeSubmitOrder:(void (^)(TNCheckSumitOrderModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.paymentDTO checkOrderCanSubmitWithLatitude:self.addressModel.latitude longitude:self.addressModel.longitude storeNo:self.storeModel.storeNo paymentMethod:self.paymentMethodModel.method
                                               scene:@""
                                        productItems:self.storeModel.selectedItems
                                             success:successBlock
                                             failure:failureBlock];
}
#pragma mark -立即送达不可用处理
- (void)processImmediateDeliveryNotAvailable {
    self.appointmentType = TNOrderAppointmentTypeDefault;
    self.deliveryTime = nil;
    self.soonDeliveryTimeStr = self.calcResult.soonDelivery;
    [self calcTotalPayFee];
}

- (void)setSelectedDeliveryCompany:(TNDeliveryComponyModel *)model {
    self.selectedDeliveryComponyModel = model;
    [SACacheManager.shared setObject:model forKey:kCacheKeyTinhNowDeliveryCompanyLastChoosed type:SACacheTypeDocumentNotPublic];
}
#pragma mark - 赋值
/// 更新支付优惠
- (void)updatePayDiscountAmount:(SAMoneyModel *)payDiscountAmount {
    self.paydiscountAmount = payDiscountAmount;
}
- (void)updateAddressModel:(SAShoppingAddressModel *)addressModel {
    self.addressModel = addressModel;
    // 拿到地址后就重新获取支付方式
    self.avaliablePaymentMethods = @[];
    self.paymentMethodModel = nil;
    self.appointmentType = TNOrderAppointmentTypeDefault;
    self.deliveryTime = nil;
    @HDWeakify(self);
    [self.view showloading];
    [self queryPaymentInfoCompletion:^{
        @HDStrongify(self);
        if (!HDIsArrayEmpty(self.avaliablePaymentMethods)) {
            [self calcTotalPayFee];
        } else {
            !self.networkFailBlock ?: self.networkFailBlock();
        }
    }];
}

#pragma mark - setter
- (void)setStoreModel:(TNShoppingCarStoreModel *)storeModel {
    _storeModel = storeModel;
    // 只要有一条商品试海外购商品 就判定该订单为海外购订单
    self.hasOverseasGood = NO;
    for (TNShoppingCarItemModel *item in _storeModel.selectedItems) {
        // 统计总件数
        self.totalCount += item.quantity.unsignedIntegerValue;
        if ([item.productType isEqualToString:TNGoodsTypeOverseas]) {
            self.hasOverseasGood = YES;
            self.trackPrefixName = TNTrackEventPrefixNameOverseas;
        } else if ([item.productType isEqualToString:TNGoodsTypeGeneral]) {
            self.trackPrefixName = TNTrackEventPrefixNameFastConsume;
        } else {
            self.trackPrefixName = TNTrackEventPrefixNameOther;
        }
    }
}

- (void)setMemo:(NSString *)memo {
    _memo = memo;
    [self generateDataSource];
}
- (BOOL)needToastEnterPromotionCode {
    if (self.isSelectedUsePromotionCode && HDIsStringEmpty(self.promoCodeRspModel.promotionCode)) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)needToastSelectedCoupon {
    if (self.isSelectedUsePlateCoupon && HDIsObjectNil(self.selectCouponModel) && HDIsStringNotEmpty(self.selectCouponModel.couponCode)) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)canSubmitOrder {
    __block BOOL canBuy = NO; // 是否可以购买
    [self.storeModel.selectedItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull itemObj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (HDIsStringEmpty(itemObj.invalidMsg)) {
            // 只要有一个sku 能购买  就可以
            canBuy = YES;
        }
    }];
    return canBuy;
}
#pragma mark - lazy load
/** @lazy paymentDTO */
- (TNPaymentDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = [[TNPaymentDTO alloc] init];
    }
    return _paymentDTO;
}
/** @lazy addressDTO */
- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = [[SAShoppingAddressDTO alloc] init];
    }
    return _addressDTO;
}
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (TNCouponTicketDTO *)couponDTO {
    if (!_couponDTO) {
        _couponDTO = [[TNCouponTicketDTO alloc] init];
    }
    return _couponDTO;
}
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}
/** @lazy productDTO */
- (TNProductDTO *)productDTO {
    if (!_productDTO) {
        _productDTO = [[TNProductDTO alloc] init];
    }
    return _productDTO;
}
/** @lazy storeDTO */
- (TNStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[TNStoreDTO alloc] init];
    }
    return _storeDTO;
}
/** @lazy promoCodeRspModel */
- (TNPromoCodeRspModel *)promoCodeRspModel {
    if (!_promoCodeRspModel) {
        _promoCodeRspModel = [[TNPromoCodeRspModel alloc] init];
    }
    return _promoCodeRspModel;
}
@end
