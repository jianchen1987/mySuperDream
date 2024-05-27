//
//  TNShoppingCar.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCar.h"
#import "TNItemModel.h"
#import "TNQueryUserShoppingCarRspModel.h"
#import "TNShoppingCarBatchGoodsModel.h"
#import "TNShoppingCarCountModel.h"
#import "TNShoppingCarDTO.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import <HDKitCore/HDKitCore.h>
static TNShoppingCar *_shoppingCar;


@interface TNShoppingCar ()
/// dto
@property (nonatomic, strong) TNShoppingCarDTO *dto;
/// 购物车总商品数
@property (nonatomic, assign) NSUInteger totalGoodsCount;
/// 购物车单买商品数
@property (nonatomic, assign) NSUInteger singleTotalCount;
/// 购物车批量商品数
@property (nonatomic, assign) NSUInteger batchTotalCount;
///

@end


@implementation TNShoppingCar

+ (TNShoppingCar *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shoppingCar = TNShoppingCar.new;
    });
    return _shoppingCar;
}

- (NSArray<TNShoppingCarStoreModel *> *)findStoreCarsWithStoreNo:(NSString *_Nullable)storeNo {
    if (HDIsStringEmpty(storeNo)) {
        return self.singleShopCardataSource;
    } else {
        return [self.singleShopCardataSource mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarStoreModel *_Nonnull obj, NSUInteger idx) {
            if ([obj.storeNo isEqualToString:storeNo]) {
                return obj;
            } else {
                return nil;
            }
        }];
    }
}

- (void)queryUserShoppingTotalCountSuccess:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto queryUserShoppingTotalCountSuccess:^(TNShoppingCarCountModel *model) {
        @HDStrongify(self);
        if (!HDIsObjectNil(model)) {
            self.totalGoodsCount = model.totalItems;
            self.singleTotalCount = model.singleShoppingCartCount;
            self.batchTotalCount = model.batchShoppingCartCount;
        }
        !successBlock ?: successBlock();
    } failure:failureBlock];
}
- (void)querySingleUserShoppingCarSuccess:(void (^)(TNQueryUserShoppingCarRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto queryUserShoppingCarBySalesType:TNSalesTypeSingle success:^(TNQueryUserShoppingCarRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.singleShopCardataSource removeAllObjects];
        if (!HDIsArrayEmpty(rspModel.storeShoppingCars)) {
            [self.singleShopCardataSource addObjectsFromArray:rspModel.storeShoppingCars];
        }
        self.singleTotalCount = [self calcuSingleTotolCount];
        if (self.totalGoodsCount > 0 && self.totalGoodsCount > self.singleTotalCount && !self.hasUpdateBatchTotalCount) {
            self.batchTotalCount = self.totalGoodsCount - self.singleTotalCount;
            self.hasUpdateBatchTotalCount = YES;
        }
        self.singleRefreshFlag = !self.singleRefreshFlag;
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

- (void)queryBatchUserShoppingCarSuccess:(void (^)(TNQueryUserShoppingCarRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto queryUserShoppingCarBySalesType:TNSalesTypeBatch success:^(TNQueryUserShoppingCarRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.batchShopCardataSource removeAllObjects];
        if (!HDIsArrayEmpty(rspModel.storeShoppingCars)) {
            [self.batchShopCardataSource addObjectsFromArray:rspModel.storeShoppingCars];
        }
        self.batchTotalCount = [self calcuBatchTotolCount];
        if (self.totalGoodsCount > 0 && self.totalGoodsCount > self.batchTotalCount && !self.hasUpdateSingleTotalCount) {
            self.singleTotalCount = self.totalGoodsCount - self.batchTotalCount;
            self.hasUpdateSingleTotalCount = YES;
        }
        self.batchRefreshFlag = !self.batchRefreshFlag;
        !successBlock ?: successBlock(rspModel);
    } failure:failureBlock];
}

- (void)addItemToShoppingCarWithItem:(TNItemModel *)item success:(void (^)(TNAddItemToShoppingCarRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto addItem:item toShoppingCarSuccess:^(TNAddItemToShoppingCarRspModel *_Nonnull addItemRspModel) {
        @HDStrongify(self);
        !successBlock ?: successBlock(addItemRspModel);
        [self queryUserShoppingTotalCountSuccess:nil failure:nil];
        if ([item.salesType isEqualToString:TNSalesTypeSingle]) {
            [self querySingleUserShoppingCarSuccess:nil failure:nil];
        } else if ([item.salesType isEqualToString:TNSalesTypeBatch]) {
            [self queryBatchUserShoppingCarSuccess:nil failure:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        /// 失败了也刷新购物车  有些情况  接口报错 但是实际加入成功
        @HDStrongify(self);
        [self queryUserShoppingTotalCountSuccess:nil failure:nil];
        if ([item.salesType isEqualToString:TNSalesTypeSingle]) {
            [self querySingleUserShoppingCarSuccess:nil failure:nil];
        } else if ([item.salesType isEqualToString:TNSalesTypeBatch]) {
            [self queryBatchUserShoppingCarSuccess:nil failure:nil];
        }
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)deleteItemFromShoppingCarWithItem:(TNShoppingCarItemModel *)item success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto deleteItem:item fromShoppingCarSuccess:^{
        @HDStrongify(self);
        self.totalGoodsCount -= 1;
        !successBlock ?: successBlock();
        self.singleTotalCount = [self calcuSingleTotolCount];
    } failure:failureBlock];
}
- (void)batchDeleteStoreItemFromShoppingCarWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   merchantDisplayNo:(NSString *)merchantDisplayNo
                                             success:(void (^)(void))successBlock
                                             failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto batchDeleteStoreItems:items merchantDisplayNo:merchantDisplayNo fromShoppingCarSuccess:^{
        @HDStrongify(self);
        self.totalGoodsCount -= items.count;
        !successBlock ?: successBlock();
        self.batchTotalCount = [self calcuBatchTotolCount];
    } failure:failureBlock];
}
- (void)batchDeleteItemsFromShoppingCarWithItems:(NSArray<NSDictionary *> *)items salesType:(TNSalesType)salesType success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto batchDeleteShopCartItems:items fromShoppingCarSuccess:^{
        @HDStrongify(self);
        self.totalGoodsCount -= items.count;
        !successBlock ?: successBlock();
        if (salesType == TNSalesTypeSingle) {
            self.singleTotalCount = [self calcuSingleTotolCount];
        } else {
            self.batchTotalCount = [self calcuBatchTotolCount];
        }
    } failure:failureBlock];
}
- (void)increaseItemQuantityWithItem:(TNShoppingCarItemModel *)item
                            quantity:(NSNumber *)quantity
                           salesType:(TNSalesType)salesType
                             success:(void (^)(void))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    [self.dto increaseQuantifyOfItem:item quantify:quantity salesType:salesType inShoppingCarSuccess:^{
        !successBlock ?: successBlock();
    } failure:failureBlock];
}

- (void)decreaseItemQuantityWithItem:(TNShoppingCarItemModel *)item
                            quantity:(NSNumber *)quantity
                           salesType:(TNSalesType)salesType
                             success:(void (^)(void))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    [self.dto decreaseQuantifyOfItem:item quantify:quantity salesType:salesType inShoppingCarSuccess:^{
        !successBlock ?: successBlock();
    } failure:failureBlock];
}

- (void)clearShoppingWithStoreDisplayNo:(NSString *)storeDisplayNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.dto clearShoppingCarWithStoreDisplayNo:storeDisplayNo success:^{
        @HDStrongify(self);
        self.totalGoodsCount -= 1;
        !successBlock ?: successBlock();
        self.singleTotalCount = [self calcuSingleTotolCount];
    } failure:failureBlock];
}

- (void)calcShoppingCarTotalPriceWithItems:(NSArray<TNShoppingCarItemModel *> *)items
                                   success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.dto calcShoppingCarTotalPriceWithItems:items success:successBlock failure:failureBlock];
}
- (void)increaseShoppingCarGoodTotalCount:(NSInteger)count {
    self.totalGoodsCount -= count;
}
- (void)clean {
    self.totalGoodsCount = 0;
    self.singleTotalCount = 0;
    self.batchTotalCount = 0;
    [self.singleShopCardataSource removeAllObjects];
    [self.batchShopCardataSource removeAllObjects];
}

- (void)convertCartPointByTargetView:(UIView *)targetView {
    CGPoint point = [targetView convertPoint:targetView.frame.origin toView:[UIApplication sharedApplication].keyWindow];
    point.x += targetView.frame.size.width / 2 - kRealWidth(10);

    self.activityBottomCartPoint = point;
}
- (void)activityCartShake {
    self.activityShake = !self.activityShake;
}
// 计算单买的商品总数
- (NSInteger)calcuSingleTotolCount {
    NSUInteger totalCount = 0;
    for (TNShoppingCarStoreModel *store in self.singleShopCardataSource) {
        totalCount += store.shopCarItems.count;
    }
    return totalCount;
}
// 计算批量的商品总数
- (NSInteger)calcuBatchTotolCount {
    NSUInteger totalCount = 0;
    for (TNShoppingCarStoreModel *store in self.batchShopCardataSource) {
        for (TNShoppingCarBatchGoodsModel *item in store.batchShopCarItems) {
            totalCount += item.shopCarItems.count;
        }
    }
    return totalCount;
}
//-(NSUInteger)totalGoodsCount{
//    return self.singleTotalCount + self.batchTotalCount;
//}
#pragma mark - lazy load
/** @lazy dto */
- (TNShoppingCarDTO *)dto {
    if (!_dto) {
        _dto = [[TNShoppingCarDTO alloc] init];
    }
    return _dto;
}
/** @lazy singleShopCardataSource */
- (NSMutableArray<TNShoppingCarStoreModel *> *)singleShopCardataSource {
    if (!_singleShopCardataSource) {
        _singleShopCardataSource = [NSMutableArray array];
    }
    return _singleShopCardataSource;
}
/** @lazy batchShopCardataSource */
- (NSMutableArray<TNShoppingCarStoreModel *> *)batchShopCardataSource {
    if (!_batchShopCardataSource) {
        _batchShopCardataSource = [NSMutableArray array];
    }
    return _batchShopCardataSource;
}
@end
