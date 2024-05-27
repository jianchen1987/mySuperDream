//
//  PNBindMarketInfoAlertView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBindMarketInfoAlertView.h"
#import "HDAppTheme+PayNow.h"
#import "PNMultiLanguageManager.h"
#import "PNOperationButton.h"
#import "PNUtilMacro.h"
#import "SALabel.h"
#import "SANotificationConst.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "PNMarketingDTO.h"
#import <HDUIKit/NAT.h>
#import "UIView+NAT.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@interface PNBindMarketInfoAlertView () <HDUITextFieldDelegate>
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 副文本
@property (nonatomic, strong) SALabel *subTitleLabel;
/// 取消按钮 背景view
@property (nonatomic, strong) UIView *cancelBtnBgView;
/// 取消按钮
@property (strong, nonatomic) HDUIButton *cancelBtn;
/// 确定按钮 背景view
@property (nonatomic, strong) UIView *doneBtnBgView;
/// 确定按钮
@property (strong, nonatomic) HDUIButton *doneBtn;
/// 按钮上面的横线
@property (nonatomic, strong) UIView *verLine;
/// 两个按钮之间的 竖线
@property (nonatomic, strong) UIView *horline;

/// 电话title
@property (nonatomic, strong) SALabel *phoneTitleLabel;
///// 输入框TextField
@property (nonatomic, strong) HDUITextField *phoneTextField;
/// 电话title
@property (nonatomic, strong) SALabel *nameTitleLabel;
@property (nonatomic, strong) SALabel *nameValueLabel;

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) PNMarketingDTO *marketingDTO;


@property (nonatomic, strong) PNBindMarketingInfoAlertConfig *config;
@end


@implementation PNBindMarketInfoAlertView

- (instancetype)initAlertWithConfig:(PNBindMarketingInfoAlertConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}
#pragma mark - override
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.top.equalTo(self.mas_top).offset(kRealWidth(100));
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;
}

- (void)userLogoutHandler {
    [self dismiss];
}

- (void)setupContainerSubViews {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];

    // 给containerview添加子视图
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.subTitleLabel];
    [self.containerView addSubview:self.phoneTitleLabel];
    [self.containerView addSubview:self.phoneTextField];
    [self.containerView addSubview:self.nameTitleLabel];
    [self.containerView addSubview:self.nameValueLabel];
    [self.containerView addSubview:self.cancelBtnBgView];
    [self.cancelBtnBgView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.doneBtnBgView];
    [self.doneBtnBgView addSubview:self.doneBtn];
    [self.containerView addSubview:self.horline];
    [self.containerView addSubview:self.verLine];

    // 设置控件属性
    if (HDIsStringNotEmpty(self.config.textValue)) {
        [self.phoneTextField setTextFieldText:self.config.textValue];
    }

    if (WJIsStringNotEmpty(self.config.title)) {
        self.titleLabel.text = self.config.title;
        self.titleLabel.font = self.config.titleFont;
        self.titleLabel.textColor = self.config.titleColor;
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
    }

    if (WJIsStringNotEmpty(self.config.subTitle)) {
        self.subTitleLabel.text = self.config.subTitle;
        self.subTitleLabel.font = self.config.subTitleFont;
        self.subTitleLabel.textColor = self.config.subTitleColor;
        self.subTitleLabel.hidden = NO;
    } else {
        self.subTitleLabel.hidden = YES;
    }

    [self.cancelBtn setTitle:self.config.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:self.config.cancelButtonColor forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = self.config.cancelButtonFont;
    self.cancelBtn.backgroundColor = self.config.cancelButtonBackgroundColor;
    self.cancelBtn.layer.cornerRadius = kRealWidth(4);
    [self.cancelBtn sizeToFit];

    [self.doneBtn setTitle:self.config.doneButtonTitle forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:self.config.doneButtonColor forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = self.config.doneButtonFont;
    self.doneBtn.backgroundColor = self.config.doneButtonBackgroundColor;
    self.doneBtn.layer.cornerRadius = kRealWidth(4);
    [self.doneBtn sizeToFit];
}

- (void)layoutContainerViewSubViews {
    if (!self.titleLabel.hidden) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        }];
    }

    if (!self.subTitleLabel.hidden) {
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.titleLabel.hidden) {
                make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
            }
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        }];
    }

    [self.phoneTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.subTitleLabel.hidden) {
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(kRealWidth(17));
        } else {
            if (!self.titleLabel.hidden) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(17));
            } else {
                make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(32));
            }
        }
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
    }];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTitleLabel.mas_bottom).offset(kRealWidth(17));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        make.height.equalTo(@(kRealWidth(40)));
    }];

    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
    }];

    [self.nameValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTitleLabel.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
    }];


    [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.mas_equalTo(self.nameValueLabel.mas_bottom).offset(kRealWidth(32));

        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kRealWidth(56));
        make.height.equalTo(@(1));
    }];

    [self.cancelBtnBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left);
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(0.5);
    }];

    [self.doneBtnBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelBtnBgView.mas_right);
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.containerView.mas_width).multipliedBy(0.5);
    }];

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.cancelBtnBgView);
        make.width.equalTo(@(self.cancelBtn.width + 32));
        make.height.mas_equalTo(kRealWidth(32));
    }];

    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.doneBtnBgView);
        make.width.equalTo(@(self.doneBtn.width + 32));
        make.height.mas_equalTo(kRealWidth(32));
    }];

    [self.horline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verLine.mas_bottom);
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
        make.width.equalTo(@(1));
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
    }];
}

#pragma mark delegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldBeginEditing");
    return YES;
}

- (void)hd_textFieldDidBeginEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldDidBeginEditing");
}

- (BOOL)hd_textFieldShouldEndEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldEndEditing");
    return YES;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldDidEndEditing");
    if (HDIsStringNotEmpty(self.phoneTextField.validInputText)) {
        [self getCoolCashAccountName];
    }
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    HDLog(@"hd_textFieldDidEndEditing reason");
}

- (BOOL)hd_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    HDLog(@"hd_textField shouldChangeCharactersInRange replacementString");

    return YES;
}

- (BOOL)hd_textFieldShouldClear:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldClear");
    return YES;
}

- (BOOL)hd_textFieldShouldReturn:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldReturn");
    return YES;
}

#pragma mark
/// 清除文本
- (void)clearText {
    [self.phoneTextField setTextFieldText:@""];
    self.nameValueLabel.text = @"";
}

#pragma mark
- (void)getCoolCashAccountName {
    [self showloading];

    self.doneBtn.enabled = NO;
    NSString *phone = [NSString stringWithFormat:@"8550%@", self.phoneTextField.validInputText];
    @HDWeakify(self);
    [self.marketingDTO getCCAmountWithMobile:phone success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        HDLog(@"%@", rspModel.data);
        if ([rspModel.data isKindOfClass:NSDictionary.class]) {
            NSString *firstName = [rspModel.data objectForKey:@"firstName"] ?: @"";
            NSString *lastName = [rspModel.data objectForKey:@"lastName"] ?: @"";
            self.nameValueLabel.text = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
            self.doneBtn.enabled = YES;
        } else {
            self.nameValueLabel.text = @"";
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        self.nameValueLabel.text = @"";
    }];
}

/// 绑定推广员
- (void)bindAction:(void (^)(BOOL isSuccess))completion {
    [self showloading];
    @HDWeakify(self);
    NSString *phone = [NSString stringWithFormat:@"8550%@", self.phoneTextField.validInputText];
    [self.marketingDTO bindMarketing:VipayUser.shareInstance.loginName promoterLoginName:phone success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"qv3Liso5", @"绑定成功") type:HDTopToastTypeSuccess];
        !completion ?: completion(YES);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        !completion ?: completion(NO);
    }];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;

        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.numberOfLines = 0;

        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UIView *)cancelBtnBgView {
    if (!_cancelBtnBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft radius:kRealWidth(8)];
        };
        _cancelBtnBgView = view;
    }
    return _cancelBtnBgView;
}

- (HDUIButton *)cancelBtn {
    if (!_cancelBtn) {
        HDUIButton *btn = [[HDUIButton alloc] init];

        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.config.cancelHandler ?: self.config.cancelHandler(self);
        }];

        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (UIView *)doneBtnBgView {
    if (!_doneBtnBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomRight radius:kRealWidth(8)];
        };
        _doneBtnBgView = view;
    }
    return _doneBtnBgView;
}

- (HDUIButton *)doneBtn {
    if (!_doneBtn) {
        HDUIButton *btn = [[HDUIButton alloc] init];
        btn.enabled = NO;
        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self bindAction:^(BOOL isSuccess) {
                if (isSuccess) {
                    !self.config.doneHandler ?: self.config.doneHandler(self.phoneTextField.validInputText, self);
                }
            }];
        }];

        _doneBtn = btn;
    }
    return _doneBtn;
}

- (UIView *)verLine {
    if (!_verLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _verLine = view;
    }
    return _verLine;
}

- (UIView *)horline {
    if (!_horline) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _horline = view;
    }
    return _horline;
}

- (SALabel *)phoneTitleLabel {
    if (!_phoneTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"5GuGNYPi", @"请输入推广专员手机号");
        _phoneTitleLabel = label;
    }
    return _phoneTitleLabel;
}

- (HDUITextField *)phoneTextField {
    if (!_phoneTextField) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.PayNowFont.standard14;
        config.textColor = HDAppTheme.PayNowColor.c333333;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.placeholder = PNLocalizedString(@"tf_placeholder_phone_num", @"请输入手机号码");
        config.leftLabelString = @"8550";
        config.leftLabelColor = HDAppTheme.PayNowColor.c333333;
        config.leftLabelFont = HDAppTheme.PayNowFont.standard14;
        config.leftViewEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);

        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.clearButtonMode = UITextFieldViewModeWhileEditing;

        [textField setConfig:config];
        textField.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textField.layer.cornerRadius = kRealWidth(4);
        textField.delegate = self;

        _phoneTextField = textField;
    }
    return _phoneTextField;
}

- (SALabel *)nameTitleLabel {
    if (!_nameTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"pn_full_name_2", @"姓名");
        _nameTitleLabel = label;
    }
    return _nameTitleLabel;
}

- (SALabel *)nameValueLabel {
    if (!_nameValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        label.hd_edgeInsets = UIEdgeInsetsMake(15, 12, 12, 15);
        label.layer.cornerRadius = kRealWidth(4);
        label.text = @" ";
        _nameValueLabel = label;
    }
    return _nameValueLabel;
}

- (PNMarketingDTO *)marketingDTO {
    if (!_marketingDTO) {
        _marketingDTO = [[PNMarketingDTO alloc] init];
    }
    return _marketingDTO;
}

@end
