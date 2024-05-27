//
//  TNCouponParamsModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCouponParamsModel : TNModel
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 币种
@property (nonatomic, copy) NSString *currencyType;
/// 应付金额
@property (nonatomic, copy) NSString *amount;
/// 当前时间
@property (nonatomic, copy) NSString *orderTime;
/// 商户编号
@property (nonatomic, copy) NSString *merchantNo;
/// 运费
@property (nonatomic, copy) NSString *deliveryAmt;
/// 打包费
@property (nonatomic, copy) NSString *packingAmt;
/// 渠道  默认14  电商
@property (nonatomic, copy) NSString *businessType;
/// 操作员编号
@property (nonatomic, copy) NSString *userId;
/// sku list 筛选专题
@property (nonatomic, strong) NSArray *skuList;

@end

NS_ASSUME_NONNULL_END
