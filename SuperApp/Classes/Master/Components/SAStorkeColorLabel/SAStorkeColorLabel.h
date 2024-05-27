//
//  SAStorkeColorLabel.h
//  SuperApp
//
//  Created by VanJay on 2020/7/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SALabel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 支持外部描边的 label
@interface SAStorkeColorLabel : UIView
/// 角标
@property (nonatomic, strong, readonly) SALabel *badgeNumberLB;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWidthContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;
@end

NS_ASSUME_NONNULL_END
