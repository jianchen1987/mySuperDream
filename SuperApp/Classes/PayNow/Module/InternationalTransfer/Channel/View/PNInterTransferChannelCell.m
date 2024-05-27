//
//  PNInterTransferChannelCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferChannelCell.h"
#import "PNInterTransferChannelModel.h"


@interface PNInterTransferChannelCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *subBgView;
@property (nonatomic, strong) UIImageView *leftLogoImgView;
@property (nonatomic, strong) SALabel *middleLabel;
@property (nonatomic, strong) UIImageView *rightLogoImgView;
@property (nonatomic, strong) SALabel *leftLabel;
@property (nonatomic, strong) SALabel *rightLabel;
@property (nonatomic, strong) UIImageView *middleImgView;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, assign) CGFloat logoWidth;
@end


@implementation PNInterTransferChannelCell

- (void)hd_setupViews {
    self.logoWidth = kRealWidth(50);

    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.bgView];

    [self.bgView addSubview:self.subBgView];

    [self.subBgView addSubview:self.leftLogoImgView];
    [self.subBgView addSubview:self.middleLabel];
    [self.subBgView addSubview:self.rightLogoImgView];

    [self.subBgView addSubview:self.leftLabel];
    [self.subBgView addSubview:self.middleImgView];
    [self.subBgView addSubview:self.rightLabel];

    [self.bgView addSubview:self.arrowImgView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(16));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(16));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.subBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(16));
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(-kRealWidth(20));
    }];

    [self.leftLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subBgView.mas_left);
        make.top.mas_equalTo(self.subBgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(self.logoWidth, self.logoWidth));
    }];

    [self.middleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLogoImgView.mas_right).offset(kRealWidth(30));
        make.centerY.mas_equalTo(self.leftLogoImgView.mas_centerY);
    }];

    [self.rightLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleLabel.mas_right).offset(kRealWidth(30));
        make.top.mas_equalTo(self.leftLogoImgView);
        make.size.mas_equalTo(CGSizeMake(self.logoWidth, self.logoWidth));
        make.right.mas_equalTo(self.subBgView.mas_right);
        //        if (self.leftLabel.hidden) {
        //            make.bottom.mas_equalTo(self.subBgView.mas_bottom);
        //        }
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(16));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];

    //    if (!self.leftLabel.hidden) {
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.leftLogoImgView.mas_right);
        make.top.mas_equalTo(self.leftLogoImgView.mas_bottom).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.subBgView.mas_bottom);
    }];

    [self.middleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(kRealWidth(12));
        make.size.mas_equalTo(@(CGSizeMake(kRealWidth(20), kRealWidth(20))));
        make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
    }];

    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleImgView.mas_right).offset(kRealWidth(12));
        make.top.bottom.equalTo(self.leftLabel);
        make.right.mas_equalTo(self.subBgView.mas_right);
    }];
    //    }

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNInterTransferChannelModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:self.model.logoPath placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(self.logoWidth, self.logoWidth)] imageView:self.rightLogoImgView];
    if (!WJIsObjectNil(self.model.rateModel.sourceAmt) && !WJIsObjectNil(self.model.rateModel.targetAmt)) {
        self.leftLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.rateModel.sourceAmt.amount, self.model.rateModel.sourceAmt.currency];
        self.rightLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.rateModel.targetAmt.amount, self.model.rateModel.targetAmt.currency];
        self.middleImgView.hidden = NO;
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = NO;

        [self.rightLabel sizeToFit];
        [self.leftLabel sizeToFit];
    } else {
        self.middleImgView.hidden = YES;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)subBgView {
    if (!_subBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _subBgView = view;
    }
    return _subBgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)leftLogoImgView {
    if (!_leftLogoImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_wownow"];
        imageView.layer.cornerRadius = self.logoWidth * 0.5;
        imageView.layer.masksToBounds = YES;
        _leftLogoImgView = imageView;
    }
    return _leftLogoImgView;
}

- (UIImageView *)rightLogoImgView {
    if (!_rightLogoImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = self.logoWidth * 0.5;
        imageView.layer.masksToBounds = YES;
        _rightLogoImgView = imageView;
    }
    return _rightLogoImgView;
}

- (SALabel *)middleLabel {
    if (!_middleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"pn_transfer_to", @"转账至");
        _middleLabel = label;
    }
    return _middleLabel;
}

- (SALabel *)leftLabel {
    if (!_leftLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.hidden = YES;
        _leftLabel = label;
    }
    return _leftLabel;
}

- (SALabel *)rightLabel {
    if (!_rightLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.hidden = YES;
        _rightLabel = label;
    }
    return _rightLabel;
}

- (UIImageView *)middleImgView {
    if (!_middleImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_currcy_other"];
        imageView.hidden = YES;
        _middleImgView = imageView;
    }
    return _middleImgView;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_gray_small"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}
@end
