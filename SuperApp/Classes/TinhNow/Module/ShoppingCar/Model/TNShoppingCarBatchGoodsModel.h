//
//  TNShoppingCarBatchGoodsModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  批量商品项

#import "TNModel.h"
#import "TNProductBatchPriceInfoModel.h"
@class TNShoppingCarItemModel;
NS_ASSUME_NONNULL_BEGIN

/// 按规格报价 购物属性
@interface TNShoppingCarSkuPriceStrategyModel : TNModel
/// 规格id
@property (nonatomic, copy) NSString *skuId;
/// 金额
@property (nonatomic, strong) SAMoneyModel *price;
/// 起批量
@property (nonatomic, assign) NSInteger startQuantity;
@end

///批量扩展字段 购物车属性
@interface TNShoppingCarBatchExtendModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 是否支持批量采购模式 0: 不支持 1：支持
@property (nonatomic, assign) BOOL enabledStagePrice;
/// 单位 如 ‘件’
@property (nonatomic, copy) NSString *unit;
/// 每批数量 倍数 如果 每次加购 都必须是这个的倍数
@property (nonatomic, assign) NSInteger batchNumber;
/// 售卖单位，如果为批量售卖，代表售卖的单位，该属性不为空时batchNumber为必填
@property (nonatomic, copy) NSString *sellUnit;
/// 是否支持混批
@property (nonatomic, assign) BOOL mixWholeSale;
/// 报价模式  0:无规格按数量报价    1：按规格报价   2:有规格按数量报价
@property (nonatomic, assign) TNProductQuoteType quoteType;
/// 阶梯价, 1688 商品数据返回的批量购买阶梯价信息quoteType 为 0、2 时这个字段返回全部阶梯价，为 1 时，只返回默认sku的阶梯价
@property (strong, nonatomic) NSArray<TNPriceRangesModel *> *priceRanges;
/// 按规格报价 sku价格策略
@property (strong, nonatomic) NSArray<TNShoppingCarSkuPriceStrategyModel *> *skuCatDTOList;

/// 根据sku 获取起批数量  会处理 阶梯价和非阶梯价的起批数量
- (NSInteger)getStartQuantityBySkuId:(NSString *)skuId;
/// 通过数量获取阶梯价格
- (SAMoneyModel *)getStageSalePriceByCount:(NSInteger)count;
@end


@interface TNShoppingCarBatchGoodsModel : TNModel
///  skuid
@property (nonatomic, copy) NSString *goodsSkuId;
///  商品id
@property (nonatomic, copy) NSString *goodsId;
///  商品名字
@property (nonatomic, copy) NSString *goodsName;
///  商品图片
@property (nonatomic, copy) NSString *picture;
///  商品状态
@property (nonatomic, assign) TNStoreItemState goodsState;
///  购物车商品列表
@property (nonatomic, strong) NSArray<TNShoppingCarItemModel *> *shopCarItems;
///  批量购物车商品属性数据
@property (strong, nonatomic) TNShoppingCarBatchExtendModel *productCatDTO;

///  是否选中
@property (nonatomic, assign) BOOL isSelected;
///  临时选中  批量购物车要用到
@property (nonatomic, assign) BOOL tempSelected;
///计算属性  混批商品 是否超过总起批量
@property (nonatomic, assign) BOOL isExceedTotalStartQuantity;
///  计算属性 起批数量  调用isExceedTotalStartQuantity 后  会复制
@property (nonatomic, assign) NSInteger startQuantity;
/// 显示起批量提示
@property (nonatomic, assign) BOOL showStartQuantityTips;

@end

NS_ASSUME_NONNULL_END
