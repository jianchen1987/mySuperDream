//
//  HDScrollIndicatorView.h
//  SuperApp
//
//  Created by seeu on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDScrollIndicatorView : UIView

///< 背景色
@property (nonatomic, strong) UIColor *bgColor;
///< 点颜色
@property (nonatomic, strong) UIColor *dotColor;

///< 进度
@property (nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
