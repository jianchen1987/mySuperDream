//
//  PNTransferFormConfig.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import <HDUIKit/HDUIKit.h>
//编辑类型
typedef NS_ENUM(NSUInteger, PNSTransferFormValueEditType) {
    PNSTransferFormValueEditTypeEnter = 0, //输入
    PNSTransferFormValueEditTypeDrop = 1,  //点击下拉
    PNSTransferFormValueEditTypeJump = 2,  //点击跳转
    PNSTransferFormValueEditTypeShow = 3,  //展示
};
NS_ASSUME_NONNULL_BEGIN


@interface PNTransferFormConfig : PNModel

///关联属性
@property (nonatomic, copy) NSString *associateString;
/// 文本
@property (nonatomic, copy) NSString *keyText;
/// key字体
@property (strong, nonatomic) UIFont *keyFont;
/// 展示文本的※
@property (nonatomic, assign) BOOL showKeyStar;
/// 富文本
@property (nonatomic, copy) NSString *subKeyText;
/// 富文本字体
@property (nonatomic, strong) UIFont *subKeyFont;
/// 富文本颜色
@property (nonatomic, strong) UIColor *subKeyColor;
/// 值
@property (nonatomic, copy) NSString *valueText;
/// 占位值
@property (nonatomic, copy) NSString *valuePlaceHold;
/// 仅展示 不能编辑  包括输入和点击  颜色偏灰
@property (nonatomic, assign) BOOL onlyShow;
/// 编辑类型 输入 还是下拉
@property (nonatomic, assign) PNSTransferFormValueEditType editType;
/// 线条高度 为0 就隐藏
@property (nonatomic, assign) CGFloat lineHeight;
/// 输入框高度 默认40
@property (nonatomic, assign) CGFloat valueContainerHeight;
/// 键盘类型
@property (nonatomic, assign) UIKeyboardType keyboardType;
/// 最大输入数字
@property (nonatomic, assign) NSInteger maxInputLength;
/// 左边占位 Label
@property (nonatomic, copy) NSString *leftLabelString;

/// 有默认设置
@property (strong, nonatomic) HDUITextFieldConfig *textfeildConfig;
/// 右边提示文本
@property (nonatomic, copy) NSString *rightTipText;
/// 右边图片
@property (nonatomic, copy) NSString *rightTipImageStr;

/// 是否使用wownow 键盘 【默认NO】
@property (nonatomic, assign) BOOL useWOWNOWKeyboard;
/// wownow键盘类型 当 useWOWNOWKeyboard = YES 才会生效
@property (nonatomic, assign) HDKeyBoardType wownowKeyBoardType;
///是否正在输入
@property (nonatomic, assign) BOOL isEditing;

/// 右边提示按钮点击
@property (nonatomic, copy) void (^rightTipClickCallBack)(PNTransferFormConfig *targetConfig);
/// 值容器点击回调
@property (nonatomic, copy) void (^valueContainerClickCallBack)(PNTransferFormConfig *targetConfig);
/// 值变化回调
@property (nonatomic, copy) void (^valueChangedCallBack)(PNTransferFormConfig *targetConfig);
/// 即将结束输入的时候 回调
@property (nonatomic, copy) void (^textFiledShouldEndEditCallBack)(PNTransferFormConfig *targetConfig);
@end

NS_ASSUME_NONNULL_END
