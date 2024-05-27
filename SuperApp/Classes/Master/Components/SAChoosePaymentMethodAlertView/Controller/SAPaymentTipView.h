//
//  SAPaymentTipView.h
//  SuperApp
//
//  Created by Tia on 2023/3/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentTipView : SAView

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) NSString *text;
/// 是否只是线上支付不能用
@property (nonatomic, assign) BOOL isOnlyOnline;

@end

NS_ASSUME_NONNULL_END
