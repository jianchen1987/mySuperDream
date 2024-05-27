//
//  SAAddOrModifyAddressPhoneView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressPhoneView.h"


@interface SAAddOrModifyAddressPhoneView () <HDUITextFieldDelegate>
/// 号码
@property (nonatomic, strong) HDUITextField *phoneNumberTF;
@end


@implementation SAAddOrModifyAddressPhoneView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"phone_number", @"号码");

    [self addSubview:self.phoneNumberTF];
    [super hd_setupViews];
}

- (void)updateConstraints {
    [super updateConstraints];

    // 覆盖父类
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self.phoneNumberTF.inputTextField);
    }];

    [self.phoneNumberTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-kRealWidth(15));
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.left.equalTo(self.titleLB.mas_right);
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [self.phoneNumberTF.inputTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
}

#pragma mark - setter
- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;

    [self.phoneNumberTF setTextFieldText:mobile];
}

#pragma mark - HDUITextFieldDelegate
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    !self.phoneNoDidEndEditing ?: self.phoneNoDidEndEditing(self.phoneNumberTF.validInputText);
}

#pragma mark - lazy load
- (HDUITextField *)phoneNumberTF {
    if (!_phoneNumberTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"contact_phone_number", @"联系手机号码") leftLabelString:@"855"];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.font.standard3;
        config.textColor = HDAppTheme.color.G1;
        config.leftLabelColor = HDAppTheme.color.G1;
        config.leftViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        config.shouldSeparatedTextWithSymbol = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumber;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.maxInputLength = 10;
        config.separatedFormat = @"xxx-xxx-xxxx";

        [textField setConfig:config];

        @HDWeakify(textField);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(textField);
            if (text.length <= 1) {
                if ([text hasPrefix:@"0"]) {
                    [textField updateConfigWithDict:@{@"separatedFormat": @"xxx-xxx-xxxx", @"maxInputLength": @(10)}];
                } else {
                    [textField updateConfigWithDict:@{@"separatedFormat": @"xx-xxx-xxxx", @"maxInputLength": @(9)}];
                }
            }

            !self.phoneNoDidChanged ?: self.phoneNoDidChanged(text);
        };

        textField.delegate = self;

        _phoneNumberTF = textField;
    }
    return _phoneNumberTF;
}
@end
