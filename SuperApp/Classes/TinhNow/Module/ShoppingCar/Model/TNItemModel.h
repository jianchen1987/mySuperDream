//
//  TNItemModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//
#import "TNCodingModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNItemSkuModel : TNCodingModel
/// skuId
@property (nonatomic, copy) NSString *goodsSkuId;
/// 数量
@property (nonatomic, strong) NSNumber *addDelta;
/// 价格
@property (nonatomic, strong) SAMoneyModel *salePrice;
/// 规格名称
@property (nonatomic, copy) NSString *properties;
/// sku图片
@property (nonatomic, copy) NSString *thumbnail;
/// 重量  返回的是 克  需转换成千克
@property (strong, nonatomic) NSNumber *weight;
/// 重量展示
@property (nonatomic, copy) NSString *showWight;
@end


@interface TNItemModel : TNCodingModel

/// 所属门店NO
@property (nonatomic, copy) NSString *storeNo;
/// 商品ID
@property (nonatomic, copy) NSString *goodsId;
/// 批量sku数组
@property (strong, nonatomic) NSArray<TNItemSkuModel *> *skuList;
/// 分享码
@property (nonatomic, copy) NSString *shareCode;
/// 商品名称
@property (nonatomic, copy) NSString *goodName;
/// 供销码
@property (nonatomic, copy) NSString *sp;
/// 单买还是批量
@property (nonatomic, copy) TNSalesType salesType;
@end

NS_ASSUME_NONNULL_END
