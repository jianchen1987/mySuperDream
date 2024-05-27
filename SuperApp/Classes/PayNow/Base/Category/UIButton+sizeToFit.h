//
//  UIButton+sizeToFit.h
//  ViPay
//
//  Created by seeu on 2019/6/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIButton (sizeToFit)

- (CGSize)fitSizeForCurrentTitleWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
