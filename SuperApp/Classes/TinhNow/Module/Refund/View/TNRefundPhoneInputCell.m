//
//  TNRefundPhoneInputCell.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundPhoneInputCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNApplyRefundModel.h"


@interface TNRefundPhoneInputCell () <UITextFieldDelegate>
///
@property (nonatomic, strong) UILabel *titleLabel;
///
@property (nonatomic, strong) UITextField *textField;
///
@property (nonatomic, strong) UIView *line;
@end


@implementation TNRefundPhoneInputCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12.f);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12.f);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.height.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [super updateConstraints];
}

- (void)setUserPhone:(NSString *)userPhone {
    _userPhone = userPhone;

    self.textField.text = userPhone;
}

#pragma mark -
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.endEidtHandler) {
        self.endEidtHandler(textField.text);
    }
}

#pragma mark -
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _titleLabel.text = TNLocalizedString(@"tn_page_contact_title", @"联系电话");
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = TNLocalizedString(@"tn_input", @"请输入");
        _textField.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _line;
}

@end


@implementation TNRefundPhoneInputCellModel

@end
