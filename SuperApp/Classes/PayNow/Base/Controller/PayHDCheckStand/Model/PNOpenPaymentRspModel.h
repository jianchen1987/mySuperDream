//
//  PNOpenPaymentRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOpenPaymentRspModel : HDJsonRspModel
/// KEY(需要解密)
@property (nonatomic, strong) NSString *authKey;
/// 支付用户TOKEN[注: 10位数字(需要解密)]
@property (nonatomic, strong) NSString *payerUsrToken;

/// 生成用户付款码 返回下面这两个字段
/// 付款码 qr code 内容
@property (nonatomic, strong) NSString *payCode;
/// 有效时间(单位/秒)
@property (nonatomic, assign) NSInteger validTime;
/// 美元限额
@property (nonatomic, assign) NSInteger usdLimitAmount;
/// 卡瑞尔限额
@property (nonatomic, assign) NSInteger khrLimitAmount;

@end

NS_ASSUME_NONNULL_END
