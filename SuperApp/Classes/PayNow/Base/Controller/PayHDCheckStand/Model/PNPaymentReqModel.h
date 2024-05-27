//
//  PNPaymentReqModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentReqModel : PNModel
/// 业务请求身份标识枚举 12付款码
@property (nonatomic, assign) PNUserBussinessType businessType;
/// 支付认证类型(10:免密支付认证/11:非免密支付认证)
@property (nonatomic, assign) PNUserCertifiedTypes certifiedType;
/// 加密因子 [加密因子(免密不上送)]
@property (nonatomic, strong) NSString *index;
/// 密码 [密码(免密不上送)]
@property (nonatomic, strong) NSString *password;
@end

NS_ASSUME_NONNULL_END
