//
//  SAApplePayRequest.h
//  SuperApp
//
//  Created by seeu on 2022/1/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAApplePayRequest : SACodingModel

///< 支付订单号
@property (nonatomic, copy) NSString *orderNo;
///< 产品Id
@property (nonatomic, copy) NSString *productId;
///< 数量
@property (nonatomic, assign) NSInteger quantity;
///< userInfo 业务自定义参数，随着响应回传
@property (nonatomic, strong) NSDictionary *userInfo;
///< 回调
@property (nonatomic, copy) void (^paymentCompletionBlock)(NSInteger rspCode, NSDictionary *userInfo);

@end

NS_ASSUME_NONNULL_END
