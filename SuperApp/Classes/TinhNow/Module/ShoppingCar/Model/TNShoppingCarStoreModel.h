//
//  TNShoppingCarStoreModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNShoppingCarItemModel;
@class SAMoneyModel;
@class TNCalcTotalPayFeeTrialRspModel;
@class TNItemModel;
@class TNShoppingCarBatchGoodsModel;


@interface TNShoppingCarStoreModel : TNCodingModel
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 门店购物车展示号
@property (nonatomic, copy) NSString *storeShoppingCarDisplayNo;
/// 门店购物车总金额,商品总金额，不含打包 税费
@property (nonatomic, strong) SAMoneyModel *totalPrice;
/// 门店状态
@property (nonatomic, copy) TNStoreState merchantStoreStatus;
/// 购物车商品列表
@property (nonatomic, strong) NSArray<TNShoppingCarItemModel *> *shopCarItems;
/// 当前选中商品列表
@property (nonatomic, strong) NSArray<TNShoppingCarItemModel *> *selectedItems;
/// 试算结果
@property (nonatomic, strong, nullable) TNCalcTotalPayFeeTrialRspModel *calcTotalFeeTrialRspModel;
/// 店铺类型
@property (nonatomic, copy) TNStoreType type;
/// 批量买商品数据
@property (strong, nonatomic) NSArray<TNShoppingCarBatchGoodsModel *> *batchShopCarItems;

#pragma mark - 绑定属性
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;
///  临时选中  批量购物车要用到
@property (nonatomic, assign) BOOL tempSelected;

/// 单买选中的商品合计支付金额  没有选中的就为空  已带币种
@property (strong, nonatomic) NSString *singleCalcTotalPayPriceStr;

/// 批量选中的商品合计支付金额  没有选中的就为空  已带币种
@property (strong, nonatomic) NSString *batchCalcTotalPayPriceStr;

/// ********绑定属性   批量购物车列表展示用  一行商品显示  余下sku列表显示
@property (strong, nonatomic) NSArray *batchList;
/// 默认选中单买还是批量
@property (nonatomic, copy) TNSalesType salesType;

/// 全部商品已下架
@property (nonatomic, assign) BOOL allProductOffSale;

@end

NS_ASSUME_NONNULL_END
