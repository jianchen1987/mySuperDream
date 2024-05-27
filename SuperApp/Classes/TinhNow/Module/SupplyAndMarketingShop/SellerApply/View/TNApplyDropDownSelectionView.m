//
//  TNApplyDropDownSelectionView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNApplyDropDownSelectionView.h"
#import "NSString+extend.h"
#import "TNSingleSelectedAlertView.h"


@interface TNApplyDropDownSelectionView () <HDUITextFieldDelegate>
@property (strong, nonatomic) UILabel *keyLabel;        ///<文本
@property (strong, nonatomic) HDUITextField *textfeild; ///<选择框
/// 文本文案
@property (nonatomic, copy) NSString *keytext;
/// 占位文案
@property (nonatomic, copy) NSString *placeHoldText;

@end


@implementation TNApplyDropDownSelectionView
- (instancetype)initSelectionViewWithKeyText:(NSString *)keyText placeHoldText:(NSString *)placeHoldText {
    self.keytext = keyText;
    self.placeHoldText = placeHoldText;
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.keyLabel];
    [self addSubview:self.textfeild];
}
- (void)updateConstraints {
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];
    [self.textfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.keyLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(35));
    }];
    [super updateConstraints];
}
#pragma mark -setter
- (void)setCurrentValueText:(NSString *)currentValueText {
    _currentValueText = currentValueText;
    [self.textfeild setTextFieldText:currentValueText];
}
- (void)setKeyValueArray:(NSArray<NSDictionary *> *)keyValueArray {
    _keyValueArray = keyValueArray;
}
#pragma mark -HDUITextFieldDelegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    [self showChannelAlertView];
    return NO;
}
// 了解渠道弹窗
- (void)showChannelAlertView {
    [KeyWindow endEditing:YES];
    TNSingleSelectedAlertConfig *config = [[TNSingleSelectedAlertConfig alloc] init];
    config.title = self.placeHoldText;
    NSMutableArray *dataArr = [NSMutableArray array];
    if (!HDIsArrayEmpty(self.keyValueArray)) {
        for (NSDictionary *dict in self.keyValueArray) {
            TNSingleSelectedItem *item = [[TNSingleSelectedItem alloc] init];
            item.itemId = dict[@"key"];
            item.name = dict[@"value"];
            if ([self.currentValueText isEqualToString:item.name]) {
                item.selected = YES;
            }
            [dataArr addObject:item];
        }
    }
    config.dataArr = dataArr;
    TNSingleSelectedAlertView *alertView = [[TNSingleSelectedAlertView alloc] initWithConfig:config];
    @HDWeakify(self);
    alertView.selectedItemCallBack = ^(TNSingleSelectedItem *_Nonnull item) {
        @HDStrongify(self);
        !self.selectedCallBack ?: self.selectedCallBack(item.itemId, item.name);
        //        [self.textfeild setTextFieldText:item.name];
        self.currentValueText = item.name;
    };
    [alertView show];
}
/** @lazy channelKeyLabel */
- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _keyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        NSString *starName = @"*";
        NSString *keyStr = [NSString stringWithFormat:@"%@%@", starName, self.keytext];
        NSMutableAttributedString *attr = [NSString highLightString:starName inLongString:keyStr font:HDAppTheme.TinhNowFont.standard14 color:HexColor(0xFF2323)];
        _keyLabel.attributedText = attr;
    }
    return _keyLabel;
}
- (HDUITextField *)textfeild {
    if (!_textfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = self.placeHoldText;
        //        TNLocalizedString(@"k2UgCi7p", @"请选择信息来源的渠道");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        config.rightIconImage = [UIImage imageNamed:@"tn_drop_down"];
        config.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        textField.clickRightImageViewBlock = ^{
            [self showChannelAlertView];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.delegate = self;
        _textfeild = textField;
    }
    return _textfeild;
}
@end
