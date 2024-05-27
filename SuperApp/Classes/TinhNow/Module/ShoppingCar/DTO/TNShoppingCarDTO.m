//
//  TNShoppingCarDTO.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCarDTO.h"
#import "SAWindowManager.h"
#import "TNAddItemToShoppingCarRspModel.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNItemModel.h"
#import "TNQueryUserShoppingCarRspModel.h"
#import "TNShoppingCarCountModel.h"
#import "TNShoppingCarItemModel.h"
#import "TalkingData.h"
#import <HDKitCore/HDKitCore.h>
#import <HDWebViewHostViewController.h>


@implementation TNShoppingCarDTO
- (void)queryUserShoppingTotalCountSuccess:(void (^)(TNShoppingCarCountModel *model))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/cart/countItems";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = [SAUser shared].operatorNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNShoppingCarCountModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
/// 查询用户购物车
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryUserShoppingCarBySalesType:(TNSalesType)salesType success:(void (^_Nullable)(TNQueryUserShoppingCarRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/cart/ecommerce/query";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = @"11";
    params[@"buyType"] = salesType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNQueryUserShoppingCarRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 添加商品到购物车，返回购物车商品对象
/// @param item 商品对象
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addItem:(TNItemModel *)item toShoppingCarSuccess:(void (^_Nullable)(TNAddItemToShoppingCarRspModel *item))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/addShowV2";
    //    @"/shop/cart/ecommerce/addShow";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"addDelta"] = item.quantity;
    params[@"storeNo"] = item.storeNo;
    params[@"goodsId"] = item.goodsId;
    //    params[@"goodsSkuId"] = item.goodsSkuId;
    if (HDIsStringNotEmpty(item.shareCode)) {
        params[@"shareCode"] = item.shareCode;
    }
    if (!HDIsArrayEmpty(item.skuList)) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TNItemSkuModel *model in item.skuList) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"goodsSkuId"] = model.goodsSkuId;
            dict[@"addDelta"] = model.addDelta;
            [temp addObject:dict];
        }
        params[@"skuList"] = temp;
    }
    if (HDIsStringNotEmpty(item.sp)) {
        params[@"sp"] = item.sp;
    }
    params[@"businessType"] = @"11";
    params[@"buyType"] = item.salesType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        //加购成功后  通知H5 刷新  如果H5 页面在的话  只刷新最前面一个web
        UIViewController *currentVC = SAWindowManager.visibleViewController;
        if (![currentVC isKindOfClass:[HDWebViewHostViewController class]]) {
            NSArray *vcs = currentVC.navigationController.viewControllers;
            for (UIViewController *vc in [[vcs reverseObjectEnumerator] allObjects]) {
                if ([vc isKindOfClass:[HDWebViewHostViewController class]]) {
                    HDWebViewHostViewController *webVC = (HDWebViewHostViewController *)vc;
                    [webVC executeJavaScriptString:@"WOWNOW_BRIDGE.addGoodsToShoppingCar()"];
                    break;
                }
            }
        }
        //加入购物车 埋点
        int price = 0;
        int count = 0;
        for (TNItemSkuModel *skuModel in item.skuList) {
            price += [skuModel.salePrice.cent intValue];
            count += [skuModel.addDelta intValue];
        }
        [TalkingData onAddItemToShoppingCart:item.goodsId category:@"" name:item.goodName unitPrice:price amount:count];

        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNAddItemToShoppingCarRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 删除购物车商品
/// @param item 购物车商品对象
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)deleteItem:(TNShoppingCarItemModel *)item fromShoppingCarSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/deleteItem";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = @"11";
    params[@"itemDisplayNo"] = item.itemDisplayNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 批量删除规格
/// @param items 规格数组
/// @param successBlock 成功回调
/// @param failureBlock 成功回调
- (void)batchDeleteStoreItems:(NSArray<TNShoppingCarItemModel *> *)items
            merchantDisplayNo:(NSString *)merchantDisplayNo
       fromShoppingCarSuccess:(void (^)(void))successBlock
                      failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/batchDeleteItem";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"itemDisplayNo"] = obj.itemDisplayNo;
        dict[@"businessType"] = @"11";
        dict[@"merchantDisplayNo"] = merchantDisplayNo;
        [array addObject:dict];
    }];
    params[@"batchDeleteItemList"] = array;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 增加购物车商品数量
/// @param item 购物车商品对象
/// @param quantify 数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)increaseQuantifyOfItem:(TNShoppingCarItemModel *)item
                      quantify:(NSNumber *)quantify
                     salesType:(TNSalesType)salesType
          inShoppingCarSuccess:(void (^_Nullable)(void))successBlock
                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/add";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = @"11";
    params[@"itemDisplayNo"] = item.itemDisplayNo;
    params[@"addDelta"] = quantify;
    if (HDIsStringNotEmpty(item.shareCode)) {
        params[@"shareCode"] = item.shareCode;
    }
    params[@"buyType"] = salesType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 减少购物车商品数量
/// @param item 购物车商品对象
/// @param quantify 数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)decreaseQuantifyOfItem:(TNShoppingCarItemModel *)item
                      quantify:(NSNumber *)quantify
                     salesType:(TNSalesType)salesType
          inShoppingCarSuccess:(void (^_Nullable)(void))successBlock
                       failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/deleteAmount";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = @"11";
    params[@"itemDisplayNo"] = item.itemDisplayNo;
    params[@"deleteDelta"] = quantify;
    params[@"buyType"] = salesType;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)calcShoppingCarTotalPriceWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSArray<TNCalcPaymentFeeGoodsModel *> *cartItems = [items mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        TNCalcPaymentFeeGoodsModel *model = TNCalcPaymentFeeGoodsModel.new;
        model.shareCode = obj.shareCode;
        model.quantity = obj.quantity;
        model.skuId = obj.goodsSkuId;
        model.goodsId = obj.goodsId;
        return model;
    }];

    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/order/calculate";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cartItemDTOS"] = [cartItems yy_modelToJSONObject];

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([TNCalcTotalPayFeeTrialRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 清空购物车
/// @param storeDisplayNo 门店展示号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)clearShoppingCarWithStoreDisplayNo:(NSString *)storeDisplayNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/deleteCart";

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessType"] = @"11";
    if (HDIsStringNotEmpty(storeDisplayNo)) {
        params[@"merchantDisplayNo"] = storeDisplayNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
- (void)batchDeleteShopCartItems:(NSArray<NSDictionary *> *)items fromShoppingCarSuccess:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/shop/cart/ecommerce/batchDeleteItem";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!HDIsArrayEmpty(items)) {
        params[@"batchDeleteItemList"] = items;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}
@end
