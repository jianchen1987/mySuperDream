//
//  PNPacketRecordDetailsHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordDetailsHeaderView.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNPacketRecordDetailsHeaderView ()
@property (nonatomic, strong) UIView *userNameBgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *remarksLabel;

@property (nonatomic, strong) SALabel *moneyLabel;
@property (nonatomic, strong) HDUIButton *transferToWalletBtn;

@property (nonatomic, assign) CGFloat maxNameWidth;
@end


@implementation PNPacketRecordDetailsHeaderView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };

    self.maxNameWidth = kScreenWidth - kRealWidth(48);

    [self addSubview:self.userNameBgView];
    [self addSubview:self.headImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.remarksLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.transferToWalletBtn];
}

- (void)updateConstraints {
    [self.userNameBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(32));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.headImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.top.bottom.left.mas_equalTo(self.userNameBgView);
    }];

    [self.nameLabel sizeToFit];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(self.userNameBgView.mas_right);
        make.centerY.mas_equalTo(self.headImgView.mas_centerY);
        if (self.nameLabel.hd_width > self.maxNameWidth) {
            make.width.equalTo(@(self.maxNameWidth));
        }
    }];

    [self.remarksLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.userNameBgView.mas_bottom).offset(kRealWidth(12));

        if ([self.viewType isEqualToString:@"send"]) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(32));
        }
    }];

    if ([self.viewType isEqualToString:@"reciver"]) {
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.remarksLabel.mas_bottom).offset(kRealWidth(32));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        }];

        [self.transferToWalletBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moneyLabel.mas_bottom);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(20));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketDetailModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.hearUrl placeholderImage:[UIImage imageNamed:@""] imageView:self.headImgView];

    NSString *packetType = model.packetType == PNPacketType_Nor ? PNLocalizedString(@"pn_Normal_packet", @"普通红包") : PNLocalizedString(@"pn_lucky_packet", @"口令红包");
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.sendName, packetType];
    self.remarksLabel.text = self.model.remarks;

    if ([self.viewType isEqualToString:@"reciver"]) {
        if (self.model.currentAmt.doubleValue > 0) {
            NSString *higStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.currentAmt currencyCode:PNCurrencyTypeKHR];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@", [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeKHR], higStr];
            self.moneyLabel.attributedText = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:40]
                                                                         highLightColor:[UIColor hd_colorWithHexString:@"#D0AB5C"]
                                                                                norFont:[HDAppTheme.PayNowFont fontDINBold:30]
                                                                               norColor:[UIColor hd_colorWithHexString:@"#D0AB5C"]];
            self.moneyLabel.hidden = NO;
            self.transferToWalletBtn.hidden = NO;
        } else {
            self.moneyLabel.hidden = YES;
            self.transferToWalletBtn.hidden = YES;
        }
    } else {
        self.moneyLabel.hidden = YES;
        self.transferToWalletBtn.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)userNameBgView {
    if (!_userNameBgView) {
        UIView *view = [[UIView alloc] init];
        _userNameBgView = view;
    }
    return _userNameBgView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _headImgView = imageView;

        _headImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
    }
    return _headImgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16M;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)remarksLabel {
    if (!_remarksLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        _remarksLabel = label;
    }
    return _remarksLabel;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#D0AB5C"];
        label.font = [HDAppTheme.PayNowFont fontDINBold:40];
        label.textAlignment = NSTextAlignmentCenter;
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (HDUIButton *)transferToWalletBtn {
    if (!_transferToWalletBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_packet_transer_to_wallet", @"领取成功，已存入钱包>") forState:0];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"#D0AB5C"] forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            [HDMediator.sharedInstance navigaveToPayNowBillListVC:@{}];
        }];

        _transferToWalletBtn = button;
    }
    return _transferToWalletBtn;
}

@end
