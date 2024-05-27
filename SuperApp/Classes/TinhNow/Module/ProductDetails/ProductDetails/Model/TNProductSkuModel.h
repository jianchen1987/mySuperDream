//
//  TNProductSkuModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
#import "TNProductBatchPriceInfoModel.h"
#import "TNProductSpecPropertieModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductSkuModel : TNModel
/// 索引
@property (nonatomic, copy) NSString *specValueKey;
/// skuId
@property (nonatomic, copy) NSString *skuId;
/// skuSn
@property (nonatomic, copy) NSString *skuSn;
/// 购买价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 市场价
@property (nonatomic, strong) SAMoneyModel *marketPrice;
/// 团购价
@property (nonatomic, strong) SAMoneyModel *groupBuyingPrice;
/// 赠送积分
@property (nonatomic, strong) NSNumber *rewardPoint;
/// 兑换积分
@property (nonatomic, strong) NSNumber *exchangePoint;
/// 库存
@property (nonatomic, strong) NSNumber *stock;
/// 是否默认sku
@property (nonatomic, assign) BOOL isDefault;
/// 是否售完
@property (nonatomic, assign) BOOL isOutOfStock;
/// 图片
@property (nonatomic, copy) NSString *thumbnail;
/// 最低价
@property (nonatomic, strong) SAMoneyModel *lowestPrice;
/// 规格
@property (nonatomic, strong) NSArray<TNProductSpecPropertieModel *> *specificationValues;
/// sku大图  用于预览大图
@property (nonatomic, copy) NSString *skuLargeImg;
/// 重量  返回的是 克  需转换成千克
@property (strong, nonatomic) NSNumber *weight;
/// 重量显示带单位
@property (nonatomic, copy) NSString *showWight;
/// 规格显示数组  微店改价接口才有的字符
@property (strong, nonatomic) NSArray<NSString *> *specifications;
///<批发价  ES搜索接口使用  和详情返回字段不一致  这里统一取值
@property (strong, nonatomic) SAMoneyModel *bulkPrice;
///<收益
@property (strong, nonatomic) SAMoneyModel *revenue;
/// 规格数组  用于筛选规则  将specValueKey 转成数组
@property (nonatomic, copy) NSArray *specValueKeyArray;
///固定加价金额，单位：美元，保留两位小数
@property (nonatomic, copy) NSString *additionValue;

/// 微店加价金额 用于提交标记是否更改过价格
@property (nonatomic, copy) NSString *changedPrice;
/// 加价后用于计算回显的销售价
@property (nonatomic, copy) NSString *showSalePrice;
///阶梯价
@property (strong, nonatomic) TNPriceRangesModel *priceRange;

///绑定属性
/// 加入的数量
@property (nonatomic, assign) NSInteger editCount;
/// 达到阶梯价赋值的金额  直接可以去提交订单页
@property (strong, nonatomic) SAMoneyModel *tempSalesPrice;

@end

NS_ASSUME_NONNULL_END
