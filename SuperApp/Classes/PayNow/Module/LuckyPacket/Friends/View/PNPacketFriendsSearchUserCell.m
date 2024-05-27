//
//  PNPacketFriendsSearchUserCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsSearchUserCell.h"


@interface PNPacketFriendsSearchUserCell ()
@property (nonatomic, strong) UIImageView *userIconImgView;
@property (nonatomic, strong) SALabel *nameLabel;
///
@property (nonatomic, strong) SALabel *contentLabel;
@end


@implementation PNPacketFriendsSearchUserCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.userIconImgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.line];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kRealWidth(12));
        make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        make.top.bottom.equalTo(self.contentView);
    }];

    [self.userIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIconImgView.mas_right).offset(kRealWidth(8));
        make.top.mas_equalTo(self.userIconImgView.mas_top).offset(kRealWidth(4));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(6));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userIconImgView.mas_left);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-1);
        make.right.mas_equalTo(self.bgView.mas_right);
        make.height.equalTo(@(1));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketCoolCashUserModel *)model {
    _model = model;

    if (model.walletOpened) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.surname, model.name];
        self.nameLabel.textColor = HDAppTheme.PayNowColor.c333333;
    } else {
        self.nameLabel.text = PNLocalizedString(@"pn_not_open_wallet", @"还没开通钱包账户");
        self.nameLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
    }

    self.contentLabel.text = self.model.loginName;

    [HDWebImageManager setImageWithURL:self.model.headUrl placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:self.userIconImgView];

    [self setNeedsUpdateConstraints];
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

- (UIImageView *)userIconImgView {
    if (!_userIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _userIconImgView = imageView;
    }
    return _userIconImgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _line = view;
    }
    return _line;
}
@end
