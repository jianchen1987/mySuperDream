//
//  SASelectableTableViewCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASelectableTableViewCellModel : SAModel
/// 图片
@property (nonatomic, strong, nullable) UIImage *image;
/// 图片大小
@property (nonatomic, assign) CGSize imageSize;
/// 文字
@property (nonatomic, copy) NSString *text;
/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 文字字体
@property (nonatomic, strong) UIFont *textFont;
/// 选择图片
@property (nonatomic, strong, nullable) UIImage *selectedImage;
/// bottom图片
@property (nonatomic, strong, nullable) UIImage *bottomImage;
/// content
@property (nonatomic, strong, nullable) NSString *subTitle;
/// 文字颜色
@property (nonatomic, strong) UIColor *subTitleColor;
/// 文字字体
@property (nonatomic, strong) UIFont *subTitleFont;

@end

NS_ASSUME_NONNULL_END
