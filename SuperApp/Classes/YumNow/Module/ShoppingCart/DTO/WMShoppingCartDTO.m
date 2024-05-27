
//
//  WMShoppingCartDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartDTO.h"
#import "NSArray+SAExtension.h"
#import "SACacheManager.h"
#import "WMGetUserShoppingCartLocalRspModel.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMShoppingCartAddGoodsRspModel.h"
#import "WMShoppingCartBatchDeleteItem.h"
#import "WMShoppingCartEntryWindow.h"
#import "WMShoppingCartMinusGoodsRspModel.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartRemoveGoodsRspModel.h"
#import "WMShoppingCartRemoveStoreGoodsRspModel.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreShoppingCartDTO.h"
#import <HDKitCore/HDKitCore.h>


@interface WMShoppingCartDTO ()
/// 门店购物车 DTo
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;

@end


@implementation WMShoppingCartDTO

- (void)getUserShoppingCartInfoWithClientType:(SABusinessType)businessType
                                      success:(void (^_Nullable)(WMGetUserShoppingCartRspModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;

    if (SAUser.hasSignedIn) {
        request.requestURI = @"/shop/cart/delivery/query";
        request.isNeedLogin = true;
        params[@"businessType"] = businessType;
    } else {
        WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
        // 本地购物车无数据
        if (HDIsObjectNil(localShoppingCartRspModel)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WMGetUserShoppingCartRspModel *model = WMGetUserShoppingCartRspModel.new;
                [WMShoppingCartEntryWindow.sharedInstance updateIndicatorDotWithCount:model.list.count];
                !successBlock ?: successBlock(model);
            });
            return;
        }
        request.isNeedLogin = false;
        request.requestURI = @"/shop/cart/delivery/queryWithoutLogin";
        params[@"merchantCartBOS"] = localShoppingCartRspModel.list.yy_modelToJSONObject;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMGetUserShoppingCartRspModel *model = [WMGetUserShoppingCartRspModel yy_modelWithJSON:rspModel.data];
        [WMShoppingCartEntryWindow.sharedInstance updateIndicatorDotWithCount:model.list.count];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)updateGoodsCountInShoppingCartWithClientType:(SABusinessType)businessType
                                               count:(NSUInteger)goodsCount
                                             goodsId:(NSString *)goodsId
                                          goodsSkuId:(NSString *)goodsSkuId
                                         propertyIds:(NSArray<NSString *> *)propertyIds
                                             storeNo:(NSString *)storeNo
                                   inEffectVersionId:(NSString *)inEffectVersionId
                                             success:(void (^)(WMShoppingCartUpdateGoodsRspModel *_Nonnull))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    if (HDIsStringEmpty(inEffectVersionId)) {
        SARspModel *rspModel = SARspModel.new;
        rspModel.msg = @"inEffectVersionId 为空";
        HDLog(@"inEffectVersionId 为空");
        !failureBlock ?: failureBlock(rspModel, CMResponseErrorTypeInvalidParams, nil);
        return;
    }

    if (!SAUser.hasSignedIn) {
        [self.storeShoppingCartDTO updateGoodsCountInShoppingCartWithClientType:businessType count:goodsCount goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:storeNo
                                                              inEffectVersionId:inEffectVersionId
                                                                        success:successBlock
                                                                        failure:failureBlock];
        return;
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"itemCount"] = @(goodsCount);
    params[@"goodsId"] = goodsId;
    params[@"goodsSkuId"] = goodsSkuId;
    params[@"propertyIds"] = HDIsArrayEmpty(propertyIds) ? @[] : propertyIds;
    params[@"storeNo"] = storeNo;
    params[@"inEffectVersionId"] = inEffectVersionId;

    NSMutableDictionary *shopCartQuery = [NSMutableDictionary dictionary];
    shopCartQuery[@"businessType"] = businessType;
    params[@"queryShopCar"] = shopCartQuery;

    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/updateItem";
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartUpdateGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addGoodsToShoppingCartWithClientType:(SABusinessType)businessType
                                    addDelta:(NSUInteger)addDelta
                               userDisplayNo:(NSString *)userDisplayNo
                           merchantDisplayNo:(NSString *)merchantDisplayNo
                               itemDisplayNo:(NSString *)itemDisplayNo
                                     goodsId:(NSString *_Nullable)goodsId
                                  goodsSkuId:(NSString *_Nullable)goodsSkuId
                                 propertyIds:(NSArray<NSString *> *_Nullable)propertyIds
                                     storeNo:(NSString *_Nullable)storeNo
                           inEffectVersionId:(NSString *)inEffectVersionId
                                     success:(void (^)(WMShoppingCartAddGoodsRspModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        [self.storeShoppingCartDTO addGoodsToShoppingCartWithClientType:SABusinessTypeYumNow addDelta:addDelta goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:storeNo
                                                      inEffectVersionId:inEffectVersionId
                                                                success:successBlock
                                                                failure:failureBlock];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"addDelta"] = @(addDelta);
    params[@"userDisplayNo"] = userDisplayNo;
    params[@"merchantDisplayNo"] = merchantDisplayNo;
    params[@"itemDisplayNo"] = itemDisplayNo;
    params[@"storeNo"] = storeNo;
    params[@"goodsId"] = goodsId;
    params[@"goodsSkuId"] = goodsSkuId;
    params[@"propertyIds"] = HDIsArrayEmpty(propertyIds) ? @[] : propertyIds;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/add";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartAddGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)minusGoodsFromShopppingCartWithClientType:(SABusinessType)businessType
                                      deleteDelta:(NSUInteger)deleteDelta
                                    itemDisplayNo:(NSString *)itemDisplayNo
                                       goodsSkuId:(NSString *_Nullable)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *_Nullable)propertyValues
                                          storeNo:(NSString *_Nullable)storeNo
                                          success:(void (^)(WMShoppingCartMinusGoodsRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        [self.storeShoppingCartDTO minusGoodsFromShopppingCartWithClientType:businessType deleteDelta:deleteDelta goodsSkuId:goodsSkuId propertyValues:propertyValues storeNo:storeNo
                                                                     success:successBlock
                                                                     failure:failureBlock];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"deleteDelta"] = @(deleteDelta);
    params[@"itemDisplayNo"] = itemDisplayNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteAmount";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartMinusGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)removeGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                merchantDisplayNo:(NSString *)merchantDisplayNo
                                    itemDisplayNo:(NSString *)itemDisplayNo
                                          storeNo:(NSString *)storeNo
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          success:(void (^)(WMShoppingCartRemoveGoodsRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        [self.storeShoppingCartDTO removeGoodsFromShoppingCartWithClientType:businessType storeNo:storeNo goodsSkuId:goodsSkuId propertyValues:propertyValues success:successBlock
                                                                     failure:failureBlock];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"merchantDisplayNo"] = merchantDisplayNo;
    params[@"itemDisplayNo"] = itemDisplayNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteItem";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartRemoveGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)removeStoreGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                     merchantDisplayNo:(NSString *)merchantDisplayNo
                                               storeNo:(NSString *)storeNo
                                               success:(void (^)(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull))successBlock
                                               failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        [self.storeShoppingCartDTO removeStoreGoodsFromShoppingCartWithClientType:businessType storeNo:storeNo success:successBlock failure:failureBlock];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"merchantDisplayNo"] = merchantDisplayNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteCart";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartRemoveStoreGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)orderPayFeeTrialCalculateWithItems:(NSArray<WMShoppingCartPayFeeCalItem *> *)items
                                   success:(void (^)(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull))successBlock
                                   failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-order/app/user/trial";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = [items yy_modelToJSONObject];
    params[@"operatorNo"] = [SAUser.shared operatorNo];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        WMShoppingItemsPayFeeTrialCalRspModel *model = [WMShoppingItemsPayFeeTrialCalRspModel yy_modelWithJSON:rspModel.data];
        if ([model isKindOfClass:WMShoppingItemsPayFeeTrialCalRspModel.class]) {
            ///商品限制活动弹窗
            WMShoppingCartPayFeeCalProductModel *selectProduct = nil;
            NSArray<WMShoppingCartPayFeeCalItem *> *filterOrderArr = [items hd_filterWithBlock:^BOOL(WMShoppingCartPayFeeCalItem *_Nonnull item) {
                return item.select;
            }];
            if (!HDIsArrayEmpty(filterOrderArr)) {
                NSArray *arr = [model.products hd_filterWithBlock:^BOOL(WMShoppingCartPayFeeCalProductModel *_Nonnull item) {
                    return [item.productId isEqualToString:filterOrderArr.firstObject.productId]
                           && (item.productPromotion.type == WMStoreGoodsPromotionLimitTypeActivityTotalNum || item.productPromotion.type == WMStoreGoodsPromotionLimitTypeDayProNum);
                }];
                if (!HDIsArrayEmpty(arr)) {
                    selectProduct = arr.firstObject;
                }
            }
            if (selectProduct) {
                NSString *content = nil;
                if (selectProduct.productPromotion.type == WMStoreGoodsPromotionLimitTypeActivityTotalNum) {
                    __block NSInteger total = 0;
                    __block double beforePrice = 0;
                    __block double afterPrice = 0;
                    [model.products enumerateObjectsUsingBlock:^(WMShoppingCartPayFeeCalProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if (obj.productPromotion.type == WMStoreGoodsPromotionLimitTypeActivityTotalNum &&
                            [obj.productPromotion.activityNo isEqualToString:selectProduct.productPromotion.activityNo]) {
                            beforePrice += (obj.count * (obj.salePrice.cent.doubleValue - obj.discountPrice.cent.doubleValue));
                            afterPrice += obj.freeProductPromotionAmount.cent.doubleValue;
                            total += obj.count;
                        }
                    }];
                    if (afterPrice < beforePrice && total <= (selectProduct.productPromotion.limitValue + 1)) {
                        content =
                            [NSString stringWithFormat:WMLocalizedString(@"wm_only_item_can_enjoy_discount_price_in_periody", @"活动期内共限%zd份商品优惠"), selectProduct.productPromotion.limitValue];
                    }
                } else if (selectProduct.productPromotion.type == WMStoreGoodsPromotionLimitTypeDayProNum) {
                    if (selectProduct.freeProductPromotionAmount.cent.doubleValue < (selectProduct.count * (selectProduct.salePrice.cent.doubleValue - selectProduct.discountPrice.cent.doubleValue))
                        && selectProduct.count <= (selectProduct.productPromotion.limitValue + 1)) {
                        content =
                            [NSString stringWithFormat:WMLocalizedString(@"wm_only_item_can_enjoy_discount_price_per_day", @"该商品每日限%zd件享受优惠价"), selectProduct.productPromotion.limitValue];
                    }
                }

                if (content) {
                    [NAT showToastWithTitle:nil content:content type:HDTopToastTypeInfo];
                }
            }
            !successBlock ?: successBlock(model);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
/// 进入订单提交页前检查(下单检查)
/// @param storeNo 门店号
/// @param items 需要检查
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderCheckBeforeGoToOrderSubmitWithStoreNo:(NSString *)storeNo
                                             items:(NSArray<WMShoppingCartOrderCheckItem *> *)items
                                       activityNos:(NSArray<NSString *> *)activityNos
                                           success:(void (^)(SARspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"products"] = [items yy_modelToJSONObject];
    params[@"storeNo"] = storeNo;
    params[@"activityNos"] = activityNos;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/takeaway-order/app/user/order-check";
    request.shouldAlertErrorMsgExceptSpecCode = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
/// 批量删除购物项接口
/// @param deleteItems 删除商品的购物号数组
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)batchDeleteGoodsFromShoppingCartWithDeleteItems:(NSArray<WMShoppingCartBatchDeleteItem *> *)deleteItems success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        @autoreleasepool {
            NSArray<NSString *> *deleteInEffectVersionIds = [deleteItems mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartBatchDeleteItem *_Nonnull obj, NSUInteger idx) {
                return obj.inEffectVersionId;
            }];
            [self handlingRemoveGoodsFromShoppingCartWithClientType:SABusinessTypeYumNow deleteInEffectVersionIds:deleteInEffectVersionIds];
            !successBlock ?: successBlock();
        }
        return;
        ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *deleteItemsParams = [[NSMutableArray alloc] init];
    for (WMShoppingCartBatchDeleteItem *item in deleteItems) {
        [deleteItemsParams addObject:[item yy_modelToJSONObject]];
    }
    params[@"deleteItems"] = deleteItemsParams;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/batch/deleteAmount";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getActivityCouponShoppingCartWithStoreNos:(NSArray<NSString *> *)storeNos
                                          success:(void (^)(NSArray<WMCouponActivityContentModel *> *))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNos"] = storeNos;
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/takeaway-merchant/app/super-app/get-activity-coupon";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *marr = [NSArray yy_modelArrayWithClass:WMCouponActivityContentModel.class json:rspModel.data];
        if ([marr isKindOfClass:NSArray.class]) {
            !successBlock ?: successBlock(marr);
        } else {
            !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)checkProductStatusWithStoreNo:(NSString *)storeNo
                           productIds:(NSArray<NSString *> *)productIds
                              success:(void (^)(NSDictionary *))successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"storeNo"] = storeNo;
    params[@"productIds"] = productIds;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestURI = @"/takeaway-product/app/user/check-product-status";
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray *arr = ((NSDictionary *)rspModel.data)[@"resultList"];
        NSMutableDictionary *mdic = NSMutableDictionary.new;
        for (NSDictionary *dic in arr) {
            if (dic[@"productStatusResult"] && dic[@"productId"]) {
                NSString *productId = [NSString stringWithFormat:@"%@", dic[@"productId"]];
                NSString *productStatusResult = [NSString stringWithFormat:@"%@", dic[@"productStatusResult"]];
                if (![productStatusResult isEqualToString:@"1"]) {
                    mdic[productId] = productStatusResult;
                }
            }
        }
        !successBlock ?: successBlock([NSDictionary dictionaryWithDictionary:mdic]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

#pragma mark - 私有方法
// 批量删除离线购物车数据
- (void)handlingRemoveGoodsFromShoppingCartWithClientType:(SABusinessType)businessType deleteInEffectVersionIds:(NSArray<NSString *> *)deleteInEffectVersionIds {
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (!HDIsObjectNil(localShoppingCartRspModel)) {
        NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
        if (!HDIsArrayEmpty(list)) {
            NSMutableArray *storeItemList = localShoppingCartRspModel.list.mutableCopy;
            for (WMShoppingCartStoreQueryItem *storeItem in list) {
                NSMutableArray *oldList = storeItem.shopCartItemBOS.mutableCopy;
                for (WMShoppingCartStoreQueryProduct *product in storeItem.shopCartItemBOS) {
                    if ([deleteInEffectVersionIds containsObject:product.inEffectVersionId]) {
                        [oldList removeObject:product];
                    }
                }
                storeItem.shopCartItemBOS = oldList;
                // 如果门店空了，删除门店
                if (HDIsArrayEmpty(storeItem.shopCartItemBOS)) {
                    // 移除门店
                    [storeItemList removeObject:storeItem];
                }
            }

            localShoppingCartRspModel.list = storeItemList;
        }

        // 存库
        [self saveLocalShoppingCartRspModel:localShoppingCartRspModel];
    }
}

#pragma mark - 存取
/// 获取本地缓存的购物车信息
- (WMGetUserShoppingCartLocalRspModel *)getLocalShoppingCartRspModel {
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = [SACacheManager.shared objectForKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
    return localShoppingCartRspModel;
}

- (void)saveLocalShoppingCartRspModel:(WMGetUserShoppingCartLocalRspModel *)localShoppingCartRspModel {
    [SACacheManager.shared setObject:localShoppingCartRspModel forKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
}

#pragma mark - lazy load

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}
@end
