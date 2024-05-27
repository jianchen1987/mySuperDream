//
//  WMStoreShoppingCartDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreShoppingCartDTO.h"
#import "NSArray+SAExtension.h"
#import "SACacheManager.h"
#import "WMGetUserShoppingCartLocalRspModel.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMShoppingCartAddGoodsRspModel.h"
#import "WMShoppingCartEntryWindow.h"
#import "WMShoppingCartMinusGoodsRspModel.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartRemoveGoodsRspModel.h"
#import "WMShoppingCartRemoveStoreGoodsRspModel.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailAdaptor.h"


@interface WMStoreShoppingCartDTO ()

@end


@implementation WMStoreShoppingCartDTO

- (void)updateGoodsCountInShoppingCartWithClientType:(SABusinessType)businessType
                                               count:(NSUInteger)goodsCount
                                             goodsId:(NSString *)goodsId
                                          goodsSkuId:(NSString *)goodsSkuId
                                         propertyIds:(NSArray<NSString *> *)propertyIds
                                             storeNo:(NSString *)storeNo
                                   inEffectVersionId:(NSString *)inEffectVersionId
                                             success:(void (^)(WMShoppingCartUpdateGoodsRspModel *))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    if (HDIsStringEmpty(inEffectVersionId)) {
        SARspModel *rspModel = SARspModel.new;
        rspModel.msg = @"inEffectVersionId 为空";
        HDLog(@"inEffectVersionId 为空");
        !failureBlock ?: failureBlock(rspModel, CMResponseErrorTypeInvalidParams, nil);
        return;
    }

    if (!SAUser.hasSignedIn) {
        // 更新离线购物车商品数量
        @autoreleasepool {
            if (goodsCount == 0) {
                [self handlingRemoveGoodsFromShoppingCartWithClientType:businessType storeNo:storeNo goodsSkuId:goodsSkuId propertyValues:propertyIds
                                                                success:^(WMShoppingCartRemoveGoodsRspModel *_Nonnull rspModel) {
                                                                    !successBlock ?: successBlock(nil);
                                                                }];
            } else {
                NSUInteger currentPurchaseQuantity = [self currentPurchaseQuantityInLocalShoppingCartWithStoreNo:storeNo goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds];
                [self handlerAddingGoodsToShoppingCartWithClientType:businessType addDelta:goodsCount - currentPurchaseQuantity goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds
                                                             storeNo:storeNo
                                                   inEffectVersionId:inEffectVersionId success:^(WMShoppingCartAddGoodsRspModel *_Nonnull rspModel) {
                                                       !successBlock ?: successBlock(nil);
                                                   }];
            }
        }
        return;
    }
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
    params[@"queryMerchantCart"] = shopCartQuery;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/updateItem";
    request.shouldAlertErrorMsgExceptSpecCode = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartUpdateGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)addGoodsToShoppingCartWithClientType:(SABusinessType)businessType
                                    addDelta:(NSUInteger)addDelta
                                     goodsId:(NSString *)goodsId
                                  goodsSkuId:(NSString *)goodsSkuId
                                 propertyIds:(NSArray<NSString *> *)propertyIds
                                     storeNo:(NSString *)storeNo
                           inEffectVersionId:(NSString *)inEffectVersionId
                                     success:(void (^)(WMShoppingCartAddGoodsRspModel *_Nonnull))successBlock
                                     failure:(CMNetworkFailureBlock)failureBlock {
    if (HDIsStringEmpty(inEffectVersionId)) {
        SARspModel *rspModel = SARspModel.new;
        rspModel.msg = @"inEffectVersionId 为空";
        HDLog(@"inEffectVersionId 为空");
        !failureBlock ?: failureBlock(rspModel, CMResponseErrorTypeInvalidParams, nil);
        return;
    }

    if (!SAUser.hasSignedIn) {
        @autoreleasepool {
            [self handlerAddingGoodsToShoppingCartWithClientType:businessType addDelta:addDelta goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:storeNo
                                               inEffectVersionId:inEffectVersionId
                                                         success:successBlock];
        }
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"addDelta"] = @(addDelta);
    params[@"goodsId"] = goodsId;
    params[@"goodsSkuId"] = goodsSkuId;
    params[@"propertyIds"] = HDIsArrayEmpty(propertyIds) ? @[] : propertyIds;
    params[@"storeNo"] = storeNo;
    params[@"inEffectVersionId"] = inEffectVersionId;
    params[@"appVersion"] = [HDDeviceInfo appVersion];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/addShow";
    request.shouldAlertErrorMsgExceptSpecCode = false;

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
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          storeNo:(NSString *)storeNo
                                          success:(void (^)(WMShoppingCartMinusGoodsRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        @autoreleasepool {
            [self handlerMinusGoodsFromShopppingCartWithClientType:businessType deleteDelta:deleteDelta goodsSkuId:goodsSkuId propertyValues:propertyValues storeNo:storeNo success:successBlock];
        }
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"deleteDelta"] = @(deleteDelta);
    params[@"goodsSkuId"] = goodsSkuId;
    params[@"propertyValues"] = propertyValues;
    params[@"storeNo"] = storeNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteAmountShow";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartMinusGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)removeGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                          storeNo:(NSString *)storeNo
                                       goodsSkuId:(NSString *)goodsSkuId
                                   propertyValues:(NSArray<NSString *> *)propertyValues
                                          success:(void (^)(WMShoppingCartRemoveGoodsRspModel *_Nonnull))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        @autoreleasepool {
            [self handlingRemoveGoodsFromShoppingCartWithClientType:businessType storeNo:storeNo goodsSkuId:goodsSkuId propertyValues:propertyValues success:successBlock];
        }
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"goodsSkuId"] = goodsSkuId;
    params[@"propertyValues"] = propertyValues;
    params[@"storeNo"] = storeNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteItemShow";

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartRemoveGoodsRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)removeStoreGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                               storeNo:(NSString *)storeNo
                                               success:(void (^)(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull))successBlock
                                               failure:(CMNetworkFailureBlock)failureBlock {
    if (!SAUser.hasSignedIn) {
        @autoreleasepool {
            [self handlingRemoveStoreGoodsFromShoppingCartWithClientType:businessType storeNo:storeNo success:successBlock];
        }
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"storeNo"] = storeNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/deleteCartShow";

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
    [self.shoppingCartDTO orderPayFeeTrialCalculateWithItems:items success:successBlock failure:failureBlock];
}

- (void)orderCheckBeforeGoToOrderSubmitWithStoreNo:(NSString *)storeNo
                                             items:(NSArray<WMShoppingCartOrderCheckItem *> *)items
                                       activityNos:(NSArray<NSString *> *)activityNos
                                           success:(void (^)(SARspModel *rspModel))successBlock
                                           failure:(CMNetworkFailureBlock)failureBlock {
    [self.shoppingCartDTO orderCheckBeforeGoToOrderSubmitWithStoreNo:storeNo items:items activityNos:activityNos success:successBlock failure:failureBlock];
}

- (void)queryStoreShoppingCartWithClientType:(SABusinessType)businessType
                                     storeNo:(NSString *)storeNo
                                     success:(void (^)(WMShoppingCartStoreItem *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!SAUser.hasSignedIn) {
        [self.shoppingCartDTO getUserShoppingCartInfoWithClientType:businessType success:^(WMGetUserShoppingCartRspModel *_Nonnull rspModel) {
            WMShoppingCartStoreItem *shopppingCartItem = [WMStoreDetailAdaptor shoppingCardStoreItemWithStoreNo:storeNo inUserShoppingCartRspModel:rspModel];
            !successBlock ?: successBlock(shopppingCartItem);
        } failure:failureBlock];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = businessType;
    params[@"storeNo"] = storeNo;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/delivery/queryMerchantCartShow";
    request.isNeedLogin = true;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([WMShoppingCartStoreItem yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)minusGoodsFromLocalShopppingCartWithClientType:(SABusinessType)businessType
                                           deleteDelta:(NSUInteger)deleteDelta
                                            goodsSkuId:(NSString *)goodsSkuId
                                        propertyValues:(NSArray<NSString *> *)propertyValues
                                               storeNo:(NSString *)storeNo {
    [self handlerMinusGoodsFromShopppingCartWithClientType:businessType deleteDelta:deleteDelta goodsSkuId:goodsSkuId propertyValues:propertyValues storeNo:storeNo success:nil];
}

#pragma mark - private methods
- (NSUInteger)currentPurchaseQuantityInLocalShoppingCartWithStoreNo:(NSString *)storeNo goodsId:(NSString *)goodsId goodsSkuId:(NSString *)goodsSkuId propertyIds:(NSArray<NSString *> *)propertyIds {
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (HDIsObjectNil(localShoppingCartRspModel)) {
        return 0;
    }
    NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
    if (HDIsArrayEmpty(list)) {
        return 0;
    }
    WMShoppingCartStoreQueryItem *destStoreItem;
    for (WMShoppingCartStoreQueryItem *storeItem in list) {
        if ([storeItem.storeNo isEqualToString:storeNo]) {
            destStoreItem = storeItem;
            break;
        }
    }
    if (HDIsObjectNil(destStoreItem)) {
        return 0;
    }
    // 门店存在
    WMShoppingCartStoreQueryProduct *destProduct;
    for (WMShoppingCartStoreQueryProduct *product in destStoreItem.shopCartItemBOS) {
        NSArray<NSString *> *properties = [product.propertyValues componentsSeparatedByString:@","];
        if (!HDIsArrayEmpty(propertyIds)) {
            if ([product.goodsSkuId isEqualToString:goodsSkuId] && [properties isSetFormatEqualTo:propertyIds]) {
                destProduct = product;
                break;
            }
        } else {
            if ([product.goodsSkuId isEqualToString:goodsSkuId]) {
                destProduct = product;
                break;
            }
        }
    }
    if (HDIsObjectNil(destProduct)) {
        return 0;
    }

    return destProduct.purchaseQuantity;
}

- (void)handlerAddingGoodsToShoppingCartWithClientType:(SABusinessType)businessType
                                              addDelta:(NSUInteger)addDelta
                                               goodsId:(NSString *)goodsId
                                            goodsSkuId:(NSString *)goodsSkuId
                                           propertyIds:(NSArray<NSString *> *)propertyIds
                                               storeNo:(NSString *)storeNo
                                     inEffectVersionId:(NSString *)inEffectVersionId
                                               success:(void (^)(WMShoppingCartAddGoodsRspModel *_Nonnull))successBlock {
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (HDIsObjectNil(localShoppingCartRspModel)) {
        localShoppingCartRspModel = WMGetUserShoppingCartLocalRspModel.new;
        localShoppingCartRspModel.gmtCreate = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000];
    }

    // 属性 id 从小到大排序
    NSArray<NSString *> *sortedPropertyIds = [propertyIds sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
        return obj1.integerValue > obj2.integerValue;
    }];

    // 添加新店到购物车
    WMShoppingCartStoreQueryItem * (^handlerNewStoreItemAddingToShopppingCart)(void) = ^WMShoppingCartStoreQueryItem *(void) {
        WMShoppingCartStoreQueryItem *item = WMShoppingCartStoreQueryItem.new;
        item.storeNo = storeNo;
        item.updateTime = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000];

        WMShoppingCartStoreQueryProduct *product = WMShoppingCartStoreQueryProduct.new;
        product.updateTime = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000];
        product.purchaseQuantity = addDelta;
        product.goodsId = goodsId;
        product.goodsSkuId = goodsSkuId;
        product.propertyValues = [sortedPropertyIds componentsJoinedByString:@","];
        product.businessType = businessType;
        product.inEffectVersionId = inEffectVersionId;
        item.shopCartItemBOS = @[product];
        product.storeNo = storeNo;
        return item;
    };
    // 添加新商品到门店
    WMShoppingCartStoreQueryProduct * (^handlerNewProductAddingToStoreShopppingCart)(void) = ^WMShoppingCartStoreQueryProduct * {
        WMShoppingCartStoreQueryProduct *product = WMShoppingCartStoreQueryProduct.new;
        product.updateTime = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000];
        product.purchaseQuantity = addDelta;
        product.goodsId = goodsId;
        product.goodsSkuId = goodsSkuId;
        product.propertyValues = [sortedPropertyIds componentsJoinedByString:@","];
        product.inEffectVersionId = inEffectVersionId;
        product.businessType = businessType;
        product.storeNo = storeNo;
        return product;
    };

    NSUInteger purchaseQuantity = 0;
    NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
    if (HDIsArrayEmpty(list)) {
        // 购物车为空，增加门店
        WMShoppingCartStoreQueryItem *storeItem = handlerNewStoreItemAddingToShopppingCart();
        localShoppingCartRspModel.list = @[storeItem];
        purchaseQuantity = addDelta;
    } else {
        WMShoppingCartStoreQueryItem *destStoreItem;
        for (WMShoppingCartStoreQueryItem *storeItem in list) {
            if ([storeItem.storeNo isEqualToString:storeNo]) {
                destStoreItem = storeItem;
                break;
            }
        }
        if (!HDIsObjectNil(destStoreItem)) {
            // 门店存在
            WMShoppingCartStoreQueryProduct *destProduct;
            for (WMShoppingCartStoreQueryProduct *product in destStoreItem.shopCartItemBOS) {
                NSArray<NSString *> *properties = [product.propertyValues componentsSeparatedByString:@","];
                if (!HDIsArrayEmpty(propertyIds)) {
                    if ([product.goodsSkuId isEqualToString:goodsSkuId] && [properties isSetFormatEqualTo:propertyIds]) {
                        destProduct = product;
                        break;
                    }
                } else {
                    if ([product.goodsSkuId isEqualToString:goodsSkuId]) {
                        destProduct = product;
                        break;
                    }
                }
            }
            if (!HDIsObjectNil(destProduct)) {
                // 门店存在，商品存在，增加数量
                destProduct.purchaseQuantity = (destProduct.purchaseQuantity + addDelta);
                purchaseQuantity = destProduct.purchaseQuantity;
            } else {
                // 门店存在，商品不存在，增加商品
                WMShoppingCartStoreQueryProduct *product = handlerNewProductAddingToStoreShopppingCart();
                NSMutableArray *oldList = destStoreItem.shopCartItemBOS.mutableCopy;
                [oldList addObject:product];
                destStoreItem.shopCartItemBOS = oldList;
                purchaseQuantity = addDelta;
            }
        } else {
            // 门店不存在，增加门店
            WMShoppingCartStoreQueryItem *storeItem = handlerNewStoreItemAddingToShopppingCart();
            NSMutableArray *oldList = localShoppingCartRspModel.list.mutableCopy;
            [oldList addObject:storeItem];
            localShoppingCartRspModel.list = oldList;
            purchaseQuantity = addDelta;
        }
    }
    // 存库
    [self saveLocalShoppingCartRspModel:localShoppingCartRspModel];

    WMShoppingCartAddGoodsRspModel *rspModel = WMShoppingCartAddGoodsRspModel.new;
    rspModel.purchaseQuantity = purchaseQuantity;
    !successBlock ?: successBlock(rspModel);
}

- (void)handlerMinusGoodsFromShopppingCartWithClientType:(SABusinessType)businessType
                                             deleteDelta:(NSUInteger)deleteDelta
                                              goodsSkuId:(NSString *)goodsSkuId
                                          propertyValues:(NSArray<NSString *> *)propertyValues
                                                 storeNo:(NSString *)storeNo
                                                 success:(void (^)(WMShoppingCartMinusGoodsRspModel *_Nonnull))successBlock {
    WMShoppingCartMinusGoodsRspModel *rspModel = WMShoppingCartMinusGoodsRspModel.new;
    rspModel.goodsSkuId = goodsSkuId;

    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (!HDIsObjectNil(localShoppingCartRspModel)) {
        NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
        if (!HDIsArrayEmpty(list)) {
            WMShoppingCartStoreQueryItem *destStoreItem;
            for (WMShoppingCartStoreQueryItem *storeItem in list) {
                if ([storeItem.storeNo isEqualToString:storeNo]) {
                    destStoreItem = storeItem;
                    break;
                }
            }
            if (!HDIsObjectNil(destStoreItem)) {
                // 门店存在
                WMShoppingCartStoreQueryProduct *destProduct;
                for (WMShoppingCartStoreQueryProduct *product in destStoreItem.shopCartItemBOS) {
                    NSArray<NSString *> *properties = [product.propertyValues componentsSeparatedByString:@","];

                    if (!HDIsArrayEmpty(propertyValues)) {
                        if ([product.goodsSkuId isEqualToString:goodsSkuId] && [properties isSetFormatEqualTo:propertyValues]) {
                            destProduct = product;
                            break;
                        }
                    } else {
                        if ([product.goodsSkuId isEqualToString:goodsSkuId]) {
                            destProduct = product;
                            break;
                        }
                    }
                }
                if (!HDIsObjectNil(destProduct)) {
                    // 门店存在，商品存在，减少数量
                    if (destProduct.purchaseQuantity > deleteDelta) {
                        destProduct.purchaseQuantity = (destProduct.purchaseQuantity - deleteDelta);
                        rspModel.goodsSkuId = goodsSkuId;
                    } else {
                        // 移除商品
                        NSMutableArray *oldList = destStoreItem.shopCartItemBOS.mutableCopy;
                        [oldList removeObject:destProduct];
                        destStoreItem.shopCartItemBOS = oldList;
                    }
                }
            }
        }
        // 存库
        [self saveLocalShoppingCartRspModel:localShoppingCartRspModel];
    }
    !successBlock ?: successBlock(rspModel);
}

- (void)handlingRemoveGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                                  storeNo:(NSString *)storeNo
                                               goodsSkuId:(NSString *)goodsSkuId
                                           propertyValues:(NSArray<NSString *> *)propertyValues
                                                  success:(void (^)(WMShoppingCartRemoveGoodsRspModel *_Nonnull))successBlock {
    WMShoppingCartRemoveGoodsRspModel *rspModel = WMShoppingCartRemoveGoodsRspModel.new;
    rspModel.goodsSkuId = goodsSkuId;
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (!HDIsObjectNil(localShoppingCartRspModel)) {
        NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
        if (!HDIsArrayEmpty(list)) {
            WMShoppingCartStoreQueryItem *destStoreItem;
            for (WMShoppingCartStoreQueryItem *storeItem in list) {
                if ([storeItem.storeNo isEqualToString:storeNo]) {
                    destStoreItem = storeItem;
                    break;
                }
            }
            if (!HDIsObjectNil(destStoreItem)) {
                // 门店存在
                WMShoppingCartStoreQueryProduct *destProduct;
                for (WMShoppingCartStoreQueryProduct *product in destStoreItem.shopCartItemBOS) {
                    NSArray<NSString *> *properties = [product.propertyValues componentsSeparatedByString:@","];
                    if (!HDIsArrayEmpty(propertyValues)) {
                        if ([product.goodsSkuId isEqualToString:goodsSkuId] && [properties isSetFormatEqualTo:propertyValues]) {
                            destProduct = product;
                            break;
                        }
                    } else {
                        if ([product.goodsSkuId isEqualToString:goodsSkuId]) {
                            destProduct = product;
                            break;
                        }
                    }
                }
                if (!HDIsObjectNil(destProduct)) {
                    // 移除商品
                    NSMutableArray *oldList = destStoreItem.shopCartItemBOS.mutableCopy;
                    [oldList removeObject:destProduct];
                    destStoreItem.shopCartItemBOS = oldList;

                    // 如果门店空了，删除门店
                    if (HDIsArrayEmpty(destStoreItem.shopCartItemBOS)) {
                        // 移除门店
                        NSMutableArray *storeItemList = localShoppingCartRspModel.list.mutableCopy;
                        [storeItemList removeObject:destStoreItem];
                        localShoppingCartRspModel.list = storeItemList;
                    }
                }
            }
        }

        // 存库
        [self saveLocalShoppingCartRspModel:localShoppingCartRspModel];
    }
    !successBlock ?: successBlock(rspModel);
}

- (void)handlingRemoveStoreGoodsFromShoppingCartWithClientType:(SABusinessType)businessType
                                                       storeNo:(NSString *)storeNo
                                                       success:(void (^)(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull))successBlock {
    WMShoppingCartRemoveStoreGoodsRspModel *rspModel = WMShoppingCartRemoveStoreGoodsRspModel.new;
    rspModel.isSuccess = true;
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = self.getLocalShoppingCartRspModel;
    if (!HDIsObjectNil(localShoppingCartRspModel)) {
        NSArray<WMShoppingCartStoreQueryItem *> *list = localShoppingCartRspModel.list;
        if (!HDIsArrayEmpty(list)) {
            WMShoppingCartStoreQueryItem *destStoreItem;
            for (WMShoppingCartStoreQueryItem *storeItem in list) {
                if ([storeItem.storeNo isEqualToString:storeNo]) {
                    destStoreItem = storeItem;
                    break;
                }
            }
            if (!HDIsObjectNil(destStoreItem)) {
                // 移除门店
                NSMutableArray *storeItemList = localShoppingCartRspModel.list.mutableCopy;
                [storeItemList removeObject:destStoreItem];
                localShoppingCartRspModel.list = storeItemList;
            }
        }

        if (!HDIsArrayEmpty(localShoppingCartRspModel.list)) {
            // 存库
            [self saveLocalShoppingCartRspModel:localShoppingCartRspModel];
        } else {
            // 删除记录
            [SACacheManager.shared removeObjectForKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
        }
    }
    !successBlock ?: successBlock(rspModel);
}

#pragma mark - 存取
- (WMGetUserShoppingCartLocalRspModel *)getLocalShoppingCartRspModel {
    WMGetUserShoppingCartLocalRspModel *localShoppingCartRspModel = [SACacheManager.shared objectForKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
    return localShoppingCartRspModel;
}

- (void)saveLocalShoppingCartRspModel:(WMGetUserShoppingCartLocalRspModel *)localShoppingCartRspModel {
    [SACacheManager.shared setObject:localShoppingCartRspModel forKey:kCacheKeyLocalShoppingCart type:SACacheTypeDocumentPublic];
}

#pragma mark - lazy load
- (WMShoppingCartDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = WMShoppingCartDTO.new;
    }
    return _shoppingCartDTO;
}
@end
