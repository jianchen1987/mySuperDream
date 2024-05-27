//
//  GNPromoCodeView.m
//  SuperApp
//
//  Created by wmz on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNPromoCodeView.h"


@implementation GNPromoCodeView

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.textField];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(28));
        make.centerX.equalTo(self);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(14));
        make.left.mas_equalTo(kRealWidth(46));
        make.right.mas_equalTo(-kRealWidth(46));
        make.height.mas_equalTo(kRealWidth(27));
        make.bottom.mas_equalTo(-kRealWidth(28));
    }];

    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = textField.text.length - range.length + string.length;
    return length <= 20;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        UILabel *titleLB = UILabel.new;
        titleLB.text = WMLocalizedString(@"P82qTdqX", @"请输入促销码获取立减优惠");
        titleLB.textColor = [UIColor hd_colorWithHexString:@"#838383"];
        titleLB.font = [HDAppTheme.font gn_ForSize:12];
        _titleLB = titleLB;
    }
    return _titleLB;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = HDAppTheme.color.G4.CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = kRealWidth(13.5);
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField = textField;
    }
    return _textField;
}

@end
