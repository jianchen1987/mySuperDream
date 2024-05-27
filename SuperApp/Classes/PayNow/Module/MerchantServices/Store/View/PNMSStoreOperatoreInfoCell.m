//
//  PNMSStoreOperatoreInfoCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatoreInfoCell.h"
#import "PNMSStoreOperatorInfoModel.h"


@interface PNMSStoreOperatoreInfoCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *roleLabel;
@property (nonatomic, strong) SALabel *phoneLabel;
@property (nonatomic, strong) HDUIButton *qrCodeBtn;
@property (nonatomic, strong) HDUIButton *unBindBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *verLine;
@end


@implementation PNMSStoreOperatoreInfoCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.roleLabel];
    [self.bgView addSubview:self.phoneLabel];
    [self.bgView addSubview:self.arrowImgView];
    [self.bgView addSubview:self.qrCodeBtn];
    [self.bgView addSubview:self.unBindBtn];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.verLine];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.nameLabel sizeToFit];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
    }];

    [self.roleLabel sizeToFit];
    [self.roleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(kRealWidth(5));
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
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

    [self.qrCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left);
        make.top.mas_equalTo(self.line.mas_bottom);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        if (!self.unBindBtn.hidden) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        } else {
            make.right.mas_equalTo(self.mas_right);
        }
    }];

    if (!self.unBindBtn.hidden) {
        [self.unBindBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.qrCodeBtn.mas_right);
            make.width.top.bottom.equalTo(self.qrCodeBtn);
        }];

        [self.verLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(PixelOne));
            make.top.mas_equalTo(self.line.mas_bottom).offset(kRealWidth(8));
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(8));
            make.left.mas_equalTo(self.qrCodeBtn.mas_right);
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(PNMSStoreOperatorInfoModel *)model {
    _model = model;

    self.nameLabel.text = self.model.userName;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"EflnCwt2", @"手机号"), self.model.operatorMobile];

    if (self.model.role == PNMSRoleType_STORE_MANAGER) {
        self.roleLabel.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.roleLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        self.roleLabel.text = PNLocalizedString(@"pn_store_manager_2", @"店长");
    } else {
        self.roleLabel.backgroundColor = [HDAppTheme.PayNowColor.mainThemeColor colorWithAlphaComponent:0.1];
        self.roleLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.roleLabel.text = PNLocalizedString(@"pn_store_Staff", @"店员");
    }

    if (VipayUser.shareInstance.role == PNMSRoleType_STORE_MANAGER && model.role == PNMSRoleType_STORE_MANAGER) {
        self.unBindBtn.hidden = YES;
    } else {
        self.unBindBtn.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

- (void)qrCodeAction {
    !self.qrCodeBlock ?: self.qrCodeBlock(self.model);
}

- (void)unBindAction {
    NSString *msg = [NSString stringWithFormat:PNLocalizedString(@"pn_reset_unbind_store_operator", @"您确认要解除此店员【%@】绑定吗？"), self.model.userName];
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

- (SALabel *)roleLabel {
    if (!_roleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.layer.cornerRadius = kRealWidth(4);
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(2), kRealWidth(3), kRealWidth(2), kRealWidth(3));
        _roleLabel = label;
    }
    return _roleLabel;
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

- (HDUIButton *)qrCodeBtn {
    if (!_qrCodeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_Staff_receiving_QR", @"店员收款码") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.c666666 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(14), 0, kRealWidth(14), 0);
        [button addTarget:self action:@selector(qrCodeAction) forControlEvents:UIControlEventTouchUpInside];

        _qrCodeBtn = button;
    }
    return _qrCodeBtn;
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
