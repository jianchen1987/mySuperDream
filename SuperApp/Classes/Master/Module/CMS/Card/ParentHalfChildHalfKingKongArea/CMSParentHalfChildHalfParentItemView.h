//
//  CMSParentHalfChildHalfParentItemView.h
//  SuperApp
//
//  Created by Tia on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSParentHalfChildHalfParentItemView : SAView

@property (nonatomic, strong, readonly) SALabel *titleLB;

@property (nonatomic, strong, readonly) SALabel *subTitleLB;

@property (nonatomic, strong, readonly) SDAnimatedImageView *imageView;

/// 点击回调
@property (nonatomic, copy) void (^clickView)(void);

@end

NS_ASSUME_NONNULL_END
