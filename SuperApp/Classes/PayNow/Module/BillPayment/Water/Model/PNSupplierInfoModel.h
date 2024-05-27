//
//  PNSupplierInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNSupplierInfoModel : PNModel
/// 商家代码
@property (nonatomic, strong) NSString *code;
/// 商家名
@property (nonatomic, strong) NSString *name;
/// 商家名 - 简称
@property (nonatomic, strong) NSString *shortName;
/// 允许 部分支付（布尔）用户可以支付小于账单金额的金额
@property (nonatomic, assign) BOOL allowPartialPayment;
/// 允许超额支付（布尔）用户可以支付超过账单金额的金额
@property (nonatomic, assign) BOOL allowExceedPayment;
/// icon
@property (nonatomic, strong) NSString *paymentCategoryIcon;
@end

NS_ASSUME_NONNULL_END
