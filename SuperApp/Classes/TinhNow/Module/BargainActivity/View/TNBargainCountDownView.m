//
//  TNBargainCountDownView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNBargainCountDownView.h"
#define insetSpace 3
#define itemWH kRealWidth(26)


@interface TNBargainCountDownView ()
/// 时
@property (strong, nonatomic) HDLabel *hourLabel;
/// 分
@property (strong, nonatomic) HDLabel *minuteLabel;
/// 秒
@property (strong, nonatomic) HDLabel *secondLabel;
/// 后缀文本
@property (strong, nonatomic) HDLabel *suffixLabel;
/// ：
@property (strong, nonatomic) HDLabel *symbolOneLabel;
/// ：
@property (strong, nonatomic) HDLabel *symbolTwoLabel;
/// 当前语言
@property (nonatomic, copy) SALanguageType currentLanguage;
/// 小时数
@property (nonatomic, assign) NSInteger hour;
@end


@implementation TNBargainCountDownView
- (void)hd_setupViews {
    [self addSubview:self.hourLabel];
    [self addSubview:self.minuteLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.suffixLabel];
    [self addSubview:self.symbolOneLabel];
    [self addSubview:self.symbolTwoLabel];
    self.currentLanguage = [SAMultiLanguageManager currentLanguage];
}
- (void)setSuffixText:(NSString *)suffixText {
    _suffixText = suffixText;
    if (HDIsStringNotEmpty(suffixText)) {
        self.suffixLabel.hidden = NO;
        self.suffixLabel.text = suffixText;
    } else {
        self.suffixLabel.hidden = YES;
    }
    [self updateConstraintsIfNeeded];
}
- (void)updateHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    self.hour = hour;
    if (hour > 0) {
        self.hourLabel.text = [NSString stringWithFormat:@"%02ld", hour];
    } else {
        self.hourLabel.text = @"00";
    }
    if (minute > 0) {
        self.minuteLabel.text = [NSString stringWithFormat:@"%02ld", minute];
    } else {
        self.minuteLabel.text = @"00";
    }
    if (second > 0) {
        self.secondLabel.text = [NSString stringWithFormat:@"%02ld", second];
    } else {
        self.secondLabel.text = @"00";
    }
}
- (void)updateConstraints {
    [self.hourLabel sizeToFit];
    [self.hourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if ([self.currentLanguage isEqualToString:SALanguageTypeEN]) {
            make.left.equalTo(self.suffixLabel.mas_right).offset(kRealWidth(10));
        } else {
            make.left.equalTo(self.mas_left);
        }
        make.top.bottom.equalTo(self);
        make.height.mas_equalTo(itemWH);
        if (self.hour < 100) { //小于三位数的小时 固定宽度
            make.width.mas_equalTo(itemWH);
        }
    }];
    [self.symbolOneLabel sizeToFit];
    [self.symbolOneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.hourLabel.mas_top).offset(-2);
        make.height.mas_equalTo(itemWH);
    }];
    [self.minuteLabel sizeToFit];
    [self.minuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolOneLabel.mas_right).offset(kRealWidth(4));
        make.centerY.equalTo(self.hourLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(itemWH, itemWH));
    }];
    [self.symbolTwoLabel sizeToFit];
    [self.symbolTwoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.mas_right).offset(kRealWidth(4));
        make.top.equalTo(self.hourLabel.mas_top).offset(-2);
        make.height.mas_equalTo(itemWH);
    }];
    [self.secondLabel sizeToFit];
    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolTwoLabel.mas_right).offset(kRealWidth(4));
        make.centerY.equalTo(self.hourLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(itemWH, itemWH));
        if (self.suffixLabel.isHidden || [self.currentLanguage isEqualToString:SALanguageTypeEN]) {
            make.right.equalTo(self.mas_right);
        }
    }];
    if (!self.suffixLabel.isHidden) {
        [self.suffixLabel sizeToFit];
        [self.suffixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([self.currentLanguage isEqualToString:SALanguageTypeEN]) {
                make.left.equalTo(self.mas_left);
            } else {
                make.left.equalTo(self.secondLabel.mas_right).offset(kRealWidth(10));
                make.right.equalTo(self.mas_right);
            }
            make.centerY.equalTo(self.hourLabel.mas_centerY);
        }];
    }

    [super updateConstraints];
}
/** @lazy hourLabel */
- (HDLabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[HDLabel alloc] init];
        _hourLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#EC293E"];
        _hourLabel.textColor = [UIColor whiteColor];
        _hourLabel.font = HDAppTheme.TinhNowFont.standard15;
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.text = @"00";
        _hourLabel.hd_edgeInsets = UIEdgeInsetsMake(0, insetSpace, 0, insetSpace);
        _hourLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _hourLabel;
}
/** @lazy minuteLabel */
- (HDLabel *)minuteLabel {
    if (!_minuteLabel) {
        _minuteLabel = [[HDLabel alloc] init];
        _minuteLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#EC293E"];
        _minuteLabel.textColor = [UIColor whiteColor];
        _minuteLabel.font = HDAppTheme.TinhNowFont.standard15;
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.text = @"00";
        _minuteLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _minuteLabel;
}
/** @lazy secondLabel */
- (HDLabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[HDLabel alloc] init];
        _secondLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#EC293E"];
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.font = HDAppTheme.TinhNowFont.standard15;
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.text = @"00";
        _secondLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _secondLabel;
}
/** @lazy symbolOneLabel */
- (HDLabel *)symbolOneLabel {
    if (!_symbolOneLabel) {
        _symbolOneLabel = [[HDLabel alloc] init];
        _symbolOneLabel.textColor = [UIColor hd_colorWithHexString:@"#EC293E"];
        _symbolOneLabel.text = @":";
        _symbolOneLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _symbolOneLabel;
}
/** @lazy symbolTwoLabel */
- (HDLabel *)symbolTwoLabel {
    if (!_symbolTwoLabel) {
        _symbolTwoLabel = [[HDLabel alloc] init];
        _symbolTwoLabel.textColor = [UIColor hd_colorWithHexString:@"#EC293E"];
        _symbolTwoLabel.text = @":";
        _symbolTwoLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _symbolTwoLabel;
}
/** @lazy suffixLabel */
- (HDLabel *)suffixLabel {
    if (!_suffixLabel) {
        _suffixLabel = [[HDLabel alloc] init];
        _suffixLabel.textColor = [UIColor hd_colorWithHexString:@"#FE2337"];
        _suffixLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _suffixLabel;
}
@end
