//
//  PNInputItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDKeyBoard.h"
#import "PNModel.h"

typedef enum : NSUInteger {
    PNInputCoverUpNone = 0,   ///< 默认值
    PNInputCoverUpName = 1,   ///< 显示第一位，其余都遮掩脱敏
    PNInputCoverUpNumber = 2, ///< 显示第一位和最后一位，其余都遮掩脱敏
} PNInputCoverUpType;

typedef enum : NSUInteger {
    PNInputStypeRow_One = 0, ///< 一行显示 【左边title， 右边textfiled】
    PNInputStypeRow_Two = 1, ///< 两行显示 【第一行title 第二行textfiled】
} PNInputStypeRow;

NS_ASSUME_NONNULL_BEGIN


@interface PNInputItemModel : PNModel
@property (nonatomic, assign) PNInputStypeRow style;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内内边距

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) BOOL enabled;

/// 左边的title
@property (nonatomic, strong) NSString *title;
/// 左边的title 颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 左边的title 字体大小
@property (nonatomic, strong) UIFont *titleFont;
/// 左边title 的富文本 【attributedTitle 优先级 比 title 高】
@property (nonatomic, strong) NSMutableAttributedString *attributedTitle;

/// value
@property (nonatomic, strong) NSString *value;
/// value 颜色
@property (nonatomic, strong) UIColor *valueColor;
/// value 字体大小
@property (nonatomic, strong) UIFont *valueFont;
/// value 对齐方式
@property (nonatomic, assign) NSTextAlignment valueAlignment;
/// input 输入是强行转成左对齐  【当input textFiled.textAlignment = .right 点击空格不出现】
@property (nonatomic, assign) BOOL fixWhenInputSpace;
/// input 的占位符
@property (nonatomic, strong) NSString *placeholder;
/// input 的占位符 颜色
@property (nonatomic, strong) UIColor *placeholderColor;
/// input 的占位符 字体大小
@property (nonatomic, strong) UIFont *placeholderFont;

/// input 左边 Label
@property (nonatomic, copy) NSString *leftLabelString;
/// input 左边 颜色
@property (nonatomic, strong) UIColor *leftLabelColor;
/// input 左边  字体大小
@property (nonatomic, strong) UIFont *leftLabelFont;

/// 底部线条颜色
@property (nonatomic, strong) UIColor *bottomLineColor;
/// 底部线条高度
@property (nonatomic, assign) CGFloat bottomLineHeight;
/// 底部线条 开始缩进 [距离左边间距]
@property (nonatomic, assign) CGFloat bottomLineSpaceToLeft;
/// 底部线条 结束缩进 [距离右边间距]
@property (nonatomic, assign) CGFloat bottomLineSpaceToRight;
///< 类型
@property (nonatomic, assign) UIKeyboardType keyboardType;

/// 是否使用wownow 键盘 【默认NO】
@property (nonatomic, assign) BOOL useWOWNOWKeyboard;
/// wownow键盘类型 当 useWOWNOWKeyboard = YES 才会生效
@property (nonatomic, assign) HDKeyBoardType wownowKeyBoardType;
/// 最长输入长度
@property (nonatomic, assign) NSInteger maxInputLength;
/// 是否开启名字 遮掩 【目前仅仅针对名字样式做遮掩， exp: 哈*** 】
@property (nonatomic, assign) PNInputCoverUpType coverUp;
/// 是否需要大写 - 针对输入是英文的
@property (nonatomic, assign) BOOL isUppercaseString;
/// 是否聚焦时 清除内容 - 【键盘弹起时候】
@property (nonatomic, assign) BOOL isWhenEidtClearValue;
/// 输入是否允许中间有多个空格【将多个空格替换成一个空格】 默认允许输入多个空格
@property (nonatomic, assign) BOOL canInputMoreSpace;
/// 是否需要首位不能输入0
@property (nonatomic, assign) BOOL firstDigitCanNotEnterZero;

@end

NS_ASSUME_NONNULL_END
