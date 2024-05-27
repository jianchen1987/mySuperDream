//
//  TNProductBatchPriceInfoModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
typedef NS_ENUM(NSInteger, TNProductQuoteType) {
    ///无规格按数量报价  阶梯报价
    TNProductQuoteTypeNoSpecByNumber = 0,
    ///按规格报价
    TNProductQuoteTypeBySpec = 1,
    ///有规格按数量报价 阶梯报价
    TNProductQuoteTypeHasSpecByNumber = 2,
};

NS_ASSUME_NONNULL_BEGIN


@interface TNPriceRangesModel : TNModel
/// 起批量
@property (nonatomic, assign) NSInteger startQuantity;
/// 销售价
@property (nonatomic, strong) SAMoneyModel *price;
/// 批发价
@property (nonatomic, strong) SAMoneyModel *tradePrice;
/// 如果有卖家加价策略，那么这里保存了当前商品卖家加价策略计算出来的最终加价金额
@property (nonatomic, strong) SAMoneyModel *additionPrice;

@end


@interface TNProductBatchPriceInfoModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
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

/// 绑定属性
///是否已经加入销售
@property (nonatomic, assign) BOOL isJoinSales;
/// 详情样式
@property (nonatomic, assign) TNProductDetailViewType detailViewType;
/// 是否是限购商品
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 最大限购数量
@property (nonatomic, assign) NSInteger maxLimit;
@end

NS_ASSUME_NONNULL_END
