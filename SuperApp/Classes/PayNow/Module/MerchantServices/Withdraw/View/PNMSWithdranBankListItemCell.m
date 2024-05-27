//
//  PNMSWithdranBankListItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdranBankListItemCell.h"
#import "PNMSWithdranBankInfoModel.h"
#import "SAAppEnvManager.h"
#import "UIColor+Extend.h"


@interface PNMSWithdranBankListItemCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *accountNameLabel;
@property (nonatomic, strong) SALabel *cardNumLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@end


@implementation PNMSWithdranBankListItemCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.accountNameLabel];
    [self.bgView addSubview:self.cardNumLabel];
    [self.bgView addSubview:self.arrowImgView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(38), kRealWidth(38)));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(kRealWidth(8));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(18));
        make.right.mas_equalTo(self.cardNumLabel.mas_left).offset(-kRealWidth(12));
    }];

    [self.accountNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.cardNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(-kRealWidth(12)).priorityHigh();
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.iconImgView.mas_centerY);
    }];

    [self.cardNumLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNMSWithdranBankInfoModel *)model {
    _model = model;

    NSString *logoURLStr = [NSString stringWithFormat:@"%@/files/files/app/%@", SAAppEnvManager.sharedInstance.appEnvConfig.payFileServer, model.bankImage];
    [HDWebImageManager setImageWithURL:logoURLStr placeholderImage:[UIImage imageNamed:@"toBank1"] imageView:self.iconImgView];

    self.nameLabel.text = model.bankName;
    self.accountNameLabel.text = model.accountName;

    if (model.accountNumber.length > 4) {
        ///遮掩一下
        NSString *newStr = [model.accountNumber stringByReplacingCharactersInRange:NSMakeRange(0, model.accountNumber.length - 4) withString:@"****"];

        self.cardNumLabel.text = newStr;
    } else {
        self.cardNumLabel.text = model.accountNumber;
    }

    if (WJIsStringNotEmpty(model.bgColor)) {
        NSArray *arr = [model.bgColor componentsSeparatedByString:@","];
        if (arr.count > 1) {
            self.bgView.backgroundColor = [UIColor tn_colorGradientChangeWithSize:CGSizeMake(kScreenWidth, 100) direction:TNGradientChangeDirectionLevel
                                                                       startColor:[UIColor hd_colorWithHexString:arr[0]]
                                                                         endColor:[UIColor hd_colorWithHexString:arr[1]]];
        } else if (arr.count == 1) {
            self.bgView.backgroundColor = [UIColor tn_colorGradientChangeWithSize:CGSizeMake(kScreenWidth, 100) direction:TNGradientChangeDirectionLevel startColor:arr[0]
                                                                         endColor:[UIColor hd_colorWithHexString:arr[0]]];
        } else {
            self.bgView.backgroundColor = [UIColor tn_colorGradientChangeWithSize:CGSizeMake(kScreenWidth, 100) direction:TNGradientChangeDirectionLevel
                                                                       startColor:[UIColor hd_colorWithHexString:@"#D7DBE0"]
                                                                         endColor:[UIColor hd_colorWithHexString:@"#ABB7C2"]];
        }
    } else {
        self.bgView.backgroundColor = [UIColor tn_colorGradientChangeWithSize:CGSizeMake(kScreenWidth, 100) direction:TNGradientChangeDirectionLevel
                                                                   startColor:[UIColor hd_colorWithHexString:@"#D7DBE0"]
                                                                     endColor:[UIColor hd_colorWithHexString:@"#ABB7C2"]];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(12)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(19)];
        };
    }
    return _iconImgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard16B;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)accountNameLabel {
    if (!_accountNameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.7];
        label.font = HDAppTheme.PayNowFont.standard12;
        _accountNameLabel = label;
    }
    return _accountNameLabel;
}

- (SALabel *)cardNumLabel {
    if (!_cardNumLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard16M;
        label.textAlignment = NSTextAlignmentRight;
        _cardNumLabel = label;
    }
    return _cardNumLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_white"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}
@end
