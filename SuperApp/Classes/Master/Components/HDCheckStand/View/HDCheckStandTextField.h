//
//  HDCheckStandTextField.h
//  SuperApp
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HDCheckStandSecurityCharacterType) {
    HDCheckStandSecurityCharacterTypeSecurityDot,    ///< dot● ,default.
    HDCheckStandSecurityCharacterTypePlainText,      ///< Instead of dot with using plaintext.
    HDCheckStandSecurityCharacterTypeCustomImage,    ///< Instead of dot with using custom image.
    HDCheckStandSecurityCharacterTypeHorizontalLine, ///< Instead of dot with using horizontal line.
};

typedef NS_ENUM(NSUInteger, HDCheckStandTextFieldBorderType) {
    HDCheckStandTextFieldBorderTypeHaveRoundedCorner, ///< The border has rounded corners,default.
    HDCheckStandTextFieldBorderTypeNoRoundedCorner,   ///< The border is not rounded.
    HDCheckStandTextFieldBorderTypeSeparateBox,       ///< Each input bit has a separate box.(No support yet.)
    HDCheckStandTextFieldBorderTypeNoBorder,          ///< The control has no borders.
};

@class HDCheckStandTextField;
@protocol HDCheckStandTextFieldDelegate <NSObject>

@required

/**
 输入完成 end editing

 @param textField 支付框
 */
- (void)checkStandTextFieldDidFinishedEditing:(HDCheckStandTextField *)textField;

@optional

/**
 开始响应

 @param textField 支付款
 */
- (void)checkStandTextFieldBecomeFirstResponder:(HDCheckStandTextField *)textField;

- (void)checkStandTextFieldResignFirstResponder:(HDCheckStandTextField *)textField;

/**
 开始输入 begin editing

 @param textField 支付框
 */
- (void)checkStandTextFieldDidBeginEditing:(HDCheckStandTextField *)textField;

/**
 删除一个字符 delete a character

 @param textField 支付框
 */
- (void)checkStandTextFieldDidDelete:(HDCheckStandTextField *)textField;

/**
 清除完成 clear all characters

 @param textField 支付框
 */
- (void)checkStandTextFieldDidClear:(HDCheckStandTextField *)textField;

@end


@interface HDCheckStandTextField : UIControl

@property (nonatomic, weak) id<HDCheckStandTextFieldDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfCharacters;
@property (nonatomic, assign) HDCheckStandSecurityCharacterType securityCharacterType;
@property (nonatomic, assign) HDCheckStandTextFieldBorderType borderType;
@property (nonatomic, assign) CGFloat diameterOfDot;
@property (nonatomic, assign) CGSize securityImageSize;
@property (nonatomic, assign, readonly) NSInteger countOfVerification;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void (^completion)(HDCheckStandTextField *field, NSString *text);

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *colorOfCharacter;
@property (nonatomic, strong) UIImage *securityImage;

- (instancetype)initWithNumberOfCharacters:(NSInteger)numberOfCharacters
                     securityCharacterType:(HDCheckStandSecurityCharacterType)securityCharacterType
                                borderType:(HDCheckStandTextFieldBorderType)borderType;

- (void)insertText:(NSString *)text;
- (void)deleteBackward;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
