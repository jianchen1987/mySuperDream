//
//  PNMSOperatorListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorListCell.h"
#import "PNMSOperatorInfoModel.h"


@interface PNMSOperatorListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *phoneLabel;
@property (nonatomic, strong) HDUIButton *resetPwdBtn;
@property (nonatomic, strong) HDUIButton *unBindBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *verLine;
@end


@implementation PNMSOperatorListCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.phoneLabel];
    [self.bgView addSubview:self.arrowImgView];
    [self.bgView addSubview:self.resetPwdBtn];
    [self.bgView addSubview:self.unBindBtn];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.verLine];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
    }];

    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(12));
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(-kRealWidth(4));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(kRealWidth(16));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
    }];

    [self.resetPwdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left);
        make.top.mas_equalTo(self.line.mas_bottom);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];

    [self.unBindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resetPwdBtn.mas_right);
        make.width.top.bottom.equalTo(self.resetPwdBtn);
    }];

    [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.line.mas_bottom).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(8));
        make.left.mas_equalTo(self.resetPwdBtn.mas_right);
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSOperatorInfoModel *)model {
    _model = model;

    self.nameLabel.text = self.model.name;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"EflnCwt2", @"手机号"), self.model.operatorMobile];

    [self setNeedsUpdateConstraints];
}

- (void)resetPwdAction {
    NSString *msg = [NSString stringWithFormat:PNLocalizedString(@"pn_reset_operator_pwd", @"确定要重置账号“%@”的交易密码吗？"), self.model.name];
    [NAT showAlertWithMessage:msg confirmButtonTitle:PNLocalizedString(@"pn_confirm", @"确认") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
        !self.resetPasswordBlock ?: self.resetPasswordBlock(self.model);
    } cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
    }];
}

- (void)unBindAction {
    NSString *msg = [NSString stringWithFormat:PNLocalizedString(@"pn_reset_unbind_operator", @"您确认要解除此操作员【%@】绑定吗？"), self.model.name];
    [NAT showAlertWithMessage:msg confirmButtonTitle:PNLocalizedString(@"pn_confirm", @"确认") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
        !self.unBindBlock ?: self.unBindBlock(self.model);
    } cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
    }];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)phoneLabel {
    if (!_phoneLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        _phoneLabel = label;
    }
    return _phoneLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_icon_black_arrow"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (HDUIButton *)resetPwdBtn {
    if (!_resetPwdBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_Reset_transaction_password", @"重置交易密码") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c666666 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(14), 0, kRealWidth(14), 0);
        [button addTarget:self action:@selector(resetPwdAction) forControlEvents:UIControlEventTouchUpInside];

        _resetPwdBtn = button;
    }
    return _resetPwdBtn;
}

- (HDUIButton *)unBindBtn {
    if (!_unBindBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_Unbind", @"解除绑定") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12M;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(14), 0, kRealWidth(14), 0);
        [button addTarget:self action:@selector(unBindAction) forControlEvents:UIControlEventTouchUpInside];

        _unBindBtn = button;
    }
    return _unBindBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}

- (UIView *)verLine {
    if (!_verLine) {
        _verLine = [[UIView alloc] init];
        _verLine.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _verLine;
}
@end
