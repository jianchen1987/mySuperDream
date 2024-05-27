//
//  SALogoTitleHeaderView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALogoTitleHeaderViewModel : NSObject
@property (nonatomic, strong) UIImage *image;                ///< 图片
@property (nonatomic, copy) NSString *title;                 ///< 标题
@property (nonatomic, strong) UIFont *titleFont;             ///< 标题字体
@property (nonatomic, strong) UIColor *titleColor;           ///< 标题颜色
@property (nonatomic, copy) NSString *subTitle;              ///< 子标题
@property (nonatomic, strong) UIFont *subTitleFont;          ///< 子标题字体
@property (nonatomic, strong) UIColor *subTitleColor;        ///< 子标题颜色
@property (nonatomic, assign) CGFloat marginImageToTitle;    ///< 图片和标题间距
@property (nonatomic, assign) CGFloat marginTitleToSubTitle; ///< 标题和子标题间距
@end

/**
 类似于登录和注册界面的图片、顶部标题和子标题 View
 */
@interface SALogoTitleHeaderView : SAView
@property (nonatomic, strong) SALogoTitleHeaderViewModel *model; ///< 模型
- (void)updateTitle:(NSString *)title;
- (void)updateSubTitle:(NSString *)subTitle;
@property (nonatomic, strong, readonly) UIImageView *imageView; ///< 图片
@end

NS_ASSUME_NONNULL_END
