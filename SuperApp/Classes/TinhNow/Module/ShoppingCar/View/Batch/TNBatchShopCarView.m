//
//  TNBatchShopCarView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBatchShopCarView.h"
#import "SATableView.h"
#import "TNBatchShopCarProductCell.h"
#import "TNBatchShopCarSkuCell.h"
#import "TNShopCarFooterView.h"
#import "TNShopCarHeaderView.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNShoppingCartTableViewCell+Skeleton.h"


@interface TNBatchShopCarView () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 高度缓存
@property (strong, nonatomic) NSMutableDictionary *cellHeightsDictionary;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;
@end


@implementation TNBatchShopCarView
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self addSubview:self.tableView];
    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;
    //    if (HDIsArrayEmpty(self.shopCarDataCenter.batchShopCardataSource)) {
    //        [self getNewData];
    //    } else {
    //        self.tableView.delegate = self;
    //        self.tableView.dataSource = self;
    //        [self prepareBatchData];
    //        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    //    }
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"batchRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self prepareBatchData];
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];
}
#pragma mark -获取新数据
- (void)getNewData {
    if (![SAUser hasSignedIn]) {
        return;
    }
    @HDWeakify(self);
    [self.shopCarDataCenter queryBatchUserShoppingCarSuccess:nil failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    }];
}
#pragma mark -处理展示的列表数据
- (void)prepareBatchData {
    if (HDIsArrayEmpty(self.shopCarDataCenter.batchShopCardataSource)) {
        return;
    }
    [self.shopCarDataCenter.batchShopCardataSource enumerateObjectsUsingBlock:^(TNShoppingCarStoreModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSMutableArray *temp = [NSMutableArray array];
        __block BOOL hasProductCanSale = NO;
        [obj.batchShopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarBatchGoodsModel *_Nonnull goodObj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (!HDIsArrayEmpty(goodObj.shopCarItems)) {
                [temp addObject:goodObj];
                [goodObj.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull item, NSUInteger idx, BOOL *_Nonnull stop) {
                    ///每个sku都绑定所属商品数据
                    item.goodModel = goodObj;
                    [temp addObject:item];
                }];
            }
            if (goodObj.goodsState == TNStoreItemStateOnSale) {
                hasProductCanSale = YES;
            }
        }];
        obj.allProductOffSale = !hasProductCanSale;
        obj.batchList = temp;
    }];
}

#pragma mark -刷新section
- (void)reloadTableViewSectionWithSection:(NSInteger)section {
    if (section < self.shopCarDataCenter.batchShopCardataSource.count) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } else {
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}

#pragma mark -结算下单
- (void)settlementToSubmitOrderWithStoreModel:(TNShoppingCarStoreModel *)storeModel {
    NSMutableArray *selectedArr = [NSMutableArray array];
    for (id model in storeModel.batchList) {
        if ([model isKindOfClass:[TNShoppingCarItemModel class]]) {
            TNShoppingCarItemModel *item = model;
            if (item.isSelected) {
                [selectedArr addObject:item];
            }
        }
    }
    storeModel.selectedItems = [NSArray arrayWithArray:selectedArr];
    storeModel.salesType = TNSalesTypeBatch;
    NSString *trackPrefixName;
    if ([storeModel.type isEqualToString:TNStoreTypeOverseasShopping]) {
        trackPrefixName = TNTrackEventPrefixNameOverseas;
    } else if ([storeModel.type isEqualToString:TNStoreTypePlatfromSelf]) {
        trackPrefixName = TNTrackEventPrefixNameFastConsume;
    } else {
        trackPrefixName = TNTrackEventPrefixNameOther;
    }
    [SATalkingData trackEvent:[trackPrefixName stringByAppendingString:@"购物车_点击结算"]];
    //商品结算埋点
    NSArray *skuIds = [storeModel.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        return obj.goodsSkuId;
    }];
    [TNEventTrackingInstance trackEvent:@"cart_settle" properties:@{@"skuId": skuIds}];
    @HDWeakify(self);
    void (^callBack)(void) = ^{
        @HDStrongify(self);
        //刷新数据
        [self getNewData];
    };
    [SAWindowManager openUrl:[NSString stringWithFormat:@"SuperApp://TinhNow/OrderSubmit"]
              withParameters:@{@"shoppingCarStoreModel": storeModel, @"funnel": [trackPrefixName stringByAppendingString:@"购物车_"], @"callBack": callBack}];
}

#pragma mark -选中店铺全选
- (void)selectedStoreAllGoodsWithStoreModel:(TNShoppingCarStoreModel *)storeModel section:(NSInteger)section {
    //如果店铺所有的商品都不合规  不能选中
    __block BOOL canSelected = NO;
    [storeModel.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
            TNShoppingCarBatchGoodsModel *model = obj;
            if (model.productCatDTO.mixWholeSale) {
                __block NSInteger totalQuantity = 0;
                [model.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    totalQuantity += obj.quantity.integerValue;
                }];
                if (totalQuantity >= model.startQuantity && model.goodsState == TNStoreItemStateOnSale) {
                    canSelected = YES;
                    *stop = YES;
                }
            } else {
                __block BOOL hasMoreStartQuantity = NO;
                [model.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull subStop) {
                    if (obj.quantity.integerValue > model.startQuantity) {
                        hasMoreStartQuantity = YES;
                        *subStop = YES;
                    }
                }];
                if (hasMoreStartQuantity) {
                    canSelected = YES;
                    *stop = YES;
                }
            }
        }
    }];
    if (canSelected) {
        storeModel.isSelected = storeModel.tempSelected;
    }

    [storeModel.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
            TNShoppingCarBatchGoodsModel *model = obj;
            model.tempSelected = storeModel.tempSelected;
            //设置商品的选中状态
            [self setProductSelectedStateWithGoodModel:model tempSelected:storeModel.tempSelected];
            //设置价格更新
            [self updateSalesPriceWithGoodModel:model];
        }
    }];
    [self reloadTableViewSectionWithSection:section];
}
#pragma mark -选中商品
- (void)selectedGoodWithStoreModel:(TNShoppingCarStoreModel *)storeModel goodModel:(TNShoppingCarBatchGoodsModel *)goodModel indexPath:(NSIndexPath *)indexPath {
    //设置商品的选中状态
    [self setProductSelectedStateWithGoodModel:goodModel tempSelected:goodModel.tempSelected];

    //检查所有的店铺是否全选了
    __block BOOL allGoodSelected = YES;
    [storeModel.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
            TNShoppingCarBatchGoodsModel *model = obj;
            if (!model.isSelected) {
                allGoodSelected = NO;
                *stop = YES;
            }
        }
    }];
    storeModel.isSelected = allGoodSelected;
    storeModel.tempSelected = allGoodSelected;
    //设置价格更新
    [self updateSalesPriceWithGoodModel:goodModel];
    [self reloadTableViewSectionWithSection:indexPath.section];
}
/// 设置商品的选中状态
- (void)setProductSelectedStateWithGoodModel:(TNShoppingCarBatchGoodsModel *)goodModel tempSelected:(BOOL)tempSelected {
    if (goodModel.goodsState == TNStoreItemStateOffSale) {
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.tempSelected = tempSelected;
        }];
        return;
    }
    if (goodModel.productCatDTO.mixWholeSale) {
        //混批
        __block NSInteger totalQuantity = 0;
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.tempSelected = tempSelected;
            totalQuantity += obj.quantity.integerValue;
        }];
        if (totalQuantity >= goodModel.startQuantity) {
            __block BOOL hasBatchNumber = YES;
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.availableStock > 0) {
                    if (obj.goodModel.productCatDTO.batchNumber > 0 && [obj.quantity integerValue] % obj.goodModel.productCatDTO.batchNumber != 0) {
                        //有显示 购买倍数的
                        obj.isSelected = NO;
                    } else {
                        obj.isSelected = goodModel.tempSelected;
                        if (hasBatchNumber) {
                            hasBatchNumber = NO;
                        }
                    }
                }
            }];
            if (!hasBatchNumber) {
                goodModel.isSelected = goodModel.tempSelected;
            }
        }
    } else {
        //非混批
        __block BOOL hasCanBuySku = NO;
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.quantity.integerValue >= goodModel.startQuantity && !hasCanBuySku) {
                hasCanBuySku = YES;
                *stop = YES;
            }
        }];
        if (hasCanBuySku) {
            // 只要符合就勾选
            __block BOOL hasBatchNumber = YES;
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.quantity.integerValue >= goodModel.startQuantity && obj.availableStock > 0) {
                    if (obj.goodModel.productCatDTO.batchNumber > 0 && [obj.quantity integerValue] % obj.goodModel.productCatDTO.batchNumber != 0) {
                        //有显示 购买倍数的
                        obj.isSelected = NO;
                    } else {
                        obj.isSelected = goodModel.tempSelected;
                        if (hasBatchNumber) {
                            hasBatchNumber = NO;
                        }
                    }
                }
                if (!hasBatchNumber) {
                    goodModel.isSelected = goodModel.tempSelected;
                }
            }];
        } else {
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                goodModel.tempSelected = tempSelected;
                goodModel.isSelected = NO;
            }];
            //全部不能选
            goodModel.isSelected = NO;
        }
    }
}
#pragma mark -选中sku
- (void)selectedSkuWithStoreModel:(TNShoppingCarStoreModel *)storeModel
                        goodModel:(TNShoppingCarBatchGoodsModel *)goodModel
                        itemModel:(TNShoppingCarItemModel *)itemModel
                        indexPath:(NSIndexPath *)indexPath {
    if (goodModel.productCatDTO.mixWholeSale) {
        //支持混批
        //选中的数量
        __block NSInteger buyQuantity = 0;
        //商品全部数量
        __block NSInteger totalQuantity = 0;
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            totalQuantity += obj.quantity.integerValue;
            if (obj.tempSelected) {
                buyQuantity += obj.quantity.integerValue;
            }
        }];
        if (totalQuantity < goodModel.startQuantity) {
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isSelected = NO;
            }];
        } else {
            if (buyQuantity >= goodModel.startQuantity) {
                goodModel.showStartQuantityTips = NO;
                [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (obj.availableStock > 0) {
                        if (obj.goodModel.productCatDTO.batchNumber > 0 && [obj.quantity integerValue] % obj.goodModel.productCatDTO.batchNumber != 0) {
                            //有显示 购买倍数的
                            obj.isSelected = NO;
                        } else {
                            obj.isSelected = obj.tempSelected;
                        }
                    }
                }];
            } else {
                __block BOOL hasTempSelected = NO;
                [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    obj.isSelected = NO;
                    if (obj.tempSelected) {
                        hasTempSelected = YES;
                    }
                }];
                goodModel.showStartQuantityTips = hasTempSelected;
            }
        }
    } else {
        //非混批
        if (itemModel.quantity.integerValue >= goodModel.startQuantity) {
            itemModel.isSelected = itemModel.tempSelected;
        } else {
            itemModel.isSelected = NO;
        }
    }

    // 所有sku全选
    __block BOOL allSkuSelected = YES;
    __block BOOL allSkuTempSelected = YES;
    [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.isSelected) {
            allSkuSelected = NO;
        }
        if (!obj.tempSelected) {
            allSkuTempSelected = NO;
        }
    }];
    goodModel.isSelected = allSkuSelected;
    goodModel.tempSelected = allSkuTempSelected;

    //检查所有的商品是否全选了
    __block BOOL allGoodSelected = YES;
    [storeModel.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
            TNShoppingCarBatchGoodsModel *model = obj;
            if (!model.isSelected) {
                allGoodSelected = NO;
                *stop = YES;
            }
        }
    }];
    storeModel.isSelected = allGoodSelected;
    storeModel.tempSelected = allGoodSelected;

    //设置价格更新
    [self updateSalesPriceWithGoodModel:goodModel];
    [self reloadTableViewSectionWithSection:indexPath.section];
}

#pragma mark -根据选中以及购买数量更新商品价格
- (void)updateSalesPriceWithGoodModel:(TNShoppingCarBatchGoodsModel *)goodModel {
    if (goodModel.productCatDTO.mixWholeSale) {
        //混批计算价格
        //选中的数量
        __block NSInteger buyQuantity = 0;
        //第一次查找所有的已购买数量 是否达到起批线
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.isSelected) {
                buyQuantity += obj.quantity.integerValue;
            }
        }];
        if (buyQuantity >= goodModel.startQuantity) {
            //达到起批线
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.isSelected) {
                    //选中的一个档位价格
                    SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:buyQuantity];
                    if (!HDIsObjectNil(price)) {
                        obj.salePrice = price;
                    }
                } else {
                    //未选中的一个档位价格
                    SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:obj.quantity.integerValue];
                    if (!HDIsObjectNil(price)) {
                        obj.salePrice = price;
                    }
                }
            }];
        } else {
            //未达到起批数量  所有商品 都是一个档位
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:obj.quantity.integerValue];
                if (!HDIsObjectNil(price)) {
                    obj.salePrice = price;
                }
            }];
        }
    } else {
        //非混批计算价格  只计算单个sku 购买数量达标就可以了
        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:obj.quantity.integerValue];
            if (!HDIsObjectNil(price)) {
                obj.salePrice = price;
            }
        }];
    }
}

#pragma mark -批量删除多个商品
- (void)onDeleteShopCarProducts {
    if (!HDIsArrayEmpty(self.shopCarDataCenter.batchShopCardataSource)) {
        __block NSMutableArray *items = [NSMutableArray array];
        /// 提前备份一份剔除了删除的数组
        //        __block NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.shopCarDataCenter.batchShopCardataSource];
        [self.shopCarDataCenter.batchShopCardataSource enumerateObjectsUsingBlock:^(TNShoppingCarStoreModel *_Nonnull storeModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if (!HDIsArrayEmpty(storeModel.batchList)) {
                //                TNShoppingCarStoreModel *tempStoreModel = copyArray[idx];
                //                NSMutableArray *batchList = [NSMutableArray arrayWithArray:tempStoreModel.batchList];

                [storeModel.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj isKindOfClass:[TNShoppingCarItemModel class]]) {
                        TNShoppingCarItemModel *item = obj;
                        if (item.isSelected) {
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            dict[@"itemDisplayNo"] = item.itemDisplayNo;
                            dict[@"businessType"] = @"11";
                            dict[@"merchantDisplayNo"] = storeModel.storeShoppingCarDisplayNo;
                            [items addObject:dict];
                            //删除对应的sku
                            //                            [batchList removeObject:item];
                            //
                            //                            if ([goodModel.goodsId isEqualToString:item.goodsId]) {
                            //                                if ([goodTempArray containsObject:item]) {
                            //                                    [goodTempArray removeObject:item];
                            //                                }
                            //                            }
                        }
                    }
                }];

                //                tempStoreModel.batchList = batchList;
                //                //删除门店
                //                if (HDIsArrayEmpty(batchList)) {
                //                    [copyArray removeObject:storeModel];
                //                }
            }
        }];

        if (!HDIsArrayEmpty(items)) {
            // 弹窗确认
            NSString *message = [NSString stringWithFormat:TNLocalizedString(@"VXqx9tll", @"确认将这%ld个商品删除？"), items.count];
            [NAT showAlertWithMessage:message confirmButtonTitle:TNLocalizedString(@"tn_delete", @"删除") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                [self showloading];
                @HDWeakify(self);
                [self.shopCarDataCenter batchDeleteItemsFromShoppingCarWithItems:items salesType:TNSalesTypeBatch success:^{
                    @HDStrongify(self);
                    [self dismissLoading];
                    NSArray *skuids = [items mapObjectsUsingBlock:^id _Nonnull(NSDictionary *_Nonnull obj, NSUInteger idx) {
                        return obj[@"itemDisplayNo"];
                    }];
                    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.shopCarDataCenter.batchShopCardataSource];
                    [copyArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNShoppingCarStoreModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if (!HDIsArrayEmpty(obj.batchList)) {
                            NSMutableArray *tempBatchList = [NSMutableArray arrayWithArray:obj.batchList];
                            [tempBatchList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
                                    TNShoppingCarBatchGoodsModel *goodModel = obj;
                                    NSMutableArray *tempShopList = [NSMutableArray arrayWithArray:goodModel.shopCarItems];
                                    [tempShopList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                        if ([skuids containsObject:obj.itemDisplayNo]) {
                                            [tempShopList removeObject:obj];
                                        }
                                    }];
                                    goodModel.shopCarItems = tempShopList;
                                    //检查sku是否是混批的
                                    if (goodModel.productCatDTO.mixWholeSale) {
                                        __block NSInteger totalCount = 0;
                                        //支持混批的话  就要查找所有的数量
                                        [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                            totalCount += obj.quantity.integerValue;
                                        }];

                                        SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:totalCount];
                                        if (!HDIsObjectNil(price)) {
                                            //支持混批的话  商品下所以规格的价格都要变化
                                            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                                obj.salePrice = price;
                                            }];
                                        }
                                    }
                                } else if ([obj isKindOfClass:[TNShoppingCarItemModel class]]) {
                                    TNShoppingCarItemModel *item = obj;
                                    if ([skuids containsObject:item.itemDisplayNo]) {
                                        [tempBatchList removeObject:obj];
                                    }
                                }
                            }];
                            obj.batchList = tempBatchList;

                            if (HDIsArrayEmpty(obj.batchList)) {
                                [copyArray removeObject:obj];
                            }
                        }
                    }];

                    self.shopCarDataCenter.batchShopCardataSource = copyArray;
                    [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self dismissLoading];
                }];
            } cancelButtonTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];

        } else {
            [HDTips showWithText:TNLocalizedString(@"I80nN3yX", @"请选择商品")];
        }
    }
}

#pragma mark -删除弹窗确认
- (void)showDeleteConfirmAlertWithStoreModel:(TNShoppingCarStoreModel *)storeModel
                                   goodModel:(TNShoppingCarBatchGoodsModel *)goodModel
                                   itemModel:(TNShoppingCarItemModel *)itemModel
                                   indexPath:(NSIndexPath *)indexPath {
    // 弹窗确认
    //    [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"确认删除商品吗？") confirmButtonTitle:WMLocalizedString(@"cart_not_now", @"暂时不")
    //        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //            [alertView dismiss];
    //        }
    //        cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //            [alertView dismiss];
    if (HDIsObjectNil(itemModel)) {
        [self deleteGoodWithStoreModel:storeModel goodModel:goodModel indexPath:indexPath];
    } else {
        [self deleteSkuWithStoreModel:storeModel goodModel:goodModel itemModel:itemModel indexPath:indexPath];
    }
    //        }];
}
#pragma mark -删除商品
- (void)deleteGoodWithStoreModel:(TNShoppingCarStoreModel *)storeModel goodModel:(TNShoppingCarBatchGoodsModel *)goodModel indexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    [self showloading];
    [self.shopCarDataCenter batchDeleteStoreItemFromShoppingCarWithItems:goodModel.shopCarItems merchantDisplayNo:storeModel.storeShoppingCarDisplayNo success:^{
        @HDStrongify(self);
        [self dismissLoading];
        //删除商品埋点
        NSArray *skuIds = [goodModel.shopCarItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
            return obj.goodsSkuId;
        }];
        //删除sku埋点
        [TNEventTrackingInstance trackEvent:@"cart_remove" properties:@{@"skuId": skuIds}];
        goodModel.shopCarItems = @[];
        [self processAfterDeleteGoodDataWithStoreModel:storeModel goodModel:goodModel indexPath:indexPath];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}
///删除完商品后处理数据
- (void)processAfterDeleteGoodDataWithStoreModel:(TNShoppingCarStoreModel *)storeModel goodModel:(TNShoppingCarBatchGoodsModel *)goodModel indexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempBatchList = [NSMutableArray arrayWithArray:storeModel.batchList];
    [tempBatchList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
            TNShoppingCarBatchGoodsModel *tempGoodModel = obj;
            if ([goodModel.goodsId isEqualToString:tempGoodModel.goodsId]) {
                [tempBatchList removeObject:tempGoodModel];
            }

        } else if ([obj isKindOfClass:[TNShoppingCarItemModel class]]) {
            TNShoppingCarItemModel *item = obj;
            if ([goodModel.goodsId isEqualToString:item.goodModel.goodsId]) {
                [tempBatchList removeObject:item];
            }
        }
    }];
    storeModel.batchList = tempBatchList;
    if (!HDIsArrayEmpty(tempBatchList)) {
        [self reloadTableViewSectionWithSection:indexPath.section];
    } else {
        if ([self.shopCarDataCenter.batchShopCardataSource containsObject:storeModel]) {
            [self.shopCarDataCenter.batchShopCardataSource removeObject:storeModel];
        }
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}
#pragma mark -删除sku
- (void)deleteSkuWithStoreModel:(TNShoppingCarStoreModel *)storeModel
                      goodModel:(TNShoppingCarBatchGoodsModel *)goodModel
                      itemModel:(TNShoppingCarItemModel *)itemModel
                      indexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    [self showloading];
    [self.shopCarDataCenter batchDeleteStoreItemFromShoppingCarWithItems:@[itemModel] merchantDisplayNo:storeModel.storeShoppingCarDisplayNo success:^{
        @HDStrongify(self);
        [self dismissLoading];
        NSMutableArray *tempBatchList = [NSMutableArray arrayWithArray:storeModel.batchList];
        if ([tempBatchList containsObject:itemModel]) {
            [tempBatchList removeObject:itemModel];
        }
        NSMutableArray *tempSkus = [NSMutableArray arrayWithArray:goodModel.shopCarItems];
        [tempSkus enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj.goodsSkuId isEqualToString:itemModel.goodsSkuId]) {
                [tempSkus removeObject:obj];
                *stop = YES;
            }
        }];
        goodModel.shopCarItems = tempSkus;
        storeModel.batchList = tempBatchList;

        //检查sku是否是混批的
        if (goodModel.productCatDTO.mixWholeSale) {
            __block NSInteger totalCount = 0;
            //支持混批的话  就要查找所有的数量
            [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                totalCount += obj.quantity.integerValue;
            }];

            SAMoneyModel *price = [goodModel.productCatDTO getStageSalePriceByCount:totalCount];
            if (!HDIsObjectNil(price)) {
                //支持混批的话  商品下所以规格的价格都要变化
                [goodModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    obj.salePrice = price;
                }];
            }
        }
        if (HDIsArrayEmpty(tempSkus)) {
            //商品都删除完了 就继续删除商品
            [self processAfterDeleteGoodDataWithStoreModel:storeModel goodModel:goodModel indexPath:indexPath];
        } else {
            [self reloadTableViewSectionWithSection:indexPath.section];
        }

        //删除sku埋点
        [TNEventTrackingInstance trackEvent:@"cart_remove" properties:@{@"skuId": @[itemModel.goodsSkuId]}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark -增加单个商品的数量
- (void)plusProductCountWithStoreModel:(TNShoppingCarStoreModel *)storeModel
                             goodModel:(TNShoppingCarBatchGoodsModel *)goodModel
                             itemModel:(TNShoppingCarItemModel *)itemModel
                              addDelta:(NSInteger)addDelta
                             indexPath:(NSIndexPath *)indexPath {
    [self showloading];
    @HDWeakify(self);
    [self.shopCarDataCenter increaseItemQuantityWithItem:itemModel quantity:[NSNumber numberWithInteger:addDelta] salesType:TNSalesTypeBatch success:^{
        @HDStrongify(self);
        [self dismissLoading];
        NSInteger quantity = itemModel.quantity.integerValue + addDelta;
        itemModel.quantity = [NSNumber numberWithInteger:quantity];
        // 加减规格  都要重新验证一下 更新选中
        [self selectedSkuWithStoreModel:storeModel goodModel:goodModel itemModel:itemModel indexPath:indexPath];
        //增加商品个数埋点
        [TNEventTrackingInstance trackEvent:@"cart_add_num" properties:@{@"skuId": itemModel.goodsSkuId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        //失败刷新回原来的显示
        [self reloadTableViewSectionWithSection:indexPath.section];
    }];
}

#pragma mark -减少单个商品的数量
- (void)minusProductCountWithStoreModel:(TNShoppingCarStoreModel *)storeModel
                              goodModel:(TNShoppingCarBatchGoodsModel *)goodModel
                              itemModel:(TNShoppingCarItemModel *)itemModel
                          decreaseDelta:(NSInteger)decreaseDelta
                              indexPath:(NSIndexPath *)indexPath {
    [self showloading];
    @HDWeakify(self);
    [self.shopCarDataCenter decreaseItemQuantityWithItem:itemModel quantity:[NSNumber numberWithInteger:decreaseDelta] salesType:TNSalesTypeBatch success:^{
        @HDStrongify(self);
        [self dismissLoading];
        NSInteger quantity = itemModel.quantity.integerValue - decreaseDelta;
        itemModel.quantity = [NSNumber numberWithInteger:quantity];
        [self selectedSkuWithStoreModel:storeModel goodModel:goodModel itemModel:itemModel indexPath:indexPath];
        //减少商品个数埋点
        [TNEventTrackingInstance trackEvent:@"cart_minus_num" properties:@{@"skuId": itemModel.goodsSkuId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        //失败刷新回原来的显示
        [self reloadTableViewSectionWithSection:indexPath.section];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shopCarDataCenter.batchShopCardataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[section];
    return storeModel.batchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[indexPath.section];
    id model = storeModel.batchList[indexPath.row];
    if ([model isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
        TNShoppingCarBatchGoodsModel *goodModel = model;
        TNBatchShopCarProductCell *cell = [TNBatchShopCarProductCell cellWithTableView:tableView];
        cell.model = goodModel;
        @HDWeakify(self);
        cell.clickedSelectBTNBlock = ^{
            @HDStrongify(self);
            [self selectedGoodWithStoreModel:storeModel goodModel:goodModel indexPath:indexPath];
        };
        cell.clickedDeleteBTNBlock = ^{
            @HDStrongify(self);
            [self showDeleteConfirmAlertWithStoreModel:storeModel goodModel:goodModel itemModel:nil indexPath:indexPath];
        };
        return cell;
    } else if ([model isKindOfClass:[TNShoppingCarItemModel class]]) {
        TNShoppingCarItemModel *item = model;
        TNBatchShopCarSkuCell *cell = [TNBatchShopCarSkuCell cellWithTableView:tableView];
        cell.model = item;
        @HDWeakify(self);
        cell.clickedSelectBTNBlock = ^{
            @HDStrongify(self);
            [self selectedSkuWithStoreModel:storeModel goodModel:item.goodModel itemModel:item indexPath:indexPath];
        };
        cell.clickedPlusBTNBlock = ^(NSUInteger addDelta, NSUInteger forwardCount) {
            @HDStrongify(self);
            [self plusProductCountWithStoreModel:storeModel goodModel:item.goodModel itemModel:item addDelta:addDelta indexPath:indexPath];
        };
        cell.clickedMinusBTNBlock = ^(NSUInteger deleteDelta, NSUInteger currentCount) {
            @HDStrongify(self);
            [self minusProductCountWithStoreModel:storeModel goodModel:item.goodModel itemModel:item decreaseDelta:deleteDelta indexPath:indexPath];
        };
        cell.maxCountLimtedHandler = ^(NSUInteger count) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
        };
        cell.clickedDeleteBTNBlock = ^{
            @HDStrongify(self);
            [self showDeleteConfirmAlertWithStoreModel:storeModel goodModel:item.goodModel itemModel:item indexPath:indexPath];
        };
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNShopCarHeaderView *headerView = [TNShopCarHeaderView headerWithTableView:tableView];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[section];
    headerView.model = storeModel;
    @HDWeakify(self);
    headerView.clickAllSelectedStoreProductCallBack = ^{
        @HDStrongify(self);
        [self selectedStoreAllGoodsWithStoreModel:storeModel section:section];
    };
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TNShopCarFooterView *footerView = [TNShopCarFooterView headerWithTableView:tableView];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[section];
    footerView.calculateAmount = storeModel.batchCalcTotalPayPriceStr;
    @HDWeakify(self);
    footerView.clickToSubmitOrderCallback = ^{
        @HDStrongify(self);
        [self settlementToSubmitOrderWithStoreModel:storeModel];
    };
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(60);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealWidth(60);
}
#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell hd_endSkeletonAnimation];
//    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
//    if (height) return height.doubleValue;
//    return UITableViewAutomaticDimension;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[indexPath.section];
    id model = storeModel.batchList[indexPath.row];
    @HDWeakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:TNLocalizedString(@"tn_delete", @"删除")
                                                                          handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
                                                                              @HDStrongify(self);
                                                                              if ([model isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
                                                                                  TNShoppingCarBatchGoodsModel *goodModel = model;
                                                                                  [self showDeleteConfirmAlertWithStoreModel:storeModel goodModel:goodModel itemModel:nil indexPath:indexPath];

                                                                              } else if ([model isKindOfClass:[TNShoppingCarItemModel class]]) {
                                                                                  TNShoppingCarItemModel *item = model;
                                                                                  [self showDeleteConfirmAlertWithStoreModel:storeModel goodModel:item.goodModel itemModel:item indexPath:indexPath];
                                                                              }
                                                                          }];

    return @[deleteAction];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.batchShopCardataSource[indexPath.section];
    id model = storeModel.batchList[indexPath.row];
    TNShoppingCarItemModel *itemModel;
    if ([model isKindOfClass:[TNShoppingCarBatchGoodsModel class]]) {
        TNShoppingCarBatchGoodsModel *goodModel = model;
        if (!HDIsArrayEmpty(goodModel.shopCarItems)) {
            itemModel = goodModel.shopCarItems.firstObject;
        }
        if (!HDIsObjectNil(itemModel) && itemModel.goodsState == TNStoreItemStateOnSale) {
            //在售的才可以跳转
            [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": itemModel.goodsId, @"sp": itemModel.sp, @"tab": TNSalesTypeBatch}];
        }
    }
}
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = NO;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self getNewData];
        };

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"no_data_placeholder";
        model.title = WMLocalizedString(@"cart_empty", @"购物车为空");
        _tableView.placeholderViewModel = model;

        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kRealWidth(30))];
    }
    return _tableView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNShoppingCartTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNShoppingCartTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}
/** @lazy cellHeightsDictionary */
- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightsDictionary;
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillAppear {
    //每次进来刷新购物车
    [self getNewData];
}
//- (void)listDidAppear {
//    __block BOOL needPrepareData = NO;
//    [self.shopCarDataCenter.batchShopCardataSource enumerateObjectsUsingBlock:^(TNShoppingCarStoreModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if (HDIsArrayEmpty(obj.batchList)) {
//            needPrepareData = YES;
//        }
//    }];
//    if (needPrepareData) {
//        [self prepareBatchData];
//    }
//    [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
//}
@end
