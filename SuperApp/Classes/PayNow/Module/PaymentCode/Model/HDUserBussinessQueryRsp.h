//
//  HDUserBussinessQueryRsp.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 用户业务查询 */
@interface HDUserBussinessQueryRsp : SAModel
@property (nonatomic, copy) NSString *authKey; ///< 授权 key
/// [businessOpen => status]
@property (nonatomic, assign) PNUserBussinessStatus status; ///< 业务开通详情 10已开通, 11未关联设备, 12未开通付款业务
@property (nonatomic, copy) NSString *payerUsrToken;        ///< 支付用户TOKEN[注: 10位数字]

@property (nonatomic, assign) PNUserCertifiedTypes payCertifiedType; ///< 支付认证类型(10:免密支付认证/11:非免密支付认证)
@end

NS_ASSUME_NONNULL_END
