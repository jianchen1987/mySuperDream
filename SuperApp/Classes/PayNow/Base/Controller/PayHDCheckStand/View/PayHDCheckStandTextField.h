//
//  PayHDCheckstandTextField.h
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PayHDCheckstandSecurityCharacterType) {
    PayHDCheckstandSecurityCharacterTypeSecurityDot,    ///< dot● ,default.
    PayHDCheckstandSecurityCharacterTypePlainText,      ///< Instead of dot with using plaintext.
    PayHDCheckstandSecurityCharacterTypeCustomImage,    ///< Instead of dot with using custom image.
    PayHDCheckstandSecurityCharacterTypeHorizontalLine, ///< Instead of dot with using horizontal line.
};

typedef NS_ENUM(NSUInteger, PayHDCheckstandTextFieldBorderType) {
    PayHDCheckstandTextFieldBorderTypeHaveRoundedCorner, ///< The border has rounded corners,default.
    PayHDCheckstandTextFieldBorderTypeNoRoundedCorner,   ///< The border is not rounded.
    PayHDCheckstandTextFieldBorderTypeSeparateBox,       ///< Each input bit has a separate box.(No support yet.)
    PayHDCheckstandTextFieldBorderTypeNoBorder,          ///< The control has no borders.
};

@class PayHDCheckstandTextField;
@protocol PayHDCheckstandTextFieldDelegate <NSObject>

@required

/**
 输入完成 end editing

 @param textField 支付框
 */
- (void)checkStandTextFieldDidFinishedEditing:(PayHDCheckstandTextField *)textField;

@optional

/**
 开始响应

 @param textField 支付款
 */
- (void)checkStandTextFieldBecomeFirstResponder:(PayHDCheckstandTextField *)textField;

- (void)checkStandTextFieldResignFirstResponder:(PayHDCheckstandTextField *)textField;

/**
 开始输入 begin editing

 @param textField 支付框
 */
- (void)checkStandTextFieldDidBeginEditing:(PayHDCheckstandTextField *)textField;

/**
 删除一个字符 delete a character

 @param textField 支付框
 */
- (void)checkStandTextFieldDidDelete:(PayHDCheckstandTextField *)textField;

/**
 清除完成 clear all characters

 @param textField 支付框
 */
- (void)checkStandTextFieldDidClear:(PayHDCheckstandTextField *)textField;

@end


@interface PayHDCheckstandTextField : UIControl

@property (nonatomic, weak) id<PayHDCheckstandTextFieldDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfCharacters;
@property (nonatomic, assign) PayHDCheckstandSecurityCharacterType securityCharacterType;
@property (nonatomic, assign) PayHDCheckstandTextFieldBorderType borderType;
@property (nonatomic, assign) CGFloat diameterOfDot;
@property (nonatomic, assign) CGSize securityImageSize;
@property (nonatomic, assign, readonly) NSInteger countOfVerification;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void (^completion)(PayHDCheckstandTextField *field, NSString *text);

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *colorOfCharacter;
@property (nonatomic, strong) UIImage *securityImage;

- (instancetype)initWithNumberOfCharacters:(NSInteger)numberOfCharacters
                     securityCharacterType:(PayHDCheckstandSecurityCharacterType)securityCharacterType
                                borderType:(PayHDCheckstandTextFieldBorderType)borderType;

- (void)insertText:(NSString *)text;
- (void)deleteBackward;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
