//
//  WMOrderSubmitV2ViewModel.m
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitV2ViewModel.h"
#import "SAAddressModel.h"
#import "SAApolloManager.h"
#import "SACacheManager.h"
#import "SAGuardian.h"
#import "SANotificationConst.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressModel.h"
#import "SAUserViewModel.h"
#import "WMCheckIsStoreCanDeliveryRspModel.h"
#import "WMCouponsDTO.h"
#import "WMOrderSubmitCalDeliveryFeeRspModel.h"
#import "WMOrderSubmitCalPayFeeProductItem.h"
#import "WMOrderSubmitCouponRspModel.h"
#import "WMOrderSubmitProductItem.h"
#import "WMOrderSubmitQueryGoodsItem.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDTO.h"
#import "WMStoreModel.h"
#import "WMStoreShoppingCartDTO.h"
#import "SAAddressCacheAdaptor.h"


@interface WMOrderSubmitV2ViewModel ()
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 有效地址
@property (nonatomic, strong) SAShoppingAddressModel *validAddressModel;
/// 上次选择的门店是否在配送范围内
@property (nonatomic, assign) BOOL isLastChoosedAddressAvailable;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否正在加载
@property (nonatomic, assign) BOOL isLoading;
/// 优惠券 DTO
@property (nonatomic, strong) WMCouponsDTO *couponDTO;
/// 门店 DTO
@property (nonatomic, strong) WMStoreDTO *storeDTO;
/// 地址 DTO
@property (nonatomic, strong) SAShoppingAddressDTO *shoppingAddressDTO;
/// 门店购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 提交订单
@property (nonatomic, strong) CMNetworkRequest *submitOrderRequest;
/// 聚合接口
@property (nonatomic, strong) CMNetworkRequest *aggregationRequest;

/// 聚合查询返回
@property (nonatomic, strong) WMOrderSubmitAggregationRspModel *aggregationRspModel;
/// 活动列表，可能包含减配送费，满减活动
@property (nonatomic, copy) NSArray<WMOrderSubmitPromotionModel *> *promotionList;
/// 可用优惠券数量
@property (nonatomic, assign) NSUInteger usableCouponCount;
/// 可用运费券数量
@property (nonatomic, assign) NSUInteger usableFreightCouponCount;
/// 活动金额，除去减配送费活动的金额
@property (nonatomic, strong) SAMoneyModel *activityMoneyExceptDeliveryFeeReduction;
/// 活动减免的配送费金额
@property (nonatomic, strong) SAMoneyModel *deliveryFeeReductionMoney;
/// 用户 VM
@property (nonatomic, strong) SAUserViewModel *userViewModel;
/// 年龄
@property (nonatomic, assign) NSInteger age;

@end


@implementation WMOrderSubmitV2ViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 监听离线购物车商品上传完成通知
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(uploadOfflineShoppingGoodsCompleted) name:kNotificationNameUploadOfflineShoppingGoodsCompleted object:nil];
    }
    return self;
}

- (void)dealloc {
    [_submitOrderRequest cancel];
    [_aggregationRequest cancel];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUploadOfflineShoppingGoodsCompleted object:nil];
}

#pragma mark - Data
- (void)getInitializedData {
    if (!self.isLoading) {
        self.isLoading = true;
    }
    @HDWeakify(self);
    // 验证地址是否在配送范围内
    void (^checkAddressCanDelivery)(BOOL) = ^(BOOL needChooseAddress) {
        @HDWeakify(self);
        dispatch_group_enter(self.taskGroup);
        [self checkIsStoreCanDeliveryWithLastChooseAddressSuccess:^(BOOL contained) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            if (needChooseAddress && contained) {
                !self.choosedAddressBlock ?: self.choosedAddressBlock(self.addressModelToCheck);
            }
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    };
    //    [self.addressDTO getUserAccessableShoppingAddressWithStoreNo:self.storeNo success:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
    //        @HDStrongify(self);
    //        [self dismissLoading];
    //
    //        self.availableAddressListSectionModel.list = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
    //            return [item.inRange isEqualToString:SABoolValueTrue];
    //        }];
    //        self.unavailableAddressListSectionModel.list = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
    //            return [item.inRange isEqualToString:SABoolValueFalse];
    //        }];
    //        [self.tableView successGetNewDataWithNoMoreData:true];
    //    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
    //        @HDStrongify(self);
    //        [self dismissLoading];
    //
    //        [self.tableView failGetNewData];
    //    }];

    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    ///打开gps定位默认展示离商家离用户最近的地址
    if (status == HDCLAuthorizationStatusAuthed) {
        dispatch_group_enter(self.taskGroup);
        [self.shoppingAddressDTO getUserAccessableShoppingAddressWithStoreNo:self.storeItem.storeNo success:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
            @HDStrongify(self);
            self.contactlist = list;
            NSArray *limitArr = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
                return [item.inRange isEqualToString:SABoolValueTrue];
            }];
            if (!HDIsArrayEmpty(limitArr)) {
                if (limitArr.count == 1) {
                    self.addressModelToCheck = limitArr.firstObject;
                    self.isLastChoosedAddressAvailable = YES;
                } else {
                    ///寻找最小值
                    double min = CGFLOAT_MAX;
                    SAShoppingAddressModel *minModel = nil;
                    //优先选择默认地址
                    //移除默认地址优先 2.72.0
                    //                    for (SAShoppingAddressModel *addressModel in limitArr) {
                    //                        if([addressModel.isDefault isEqualToString:SABoolValueTrue]) {
                    //                            minModel = addressModel;
                    //                            break;
                    //                        }
                    //                    }
                    //                    if(!minModel) {
                    //                        for (SAShoppingAddressModel *addressModel in limitArr) {
                    //                            if (min > addressModel.distance) {
                    //                                min = addressModel.distance;
                    //                                minModel = addressModel;
                    //                            }
                    //                        }
                    //获取当前经纬度
                    CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
                    //最新位置
                    CLLocation *toL = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
                    for (SAShoppingAddressModel *addressModel in limitArr) {
                        //比较当前位置和店铺距离大小，取最小的
                        double distance = [HDLocationUtils distanceFromLocation:toL toLocation:[[CLLocation alloc] initWithLatitude:addressModel.latitude.doubleValue longitude:addressModel.longitude.doubleValue]];
                        if (min > distance) {
                            min = distance;
                            minModel = addressModel;
                        }
                    }
                    //                    }
                    self.addressModelToCheck = nil;
                    self.popAddressModel = minModel;
                }
            }
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    } else {
        if (!HDIsObjectNil(self.addressModelToCheck)) {
            dispatch_group_enter(self.taskGroup);
            [self.shoppingAddressDTO getShoppingAddressListSuccess:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
                @HDStrongify(self);
                NSArray *addressNosArray = [list mapObjectsUsingBlock:^id _Nonnull(SAShoppingAddressModel *_Nonnull obj, NSUInteger idx) {
                    return obj.addressNo;
                }];
                if ([addressNosArray containsObject:self.addressModelToCheck.addressNo]) {
                    checkAddressCanDelivery(false);
                } else {
                    self.addressModelToCheck = nil;
                }
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            }];
        } else {
            HDLog(@"当前没有地址，需要用户选择地址");
            dispatch_group_enter(self.taskGroup);
            [self.shoppingAddressDTO getDefaultAddressSuccess:^(SAShoppingAddressModel *_Nonnull rspModel) {
                @HDStrongify(self);
                if (!HDIsObjectNil(rspModel)) {
                    self.addressModelToCheck = rspModel;
                    checkAddressCanDelivery(true);
                }
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
            }];
        }
    }

    /// 实时获取年龄
    dispatch_group_enter(self.taskGroup);
    [self.userViewModel getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull userModel) {
        @HDStrongify(self);
        self.age = userModel.WMAge;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    ///风控
    dispatch_group_enter(self.taskGroup);
    [self checkUserHasRiskCompletion:^{
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];


    dispatch_group_enter(self.taskGroup);
    if (self.pickUpStatus) {
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } else {
        [self getStorePickUpStatusWithStoreNo:self.storeItem.storeNo completion:^(BOOL pickUpStatus) {
            @HDStrongify(self);
            self.pickUpStatus = pickUpStatus;
            !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
        }];
    }

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        // 请求聚合接口获取所有数据
        [self getRenderUIData];
    });
}

///选择浮层地址
- (void)selectPopAddress {
    self.addressModelToCheck = self.popAddressModel;
    self.isLastChoosedAddressAvailable = YES;
    [self getRenderUIData];
}

///风控
- (void)checkUserHasRiskCompletion:(void (^)(void))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/risk/get.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class]) {
            self.userHasRisk = [info[@"userHasRisk"] intValue];
        }
        if (completion)
            completion();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        if (completion)
            completion();
    }];
}

- (void)getStorePickUpStatusWithStoreNo:(NSString *)storeNo completion:(void (^)(bool))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-store-pickUp-status";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{@"storeNo": storeNo};
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if ([info isKindOfClass:NSDictionary.class]) {
            if (completion)
                completion([info[@"status"] boolValue]);
        } else {
            if (completion)
                completion(NO);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        if (completion)
            completion(NO);
    }];
}

- (void)getSpecialAddress {
    if (!self.validAddressModel)
        return;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/increase-delivery";
    request.shouldAlertErrorMsgExceptSpecCode = false;
    request.isNeedLogin = true;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    [mdic setObject:@{
        @"lat": self.validAddressModel.latitude.stringValue,
        @"lon": self.validAddressModel.longitude.stringValue,
    }
             forKey:@"location"];
    [mdic setObject:self.storeItem.storeNo forKey:@"storeNo"];
    request.requestParameter = mdic;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        self.increaseDeliveryModel = [WMOrderIncreaseDeliveryModel yy_modelWithJSON:rspModel.data];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        self.increaseDeliveryModel = nil;
    }];
}

- (void)getNewAgeData {
    @HDWeakify(self);
    [self.userViewModel getUserInfoWithOperatorNo:SAUser.shared.operatorNo success:^(SAGetUserInfoRspModel *_Nonnull userModel) {
        @HDStrongify(self);
        self.age = userModel.WMAge;
        [self getRenderUIData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self getRenderUIData];
    }];
}

// 获取渲染页面所需所有数据
- (void)getRenderUIData {
    if (!self.isLoading) {
        self.isLoading = true;
    }

    BOOL hadPromoCode = self.promoCode;
    NSString *useCouponStr = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyYumNowCouponSelectedSwitch];
    NSString *useShipCouponStr = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyYumNowFreightSelectSwitch];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"age"] = @(self.age);
    params[@"storeNo"] = self.storeItem.storeNo;
    params[@"operatorNo"] = SAUser.shared.operatorNo ?: @"";
    params[@"deviceId"] = HDDeviceInfo.getUniqueId;

    //自取
    if (self.serviceType == 20) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            NSMutableDictionary *receiveAddress = [NSMutableDictionary dictionary];
            receiveAddress[@"addressNo"] = @"";
            receiveAddress[@"location"] = @{
                @"lat": [NSString stringWithFormat:@"%f", HDLocationManager.shared.coordinate2D.latitude],
                @"lon": [NSString stringWithFormat:@"%f", HDLocationManager.shared.coordinate2D.longitude]
            };
            params[@"receiveAddress"] = receiveAddress;
        }

        if (!HDIsObjectNil(self.toStoreSubscribeTimeModel)) {
            NSMutableDictionary *deliveryTime = [NSMutableDictionary dictionary];
            deliveryTime[@"date"] = [NSNumber numberWithLongLong:self.toStoreSubscribeTimeModel.date.longLongValue];
            deliveryTime[@"type"] = self.toStoreSubscribeTimeModel.type;
            params[@"deliveryTime"] = deliveryTime;
        }

    } else {
        if (!HDIsObjectNil(self.validAddressModel)) {
            NSMutableDictionary *receiveAddress = [NSMutableDictionary dictionary];
            receiveAddress[@"addressNo"] = self.validAddressModel.addressNo;
            receiveAddress[@"location"] = @{@"lat": self.validAddressModel.latitude.stringValue, @"lon": self.validAddressModel.longitude.stringValue};
            params[@"receiveAddress"] = receiveAddress;
        }

        if (!HDIsObjectNil(self.deliverySubscribeTimeModel)) {
            NSMutableDictionary *deliveryTime = [NSMutableDictionary dictionary];
            deliveryTime[@"date"] = [NSNumber numberWithLongLong:self.deliverySubscribeTimeModel.date.longLongValue];
            deliveryTime[@"type"] = self.deliverySubscribeTimeModel.type;
            params[@"deliveryTime"] = deliveryTime;
        }
    }


    if (HDIsStringNotEmpty(self.promoCode)) {
        params[@"promoCode"] = [self.promoCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    // 是否使用优惠券
    BOOL useCoupon = (useCouponStr && [useCouponStr isEqualToString:@"on"]) ? true : false;
    if (!useCoupon && !HDIsObjectNil(self.couponModel) && self.usableCouponCount) {
        useCoupon = true;
    } else if (useCoupon && HDIsObjectNil(self.couponModel) && self.usableCouponCount) {
        useCoupon = false;
    }

    ///限制使用
    //    if (self.aggregationRspModel.wmTrial.useVoucherCoupon && useCoupon) {
    //        useCoupon = false;
    //    }

    // 是否使用运费券
    BOOL useShipCoupon = (useShipCouponStr && [useShipCouponStr isEqualToString:@"on"]) ? true : false;
    if (!useShipCoupon && !HDIsObjectNil(self.freightCouponModel) && self.usableFreightCouponCount) {
        useShipCoupon = true;
    } else if (useShipCoupon && HDIsObjectNil(self.freightCouponModel) && self.usableFreightCouponCount) {
        useShipCoupon = false;
    }
    ///限制使用
    if (self.aggregationRspModel.wmTrial.useShippingCoupon && useShipCoupon) {
        useShipCoupon = false;
    }

    BOOL useDeliveryFeeReduce = false;
    if (self.aggregationRspModel.wmTrial.useDeliveryFeeReduce) {
        useDeliveryFeeReduce = true;
    }
    params[@"useDeliveryFeeReduce"] = [NSNumber numberWithInt:useDeliveryFeeReduce];
    params[@"useCoupon"] = [NSNumber numberWithInt:useCoupon];

    if (self.serviceType != 20) {
        params[@"useFreightCoupon"] = [NSNumber numberWithInt:useShipCoupon];
    } else {
        params[@"useFreightCoupon"] = @(0);
    }
    if (!HDIsObjectNil(self.couponModel)) {
        params[@"couponNo"] = self.couponModel.couponCode;
    }

    if (self.serviceType != 20) {
        if (!HDIsObjectNil(self.freightCouponModel)) {
            params[@"freightCouponNo"] = self.freightCouponModel.couponCode;
        }
    }

    //增加是否使用门店券判断逻辑 3.0.23.8
    BOOL useStoreVoucherCoupon = false;
    if (useCoupon && self.couponModel.activitySubject == WMPromotionSubjectTypeMerchant) {
        useStoreVoucherCoupon = true;
    }
    params[@"useStoreVoucherCoupon"] = [NSNumber numberWithInt:useStoreVoucherCoupon];

    // 下单商品项
    NSArray<WMOrderSubmitQueryGoodsItem *> *queryGoodsItems = [self.productList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        WMOrderSubmitQueryGoodsItem *item = WMOrderSubmitQueryGoodsItem.new;
        item.goodsId = obj.goodsId.integerValue;
        item.goodsSkuId = obj.goodsSkuId.integerValue;
        item.properties = [obj.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull property, NSUInteger idx) {
            return [NSNumber numberWithLong:property.propertyId.integerValue];
        }];
        item.inEffectVersionId = obj.inEffectVersionId.integerValue;
        return item;
    }];
    params[@"goods"] = [queryGoodsItems yy_modelToJSONObject];

    params[@"serviceType"] = @(self.serviceType == 20 ? 20 : 10);

    self.aggregationRequest.requestParameter = params;
    @HDWeakify(self);
    [self.aggregationRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        SARspModel *rspModel = response.extraData;
        self.aggregationRspModel = [WMOrderSubmitAggregationRspModel yy_modelWithJSON:rspModel.data];
        
        ///有限制减免配送费或重新试算一遍
        if ((!useDeliveryFeeReduce && self.aggregationRspModel.wmTrial.useDeliveryFeeReduce)) {
            [self performSelector:@selector(getRenderUIData) withObject:nil afterDelay:0];
            return;
        }
        
        if (self.aggregationRspModel.fullGiftInfo.giftListResps) {
            // 满赠
            self.fullGiftRspModel = self.aggregationRspModel.fullGiftInfo;
        } else {
            self.fullGiftRspModel = nil;
        }

        self.promoCode = self.aggregationRspModel.promoCodeDiscount.promotionCode;
        // 从最新的购物车数据中更新商品数据
        [self updateGoodsInShoppingCart];
        // 更新地址是否支持极速服务
        self.validAddressModel.slowPayMark = self.aggregationRspModel.wmTrial.slowPayMark;
        // 过滤活动
        [self filterPromotions];
        // 默认选择第一张优惠券
        [self updateCouponWithUse:useCoupon];
        // 默认选择第一张运费券
        [self updateShipCouponWithUse:useShipCoupon];
        // 根据商品试算更新商品价格
        [self updateProductListPrice];
        ///检查优惠码与优惠券是否有限制
        [self checkCouponLimit];
        // 更新标识
        self.isLoading = false;
        self.refreshFlag = !self.refreshFlag;
        ///特殊区域提示
        [self getSpecialAddress];

        self.changeAddress = self.changeAddressFail = NO;
        ///有限制减免配送费或重新试算一遍
        if ((!useDeliveryFeeReduce && self.aggregationRspModel.wmTrial.useDeliveryFeeReduce)) {
            [self performSelector:@selector(getRenderUIData) withObject:nil afterDelay:0];
        } else {
            ///券数量
            [self checkCouponNumAction];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [NAT showToastWithTitle:nil content:response.responseObject[@"rspInf"] type:HDTopToastTypeInfo];
        self.isLoading = false;
        self.promoCode = nil;
        self.refreshFlag = !self.refreshFlag;
        if (hadPromoCode && self.aggregationRspModel.promoCodeDiscount.promotionCode) {
            /// 使用了优惠码 优惠码不满足条件 重新试算
            [self performSelector:@selector(getRenderUIData) withObject:nil afterDelay:0];
        }
        ///切换地址试算失败 置灰
        self.changeAddressFail = self.changeAddress;
        self.changeAddress = NO;
    }];
}

///检查优惠码与优惠券是否有限制
- (void)checkCouponLimit {
    if (self.promoCode && self.aggregationRspModel.promoCodeDiscount) {
        NSMutableArray *marr = NSMutableArray.new;
        if (self.couponModel && (self.aggregationRspModel.promoCodeDiscount.voucherCouponLimit || self.couponModel.usePromoCode) && HDIsArrayEmpty(marr)) {
            [marr addObject:@(WMCouponTypeVoucher)];
        }
        //自取不校验运费券逻辑
        if (self.serviceType != 20) {
            if (self.freightCouponModel && (self.aggregationRspModel.promoCodeDiscount.shippingCouponLimit || self.freightCouponModel.usePromoCode) && HDIsArrayEmpty(marr)) {
                [marr addObject:@(WMCouponTypeShipping)];
            }
        }
        ///有限制
        if (!HDIsArrayEmpty(marr)) {
            NSString *tip = @"";
            if ([marr containsObject:@(WMCouponTypeVoucher)]) {
                tip = [NSString stringWithFormat:WMLocalizedString(@"wm_promocode_remove_coupon", @"优惠码%@不可与优惠券同时使用，点击确认移除已选择的优惠券"), self.promoCode];
            }
            if ([marr containsObject:@(WMCouponTypeShipping)]) {
                tip = [NSString stringWithFormat:WMLocalizedString(@"wm_promocode_ship_remove_coupon", @"优惠码%@不可与优惠券同时使用，点击确认移除已选择的优惠券"), self.promoCode];
            }
            [NAT showAlertWithMessage:tip confirmButtonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                    if ([marr containsObject:@(WMCouponTypeVoucher)]) {
                        self.couponModel = nil;
                    }
                    if ([marr containsObject:@(WMCouponTypeShipping)]) {
                        self.freightCouponModel = nil;
                    }
                    [self getRenderUIData];
                }
                cancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                    self.promoCode = nil;
                    [self getRenderUIData];
                }];
        }
    }
}
/// 获取运费券和现金券真实可用数量
- (void)checkCouponNumAction {
    @HDWeakify(self) dispatch_group_t couponTask = dispatch_group_create();
    NSString *storeNo = self.storeItem.storeNo;
    SACurrencyType currencyType = self.storeItem.currency;
    NSString *merchantNo = self.storeItem.merchantNo;
    NSString *amount = self.amountToQueryCoupon.centFace;
    NSString *deliveryAmt = self.aggregationRspModel.deliveryInfo.deliverFee.centFace;
    NSString *packingAmt = self.storeItem.packingFee.centFace;
    NSString *addressNo = self.validAddressModel.addressNo;
    NSString *hasPromoCode = (self.aggregationRspModel.promoCodeDiscount && self.promoCode) ? @"true" : @"false";
    NSString *hasShippingCoupon = self.freightCouponModel ? @"true" : @"false";
    NSString *couponNo = self.couponModel.couponCode;
    NSArray *activityNos = self.aggregationRspModel.wmTrial.activityNos;
    ///运费券
    dispatch_group_enter(couponTask);
    [self.couponDTO getShippingCouponListWithStoreNo:storeNo amount:amount deliveryAmt:deliveryAmt packingAmt:packingAmt currencyType:currencyType merchantNo:merchantNo hasPromoCode:hasPromoCode
        hasShippingCoupon:hasShippingCoupon
        couponNo:couponNo
        addressNo:addressNo
        activityNos:activityNos success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
            @HDStrongify(self) NSArray *availableData = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return [item.usable isEqualToString:SABoolValueTrue];
            }];
            self.usableFreightCouponCount = availableData.count;
            dispatch_group_leave(couponTask);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self) self.usableFreightCouponCount = self.aggregationRspModel.availableFreightCoupon.count;
            dispatch_group_leave(couponTask);
        }];
    ///优惠券
    dispatch_group_enter(couponTask);
    [self.couponDTO getVoucherCouponListWithStoreNo:storeNo amount:amount deliveryAmt:deliveryAmt packingAmt:packingAmt currencyType:currencyType merchantNo:merchantNo hasPromoCode:hasPromoCode
        hasShippingCoupon:hasShippingCoupon
        couponNo:couponNo
        addressNo:addressNo
        activityNos:activityNos success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
            @HDStrongify(self) NSArray *availableData = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return [item.usable isEqualToString:SABoolValueTrue];
            }];
            self.usableCouponCount = availableData.count;
            dispatch_group_leave(couponTask);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self) self.usableCouponCount = self.aggregationRspModel.availableCoupons.count;
            dispatch_group_leave(couponTask);
        }];
    dispatch_group_notify(couponTask, dispatch_get_main_queue(), ^() {
        self.refreshCoupon = !self.refreshCoupon;
    });
}

///删除优惠码重新试算
- (void)deletePromoCode:(BOOL)hadPromoCode {
    self.promoCode = nil;
    self.refreshFlag = !self.refreshFlag;
    if (hadPromoCode && self.aggregationRspModel.promoCodeDiscount.promotionCode) {
        /// 使用了优惠码 优惠码不满足条件 重新试算
        [self performSelector:@selector(getRenderUIData) withObject:nil afterDelay:0];
    }
}

// 验证地址是否在配送范围内
- (CMNetworkRequest *)checkIsStoreCanDeliveryWithLastChooseAddressSuccess:(void (^)(BOOL canDelivery))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    SAShoppingAddressModel *addressModel = self.addressModelToCheck;

    @HDWeakify(self);
    return [self.storeDTO checkIsStoreCanDeliveryWithStoreNo:self.storeItem.storeNo longitude:addressModel.longitude.stringValue latitude:addressModel.latitude.stringValue
        success:^(WMCheckIsStoreCanDeliveryRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.isLastChoosedAddressAvailable = rspModel.canDelivery.boolValue;

            !successBlock ?: successBlock(rspModel.canDelivery.boolValue);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !failureBlock ?: failureBlock(rspModel, errorType, error);
        }];
}

- (void)submitOrderWithUserNote:(NSString *)userNote
                  paymentMethod:(SAOrderPaymentType)paymentMethod
              deliveryTimeModel:(WMOrderSubscribeTimeModel *)deliveryTimeModel
                  toStoreMobile:(NSString *)toStoreMobile
                        success:(void (^)(WMOrderSubmitRspModel *_Nonnull))successBlock
                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    SAShoppingAddressModel *addressModel = self.validAddressModel;
    if (self.serviceType != 20) {
        // 地址无效
        if (HDIsObjectNil(addressModel)) {
            !failureBlock ?: failureBlock(nil, CMResponseErrorTypeInvalidParams, [NSError errorWithDomain:@"没有可用地址" code:-1 userInfo:nil]);
            return;
        }
    }

    // 总的折扣金额
    SAMoneyModel *totalDiscountPrice = self.totalDiscountPrice;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    params[@"trialId"] = self.aggregationRspModel.trial.trialId;
    params[@"totalTrialPrice"] = self.aggregationRspModel.trial.totalTrialPrice.centFace;
    params[@"deliveryTimelinessType"] = deliveryTimeModel.type;
    params[@"paymentMethod"] = @(paymentMethod);
    params[@"payType"] = @(paymentMethod);
    params[@"storeNo"] = self.storeItem.storeNo;
    params[@"businessLine"] = SAClientTypeYumNow;
    params[@"totalCommodityPrice"] = self.productTotalPrice.centFace;
    params[@"eta"] = deliveryTimeModel.date;
    // 总的折扣金额，为空传 0 ，后端说需要，搞不懂
    params[@"discountAmount"] = totalDiscountPrice.centFace;
    params[@"freeBestSaleDiscountAmount"] = self.aggregationRspModel.wmTrial.freeBestSaleDiscountAmount.centFace;

    params[@"currency"] = self.storeItem.currency;
    params[@"userName"] = SAUser.shared.loginName;
    params[@"userId"] = SAUser.shared.operatorNo;
    params[@"loginName"] = SAUser.shared.loginName;
    params[@"addressNo"] = addressModel.addressNo;
    params[@"returnUrl"] = [NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", SAClientTypeYumNow];
    params[@"autoCreatePayOrder"] = @"false";


    //自取时修改参数
    if (self.serviceType == 20) {
        params[@"addressNo"] = @"";
    }

    // 营销参数
    NSMutableDictionary *marketingReqDTO = [NSMutableDictionary dictionary];

    // 有爆品或者商品优惠，这个字段就传23
    NSMutableArray<NSNumber *> *specialMarketingTypes = @[].mutableCopy;
    if (self.aggregationRspModel.wmTrial.freeBestSaleDiscountAmount.cent.integerValue != 0 || self.aggregationRspModel.wmTrial.freeProductDiscountAmount.cent.integerValue != 0) {
        [specialMarketingTypes addObject:@(WMStorePromotionMarketingTypeProductPromotions)];
    }
    marketingReqDTO[@"specialMarketingTypes"] = specialMarketingTypes;

    NSMutableArray<NSDictionary *> *verificationPromotions = [NSMutableArray array];

    NSDictionary * (^addActivityParams)(NSString *, NSString *, WMPromoCodeRspModel *) = ^NSDictionary *(NSString *activityNo, NSString *amt, WMPromoCodeRspModel *promoCodeRspModel) {
        if (amt.doubleValue <= 0) {
            return nil;
        }
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        item[@"discountNo"] = activityNo;
        item[@"businessType"] = SAMarketingBusinessTypeYumNow;
        item[@"currencyType"] = self.storeItem.currency;
        item[@"userNo"] = SAUser.shared.operatorNo;
        item[@"amt"] = amt;
        item[@"deliveryAmt"] = self.aggregationRspModel.deliveryInfo.deliverFee.centFace;
        item[@"merchantNo"] = self.storeItem.merchantNo;
        item[@"packingAmt"] = self.aggregationRspModel.wmTrial.packageFee.centFace;
        item[@"storeNo"] = self.storeItem.storeNo;
        item[@"userPhone"] = SAUser.shared.loginName;
        item[@"vatAmt"] = self.aggregationRspModel.wmTrial.vat.centFace;
        item[@"promotionCode"]
            = HDIsStringNotEmpty(promoCodeRspModel.promotionCode) ? [promoCodeRspModel.promotionCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        if (!HDIsObjectNil(promoCodeRspModel)) {
            item[@"marketingType"] = @(promoCodeRspModel.marketingType);
        }
        return item;
    };

    if (!HDIsArrayEmpty(self.promotionList)) {
        for (WMOrderSubmitPromotionModel *promotionModel in self.promotionList) {
            //            if(promotionModel.marketingType == WMStorePromotionMarketingTypeDelievry && self.)
            NSDictionary *activityParam = addActivityParams(promotionModel.activityNo, [self amountToPairActivityWithMarketingType:promotionModel.marketingType].centFace, nil);
            if (activityParam) {
                [verificationPromotions addObject:activityParam];
            }
        }
    }

    if (!HDIsObjectNil(self.couponModel)) {
        // 优惠券
        SAMoneyModel *amtQueryCoupon = self.amountToQueryCoupon;
        NSDictionary *activityParam = addActivityParams(self.couponModel.couponCode, amtQueryCoupon.centFace, nil);
        if (activityParam) {
            [verificationPromotions addObject:activityParam];
        }
    }

    if (!HDIsObjectNil(self.freightCouponModel)) {
        // 运费券
        SAMoneyModel *amtQueryCoupon = self.amountToQueryCoupon;
        NSDictionary *activityParam = addActivityParams(self.freightCouponModel.couponCode, amtQueryCoupon.centFace, nil);

        if (activityParam) {
            [verificationPromotions addObject:activityParam];
        }
    }

    if (!HDIsObjectNil(self.promoCode)) {
        // 促销码
        SAMoneyModel *amtQueryPromoCode = self.amountToQueryPromoCode;
        NSDictionary *activityParam = addActivityParams(self.aggregationRspModel.promoCodeDiscount.activityNo, amtQueryPromoCode.centFace, self.aggregationRspModel.promoCodeDiscount);
        if (activityParam) {
            [verificationPromotions addObject:activityParam];
        }
    }

    NSMutableArray<NSDictionary *> *fillGiftPromotions = [NSMutableArray array];
    if (!HDIsObjectNil(self.fullGiftRspModel)) {
        // 满赠
        for (WMStoreFillGiftRuleModel *mo in self.fullGiftRspModel.giftListResps) {
            NSMutableDictionary *giftParams = [NSMutableDictionary dictionary];
            giftParams[@"activityNo"] = mo.activityId;
            giftParams[@"quantity"] = @(mo.quantity);
            giftParams[@"commodityId"] = mo.giftId;
            giftParams[@"commodityName"] = mo.giftName;
            [fillGiftPromotions addObject:giftParams];
        }
    }
    if (!HDIsArrayEmpty(fillGiftPromotions)) {
        params[@"giftReqDtoList"] = fillGiftPromotions;
    }

    if (!HDIsArrayEmpty(verificationPromotions)) {
        marketingReqDTO[@"verificationPromotions"] = verificationPromotions;
        params[@"marketingReqDTO"] = marketingReqDTO;
    }

    BOOL useDeliveryFeeReduce = false;
    if (self.aggregationRspModel.wmTrial.useDeliveryFeeReduce) {
        useDeliveryFeeReduce = true;
    }
    marketingReqDTO[@"useDeliveryFeeReduce"] = [NSNumber numberWithInt:useDeliveryFeeReduce];


    params[@"marketingReqDTO"] = marketingReqDTO;

    // 业务参数
    NSMutableDictionary *businessParams = [NSMutableDictionary dictionary];
    businessParams[@"addressNo"] = addressModel.addressNo;
    businessParams[@"paymentMethod"] = @(paymentMethod);
    businessParams[@"storeNo"] = self.storeItem.storeNo;
    businessParams[@"deliveryTimelinessType"] = deliveryTimeModel.type;
    businessParams[@"eta"] = deliveryTimeModel.date;
    businessParams[@"loginName"] = SAUser.shared.loginName;
    businessParams[@"remark"] = userNote;
    businessParams[@"totalDiscountAmount"] = totalDiscountPrice.centFace;
    businessParams[@"slowPayMark"] = addressModel.slowPayMark;
    businessParams[@"speedDelivery"] = addressModel.speedDelivery;
    businessParams[@"reductionAmount"] = self.reductionPrice.centFace;
    businessParams[@"discountAmount"] = self.platformDiscountPrice.centFace;
    if (self.shareCode) {
        businessParams[@"shareCode"] = self.shareCode;
    }
    //    SAAddressModel *currentAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *currentAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = currentAddressModel.lat.doubleValue;
    CGFloat lon = currentAddressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lat = HDLocationManager.shared.coordinate2D.longitude;
        } else {
            lat = 0;
            lon = 0;
        }
    }
    businessParams[@"customerLat"] = @(lat).stringValue;
    businessParams[@"customerLon"] = @(lon).stringValue;

    if (!HDIsArrayEmpty(self.promotionList)) { // 需要传商品优惠的activityNo
        NSMutableArray *productActivityNos = [NSMutableArray array];
        for (WMOrderSubmitPromotionModel *promotionModel in self.promotionList) {
            if (promotionModel.marketingType == WMStorePromotionMarketingTypeProductPromotions) {
                [productActivityNos addObject:promotionModel.activityNo];
            }
        }
        businessParams[@"activityNos"] = productActivityNos;
    }

    // 生成下单商品快照集合
    NSArray<WMOrderSubmitProductItem *> *commodityInfoList = [self.productList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        WMOrderSubmitProductItem *item = WMOrderSubmitProductItem.new;
        item.count = obj.purchaseQuantity;
        item.commoditySnapshootId = obj.inEffectVersionId;
        item.commoditySpecificationId = obj.goodsSkuId;
        item.commodityId = obj.goodsId;
        item.propertyList = [obj.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
            WMOrderSubmitProductPropertyItem *propertyItem = WMOrderSubmitProductPropertyItem.new;
            propertyItem.propertyId = obj.productPropertyId;
            propertyItem.propertySelectionId = obj.propertyId;
            return propertyItem;
        }];
        return item;
    }];
    businessParams[@"commodityInfoList"] = [commodityInfoList yy_modelToJSONObject];

    //自取时修改参数
    if (self.serviceType == 20) {
        businessParams[@"addressNo"] = @"";
        businessParams[@"customerName"] = SAUser.shared.nickName.length ? SAUser.shared.nickName : SAUser.shared.mobile;
        if (self.addressModel) {
            businessParams[@"loginName"] = self.addressModel.mobile;
            businessParams[@"customerName"] = self.addressModel.consigneeName;
            businessParams[@"slowPayMark"] = @0; //把慢必赔去掉
        }
        businessParams[@"serviceType"] = @(self.serviceType == 20 ? 20 : 10);
    }

    params[@"businessParams"] = businessParams;
    params[@"deliverDistance"] = @(self.aggregationRspModel.deliveryInfo.distance).stringValue;

    // 用于删除购物项，搞不懂吧
    NSArray<NSDictionary *> *deleteItems = [self.productList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        if (HDIsStringEmpty(obj.itemDisplayNo)) {
            return nil;
        }
        NSMutableDictionary *item = NSMutableDictionary.new;
        item[@"itemDisplayNo"] = obj.itemDisplayNo;
        item[@"deleteDelta"] = @(obj.purchaseQuantity);
        // 注意这里，业务线是购物车专用
        item[@"businessType"] = SABusinessTypeYumNow;
        return item;
    }];

    static NSInteger retryTimes = 3;
    if (HDIsArrayEmpty(deleteItems)) {
        // 重试3次去拿完整的购物车，如果3次都拿不到，去下单
        if (retryTimes > 0) {
            retryTimes--;
            [self adjustShouldQueryStoreShoppingItem:^(BOOL isSuccess) {
                [self submitOrderWithUserNote:userNote paymentMethod:paymentMethod deliveryTimeModel:deliveryTimeModel toStoreMobile:toStoreMobile success:successBlock failure:failureBlock];
            }];
            return;
        }
    } else {
        HDLog(@"重置重试参数");
        retryTimes = 3;
    }
    params[@"deleteCartItemsReqDTO"] = @{@"deleteItems": deleteItems};

    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self p_submitOrderWithParams:params riskToken:token success:successBlock failure:failureBlock];
    }];
}

- (void)p_submitOrderWithParams:(NSMutableDictionary *)params
                      riskToken:(NSString *)riskToken
                        success:(void (^)(WMOrderSubmitRspModel *rspModel))successBlock
                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }
    self.submitOrderRequest.requestParameter = params;

    [self.submitOrderRequest startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMOrderSubmitRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - private methods
// 从最新的购物车数据中更新商品数据
- (void)updateGoodsInShoppingCart {
    // 只插入本单下单的商品
    NSMutableArray<WMShoppingCartStoreProduct *> *orderGoodsList = [NSMutableArray arrayWithCapacity:self.productList.count];
    for (WMShoppingCartStoreProduct *storeProduct in self.aggregationRspModel.storeShoppingCart) {
        for (WMShoppingCartStoreProduct *orderProduct in self.productList) {
            if ([orderProduct.identifyObj isEqual:storeProduct.identifyObj]) {
                [orderGoodsList addObject:storeProduct];
                break;
            }
        }
    }

    self.productList = orderGoodsList;
}
// 默认选择第一张优惠券
- (void)updateCouponWithUse:(BOOL)use {
    NSArray<WMOrderSubmitCouponModel *> *usableList = [self.aggregationRspModel.availableCoupons hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
        return [item.usable isEqualToString:SABoolValueTrue];
    }];

    //    self.usableCouponCount = usableList.count;
    // 如果当前未选择优惠券并且希望使用优惠券，则选择第一张优惠券
    if (HDIsObjectNil(self.couponModel) && use) {
        self.couponModel = usableList.firstObject;
        ///限制使用
        //        if (self.aggregationRspModel.wmTrial.useVoucherCoupon) {
        //            self.couponModel = nil;
        //        }
    }
}
// 默认选择第一张运费券
- (void)updateShipCouponWithUse:(BOOL)use {
    NSArray<WMOrderSubmitCouponModel *> *usableList = [self.aggregationRspModel.availableFreightCoupon hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
        return [item.usable isEqualToString:SABoolValueTrue];
    }];
    //    self.usableFreightCouponCount = usableList.count;
    // 如果当前未选择运费券并且希望使用运费券，则选择第一张运费券
    if (HDIsObjectNil(self.freightCouponModel) && use) {
        /// 配送费为0 无需使用
        BOOL needDelivery = YES;
        if (!self.deliveryFeeReductionMoney || self.deliveryFeeReductionMoney.cent.doubleValue <= 0) {
            needDelivery = self.aggregationRspModel.deliveryInfo.deliverFee.cent.intValue > 0;
        } else {
            needDelivery = (self.aggregationRspModel.deliveryInfo.deliverFee.cent.integerValue - self.deliveryFeeReductionMoney.cent.integerValue) > 0;
        }
        ///限制使用
        if (self.aggregationRspModel.wmTrial.useShippingCoupon) {
            needDelivery = NO;
        }
        if (needDelivery)
            self.freightCouponModel = usableList.firstObject;
    }
    ///使用试算返回的运费券减的金额
    if (self.freightCouponModel && usableList.count) {
        NSArray *arr = [usableList hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
            return [item.couponCode isEqualToString:self.freightCouponModel.couponCode];
        }];
        if (!HDIsArrayEmpty(arr)) {
            WMOrderSubmitCouponModel *first = arr.firstObject;
            self.freightCouponModel.discountAmount = first.discountAmount;
        }
    }
}
/// 过滤活动
- (void)filterPromotions {
    NSArray<WMOrderSubmitPromotionModel *> *availablePromotions = self.aggregationRspModel.availablePromotionActivities;
    // 如果包含爆款商品 过滤首单、平台折扣、平台满减、门店满减
    if (self.aggregationRspModel.wmTrial.freeBestSaleDiscountAmount.cent.integerValue != 0) {
        availablePromotions = [availablePromotions hd_filterWithBlock:^BOOL(WMOrderSubmitPromotionModel *_Nonnull item) {
            return item.marketingType != WMStorePromotionMarketingTypeLabber && item.marketingType != WMStorePromotionMarketingTypeStoreLabber
                   && item.marketingType != WMStorePromotionMarketingTypeDiscount && item.marketingType != WMStorePromotionMarketingTypeFirst;
        }];
    }
    // 如果包含商品优惠 过滤平台折扣、平台满减、门店满减
    if (self.aggregationRspModel.wmTrial.freeProductDiscountAmount.cent.integerValue != 0) {
        availablePromotions = [availablePromotions hd_filterWithBlock:^BOOL(WMOrderSubmitPromotionModel *_Nonnull item) {
            return item.marketingType != WMStorePromotionMarketingTypeLabber && item.marketingType != WMStorePromotionMarketingTypeStoreLabber
                   && item.marketingType != WMStorePromotionMarketingTypeDiscount;
        }];
    }

    ///过滤有商品优惠 但是activityNos里没有这个活动号
    availablePromotions = [availablePromotions hd_filterWithBlock:^BOOL(WMOrderSubmitPromotionModel *_Nonnull item) {
        BOOL result = YES;
        if (item.marketingType == WMStorePromotionMarketingTypeProductPromotions && [self.aggregationRspModel.wmTrial.activityNos indexOfObject:item.activityNo] == NSNotFound) {
            result = NO;
        }
        return result;
    }];

    ///限制减免配送费
    availablePromotions = [availablePromotions hd_filterWithBlock:^BOOL(WMOrderSubmitPromotionModel *_Nonnull item) {
        BOOL result = YES;
        if (item.marketingType == WMStorePromotionMarketingTypeDelievry && self.aggregationRspModel.wmTrial.useDeliveryFeeReduce && item.discountAmount.cent.doubleValue > 0) {
            ///置为0
            item.discountAmount.cent = @"0";
            result = NO;
        }
        return result;
    }];

    self.promotionList = availablePromotions;

    [self updatePromotionMoney];
}
/// 只要更改活动列表就要更新减免的活动金额和减配送费金额
- (void)updatePromotionMoney {
    if (HDIsArrayEmpty(self.promotionList)) {
        self.activityMoneyExceptDeliveryFeeReduction.cent = @"";
        self.deliveryFeeReductionMoney.cent = @"";
        return;
    }

    self.deliveryFeeReductionMoney.cent = @"";
    // 计算 活动金额，除去减配送费活动的金额 和 活动减免的配送费金额
    long activityMoneyExceptDeliveryFeeReductionAmount = 0;

    // 计算全部活动加起来的金额，1.6.0支持多活动
    double currentMoney = 0.0;
    for (WMOrderSubmitPromotionModel *obj in self.promotionList) {
        if (obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
            // 取折扣减免金额
            self.activityMoneyExceptDeliveryFeeReduction.cy = obj.discountAmount.cy;
            currentMoney += self.aggregationRspModel.wmTrial.freeDiscountAmount.cent.doubleValue;
        } else if (obj.marketingType == WMStorePromotionMarketingTypeDelievry) {
            self.deliveryFeeReductionMoney.cent = obj.discountAmount.cent;
        } else if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
            WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
            if (inUseLadderRuleModel) {
                // 取满减减免金额
                self.activityMoneyExceptDeliveryFeeReduction.cy = obj.discountAmount.cy;
                currentMoney += self.aggregationRspModel.wmTrial.freeFullReductionAmount.cent.doubleValue;
            }
        } else if (obj.marketingType == WMStorePromotionMarketingTypeFirst) {
            self.activityMoneyExceptDeliveryFeeReduction.cy = obj.discountAmount.cy;
            currentMoney += self.aggregationRspModel.wmTrial.freeFirstOrderAmount.cent.doubleValue;
        } else if (obj.marketingType == WMStorePromotionMarketingTypeCoupon) {
            WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
            if (inUseLadderRuleModel) {
                // 取满减减免金额
                self.activityMoneyExceptDeliveryFeeReduction.cy = obj.discountAmount.cy;
                currentMoney += self.aggregationRspModel.wmTrial.freeFullReductionAmount.cent.doubleValue;
            }
        }
    }

    activityMoneyExceptDeliveryFeeReductionAmount = currentMoney;

    self.activityMoneyExceptDeliveryFeeReduction.cent = [NSString stringWithFormat:@"%zd", activityMoneyExceptDeliveryFeeReductionAmount];
}

/// 根据传入门店购物项是否完整，决定是否重新获取门店购物项更新数据
- (void)adjustShouldQueryStoreShoppingItem:(void (^)(BOOL isSuccess))completion {
    BOOL hasInvalidGoods = false;
    for (WMShoppingCartStoreProduct *storeProduct in self.storeItem.goodsList) {
        if (HDIsStringEmpty(storeProduct.itemDisplayNo)) {
            hasInvalidGoods = true;
            break;
        }
    }
    if (!hasInvalidGoods) {
        !completion ?: completion(YES);
        return;
    }

    @HDWeakify(self);
    // 获取门店购物项商品，解决从未登录到登录情况下传入商品缺少 itemDisplayNo 参数无法下单问题
    [self.storeShoppingCartDTO queryStoreShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeItem.storeNo success:^(WMShoppingCartStoreItem *_Nonnull rspModel) {
        @HDStrongify(self);
        // 记录原来的商品 id
        NSArray<NSString *> *orderGoodsIdList = [self.productList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
            return obj.goodsId;
        }];
        // 只插入本单下单的商品
        NSMutableArray<WMShoppingCartStoreProduct *> *orderGoodsList = [NSMutableArray arrayWithCapacity:self.productList.count];
        for (WMShoppingCartStoreProduct *storeProduct in rspModel.goodsList) {
            if ([orderGoodsIdList containsObject:storeProduct.goodsId]) {
                [orderGoodsList addObject:storeProduct];
            }
        }
        self.storeItem.goodsList = orderGoodsList;
        HDLog(@"获取门店购物项成功并更新传入数据源");
        !completion ?: completion(YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"获取门店购物项失败");
        !completion ?: completion(YES);
    }];
}
// 根据商品试算更新商品价格
- (void)updateProductListPrice {
    if (HDIsArrayEmpty(self.productList) || HDIsObjectNil(self.aggregationRspModel.wmTrial)) {
        return;
    }
    for (WMShoppingCartStoreProduct *product in self.productList) {
        for (WMShoppingCartPayFeeCalProductModel *calProduct in self.aggregationRspModel.wmTrial.products) {
            WMShoppingCartStoreIdentifyableProduct *identifyableProduct = WMShoppingCartStoreIdentifyableProduct.new;
            identifyableProduct.goodsId = calProduct.productId;
            identifyableProduct.goodsSkuId = calProduct.specId;
            identifyableProduct.propertyArray = [calProduct.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
                return obj.propertyId;
            }];
            if ([product.identifyObj isEqual:identifyableProduct]) {
                product.totalDiscountAmount = calProduct.freeProductPromotionAmount;
            }
        }
    }
}

#pragma mark - Notification
- (void)uploadOfflineShoppingGoodsCompleted {
    [self adjustShouldQueryStoreShoppingItem:nil];
}


#pragma mark - 金额
/// 总的平台折扣金额
- (SAMoneyModel *)platformDiscountPrice {
    SAMoneyModel *moneyModel = SAMoneyModel.new;
    moneyModel.cy = self.aggregationRspModel.wmTrial.freeDiscountAmount.cy;
    long money = 0;
    for (WMOrderSubmitPromotionModel *obj in self.promotionList) {
        if (obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
            money += obj.discountAmount.cent.integerValue;
        }
    }
    moneyModel.cent = [NSString stringWithFormat:@"%zd", money];
    return moneyModel;
}
/// 总的满减金额
- (SAMoneyModel *)reductionPrice {
    SAMoneyModel *moneyModel = SAMoneyModel.new;
    moneyModel.cy = self.aggregationRspModel.wmTrial.freeFullReductionAmount.cy;
    long money = 0;
    for (WMOrderSubmitPromotionModel *obj in self.promotionList) {
        if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
            WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
            if (inUseLadderRuleModel) {
                money += obj.discountAmount.cent.integerValue;
            }
        }
    }
    moneyModel.cent = [NSString stringWithFormat:@"%zd", money];
    return moneyModel;
}
/// 总的折扣金额
- (SAMoneyModel *)totalDiscountPrice {
    SAMoneyModel *moneyModel = SAMoneyModel.new;
    moneyModel.cy = self.aggregationRspModel.wmTrial.totalAmount.cy;

    long amountTotal = 0;

    if (self.aggregationRspModel.wmTrial.freeProductDiscountAmount) { // 包含商品优惠
        amountTotal += self.aggregationRspModel.wmTrial.freeProductDiscountAmount.cent.integerValue;
    }
    if (self.aggregationRspModel.wmTrial.freeBestSaleDiscountAmount) {
        amountTotal += self.aggregationRspModel.wmTrial.freeBestSaleDiscountAmount.cent.integerValue;
    }
    if (self.activityMoneyExceptDeliveryFeeReduction.cent.integerValue > 0) {
        amountTotal += self.activityMoneyExceptDeliveryFeeReduction.cent.integerValue;
    }
    if (self.deliveryFeeReductionMoney.cent.integerValue > 0) {
        amountTotal += self.deliveryFeeReductionMoney.cent.integerValue;
    }
    if (!HDIsObjectNil(self.couponModel)) {
        amountTotal += self.couponModel.discountAmount.cent.integerValue;
    }
    if (!HDIsObjectNil(self.freightCouponModel)) {
        amountTotal += self.freightCouponModel.discountAmount.cent.integerValue;
    }
    if (!HDIsObjectNil(self.aggregationRspModel.promoCodeDiscount)) {
        amountTotal += self.aggregationRspModel.promoCodeDiscount.discountAmount.cent.integerValue;
    }
    moneyModel.cent = [NSString stringWithFormat:@"%zd", amountTotal];
    return moneyModel;
}

/// 商品总价
- (SAMoneyModel *)productTotalPrice {
    SAMoneyModel *productTotalPrice = SAMoneyModel.new;
    productTotalPrice.cy = self.aggregationRspModel.wmTrial.totalAmount.cy;
    double money = 0.0;
    for (WMShoppingCartStoreProduct *product in self.productList) {
        money += product.showPrice.cent.doubleValue;
    }
    //    productTotalPrice.cent = self.calculateProductPriceRspModel.productTotalPrice.cent;
    productTotalPrice.cent = [NSString stringWithFormat:@"%f", money];
    return productTotalPrice;
}

/// 商品原价总价
- (SAMoneyModel *)productNormalTotalPrice {
    SAMoneyModel *productTotalPrice = SAMoneyModel.new;
    productTotalPrice.cy = self.aggregationRspModel.wmTrial.totalAmount.cy;
    double money = 0.0;
    for (WMShoppingCartStoreProduct *product in self.productList) {
        money += product.totalPrice.cent.doubleValue;
    }
    productTotalPrice.cent = [NSString stringWithFormat:@"%f", money];
    return productTotalPrice;
}

/// 查询活动的金额
- (SAMoneyModel *)amountToQueryActivity {
    // 订单试算基准金额（满减活动：商品总金额+打包费 折扣活动：商品总金额，不包含配送费金额）
    SAMoneyModel *queryActivityMoney = SAMoneyModel.new;
    queryActivityMoney.cy = self.productTotalPrice.cy;

    // 过滤减配送费优惠
    NSArray<WMStoreDetailPromotionModel *> *noneDeliveryPromotionList = [self.aggregationRspModel.wmTrial.promotions hd_filterWithBlock:^BOOL(WMStoreDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];

    BOOL hasPromotion = !HDIsArrayEmpty(noneDeliveryPromotionList);
    if (hasPromotion) {
        return self.activityMoneyExceptDeliveryFeeReduction;
    } else {
        queryActivityMoney.cent = self.productTotalPrice.cent;
    }
    return queryActivityMoney;
}

- (SAMoneyModel *)amountToPairActivityWithMarketingType:(WMStorePromotionMarketingType)marketingType {
    SAMoneyModel *queryActivityMoney = SAMoneyModel.new;
    queryActivityMoney.cy = self.productTotalPrice.cy;
    long queryActivityMoneyCent = 0;
    //    if (marketingType == WMStorePromotionMarketingTypeDiscount) {
    //        queryActivityMoneyCent = self.productTotalPrice.cent.integerValue;
    //    } else if (marketingType == WMStorePromotionMarketingTypeLabber) {
    //        queryActivityMoneyCent = (self.productTotalPrice.cent.integerValue + self.calculateProductPriceRspModel.packingChargesTotalPrice.cent.integerValue);
    //    } else if (marketingType == WMStorePromotionMarketingTypeDelievry) {
    //        queryActivityMoneyCent = self.deliveryFeeRspModel.deliverFee.cent.integerValue;
    //    } else if (marketingType == WMStorePromotionMarketingTypeFirst) {
    //        queryActivityMoneyCent = (self.productTotalPrice.cent.integerValue + self.calculateProductPriceRspModel.packingChargesTotalPrice.cent.integerValue);
    //    } else if (marketingType == WMStorePromotionMarketingTypeCoupon) {
    //        queryActivityMoneyCent = (self.productTotalPrice.cent.integerValue + self.calculateProductPriceRspModel.packingChargesTotalPrice.cent.integerValue);
    //    }
    queryActivityMoneyCent = (self.productTotalPrice.cent.integerValue + self.aggregationRspModel.wmTrial.packageFee.cent.integerValue);

    queryActivityMoney.cent = [NSString stringWithFormat:@"%zd", queryActivityMoneyCent];
    return queryActivityMoney;
}

/// 查询优惠券的金额
- (SAMoneyModel *)amountToQueryCoupon {
    // 优惠券：
    // 1.如果订单已经参与了折扣或者满减活动（不包括减配送费活动），则此字段的值为"商品总价+打包费-活动优惠"
    // 2.如果订单没有参与活动优惠，则此值为商品总金额+打包费
    SAMoneyModel *queryCouponMoney = SAMoneyModel.new;
    queryCouponMoney.cy = self.productTotalPrice.cy;
    long queryCouponMoneyCent = self.productTotalPrice.cent.integerValue + self.aggregationRspModel.wmTrial.packageFee.cent.integerValue;
    if (self.activityMoneyExceptDeliveryFeeReduction.cent.integerValue > 0) {
        queryCouponMoneyCent -= self.activityMoneyExceptDeliveryFeeReduction.cent.integerValue;
    }
    queryCouponMoney.cent = [NSString stringWithFormat:@"%zd", queryCouponMoneyCent];
    return queryCouponMoney;
}

/// 查询促销码的金额
- (SAMoneyModel *)amountToQueryPromoCode {
    SAMoneyModel *queryPromoCodeMoney = SAMoneyModel.new;
    queryPromoCodeMoney.cy = self.amountToQueryCoupon.cy;
    long queryPromoCodeMoneyCent = self.amountToQueryCoupon.cent.integerValue - self.couponModel.discountAmount.cent.integerValue;
    queryPromoCodeMoney.cent = [NSString stringWithFormat:@"%zd", queryPromoCodeMoneyCent];
    return queryPromoCodeMoney;
}

#pragma mark - lazy load
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (SAShoppingAddressModel *)validAddressModel {
    SAShoppingAddressModel *addressModel;
    if (!HDIsObjectNil(self.currentAddressModel)) {
        addressModel = self.currentAddressModel;
    } else {
        if (!HDIsObjectNil(self.addressModelToCheck) && self.isLastChoosedAddressAvailable) {
            addressModel = self.addressModelToCheck;
        }
    }
    return addressModel;
}

- (SAMoneyModel *)activityMoneyExceptDeliveryFeeReduction {
    if (!_activityMoneyExceptDeliveryFeeReduction) {
        _activityMoneyExceptDeliveryFeeReduction = SAMoneyModel.new;
    }
    return _activityMoneyExceptDeliveryFeeReduction;
}

- (SAMoneyModel *)deliveryFeeReductionMoney {
    if (!_deliveryFeeReductionMoney) {
        _deliveryFeeReductionMoney = SAMoneyModel.new;
    }
    return _deliveryFeeReductionMoney;
}

- (WMStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = WMStoreDTO.new;
    }
    return _storeDTO;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (SAShoppingAddressDTO *)shoppingAddressDTO {
    if (!_shoppingAddressDTO) {
        _shoppingAddressDTO = SAShoppingAddressDTO.new;
    }
    return _shoppingAddressDTO;
}

- (WMCouponsDTO *)couponDTO {
    if (!_couponDTO) {
        _couponDTO = WMCouponsDTO.new;
    }
    return _couponDTO;
}

- (CMNetworkRequest *)aggregationRequest {
    if (!_aggregationRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/app/mobile-app-composition/app/yumnow-order-submit/v1/query";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        request.isNeedLogin = true;
        _aggregationRequest = request;
    }
    return _aggregationRequest;
}

- (CMNetworkRequest *)submitOrderRequest {
    if (!_submitOrderRequest) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.requestURI = @"/shop/order/save";
        request.shouldAlertErrorMsgExceptSpecCode = false;
        _submitOrderRequest = request;
    }
    return _submitOrderRequest;
}

- (SAUserViewModel *)userViewModel {
    if (!_userViewModel) {
        _userViewModel = SAUserViewModel.new;
    }
    return _userViewModel;
}

@end
