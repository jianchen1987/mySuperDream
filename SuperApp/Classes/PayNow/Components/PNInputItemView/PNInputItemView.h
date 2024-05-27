//
//  PNInputItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNInputItemModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ValueChangedBlock)(NSString *text);

@class PNInputItemView;

@protocol PNInputItemViewDelegate <NSObject>

@optional
- (BOOL)pn_textFieldShouldBeginEditing:(UITextField *)textField view:(PNInputItemView *)view;
- (void)pn_textFieldDidBeginEditing:(UITextField *)textField view:(PNInputItemView *)view;
- (BOOL)pn_textFieldShouldEndEditing:(UITextField *)textField view:(PNInputItemView *)view;
- (void)pn_textFieldDidEndEditing:(UITextField *)textField view:(PNInputItemView *)view;
- (void)pn_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason view:(PNInputItemView *)view;
- (BOOL)pn_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string view:(PNInputItemView *)view;
- (BOOL)pn_textFieldShouldClear:(UITextField *)textField view:(PNInputItemView *)view;
- (BOOL)pn_textFieldShouldReturn:(UITextField *)textField view:(PNInputItemView *)view;

@end

/// 输入框， 上下居中显示 【场景：用户信息的输入】
@interface PNInputItemView : PNView
@property (nonatomic, strong) PNInputItemModel *model;

@property (nonatomic, weak) id<PNInputItemViewDelegate> delegate;

/// 读取当前输入框的内容
@property (nonatomic, strong, readonly) NSString *inputText;

@property (nonatomic, strong, readonly) UITextField *textFiled;

/// 字符发生变化时候回调
@property (nonatomic, copy) ValueChangedBlock valueChangedBlock;

- (void)update;
@end

NS_ASSUME_NONNULL_END
