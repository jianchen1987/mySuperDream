//
//  SAAlertViewConfig.h
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAAlertViewConfig : NSObject

@property (nonatomic, strong) UIFont *titleFont;                    ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;                  ///< 标题颜色
@property (nonatomic, strong) UIFont *messageFont;                  ///< 内容字体
@property (nonatomic, strong) UIColor *messageColor;                ///< 内容颜色
@property (nonatomic, assign) CGFloat labelHEdgeMargin;             ///< 文字水平外边距
@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets; ///< 容器内边距
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets;   ///< 内容 view 内边距
@property (nonatomic, assign) CGFloat marginTitle2Message;          ///< 标题和内容间距
@property (nonatomic, assign) CGFloat marginMessageToButton;        ///< 内容和按钮间距
@property (nonatomic, assign) CGFloat buttonHMargin;                ///< 按钮水平间距
@property (nonatomic, assign) CGFloat buttonVMargin;                ///< 按钮垂直间距
@property (nonatomic, assign) CGFloat buttonHeight;                 ///< 按钮高度
@property (nonatomic, assign) CGFloat buttonCorner;                 ///< 按钮圆角
@property (nonatomic, assign) CGFloat containerCorner;              ///< 容器圆角
@property (nonatomic, assign) CGFloat containerMinHeight;           ///< 容器最小高度

@end

NS_ASSUME_NONNULL_END
