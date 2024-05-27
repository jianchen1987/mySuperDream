//
//  TNTransferInputView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferInputView.h"


@interface TNTransferInputView () <UITextFieldDelegate>
/// 左边图标
@property (strong, nonatomic) UIImageView *leftIV;
/// 左边文字
@property (strong, nonatomic) HDLabel *leftLB;
/// 右边输入框
@property (strong, nonatomic) UITextField *rightTF;
/// 底部分割线
@property (strong, nonatomic) UIView *lineView;
/// 电话号码  可供外部直接获取
@property (nonatomic, copy) NSString *phoneNum;
@end


@implementation TNTransferInputView
#pragma mark - UI
- (void)hd_setupViews {
    [self addSubview:self.leftIV];
    [self addSubview:self.leftLB];
    [self addSubview:self.rightTF];
    [self addSubview:self.lineView];
    NSString *loginName = [SAUser shared].loginName;
    if ([loginName hd_isPureDigitCharacters]) {
        if ([loginName hasPrefix:@"855"] && loginName.length > 3) { //只有855的手机号自动填充  填充的时候需要去掉855显示
            self.rightTF.text = [loginName substringFromIndex:3];
            [self textFieldDidChanged:self.rightTF];
        }
    }
}
- (void)updateConstraints {
    [self.leftIV sizeToFit];
    [self.leftIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftLB.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.rightTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLB.mas_right).offset(kRealWidth(20));
        make.width.mas_equalTo(kRealWidth(200));
        make.top.bottom.equalTo(self);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];
    [super updateConstraints];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regex = @"(([0-9]\\d{0,10}))?"; //最多输入11位
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}
- (void)textFieldDidChanged:(UITextField *)textField {
    self.phoneNum = textField.text;
}
#pragma mark - setter
- (void)setLeftText:(NSString *)leftText {
    _leftText = leftText;
    self.leftLB.text = leftText;
}
- (void)setHiddenRightView:(BOOL)hiddenRightView {
    _hiddenRightView = hiddenRightView;
    self.rightTF.hidden = hiddenRightView;
}
- (void)setHiddenBottomLineView:(BOOL)hiddenBottomLineView {
    _hiddenBottomLineView = hiddenBottomLineView;
    self.lineView.hidden = hiddenBottomLineView;
}
- (void)setDisableEdit:(BOOL)disableEdit {
    _disableEdit = disableEdit;
    self.rightTF.enabled = !disableEdit;
}
- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    self.rightTF.text = mobile;
    [self textFieldDidChanged:self.rightTF];
}
#pragma mark - 懒加载
- (UIImageView *)leftIV {
    if (!_leftIV) {
        _leftIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_required_tip"]];
    }
    return _leftIV;
}
/** @lazy leftLB */
- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[HDLabel alloc] init];
        _leftLB.font = HDAppTheme.TinhNowFont.standard15M;
        _leftLB.textColor = HDAppTheme.TinhNowColor.G1;
        _leftLB.text = TNLocalizedString(@"tn_tf_contact", @"联系电话");
    }
    return _leftLB;
}
/** @lazy rightTF */
- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.placeholder = TNLocalizedString(@"tn_input", @"请输入");
        _rightTF.textColor = HDAppTheme.TinhNowColor.G1;
        _rightTF.font = HDAppTheme.TinhNowFont.standard15M;
        _rightTF.keyboardType = UIKeyboardTypePhonePad;
        _rightTF.delegate = self;
        [_rightTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _rightTF;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
@end
