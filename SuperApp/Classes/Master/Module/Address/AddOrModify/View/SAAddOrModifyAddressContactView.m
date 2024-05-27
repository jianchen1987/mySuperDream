//
//  SAAddOrModifyAddressContactView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressContactView.h"
#import "WMOperationButton.h"
#import "SARadioView.h"


@interface SAAddOrModifyAddressContactView ()
/// 姓名
@property (nonatomic, strong) UITextField *nameTF;
/// 性别 男
@property (nonatomic, strong) HDUIButton *maleBTN;
/// 性别 女
@property (nonatomic, strong) HDUIButton *femaleBTN;
/// 选中的按钮
@property (nonatomic, strong) HDUIButton *selectedBTN;
@end


@implementation SAAddOrModifyAddressContactView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"contact_people", @"联系人");

    [self addSubview:self.nameTF];
    [self addSubview:self.maleBTN];
    [self addSubview:self.femaleBTN];

    [super hd_setupViews];

    // 默认选中男性
    [self selectedButtonWithGender:SAGenderMale];
}

- (void)updateConstraints {
    [self.femaleBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.size.mas_equalTo(self.femaleBTN.bounds.size);
    }];

    [self.maleBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.femaleBTN.mas_left).offset(-kRealWidth(10));
        make.size.mas_equalTo(self.maleBTN.bounds.size);
    }];

    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right);
        make.right.equalTo(self.maleBTN.mas_left);
        make.centerY.equalTo(self);
        make.top.equalTo(self.titleLB);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedBTNHandler:(WMOperationButton *)btn {
    if (btn.isSelected)
        return;

    btn.selected = true;
    self.selectedBTN.selected = false;
    self.selectedBTN = btn;
}

- (void)nameTextChange {
    if (self.nameTF.markedTextRange) {
        // 正在输入拼音，不做处理
        return;
    }
    self.nameTF.text = [self.nameTF.text hd_stringByReplacingPattern:@"[^a-z0-9A-Z\u1780-\u17FF\u19E0-\u19FF\u4e00-\u9fff\\s]" withString:@""];
}

#pragma mark - setter
- (void)setGender:(SAGender)gender {
    _gender = gender;

    if (HDIsStringNotEmpty(gender)) {
        [self selectedButtonWithGender:gender];
    }
}

- (void)setConsigneeName:(NSString *)consigneeName {
    _consigneeName = consigneeName;
    self.nameTF.text = consigneeName;
}

#pragma mark - private methods
- (void)selectedButtonWithGender:(SAGender)type {
    for (WMOperationButton *button in @[self.maleBTN, self.femaleBTN]) {
        SAGender t = button.hd_associatedObject;
        if ([t isEqualToString:type]) {
            [self clickedBTNHandler:button];
            break;
        }
    }
}

#pragma mark - lazy load
- (UITextField *)nameTF {
    if (!_nameTF) {
        UITextField *textField = UITextField.new;
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:SALocalizedString(@"name", @"姓名") attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G3}];
        textField.attributedPlaceholder = placeholder;
        textField.font = HDAppTheme.font.standard3;
        textField.textColor = HDAppTheme.color.G1;
        [textField addTarget:self action:@selector(nameTextChange) forControlEvents:UIControlEventEditingChanged];
        _nameTF = textField;
    }
    return _nameTF;
}

- (HDUIButton *)maleBTN {
    if (!_maleBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:SALocalizedString(@"man", @"男士") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"address_check_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"address_check_selected"] forState:UIControlStateSelected];
        button.spacingBetweenImageAndTitle = 5;
        [button sizeToFit];
        button.hd_associatedObject = @"M";
        _maleBTN = button;
    }
    return _maleBTN;
}

- (HDUIButton *)femaleBTN {
    if (!_femaleBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:SALocalizedString(@"woman", @"女士") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"address_check_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"address_check_selected"] forState:UIControlStateSelected];
        button.spacingBetweenImageAndTitle = 5;
        button.hd_associatedObject = @"F";
        [button sizeToFit];
        _femaleBTN = button;
    }
    return _femaleBTN;
}

@end
