//
//  PNSetAmountView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNView.h"

// 最大限额
typedef enum : NSUInteger {
    PNSetAmountType_Persion = 1,  ///< 个人
    PNSetAmountType_Merchant = 2, ///< 商户
} PNSetAmountType;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ConfirmBlock)(NSString *accountType, NSString *amount);


@interface PNSetAmountView : PNView
@property (nonatomic, assign) PNSetAmountType amountType;
/// 记得回调
@property (nonatomic, copy) void (^callback)(NSString *amount, NSString *currency);

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end

NS_ASSUME_NONNULL_END
