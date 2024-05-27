//
//  PNUploadImageViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNUploadImageViewModel : SAInfoViewModel
@property (nonatomic, assign) NSInteger uploadImageViewLineWidth; ///< 线条宽度 跟父类的区分开【其他属性跟随使用】
@property (nonatomic, copy) NSString *subTitleText;               ///< 键文字
@property (nonatomic, strong) UIFont *subTitleFont;               ///< 键文字字体
@property (nonatomic, strong) UIColor *subTitleColor;             ///< 键文字颜色
@property (nonatomic, assign) NSTextAlignment subTitleAlignment;  ///< 键文字对齐方式
@property (nonatomic, assign) UIEdgeInsets subTitleEdgeInsets;    ///< 键内容内边距
///

@end

NS_ASSUME_NONNULL_END
