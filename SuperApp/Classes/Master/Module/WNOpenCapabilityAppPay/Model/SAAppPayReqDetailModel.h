//
//  SAAppPayReqDetailModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppPayReqDetailModel : SACodingModel
@property (nonatomic, copy) NSString *payOrderNo; ///< 支付订单号
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *bizOrderNo;
@property (nonatomic, copy) NSString *merchantNo;
@property (nonatomic, assign) NSTimeInterval timestamp; ///<
@property (nonatomic, copy) NSString *orderNo;          ///< 聚合订单号

- (NSString *)payAmountShowStr;

@end

NS_ASSUME_NONNULL_END
