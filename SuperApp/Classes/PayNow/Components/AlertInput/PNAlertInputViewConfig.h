//
//  PNAlertInputViewConfig.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNAlertInputView;

typedef NS_ENUM(NSUInteger, PNAlertInputStyle) {
    PNAlertInputStyle_textField, ///< textFiled
    PNAlertInputStyle_textView,  ///< textView
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^PNCancelVoidBlock)(PNAlertInputView *alertView);
typedef void (^PNDoneVoidBlock)(NSString *inputText, PNAlertInputView *alertView);


@interface PNAlertInputViewConfig : PNModel
/// 样式
@property (nonatomic, assign) PNAlertInputStyle style;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题字体
@property (nonatomic, strong) UIFont *titleFont;
/// 副标题
@property (nonatomic, copy) NSString *subTitle;
/// 副标题颜色
@property (nonatomic, strong) UIColor *subTitleColor;
/// 副标题字体
@property (nonatomic, strong) UIFont *subTitleFont;
/// 文本输入值【预设】
@property (nonatomic, copy) NSString *textValue;
/// 取消按钮 的title [左边]
@property (nonatomic, copy) NSString *cancelButtonTitle;
/// 取消按钮 的title 颜色 [左边]
@property (nonatomic, strong) UIColor *cancelButtonColor;
/// 取消按钮 的背景 颜色 [左边]
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
/// 取消按钮 的title 字体 [左边]
@property (nonatomic, strong) UIFont *cancelButtonFont;
/// 完成按钮 的 title [右边]
@property (nonatomic, copy) NSString *doneButtonTitle;
/// 完成按钮 的 title 颜色 [右边]
@property (nonatomic, strong) UIColor *doneButtonColor;
/// 完成按钮 的背景 颜色 [右边]
@property (nonatomic, strong) UIColor *doneButtonBackgroundColor;
/// 完成按钮 的 title 字体 [右边]
@property (nonatomic, strong) UIFont *doneButtonFont;
/// 点击取消按钮的回调
@property (nonatomic, copy, nullable) PNCancelVoidBlock cancelHandler;
/// 点击确定按钮的回调
@property (nonatomic, copy, nullable) PNDoneVoidBlock doneHandler;
/// 最大输入
@property (nonatomic, assign) NSInteger maxInputLength;

@property (nonatomic, copy) NSString *textViewPlaceholder;

+ (PNAlertInputViewConfig *)defulatConfig;
@end

NS_ASSUME_NONNULL_END
