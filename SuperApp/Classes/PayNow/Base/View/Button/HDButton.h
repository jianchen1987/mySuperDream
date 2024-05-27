//
//  HDButton.h
//  customer
//
//  Created by 帅呆 on 2018/10/31.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDButtonStyle) { HDButtonStyleBorderCycle, HDButtonStyleGradualBG, HDButtonStyleUnderLine };


@interface HDButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame type:(HDButtonStyle)style;

@end

NS_ASSUME_NONNULL_END
