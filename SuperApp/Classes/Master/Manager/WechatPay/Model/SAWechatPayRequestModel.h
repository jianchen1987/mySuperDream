//
//  SAWechatPayRequestModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWechatPayRequestModel : SAModel
/** 应用 ID */
@property (nonatomic, copy, readonly) NSString *appid;
/** 商家向财付通申请的商家 ID */
@property (nonatomic, copy, readonly) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, copy, readonly) NSString *prepayid;
/** 商家根据财付通文档填写的数据和签名，默认值为 Sign=WXPay */
@property (nonatomic, copy, readonly) NSString *package;
/** 随机串，防重发 */
@property (nonatomic, copy, readonly) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign, readonly) UInt32 timestamp;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy, readonly) NSString *sign;
@end

NS_ASSUME_NONNULL_END
