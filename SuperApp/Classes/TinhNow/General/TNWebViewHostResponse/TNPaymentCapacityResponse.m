//
//  TNPaymentHostResponse.m
//  SuperApp
//
//  Created by seeu on 2020/7/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentCapacityResponse.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "TNAddItemToShoppingCarRspModel.h"
#import "TNItemModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "UIView+NAT.h"


@implementation TNPaymentCapacityResponse
+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{
        //        @"orderAndPay_$": kHDWHResponseMethodOn,
        @"addGoodsToShoppingCar_$": kHDWHResponseMethodOn,
        //        @"deleteGoodsFromShoppingCar_$": kHDWHResponseMethodOn
    };
}

//- (void)orderAndPay:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
//
//    if (![SAUser hasSignedIn]) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"orderAndPay" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
//        [SAWindowManager switchWindowToLoginViewController];
//        return;
//    }
//
//    NSString *goodsId = [paramDict objectForKey:@"goodsId"];
//    NSString *storeNo = [paramDict objectForKey:@"storeNo"];
//    NSString *goodsSkuId = [paramDict objectForKey:@"goodsSkuId"];
//    NSString *goodsQuantity = [paramDict objectForKey:@"quantity"];
//
//    if (HDIsStringEmpty(goodsId) || HDIsStringEmpty(storeNo) || HDIsStringEmpty(goodsSkuId) || HDIsStringEmpty(goodsQuantity)) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"orderAndPay" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
//        return;
//    }
//    TNItemModel *item = TNItemModel.new;
//    item.goodsSkuId = goodsSkuId;
//    item.storeNo = storeNo;
//    item.goodsId = goodsId;
//    item.quantity = [NSNumber numberWithInteger:goodsQuantity.integerValue];
//
//    [self.webViewHost.view showloading];
//    @HDWeakify(self);
//    [[TNShoppingCar share] addItemToShoppingCarWithItem:item
//        success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
//            @HDStrongify(self);
//            [self.webViewHost.view dismissLoading];
//            NSArray<TNShoppingCarStoreModel *> *storeCarList = [[TNShoppingCar share] findStoreCarsWithStoreNo:item.storeNo];
//            TNShoppingCarStoreModel *storeCar = storeCarList.firstObject;
//            TNShoppingCarItemModel *shoppingCarItem = [storeCar getShoppingCarItemWithItem:item];
//            shoppingCarItem.quantity = item.quantity;
//            storeCar.selectedItems = @[shoppingCarItem];
//            [SAWindowManager openUrl:[NSString stringWithFormat:@"SuperApp://TinhNow/OrderSubmit"] withParameters:@{@"shoppingCarStoreModel": storeCar}];
//            [self.webViewHost fireCallback:callBackKey actionName:@"orderAndPay" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            @HDStrongify(self);
//            [self.webViewHost.view dismissLoading];
//            [self.webViewHost fireCallback:callBackKey actionName:@"orderAndPay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:(NSDictionary *)rspModel.data];
//        }];
//}

- (void)addGoodsToShoppingCar:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (![SAUser hasSignedIn]) {
        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    NSString *goodsId = [paramDict objectForKey:@"goodsId"];
    NSString *storeNo = [paramDict objectForKey:@"storeNo"];
    NSArray *skuList = [paramDict objectForKey:@"skuList"];
    NSString *buyType = [paramDict objectForKey:@"buyType"];

    if (HDIsStringEmpty(goodsId) || HDIsStringEmpty(storeNo) || HDIsArrayEmpty(skuList)) {
        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    TNItemModel *item = TNItemModel.new;
    item.skuList = skuList;
    item.storeNo = storeNo;
    item.goodsId = goodsId;
    item.salesType = buyType;

    @HDWeakify(self);
    [[TNShoppingCar share] addItemToShoppingCarWithItem:item success:^(TNAddItemToShoppingCarRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:(NSDictionary *)rspModel.data];
    }];
}

//- (void)deleteGoodsFromShoppingCar:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
//    if (![SAUser hasSignedIn]) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"deleteGoodsFromShoppingCar" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail params:@{}];
//        [SAWindowManager switchWindowToLoginViewController];
//        return;
//    }
//    NSString *goodsId = [paramDict objectForKey:@"goodsId"];
//    NSString *storeNo = [paramDict objectForKey:@"storeNo"];
//    NSArray *skuList = [paramDict objectForKey:@"skuList"];
//
//    if (HDIsStringEmpty(goodsId) || HDIsStringEmpty(storeNo) || HDIsArrayEmpty(skuList)) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
//        return;
//    }
//    TNItemModel *item = TNItemModel.new;
//    item.storeNo = storeNo;
//    item.goodsId = goodsId;
//    item.skuList = skuList;
//
//    TNShoppingCarItemModel *model = [[TNShoppingCar share] findShoppingCarItemWithGoodItem:item];
//    if (!model) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"addGoodsToShoppingCar" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
//        return;
//    }
//
//    @HDWeakify(self);
//    [[TNShoppingCar share] decreaseItemQuantityWithItem:model
//        quantity:item.quantity
//        success:^{
//            @HDStrongify(self);
//            [self.webViewHost fireCallback:callBackKey
//                                actionName:@"deleteGoodsFromShoppingCar"
//                                      code:HDWHRespCodeSuccess
//                                      type:HDWHCallbackTypeSuccess
//                                    params:@{}];
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            @HDStrongify(self);
//            [self.webViewHost fireCallback:callBackKey
//                                actionName:@"deleteGoodsFromShoppingCar"
//                                      code:HDWHRespCodeCommonFailed
//                                      type:HDWHCallbackTypeFail
//                                    params:(NSDictionary *)rspModel.data];
//        }];
//}
@end
