//
//  TNLeftCircleImageButton.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNLeftCircleImageButton : UIControl
/// 文字颜色
@property (strong, nonatomic) UIColor *textColor;
/// 文字大小
@property (strong, nonatomic) UIFont *textFont;
/// 左图片
@property (strong, nonatomic) UIImage *leftCircleImage;
/// 文本
@property (nonatomic, copy) NSString *text;
/// 文字左间距
@property (nonatomic, assign) CGFloat leftSpace;
/// 文字右间距
@property (nonatomic, assign) CGFloat rightSpace;
///
@property (nonatomic, copy) void (^addTouchUpInsideHandler)(TNLeftCircleImageButton *btn);
/// 获取按钮自身的size
- (CGSize)getSizeFits;
@end

NS_ASSUME_NONNULL_END
