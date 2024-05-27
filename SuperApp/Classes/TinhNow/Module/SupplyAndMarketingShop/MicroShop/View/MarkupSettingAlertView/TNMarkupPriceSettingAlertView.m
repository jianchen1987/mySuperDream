//
//  TNMarkupPriceSettingAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMarkupPriceSettingAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+extend.h"
#import "SAOperationButton.h"
#import "SATableView.h"
#import "SATableViewCell.h"
#import "TNDecimalTool.h"
#import "TNMicroShopDTO.h"
#import "TNMultiLanguageManager.h"
#import "TNProductSkuModel.h"
#import "TNView.h"
#import <HDKitCore.h>
#import <Masonry.h>
#pragma mark - TNBatchSettingView


@interface TNBatchSettingView : TNView
@property (strong, nonatomic) UILabel *keyLabel;        ///< 左边文本
@property (strong, nonatomic) HDUITextField *textFeild; ///<   输入框
@property (strong, nonatomic) UILabel *unitLabel;       ///< 右边文本
///  是否显示小数点
@property (nonatomic, assign) BOOL isAddPrice;
@end


@implementation TNBatchSettingView
- (instancetype)initWithLimitTextFeildAddPrice:(BOOL)addPrice {
    self.isAddPrice = addPrice;
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.keyLabel];
    [self addSubview:self.textFeild];
    [self addSubview:self.unitLabel];
    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:4];
    };
}
- (void)updateConstraints {
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kRealWidth(20));
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(14));
    }];
    [self.textFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.unitLabel.mas_left).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(150), kRealWidth(30)));
    }];
    [super updateConstraints];
}
/** @lazy keyLabel */
- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _keyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _keyLabel.text = TNLocalizedString(@"48s4Krw3", @"增加");
    }
    return _keyLabel;
}
/** @lazy unitLabel */
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = HDAppTheme.TinhNowFont.standard14;
        _unitLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _unitLabel.text = @"$";
    }
    return _unitLabel;
}
- (HDUITextField *)textFeild {
    if (!_textFeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:15];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        if (self.isAddPrice) {
            config.maxInputNumber = 9999.99;
        } else {
            config.maxInputNumber = 1000;
        }
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxDecimalsCount = 2;
        config.shouldAppendDecimalAfterEndEditing = YES;
        config.characterSetString = @"0123456789.,";
        config.allowModifyInputToMaxInputNumber = YES;
        config.bottomLineSelectedHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        [textField setConfig:config];
        textField.layer.borderColor = [UIColor colorWithRed:173 / 255.0 green:182 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.inputTextField.textAlignment = NSTextAlignmentCenter;
        _textFeild = textField;
    }
    return _textFeild;
}
@end

#pragma mark - TNMarkupPriceBatchSettingCell


@interface TNMarkupPriceBatchSettingCell : SATableViewCell <HDUITextFieldDelegate>
@property (strong, nonatomic) HDUIButton *addPriceBtn;                   ///< 按金额增加按钮
@property (strong, nonatomic) TNBatchSettingView *addPriceSettingView;   ///<金额操作视图
@property (strong, nonatomic) UILabel *addPriceDesLabel;                 ///<
@property (strong, nonatomic) HDUIButton *addScaleBtn;                   ///< 按比例增加按钮
@property (strong, nonatomic) TNBatchSettingView *addScaleSettingView;   ///<比例操作视图
@property (strong, nonatomic) UILabel *addScaleDesLabel;                 ///<
@property (strong, nonatomic) HDUIButton *addPriceAndScaleBtn;           ///< 按比例和金额增加按钮
@property (strong, nonatomic) TNBatchSettingView *fixedPriceSettingView; ///<固定金额操作视图
@property (strong, nonatomic) TNBatchSettingView *fixedScaleSettingView; ///<固定比例操作视图
@property (strong, nonatomic) UILabel *addPriceAndScaleDesLabel;         ///<
@property (strong, nonatomic) HDLabel *tipsLabel;                        ///< 提示文本
@property (strong, nonatomic) TNMicroShopPricePolicyModel *policyModel;  //加价策略模型
@property (nonatomic, copy) void (^editChangedCallBack)(void);           //输入改变回调
@property (nonatomic, copy) void (^endSetPolicyCallBack)(void);          //结束设置改价回调
@end


@implementation TNMarkupPriceBatchSettingCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.addPriceBtn];
    [self.contentView addSubview:self.addPriceDesLabel];
    [self.contentView addSubview:self.addPriceSettingView];
    [self.contentView addSubview:self.addScaleBtn];
    [self.contentView addSubview:self.addScaleDesLabel];
    [self.contentView addSubview:self.addScaleSettingView];
    [self.contentView addSubview:self.addPriceAndScaleBtn];
    [self.contentView addSubview:self.addPriceAndScaleDesLabel];
    [self.contentView addSubview:self.fixedScaleSettingView];
    [self.contentView addSubview:self.fixedPriceSettingView];
    [self.contentView addSubview:self.tipsLabel];

    //固定金额输入变化
    @HDWeakify(self);
    self.addPriceSettingView.textFeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        self.policyModel.additionValue = text;
        if (HDIsStringNotEmpty(text)) {
            [self updateUIByOperationType:TNMicroShopPricePolicyTypePrice];
        }
        !self.editChangedCallBack ?: self.editChangedCallBack();
    };

    self.addScaleSettingView.textFeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        self.policyModel.additionPercent = text;
        if (HDIsStringNotEmpty(text)) {
            [self updateUIByOperationType:TNMicroShopPricePolicyTypePercent];
        }
        !self.editChangedCallBack ?: self.editChangedCallBack();
    };

    self.fixedPriceSettingView.textFeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        self.policyModel.additionValue = text;
        if (HDIsStringNotEmpty(text)) {
            [self updateUIByOperationType:TNMicroShopPricePolicyTypeMixTure];
        }
        !self.editChangedCallBack ?: self.editChangedCallBack();
    };

    self.fixedScaleSettingView.textFeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        self.policyModel.additionPercent = text;
        if (HDIsStringNotEmpty(text)) {
            [self updateUIByOperationType:TNMicroShopPricePolicyTypeMixTure];
        }
        !self.editChangedCallBack ?: self.editChangedCallBack();
    };
}
- (void)setPolicyModel:(TNMicroShopPricePolicyModel *)policyModel {
    _policyModel = policyModel;
    if (self.policyModel.operationType == TNMicroShopPricePolicyTypePrice) {
        //按金额增加
        if (HDIsStringNotEmpty(self.policyModel.additionValue)) {
            [self.addPriceSettingView.textFeild setTextFieldText:[self.policyModel.additionValue stringCompletionPointZero:2]];
        }
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePercent) {
        //按固定比例
        if (HDIsStringNotEmpty(self.policyModel.additionPercent)) {
            [self.addScaleSettingView.textFeild setTextFieldText:self.policyModel.additionPercent];
        }
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypeMixTure) {
        //按比例和金额
        if (HDIsStringNotEmpty(self.policyModel.additionValue)) {
            [self.fixedPriceSettingView.textFeild setTextFieldText:[self.policyModel.additionValue stringCompletionPointZero:2]];
        }
        if (HDIsStringNotEmpty(self.policyModel.additionPercent)) {
            [self.fixedScaleSettingView.textFeild setTextFieldText:self.policyModel.additionPercent];
        }
    }
}

//刷新UI
- (void)updateUIByOperationType:(TNMicroShopPricePolicyType)operationType {
    self.policyModel.operationType = operationType;
    if (self.policyModel.operationType == TNMicroShopPricePolicyTypePrice) {
        //按金额增加
        self.addPriceBtn.selected = YES;
        self.addScaleBtn.selected = NO;
        self.addPriceAndScaleBtn.selected = NO;

        self.addScaleSettingView.textFeild.inputTextField.text = @"";
        self.fixedPriceSettingView.textFeild.inputTextField.text = @"";
        self.fixedScaleSettingView.textFeild.inputTextField.text = @"";

    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePercent) {
        //按固定比例
        self.addPriceBtn.selected = NO;
        self.addScaleBtn.selected = YES;
        self.addPriceAndScaleBtn.selected = NO;

        self.addPriceSettingView.textFeild.inputTextField.text = @"";
        self.fixedPriceSettingView.textFeild.inputTextField.text = @"";
        self.fixedScaleSettingView.textFeild.inputTextField.text = @"";
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypeMixTure) {
        //按比例和金额
        self.addPriceBtn.selected = NO;
        self.addScaleBtn.selected = NO;
        self.addPriceAndScaleBtn.selected = YES;

        self.addScaleSettingView.textFeild.inputTextField.text = @"";
        self.addPriceSettingView.textFeild.inputTextField.text = @"";
    }
}
// HDUITextField delegate
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    [self respondsToEndSetCallBack];
}
//响应回调
- (void)respondsToEndSetCallBack {
    if (self.policyModel.operationType == TNMicroShopPricePolicyTypePrice) {
        if (HDIsStringNotEmpty(self.policyModel.additionValue)) {
            !self.endSetPolicyCallBack ?: self.endSetPolicyCallBack();
        }
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePercent) {
        if (HDIsStringNotEmpty(self.policyModel.additionPercent)) {
            ///百分比 最大1000
            if (self.policyModel.additionPercent.floatValue > 1000) {
                self.policyModel.additionPercent = @"1000";
                [self.addScaleSettingView.textFeild setTextFieldText:self.policyModel.additionPercent];
            }
            !self.endSetPolicyCallBack ?: self.endSetPolicyCallBack();
        }
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypeMixTure) {
        if (HDIsStringNotEmpty(self.policyModel.additionPercent) && HDIsStringNotEmpty(self.policyModel.additionValue)) {
            !self.endSetPolicyCallBack ?: self.endSetPolicyCallBack();
        }
        if (HDIsStringNotEmpty(self.policyModel.additionPercent)) {
            if (self.policyModel.additionPercent.floatValue > 1000) {
                self.policyModel.additionPercent = @"1000";
                [self.fixedScaleSettingView.textFeild setTextFieldText:self.policyModel.additionPercent];
            }
        }
    }
}

- (void)updateConstraints {
    [self.addPriceBtn sizeToFit];
    [self.addPriceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];
    [self.addPriceSettingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceBtn.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.addPriceDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceSettingView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.addScaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceDesLabel.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];
    [self.addScaleSettingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addScaleBtn.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.addScaleDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addScaleSettingView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.addPriceAndScaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addScaleDesLabel.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
    }];
    [self.fixedScaleSettingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceAndScaleBtn.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.fixedPriceSettingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixedScaleSettingView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.addPriceAndScaleDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixedPriceSettingView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.tipsLabel sizeToFit];
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPriceAndScaleDesLabel.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
/** @lazy addPriceBtn */
- (HDUIButton *)addPriceBtn {
    if (!_addPriceBtn) {
        _addPriceBtn = [[HDUIButton alloc] init];
        [_addPriceBtn setTitle:TNLocalizedString(@"OiyI7Yv4", @"按金额增加") forState:UIControlStateNormal];
        [_addPriceBtn setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_addPriceBtn setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _addPriceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_addPriceBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _addPriceBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_addPriceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (btn.isSelected) {
                return;
            }
            btn.selected = !btn.isSelected;
            [self.addPriceSettingView.textFeild becomeFirstResponder];
            self.policyModel.additionPercent = @"";
            self.policyModel.additionValue = @"";
            [self updateUIByOperationType:TNMicroShopPricePolicyTypePrice];
        }];
    }
    return _addPriceBtn;
}
/** @lazy addPriceSettingView */
- (TNBatchSettingView *)addPriceSettingView {
    if (!_addPriceSettingView) {
        _addPriceSettingView = [[TNBatchSettingView alloc] initWithLimitTextFeildAddPrice:YES];
        _addPriceSettingView.keyLabel.text = TNLocalizedString(@"48s4Krw3", @"增加");
        _addPriceSettingView.unitLabel.text = @"$";
        _addPriceSettingView.textFeild.delegate = self;
    }
    return _addPriceSettingView;
}
/** @lazy addPriceDesLabel */
- (UILabel *)addPriceDesLabel {
    if (!_addPriceDesLabel) {
        _addPriceDesLabel = [[UILabel alloc] init];
        _addPriceDesLabel.font = HDAppTheme.TinhNowFont.standard12;
        _addPriceDesLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _addPriceDesLabel.numberOfLines = 0;
        _addPriceDesLabel.text = TNLocalizedString(@"ppfTLgqX", @"例如商品批发价是$10.00，固定金额为$3.50，销售价=$10.00+$3.50=$13.50");
    }
    return _addPriceDesLabel;
}
/** @lazy addScaleBtn */
- (HDUIButton *)addScaleBtn {
    if (!_addScaleBtn) {
        _addScaleBtn = [[HDUIButton alloc] init];
        [_addScaleBtn setTitle:TNLocalizedString(@"yhFG91ef", @"按固定比例") forState:UIControlStateNormal];
        [_addScaleBtn setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_addScaleBtn setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _addScaleBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_addScaleBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _addScaleBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_addScaleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (btn.isSelected) {
                return;
            }
            btn.selected = !btn.isSelected;
            self.policyModel.additionPercent = @"";
            self.policyModel.additionValue = @"";
            [self.addScaleSettingView.textFeild becomeFirstResponder];
            [self updateUIByOperationType:TNMicroShopPricePolicyTypePercent];
        }];
    }
    return _addScaleBtn;
}
/** @lazy addScaleSettingView */
- (TNBatchSettingView *)addScaleSettingView {
    if (!_addScaleSettingView) {
        _addScaleSettingView = [[TNBatchSettingView alloc] initWithLimitTextFeildAddPrice:NO];
        _addScaleSettingView.keyLabel.text = TNLocalizedString(@"48s4Krw3", @"增加");
        _addScaleSettingView.unitLabel.text = @"%";
        _addScaleSettingView.textFeild.delegate = self;
    }
    return _addScaleSettingView;
}
/** @lazy addScaleDesLabel */
- (UILabel *)addScaleDesLabel {
    if (!_addScaleDesLabel) {
        _addScaleDesLabel = [[UILabel alloc] init];
        _addScaleDesLabel.font = HDAppTheme.TinhNowFont.standard12;
        _addScaleDesLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _addScaleDesLabel.numberOfLines = 0;
        _addScaleDesLabel.text = TNLocalizedString(@"fT7d7RH8", @"例如商品批发价是$10.00，固定比例为$10%，销售价=$10.00x（1+10%）=$11.00");
    }
    return _addScaleDesLabel;
}
/** @lazy addPriceAndScaleBtn */
- (HDUIButton *)addPriceAndScaleBtn {
    if (!_addPriceAndScaleBtn) {
        _addPriceAndScaleBtn = [[HDUIButton alloc] init];
        [_addPriceAndScaleBtn setTitle:TNLocalizedString(@"CBp2ZNgi", @"按比例+金额") forState:UIControlStateNormal];
        [_addPriceAndScaleBtn setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_addPriceAndScaleBtn setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _addPriceAndScaleBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_addPriceAndScaleBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _addPriceAndScaleBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_addPriceAndScaleBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (btn.isSelected) {
                return;
            }
            btn.selected = !btn.isSelected;
            self.policyModel.additionPercent = @"";
            self.policyModel.additionValue = @"";
            [self.fixedScaleSettingView.textFeild becomeFirstResponder];
            [self updateUIByOperationType:TNMicroShopPricePolicyTypeMixTure];
        }];
    }
    return _addPriceAndScaleBtn;
}
/** @lazy fixedScaleSettingView */
- (TNBatchSettingView *)fixedScaleSettingView {
    if (!_fixedScaleSettingView) {
        _fixedScaleSettingView = [[TNBatchSettingView alloc] initWithLimitTextFeildAddPrice:NO];
        _fixedScaleSettingView.keyLabel.text = TNLocalizedString(@"Nm1uzdq4", @"固定比例");
        _fixedScaleSettingView.unitLabel.text = @"%";
        _fixedScaleSettingView.textFeild.delegate = self;
    }
    return _fixedScaleSettingView;
}
/** @lazy fixedPriceSettingView */
- (TNBatchSettingView *)fixedPriceSettingView {
    if (!_fixedPriceSettingView) {
        _fixedPriceSettingView = [[TNBatchSettingView alloc] initWithLimitTextFeildAddPrice:YES];
        _fixedPriceSettingView.keyLabel.text = TNLocalizedString(@"47ZS6Lxe", @"固定金额");
        _fixedPriceSettingView.unitLabel.text = @"$";
        _fixedPriceSettingView.textFeild.delegate = self;
    }
    return _fixedPriceSettingView;
}
/** @lazy addPriceDesLabel */
- (UILabel *)addPriceAndScaleDesLabel {
    if (!_addPriceAndScaleDesLabel) {
        _addPriceAndScaleDesLabel = [[UILabel alloc] init];
        _addPriceAndScaleDesLabel.font = HDAppTheme.TinhNowFont.standard12;
        _addPriceAndScaleDesLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _addPriceAndScaleDesLabel.numberOfLines = 0;
        _addPriceAndScaleDesLabel.text = TNLocalizedString(@"pwOl0Xvn", @"例如商品批发价是$10.00，固定比例为$10%，固定金额为$3.50，销售价={$10.00x（1+10%）}+$3.50=$14.50");
    }
    return _addPriceAndScaleDesLabel;
}
/** @lazy tipsLabel */
- (HDLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[HDLabel alloc] init];
        _tipsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _tipsLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hd_edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _tipsLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:26 / 255.0 alpha:0.1];
        //        _tipsLabel.text = TNLocalizedString(@"lh2qHdTn", @"在批发价基础上增加，选购分销商品销售价会自动加价，也可以在我的店铺修改商品销售价");
        _tipsLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _tipsLabel;
}
@end

#pragma mark - TNMarkupPriceSkuSettingCell


@interface TNMarkupPriceSkuSettingCell : SATableViewCell <HDUITextFieldDelegate>
@property (strong, nonatomic) UILabel *titleLabel;            ///< 标题
@property (strong, nonatomic) UILabel *specDesLabel;          ///<  规格描述文本
@property (strong, nonatomic) UIView *supplyPriceView;        ///<  批发价视图
@property (strong, nonatomic) UILabel *supplyPriceKeyLabel;   ///< 批发价key
@property (strong, nonatomic) UILabel *supplyPriceValueLabel; ///< 批发价值
@property (strong, nonatomic) UIView *salePriceView;          ///<  销售价价视图
@property (strong, nonatomic) UILabel *salePriceKeyLabel;     ///< 销售价key
@property (strong, nonatomic) UILabel *salePriceValueLabel;   ///< 销售价

@property (strong, nonatomic) UIView *addPriceView;             ///<  加价视图
@property (strong, nonatomic) UILabel *addPriceKeyLabel;        ///< 加价key
@property (strong, nonatomic) HDUITextField *addPriceTextFeild; ///<  加价金额 输入框
@property (strong, nonatomic) TNProductSkuModel *skuModel;

@end


@implementation TNMarkupPriceSkuSettingCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.specDesLabel];
    [self.contentView addSubview:self.supplyPriceView];
    [self.supplyPriceView addSubview:self.supplyPriceKeyLabel];
    [self.supplyPriceView addSubview:self.supplyPriceValueLabel];
    [self.contentView addSubview:self.salePriceView];
    [self.salePriceView addSubview:self.salePriceKeyLabel];
    [self.salePriceView addSubview:self.salePriceValueLabel];
    [self.contentView addSubview:self.addPriceView];
    [self.addPriceView addSubview:self.addPriceKeyLabel];
    [self.addPriceView addSubview:self.addPriceTextFeild];
}
- (void)setSkuModel:(TNProductSkuModel *)skuModel {
    _skuModel = skuModel;
    self.specDesLabel.text = [skuModel.specifications componentsJoinedByString:@" / "];
    self.supplyPriceValueLabel.text = [skuModel.bulkPrice.amount stringCompletionPointZero:2];
    if (HDIsStringNotEmpty(skuModel.showSalePrice)) {
        self.salePriceValueLabel.text = [skuModel.showSalePrice stringCompletionPointZero:2];
    } else {
        self.salePriceValueLabel.text = [skuModel.price.amount stringCompletionPointZero:2];
    }

    if (HDIsStringNotEmpty(skuModel.changedPrice)) {
        self.addPriceTextFeild.inputTextField.text = [skuModel.changedPrice stringCompletionPointZero:2];
    } else {
        self.addPriceTextFeild.inputTextField.text = [skuModel.additionValue stringCompletionPointZero:2];
    }
}
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    if (HDIsStringEmpty(self.skuModel.changedPrice)) {
        self.skuModel.changedPrice = @"0";
        self.addPriceTextFeild.inputTextField.text = @"0";
    }
    //销售价 = 批发价 + 加价
    NSDecimalNumber *salePrice = [TNDecimalTool stringDecimalAddingBy:self.skuModel.bulkPrice.amount num2:self.skuModel.changedPrice];
    self.skuModel.showSalePrice = [[TNDecimalTool roundingNumber:salePrice afterPoint:2] stringValue];
    self.salePriceValueLabel.text = [self.skuModel.showSalePrice stringCompletionPointZero:2];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
        make.height.mas_equalTo(kRealWidth(20));
    }];
    [self.specDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(kRealWidth(30));
    }];
    [self.supplyPriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.specDesLabel.mas_bottom);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.supplyPriceKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.supplyPriceView.mas_centerY);
        make.left.equalTo(self.supplyPriceView.mas_left).offset(kRealWidth(15));
    }];
    [self.supplyPriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.supplyPriceView.mas_centerY);
        make.right.equalTo(self.supplyPriceView.mas_right).offset(-kRealWidth(15));
    }];

    [self.addPriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.supplyPriceView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.addPriceKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addPriceView.mas_centerY);
        make.left.equalTo(self.addPriceView.mas_left).offset(kRealWidth(15));
    }];
    [self.addPriceTextFeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addPriceView.mas_centerY);
        make.right.equalTo(self.addPriceView.mas_right).offset(-kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(100), kRealWidth(30)));
    }];

    [self.salePriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.addPriceView.mas_bottom);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.salePriceKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.salePriceView.mas_centerY);
        make.left.equalTo(self.salePriceView.mas_left).offset(kRealWidth(15));
    }];
    [self.salePriceValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.salePriceView.mas_centerY);
        make.right.equalTo(self.salePriceView.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.text = TNLocalizedString(@"PTH72dLR", @"商品规格");
    }
    return _titleLabel;
}
/** @lazy specDesLabel */
- (UILabel *)specDesLabel {
    if (!_specDesLabel) {
        _specDesLabel = [[UILabel alloc] init];
        _specDesLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _specDesLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _specDesLabel.hd_borderPosition = HDViewBorderPositionBottom;
        _specDesLabel.hd_borderColor = HexColor(0xD6DBE8);
        _specDesLabel.hd_borderWidth = 0.5;
        _specDesLabel.hd_borderLocation = HDViewBorderLocationInside;
    }
    return _specDesLabel;
}
/** @lazy supplyPriceView */
- (UIView *)supplyPriceView {
    if (!_supplyPriceView) {
        _supplyPriceView = [[UIView alloc] init];
    }
    return _supplyPriceView;
}
/** @lazy supplyPriceKeyLabel */
- (UILabel *)supplyPriceKeyLabel {
    if (!_supplyPriceKeyLabel) {
        _supplyPriceKeyLabel = [[UILabel alloc] init];
        _supplyPriceKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _supplyPriceKeyLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _supplyPriceKeyLabel.text = TNLocalizedString(@"QZb4mhlv", @"批发价($)");
    }
    return _supplyPriceKeyLabel;
}
/** @lazy supplyPriceValueLabel */
- (UILabel *)supplyPriceValueLabel {
    if (!_supplyPriceValueLabel) {
        _supplyPriceValueLabel = [[UILabel alloc] init];
        _supplyPriceValueLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _supplyPriceValueLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
    }
    return _supplyPriceValueLabel;
}

/** @lazy addPriceView */
- (UIView *)addPriceView {
    if (!_addPriceView) {
        _addPriceView = [[UIView alloc] init];
    }
    return _addPriceView;
}
/** @lazy addPriceKeyLabel */
- (UILabel *)addPriceKeyLabel {
    if (!_addPriceKeyLabel) {
        _addPriceKeyLabel = [[UILabel alloc] init];
        _addPriceKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _addPriceKeyLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _addPriceKeyLabel.text = TNLocalizedString(@"add_price", @"加价金额");
    }
    return _addPriceKeyLabel;
}

/** @lazy salePriceView */
- (UIView *)salePriceView {
    if (!_salePriceView) {
        _salePriceView = [[UIView alloc] init];
    }
    return _salePriceView;
}
/** @lazy salePriceKeyLabel */
- (UILabel *)salePriceKeyLabel {
    if (!_salePriceKeyLabel) {
        _salePriceKeyLabel = [[UILabel alloc] init];
        _salePriceKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _salePriceKeyLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _salePriceKeyLabel.text = TNLocalizedString(@"7vkfTSRV", @"销售价($)");
    }
    return _salePriceKeyLabel;
}
/** @lazy salePriceValueLabel */
- (UILabel *)salePriceValueLabel {
    if (!_salePriceValueLabel) {
        _salePriceValueLabel = [[UILabel alloc] init];
        _salePriceValueLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _salePriceValueLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
    }
    return _salePriceValueLabel;
}
- (HDUITextField *)addPriceTextFeild {
    if (!_addPriceTextFeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.TinhNowFont.standard14;
        config.textColor = HexColor(0xFF2323);
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxDecimalsCount = 2;
        config.shouldAppendDecimalAfterEndEditing = YES;
        //        config.maxInputNumber = 999999.99;
        config.bottomLineSelectedHeight = 0;
        config.characterSetString = @"0123456789.,";
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        [textField setConfig:config];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            if (HDIsStringNotEmpty(text)) {
                self.skuModel.changedPrice = text;
            } else {
                self.skuModel.changedPrice = @"0";
            }
            //销售价 = 批发价 + 加价
            NSDecimalNumber *salePrice = [TNDecimalTool stringDecimalAddingBy:self.skuModel.bulkPrice.amount num2:self.skuModel.changedPrice];
            self.skuModel.showSalePrice = [[TNDecimalTool roundingNumber:salePrice afterPoint:2] stringValue];
            self.salePriceValueLabel.text = [self.skuModel.showSalePrice stringCompletionPointZero:2];
        };
        textField.delegate = self;
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 4;
        textField.inputTextField.textAlignment = NSTextAlignmentCenter;
        _addPriceTextFeild = textField;
    }
    return _addPriceTextFeild;
}
@end


@interface TNMarkupPriceSettingAlertView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) TNMarkupPriceSettingConfig *config;         ///<
@property (strong, nonatomic) HDLabel *titleLabel;                        /// 标题
@property (nonatomic, strong) HDUIButton *closeBTN;                       /// 关闭按钮
@property (strong, nonatomic) UIView *batchSettingView;                   ///<批量设置背景视图
@property (strong, nonatomic) HDUIButton *batchBtn;                       ///<批量按钮
@property (strong, nonatomic) SATableView *tableView;                     ///<
@property (strong, nonatomic) HDUIButton *confirBtn;                      ///<
@property (strong, nonatomic) HDTableViewSectionModel *batchSectionModel; ///< 批量设置组
@property (strong, nonatomic) HDTableViewSectionModel *skuSectionModel;   ///< sku组
@property (strong, nonatomic) NSMutableArray *dataArr;                    ///<
@property (strong, nonatomic) TNMicroShopDTO *dto;
@property (strong, nonatomic) TNMicroShopPricePolicyModel *policyModel; //加价策略模型
@property (nonatomic, assign) BOOL isNeedShowBatchBtn;
@property (nonatomic, assign) BOOL isSelectedBatchSetting; /// 是否选择了批量选择
@end


@implementation TNMarkupPriceSettingAlertView
- (instancetype)initAlertViewWithConfig:(TNMarkupPriceSettingConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        if (config.type == TNMarkupPriceSettingTypeSingleProduct) {
            ///不需要单个sku改价
            if (!HDIsArrayEmpty(config.skus)) {
                //本地计算差值
                [config.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    //差价 = 销售价 - 批发价
                    NSDecimalNumber *difPrice = [TNDecimalTool stringDecimalSubtractingBy:obj.price.amount num2:obj.bulkPrice.amount];
                    obj.additionValue = [[TNDecimalTool roundingNumber:difPrice afterPoint:2] stringValue];
                }];

                //                [self.dataArr addObject:self.skuSectionModel];
                //                self.isNeedShowBatchBtn = YES;
            }
            //            else {
            self.isSelectedBatchSetting = YES;
            [self.dataArr addObject:self.batchSectionModel];
            //            }
        } else if (config.type == TNMarkupPriceSettingTypeBatchProduct) {
            [self.dataArr addObject:self.batchSectionModel];
        } else {
            //查看是否有默认的配置
            if (!HDIsObjectNil([TNGlobalData shared].seller.pricePolicyModel)) {
                self.policyModel = [TNMicroShopPricePolicyModel copyPricePolicyModelWithOriginalModel:[TNGlobalData shared].seller.pricePolicyModel];
            }
            [self.dataArr addObject:self.batchSectionModel];
        }
    }
    return self;
}
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height - kRealWidth(80), 0);
}
- (void)keyboardWillHide:(NSNotification *)noti {
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)checkConfirmBtnEnable {
    __block BOOL enable = YES;
    @HDWeakify(self);
    void (^setEnable)(void) = ^{
        @HDStrongify(self);
        if (self.policyModel.operationType == TNMicroShopPricePolicyTypeNone) {
            enable = NO;
        } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePrice) {
            if (HDIsStringEmpty(self.policyModel.additionValue)) {
                enable = NO;
            }
        } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePercent) {
            if (HDIsStringEmpty(self.policyModel.additionPercent)) {
                enable = NO;
            }
        } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypeMixTure) {
            if (HDIsStringEmpty(self.policyModel.additionPercent) || HDIsStringEmpty(self.policyModel.additionValue)) {
                enable = NO;
            }
        }
    };
    if (self.config.type == TNMarkupPriceSettingTypeGlobal || self.config.type == TNMarkupPriceSettingTypeBatchProduct) {
        setEnable();
    } else if (self.config.type == TNMarkupPriceSettingTypeSingleProduct) {
        if (self.isSelectedBatchSetting) {
            setEnable();
        }
    }
    self.confirBtn.enabled = enable;
    if (enable) {
        self.confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
    } else {
        self.confirBtn.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
}
#pragma mark -设置全局加价策略
- (void)setMicroShopPricePolicy {
    [self showloading];
    @HDWeakify(self);
    [self.dto setSellPricePolicyWithSupplierId:[TNGlobalData shared].seller.supplierId policyModel:self.policyModel success:^(TNMicroShopPricePolicyModel *_Nonnull policyModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [TNGlobalData shared].seller.pricePolicyModel = self.policyModel; //替换最新的配置
        [HDTips showWithText:TNLocalizedString(@"lcOXit4u", @"设置成功")];
        !self.setPricePolicyCompleteCallBack ?: self.setPricePolicyCompleteCallBack();
        [self dismiss];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}
#pragma mark -设置单个商品加价
- (void)setSingleProductPrice {
    if (self.isSelectedBatchSetting) {
        //打开了批量设置
        NSMutableArray *array = [NSMutableArray array];
        for (TNProductSkuModel *model in self.config.skus) {
            if (HDIsStringNotEmpty(model.changedPrice) && ![model.changedPrice isEqualToString:model.additionValue]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"skuId"] = model.skuId;
                dict[@"type"] = @"0";
                dict[@"productId"] = self.config.productId;
                dict[@"supplierId"] = [TNGlobalData shared].seller.supplierId;
                dict[@"operationType"] = @"1"; //手动改价  都是按金额的
                dict[@"additionValue"] = model.changedPrice;
                [array addObject:dict];
            }
        }
        [self requestChangeProductPriceByType:1 array:array];
    } else {
        //只修改sku价格的话   哪个修改了  传哪个
        NSMutableArray *array = [NSMutableArray array];
        for (TNProductSkuModel *model in self.config.skus) {
            if (HDIsStringNotEmpty(model.changedPrice) && ![model.changedPrice isEqualToString:model.additionValue]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"skuId"] = model.skuId;
                dict[@"type"] = @"0";
                dict[@"productId"] = self.config.productId;
                dict[@"supplierId"] = [TNGlobalData shared].seller.supplierId;
                dict[@"operationType"] = @"1"; //手动改价  都是按金额的
                dict[@"additionValue"] = model.changedPrice;
                [array addObject:dict];
            }
        }
        if (!HDIsArrayEmpty(array)) {
            [self requestChangeProductPriceByType:0 array:array];
        } else {
            //未修改任何价格  直接退出
            [self dismiss];
        }
    }
}

#pragma mark -设置批量商品加价
- (void)setBatchProductPrice {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *productId in self.config.products) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"productId"] = productId;
        dict[@"type"] = @"0"; //写死0  分销加价
        [dict addEntriesFromDictionary:[self.policyModel yy_modelToJSONObject]];
        dict[@"supplierId"] = [TNGlobalData shared].seller.supplierId;
        [array addObject:dict];
    }
    [self requestChangeProductPriceByType:2 array:array];
}

//请求改价接口   type 修改类型（0修改单个商品价格，1批量修改单个商品价格，2批量修改多个商品价格）
- (void)requestChangeProductPriceByType:(NSInteger)type array:(NSArray *)array {
    [self showloading];
    @HDWeakify(self);
    [self.dto changeProductPriceByDictArray:array type:type success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:TNLocalizedString(@"lcOXit4u", @"设置成功")];
        !self.setPricePolicyCompleteCallBack ?: self.setPricePolicyCompleteCallBack();
        [self dismiss];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark -根据加价策略更新全部sku价格
- (void)updateSkuPriceByPolicy {
    //全局改价后  单次改价的数据重置
    if (self.policyModel.operationType == TNMicroShopPricePolicyTypePrice) {
        [self.config.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.changedPrice = self.policyModel.additionValue;
            //销售价 = 批发价 + 加价
            NSDecimalNumber *salePrice = [TNDecimalTool stringDecimalAddingBy:obj.bulkPrice.amount num2:obj.additionValue];
            obj.showSalePrice = [[TNDecimalTool roundingNumber:salePrice afterPoint:2] stringValue];
        }];
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypePercent) {
        [self.config.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSDecimalNumber *percentNumber = [TNDecimalTool stringDecimalDividingBy:self.policyModel.additionPercent num2:@"100"];
            NSDecimalNumber *price = [TNDecimalTool stringDecimalMultiplyingBy:[percentNumber stringValue] num2:obj.bulkPrice.amount];
            obj.changedPrice = [[TNDecimalTool roundingNumber:price afterPoint:2] stringValue];

            //销售价 = 批发价 + 加价
            NSDecimalNumber *salePrice = [TNDecimalTool stringDecimalAddingBy:obj.bulkPrice.amount num2:obj.additionValue];
            obj.showSalePrice = [[TNDecimalTool roundingNumber:salePrice afterPoint:2] stringValue];
        }];
    } else if (self.policyModel.operationType == TNMicroShopPricePolicyTypeMixTure) {
        [self.config.skus enumerateObjectsUsingBlock:^(TNProductSkuModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSDecimalNumber *percentNumber = [TNDecimalTool stringDecimalDividingBy:self.policyModel.additionPercent num2:@"100"];
            NSDecimalNumber *percentPrice = [TNDecimalTool stringDecimalMultiplyingBy:[percentNumber stringValue] num2:obj.bulkPrice.amount];
            NSDecimalNumber *price = [TNDecimalTool stringDecimalAddingBy:[percentPrice stringValue] num2:self.policyModel.additionValue];
            obj.changedPrice = [[TNDecimalTool roundingNumber:price afterPoint:2] stringValue];

            //销售价 = 批发价 + 加价
            NSDecimalNumber *salePrice = [TNDecimalTool stringDecimalAddingBy:obj.bulkPrice.amount num2:obj.additionValue];
            obj.showSalePrice = [[TNDecimalTool roundingNumber:salePrice afterPoint:2] stringValue];
        }];
    }
    [self.tableView successLoadMoreDataWithNoMoreData:YES];
}

#pragma mark - HDActionAlertViewOverridable

- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];

    @HDWeakify(self);
    self.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    };
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    if (self.isNeedShowBatchBtn) {
        [self.containerView addSubview:self.batchSettingView];
        [self.batchSettingView addSubview:self.batchBtn];
    }
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.confirBtn];
    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self checkConfirmBtnEnable];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(11));
    }];
    UIView *lastView = self.titleLabel;
    if (self.isNeedShowBatchBtn) {
        lastView = self.batchSettingView;
        [self.batchSettingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(kRealWidth(45));
        }];
        [self.batchBtn sizeToFit];
        [self.batchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.batchSettingView.mas_centerY);
            make.left.equalTo(self.batchSettingView.mas_left).offset(kRealWidth(15));
        }];
    }

    CGFloat height = kScreenHeight - kRealWidth(35) - kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight - kRealWidth(90) - kNavigationBarH;

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.confirBtn.mas_top).offset(-kRealWidth(8));
        make.height.mas_equalTo(height);
    }];
    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(35));
    }];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArr[section];
    return sectionModel.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    if (sectionModel == self.skuSectionModel) {
        return kRealWidth(195);
    }
    return UITableViewAutomaticDimension;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    HDTableViewSectionModel *sectionModel = self.dataArr[section];
//    if (sectionModel == self.skuSectionModel) {
//        return kRealWidth(10);
//    }
//    return 0;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
        headView.model = sectionModel.headerModel;
        return headView;
    } else {
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    if (sectionModel == self.skuSectionModel) {
        TNProductSkuModel *model = sectionModel.list[indexPath.row];
        TNMarkupPriceSkuSettingCell *cell = [TNMarkupPriceSkuSettingCell cellWithTableView:tableView];
        cell.skuModel = model;
        return cell;
    } else if (sectionModel == self.batchSectionModel) {
        TNMarkupPriceBatchSettingCell *cell = [TNMarkupPriceBatchSettingCell cellWithTableView:tableView];
        cell.tipsLabel.text = self.config.tips;
        cell.policyModel = self.policyModel;
        @HDWeakify(self);
        cell.editChangedCallBack = ^{
            @HDStrongify(self);
            [self checkConfirmBtnEnable];
        };
        cell.endSetPolicyCallBack = ^{
            @HDStrongify(self);
            [self updateSkuPriceByPolicy];
        };
        return cell;
    }
    return UITableViewCell.new;
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = self.config.title;
    }
    return _titleLabel;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy batchSettingView */
- (UIView *)batchSettingView {
    if (!_batchSettingView) {
        _batchSettingView = [[UIView alloc] init];
    }
    return _batchSettingView;
}
/** @lazy batchBtn */
- (HDUIButton *)batchBtn {
    if (!_batchBtn) {
        _batchBtn = [[HDUIButton alloc] init];
        [_batchBtn setTitle:TNLocalizedString(@"gzi49m3Y", @"批量设置") forState:UIControlStateNormal];
        [_batchBtn setImage:[UIImage imageNamed:@"tinhnow-unselect_agree_k"] forState:UIControlStateNormal];
        [_batchBtn setImage:[UIImage imageNamed:@"tinhnow-selected_agree_k"] forState:UIControlStateSelected];
        _batchBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_batchBtn setTitleColor:HDAppTheme.TinhNowColor.C1 forState:UIControlStateNormal];
        _batchBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_batchBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            self.isSelectedBatchSetting = btn.isSelected;
            [self.dataArr removeAllObjects];
            if (btn.isSelected) {
                [self.dataArr addObjectsFromArray:@[self.batchSectionModel, self.skuSectionModel]];
            } else {
                [self.dataArr addObject:self.skuSectionModel];
            }
            [self checkConfirmBtnEnable];
            [self.tableView successGetNewDataWithNoMoreData:YES];
        }];
    }
    return _batchBtn;
}
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.estimatedRowHeight = 150;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 30;
    }
    return _tableView;
}
/** @lazy confirBtn */
- (HDUIButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [[HDUIButton alloc] init];
        _confirBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_confirBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [_confirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:20];
        };
        @HDWeakify(self);
        [_confirBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self endEditing:YES];
            if (self.config.type == TNMarkupPriceSettingTypeGlobal) {
                [self setMicroShopPricePolicy];
            } else if (self.config.type == TNMarkupPriceSettingTypeSingleProduct) {
                [self setSingleProductPrice];
            } else if (self.config.type == TNMarkupPriceSettingTypeBatchProduct) {
                [self setBatchProductPrice];
            }
        }];
    }
    return _confirBtn;
}
/** @lazy batchSectionModel */
- (HDTableViewSectionModel *)batchSectionModel {
    if (!_batchSectionModel) {
        _batchSectionModel = [[HDTableViewSectionModel alloc] init];
        _batchSectionModel.list = @[@""];
    }
    return _batchSectionModel;
}
/** @lazy skuSectionModel */
- (HDTableViewSectionModel *)skuSectionModel {
    if (!_skuSectionModel) {
        _skuSectionModel = [[HDTableViewSectionModel alloc] init];
        _skuSectionModel.list = self.config.skus;
        HDTableHeaderFootViewModel *header = [[HDTableHeaderFootViewModel alloc] init];
        header.title = TNLocalizedString(@"sale_price_calculate", @"销售价=批发价+加价金额");
        header.titleColor = HDAppTheme.TinhNowColor.C1;
        header.titleFont = HDAppTheme.TinhNowFont.standard12;
        _skuSectionModel.headerModel = header;
    }
    return _skuSectionModel;
}
/** @lazy dataArr */
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/** @lazy dto */
- (TNMicroShopDTO *)dto {
    if (!_dto) {
        _dto = [[TNMicroShopDTO alloc] init];
    }
    return _dto;
}
/** @lazy policyModel */
- (TNMicroShopPricePolicyModel *)policyModel {
    if (!_policyModel) {
        _policyModel = [[TNMicroShopPricePolicyModel alloc] init];
    }
    return _policyModel;
}
@end
