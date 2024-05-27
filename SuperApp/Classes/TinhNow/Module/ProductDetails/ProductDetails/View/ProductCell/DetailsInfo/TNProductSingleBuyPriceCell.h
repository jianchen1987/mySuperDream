//
//  TNSingleBuyPriceViewCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  商品详情单买价格视图

#import "SAMoneyModel.h"
#import "SATableViewCell.h"
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductSingleBuyPriceCellModel : NSObject
/// 带币种 普通样式 需要富文本话
@property (strong, nonatomic) SAMoneyModel *priceMoney;
/// 销售价
@property (nonatomic, copy) NSString *price;
/// 市场价
@property (nonatomic, copy) NSString *marketPrice;
/// 收益
@property (copy, nonatomic) NSString *revenue;
/// 批发价
@property (copy, nonatomic) NSString *tradePrice;
/// 折扣
@property (nonatomic, copy) NSString *showDisCount;
///是否已经加入销售
@property (nonatomic, assign) BOOL isJoinSales;
/// 是否是限购商品
@property (nonatomic, assign) BOOL goodsLimitBuy;
/// 最大限购数量
@property (nonatomic, assign) NSInteger maxLimit;
/// 详情样式
@property (nonatomic, assign) TNProductDetailViewType detailViewType;
/// 第一张主图
@property (nonatomic, strong) NSString *firstImageURL;
/// 店铺类型
@property (nonatomic, copy) TNStoreType storeType;
///
@property (nonatomic, copy) NSString *productId;
@end


@interface TNProductSingleBuyPriceCell : SATableViewCell
///
@property (strong, nonatomic) TNProductSingleBuyPriceCellModel *model;
@end

NS_ASSUME_NONNULL_END
