//
//  PNMSQRCodeView.m
//  SuperApp
//
//  Created by xixi on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSQRCodeView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNMSReceiveCodeRspModel.h"
#import "PNMSReceiveCodeViewModel.h"
#import "UIImage+PNExtension.h"


@interface PNMSQRCodeView ()

@property (nonatomic, strong) PNMSReceiveCodeViewModel *viewModel;

/// 截图view
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIImageView *topTitleImgView;
@property (nonatomic, strong) UIImageView *rightIconImgView;
@property (nonatomic, strong) SALabel *merchantNameLabel;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) SALabel *moneyLabel;
@property (nonatomic, strong) UIView *line1; //扫描二维码，向我付款  这个title下面这条线
@property (nonatomic, strong) UIImageView *qrCodeImgView;
@end


@implementation PNMSQRCodeView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topBgView];
    [self.topBgView addSubview:self.topTitleImgView];
    [self.bgView addSubview:self.rightIconImgView];
    [self.bgView addSubview:self.merchantNameLabel];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.moneyLabel];

    [self.bgView addSubview:self.line1];
    [self.bgView addSubview:self.qrCodeImgView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.topTitleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.topTitleImgView.image.size);
        make.centerX.equalTo(self.topBgView);
        make.top.mas_equalTo(self.topBgView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
    }];

    [self.rightIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.rightIconImgView.image.size);
        make.right.mas_equalTo(self.topBgView.mas_right);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
    }];

    [self.merchantNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(48));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-48));
        make.top.mas_equalTo(self.rightIconImgView.mas_bottom);
    }];

    if (!self.nameLabel.hidden) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.merchantNameLabel);
            make.top.mas_equalTo(self.merchantNameLabel.mas_bottom);
        }];
    }

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(48));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-48));
        if (!self.nameLabel.hidden) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
        } else {
            make.top.mas_equalTo(self.merchantNameLabel.mas_bottom);
        }
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left);
        make.right.mas_equalTo(self.bgView.mas_right);
        make.height.equalTo(@(kRealWidth(1)));
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(25));
    }];

    CGFloat qrCodeWidth = kScreenWidth - kRealWidth(96) - kRealWidth(30);
    self.qrCodeImgView.image = [UIImage imageQRCodeContent:self.model.qrData withSize:qrCodeWidth];
    [self.qrCodeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(kRealWidth(35));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-45));
        make.width.height.equalTo(@(qrCodeWidth));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-35));
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSReceiveCodeRspModel *)model {
    _model = model;

    NSString *moneyStr = model.amount;
    if (moneyStr.doubleValue <= 0) {
        self.moneyLabel.text = model.currency;
    } else {
        if ([model.currency isEqualToString:PNCurrencyTypeKHR]) {
            moneyStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:model.amount currencyCode:model.currency];
        }

        NSString *allStr = [NSString stringWithFormat:@"%@ %@", moneyStr, model.currency];
        self.moneyLabel.attributedText = [NSMutableAttributedString highLightString:moneyStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont nunitoSansSemiBold:32]
                                                                     highLightColor:HDAppTheme.PayNowColor.c333333];
    }

    if (self.viewModel.type == PNMSReceiveCodeType_Store || self.viewModel.type == PNMSReceiveCodeType_StoreOperator) {
        self.merchantNameLabel.text = self.viewModel.storeOperatorInfoModel.storeName;
    } else {
        self.merchantNameLabel.text = self.viewModel.storeOperatorInfoModel.merchantName;
    }

    if (self.viewModel.type == PNMSReceiveCodeType_StoreOperator) {
        self.nameLabel.hidden = NO;
        self.nameLabel.text = self.viewModel.storeOperatorInfoModel.operatorName;
    } else {
        self.nameLabel.hidden = YES;
        self.nameLabel.text = @"";
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView.layer.cornerRadius = kRealWidth(25);
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor hd_colorWithHexString:@"E11F26"];
        view.layer.masksToBounds = YES;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(25)];
        };
        _topBgView = view;
    }
    return _topBgView;
}

- (UIImageView *)topTitleImgView {
    if (!_topTitleImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_khqr_code_icon"];
        _topTitleImgView = imageView;
    }
    return _topTitleImgView;
}

- (UIImageView *)rightIconImgView {
    if (!_rightIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_sj_img"];
        _rightIconImgView = imageView;
    }
    return _rightIconImgView;
}

- (SALabel *)merchantNameLabel {
    if (!_merchantNameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c000000;
        label.font = [HDAppTheme.PayNowFont nunitoSansRegular:15];
        label.numberOfLines = 0;
        _merchantNameLabel = label;
    }
    return _merchantNameLabel;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c666666;
        label.font = [HDAppTheme.PayNowFont nunitoSansRegular:12];
        label.numberOfLines = 0;
        label.hidden = YES;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c000000;
        label.font = [HDAppTheme.PayNowFont nunitoSansRegular:15];
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view drawDashLineWithlineLength:5 lineSpacing:3 lineColor:[UIColor hd_colorWithHexString:@"#818181"]];
        };
    }
    return _line1;
}

- (UIImageView *)qrCodeImgView {
    if (!_qrCodeImgView) {
        _qrCodeImgView = [[UIImageView alloc] init];
    }
    return _qrCodeImgView;
}

@end
