//
//  SAShadowBackgroundView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAShadowBackgroundView : UIView
@property (nonatomic, assign) UIRectCorner shadowRectCorners; ///< 圆角位置
@property (nonatomic, assign) CGFloat shadowRoundRadius;      ///< 圆角大小
@property (nonatomic, assign) CGFloat shadowRadius;           ///< 阴影半径大小
@property (nonatomic, assign) float shadowOpacity;            ///< 阴影透明度
@property (nonatomic, strong) UIColor *shadowColor;           ///< 阴影颜色
@property (nonatomic, strong) UIColor *shadowFillColor;       ///< 填充颜色
@property (nonatomic, assign) CGSize shadowOffset;            ///< 阴影偏移
@end

NS_ASSUME_NONNULL_END
