//
//  HDGetOrderInfoRspModel.h
//  customer
//
//  Created by 帅呆 on 2018/11/30.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDGetOrderInfoRspModel : HDJsonRspModel

@property (nonatomic, strong) NSDecimalNumber *amt;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *payeeName;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *subject;

@end

NS_ASSUME_NONNULL_END
