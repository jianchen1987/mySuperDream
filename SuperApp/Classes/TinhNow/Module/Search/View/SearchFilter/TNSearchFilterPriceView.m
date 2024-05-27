//
//  TNSearchFilterPriceView.m
//  SuperApp
//
//  Created by seeu on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchFilterPriceView.h"


@interface TNSearchFilterPriceView () <UITextFieldDelegate>
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// lowest
@property (nonatomic, strong) UITextField *lowestTextField;
/// hightest
@property (nonatomic, strong) UITextField *highestTextField;
/// line
@property (nonatomic, strong) UIView *separatedLine;
/// 批量容器
@property (strong, nonatomic) UIView *batchContainer;
///
@property (strong, nonatomic) UILabel *batchLabel;
///
@property (strong, nonatomic) UISwitch *batchSwitch;
@end


@implementation TNSearchFilterPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.lowestTextField];
    [self addSubview:self.highestTextField];
    [self addSubview:self.separatedLine];
    [self addSubview:self.batchContainer];
    [self.batchContainer addSubview:self.batchLabel];
    [self.batchContainer addSubview:self.batchSwitch];
    [self.lowestTextField becomeFirstResponder];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(5);
    }];

    [self.lowestTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(90);
        if (self.batchContainer.isHidden) {
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }
        make.height.mas_equalTo(30);
    }];

    [self.separatedLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lowestTextField.mas_right).offset(6);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(20);
        make.centerY.equalTo(self.lowestTextField.mas_centerY);
    }];

    [self.highestTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separatedLine.mas_right).offset(6);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.lowestTextField);
    }];
    if (!self.batchContainer.isHidden) {
        [self.batchContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.lowestTextField.mas_bottom).offset(20);
            make.height.mas_equalTo(35);
        }];

        [self.batchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.batchContainer);
        }];
        [self.batchSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.batchContainer);
            make.size.mas_equalTo(CGSizeMake(50, 25));
        }];
    }
    [super updateConstraints];
}

- (CGFloat)TN_layoutWithWidth:(CGFloat)width {
    CGSize size = [self systemLayoutSizeFittingSize:CGSizeMake(width, CGFLOAT_MAX) withHorizontalFittingPriority:UILayoutPriorityDefaultHigh verticalFittingPriority:UILayoutPriorityDefaultLow];
    self.frame = CGRectMake(0, 0, size.width, size.height);
    return size.height;
}

- (NSDictionary<TNSearchFilterOptions, NSObject *> *)TN_currentOptions {
    NSMutableDictionary<TNSearchFilterOptions, NSObject *> *options = NSMutableDictionary.new;
    if (HDIsStringNotEmpty(self.lowestTextField.text)) {
        [options setObject:self.lowestTextField.text forKey:TNSearchFilterOptionsPriceLowest];
    } else {
        [options setObject:@"" forKey:TNSearchFilterOptionsPriceLowest];
    }

    if (HDIsStringNotEmpty(self.highestTextField.text)) {
        [options setObject:self.highestTextField.text forKey:TNSearchFilterOptionsPriceHighest];
    } else {
        [options setObject:@"" forKey:TNSearchFilterOptionsPriceHighest];
    }
    if (self.batchSwitch.isOn) { //开启了批量才有这个入参
        [options setObject:[NSString stringWithFormat:@"%d", self.batchSwitch.isOn] forKey:TNSearchFilterOptionsStagePrice];
    }
    return [NSDictionary dictionaryWithDictionary:options];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *regex = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,5}(([.]\\d{0,2})?)))?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

#pragma mark - setter
- (void)setLowest:(NSString *)lowest {
    _lowest = lowest;
    self.lowestTextField.text = lowest;
}

- (void)setHighest:(NSString *)highest {
    _highest = highest;
    self.highestTextField.text = highest;
}
- (void)setStagePrice:(BOOL)stagePrice {
    _stagePrice = stagePrice;
    self.batchSwitch.on = stagePrice;
}
/** @lazy titlelabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _titleLabel.text = TNLocalizedString(@"FnWMUMKZ", @"价格区间");
    }
    return _titleLabel;
}
/** @lazy lowestTestField */
- (UITextField *)lowestTextField {
    if (!_lowestTextField) {
        _lowestTextField = [[UITextField alloc] init];
        _lowestTextField.borderStyle = UITextBorderStyleNone;
        _lowestTextField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:TNLocalizedString(@"tn_text_filter_lowest_placeholder", @"lowest")
                                            attributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard12, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G3}];
        _lowestTextField.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _lowestTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _lowestTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        _lowestTextField.leftViewMode = UITextFieldViewModeAlways;
        _lowestTextField.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 4.0f;
            view.layer.masksToBounds = YES;
        };
        _lowestTextField.delegate = self;
    }
    return _lowestTextField;
}
/** @lazy highestTextFIeld */
- (UITextField *)highestTextField {
    if (!_highestTextField) {
        _highestTextField = [[UITextField alloc] init];
        _highestTextField.borderStyle = UITextBorderStyleNone;
        _highestTextField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:TNLocalizedString(@"tn_text_filter_highest_placeholder", @"highest")
                                            attributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard12, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G3}];
        _highestTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _highestTextField.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _highestTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        _highestTextField.leftViewMode = UITextFieldViewModeAlways;
        _highestTextField.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 4.0f;
            view.layer.masksToBounds = YES;
        };
        _highestTextField.delegate = self;
    }
    return _highestTextField;
}
/** @lazy line */
- (UIView *)separatedLine {
    if (!_separatedLine) {
        _separatedLine = [[UIView alloc] init];
        _separatedLine.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _separatedLine;
}
/** @lazy batchContainer */
- (UIView *)batchContainer {
    if (!_batchContainer) {
        _batchContainer = [[UIView alloc] init];
    }
    return _batchContainer;
}
/** @lazy batchLabel */
- (UILabel *)batchLabel {
    if (!_batchLabel) {
        _batchLabel = [[UILabel alloc] init];
        _batchLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _batchLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _batchLabel.text = TNLocalizedString(@"cDxe1XFc", @"支持批量");
    }
    return _batchLabel;
}
/** @lazy batchSwitch */
- (UISwitch *)batchSwitch {
    if (!_batchSwitch) {
        _batchSwitch = [[UISwitch alloc] init];
        [_batchSwitch setTintColor:HDAppTheme.TinhNowColor.cD6DBE8];
        [_batchSwitch setOnTintColor:HDAppTheme.TinhNowColor.C1];
    }
    return _batchSwitch;
}
@end
