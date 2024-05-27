//
//  TNOrderDetailsGoodsInfoModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsGoodsInfoModel : TNCodingModel
/// id
@property (nonatomic, copy) NSString *productId;
/// 数量
@property (nonatomic, strong) NSNumber *quantity;
/// 是否需要物流
@property (nonatomic, assign) BOOL isDelivery;
/// 已送数量
@property (nonatomic, strong) NSNumber *shippedQuantity;
/// 上次修改时间
@property (nonatomic, assign) NSTimeInterval lastModifiedDate;
/// 规格值
@property (nonatomic, strong) NSArray<NSString *> *specificationValue;
/// 创建日期
@property (nonatomic, assign) NSTimeInterval createdDate;
/// 金额
@property (nonatomic, strong) SAMoneyModel *price;
/// 图片
@property (nonatomic, copy) NSString *thumbnail;
/// 已退数量
@property (nonatomic, strong) NSNumber *returnedQuantity;
/// 序列
@property (nonatomic, copy) NSString *sn;
/// 商品名
@property (nonatomic, copy) NSString *name;
///
@property (nonatomic, copy) NSString *skuId;
/// 是否开启了免邮 1 免邮 0 到付
@property (nonatomic, assign) BOOL freightSetting;
/// 重量  返回的是 克  需转换成千克
@property (strong, nonatomic) NSNumber *weight;
/// 重量显示带单位
@property (nonatomic, copy) NSString *showWight;
/// 供销码
@property (nonatomic, copy) NSString *sp;
@end

NS_ASSUME_NONNULL_END
