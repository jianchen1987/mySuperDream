//
//  TNWithdrawBindItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawBindItemView.h"


@implementation TNWithdrawBindItemConfig

+ (instancetype)configWithType:(TNWithdrawBindItemViewType)type
                          text:(NSString *_Nullable)text
                         title:(NSString *)title
                   placeholder:(NSString *)placeholder
                     rightText:(NSString *_Nullable)rightText
              rightPlaceholder:(NSString *_Nullable)rightPlaceholder {
    TNWithdrawBindItemConfig *config = [[TNWithdrawBindItemConfig alloc] init];
    config.type = type;
    config.title = title;
    config.placeholder = placeholder;
    config.rightText = rightText;
    config.rightPlaceholder = rightPlaceholder;
    return config;
}

@end


@interface TNWithdrawBindItemView () <HDUITextFieldDelegate>
@property (nonatomic, strong) HDLabel *titleLabel;
@property (strong, nonatomic) HDUITextField *textFeild;         ///<
@property (strong, nonatomic) HDUITextField *rightTextFeild;    ///<
@property (strong, nonatomic) TNWithdrawBindItemConfig *config; ///<
@end


@implementation TNWithdrawBindItemView

+ (instancetype)itemViewWithConfig:(TNWithdrawBindItemConfig *)config {
    TNWithdrawBindItemView *itemView = [[TNWithdrawBindItemView alloc] initWithConfig:config];
    return itemView;
}
- (instancetype)initWithConfig:(TNWithdrawBindItemConfig *)config {
    if (self = [super init]) {
        self.config = config;
        [self setupViews];
    }
    return self;
}
- (void)setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textFeild];
    if (self.config.type == TNWithdrawBindItemViewType_DoubleInput) {
        [self addSubview:self.rightTextFeild];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    [self.textFeild setTextFieldText:text];
}
- (void)setRightText:(NSString *)rightText {
    _rightText = rightText;
    [self.rightTextFeild setTextFieldText:rightText];
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(20));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
    }];
    if (self.config.type == TNWithdrawBindItemViewType_DoubleInput) {
        [self.textFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-20));
            make.right.mas_equalTo(self.rightTextFeild.mas_left).offset(-kRealWidth(20));
            make.height.equalTo(@(kRealWidth(45)));
        }];
        [self.rightTextFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.textFeild.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(15));
            make.height.equalTo(@(kRealWidth(45)));
            make.width.equalTo(self.textFeild.mas_width).dividedBy(1.4);
        }];
    } else {
        [self.textFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-20));
            make.height.equalTo(@(kRealWidth(45)));
        }];
    }
    [super updateConstraints];
}

- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.config.type == TNWithdrawBindItemViewType_Alert) {
        !self.itemClickCallBack ?: self.itemClickCallBack();
        return NO;
    }
    return YES;
}

#pragma mark
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _titleLabel.font = HDAppTheme.TinhNowFont.standard15M;
        _titleLabel.text = self.config.title;
    }
    return _titleLabel;
}

- (HDUITextField *)textFeild {
    if (!_textFeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = self.config.placeholder;
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];

        if (self.config.type == TNWithdrawBindItemViewType_Alert) {
            config.rightIconImage = [UIImage imageNamed:@"tn_arrow_blac_white"];
            config.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 13);
            [textField setConfig:config];
        } else {
            [textField setConfig:config];
            [textField setCustomRightView:UIView.new];
        }

        [textField setCustomLeftView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            !self.itemTextDidChangeCallBack ?: self.itemTextDidChangeCallBack(text);
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.delegate = self;
        _textFeild = textField;
    }
    return _textFeild;
}
- (HDUITextField *)rightTextFeild {
    if (!_rightTextFeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = self.config.rightPlaceholder;
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomRightView:UIView.new];
        [textField setCustomLeftView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            !self.itemRightTextDidChangeCallBack ?: self.itemRightTextDidChangeCallBack(text);
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.delegate = self;
        _rightTextFeild = textField;
    }
    return _rightTextFeild;
}
@end
