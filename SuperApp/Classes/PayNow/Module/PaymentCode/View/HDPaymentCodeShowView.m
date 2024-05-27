//
//  HDPaymentCodeShowView.m
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPaymentCodeShowView.h"
#import "HDBaseButton.h"
#import "HDPaymentCodeZoomInShowView.h"
#import "HDTips.h"
#import "UILabel+HDKitCore.h"
#import "UIView+HD_Extension.h"
#import <YYText/YYText.h>


@interface HDPaymentCodeShowView ()
@property (nonatomic, strong) UIImageView *barCode;                        ///< 条形码
@property (nonatomic, strong) UILabel *barCodeTip;                         ///< 条形码提示
@property (nonatomic, strong) UIImageView *qrCode;                         ///< 二维码
@property (nonatomic, strong) UIView *coverView;                           ///< 覆盖层
@property (nonatomic, strong) UIImageView *logoIV;                         ///< logo
@property (nonatomic, strong) UILabel *titleLB;                            ///< 标题
@property (nonatomic, strong) UIView *hiddenSubViewsContainer;             ///< 默认隐藏 UI 元素的容器，便于控制
@property (nonatomic, strong) UILabel *descLB;                             ///< 描述
@property (nonatomic, strong) UILabel *bottomTipLB;                        ///< 底部提示
@property (nonatomic, strong) HDBaseButton *openBTN;                       ///< 开启按钮
@property (nonatomic, strong) YYLabel *agreementLB;                        ///< 协议
@property (nonatomic, strong) UILabel *brandLB;                            ///< 品牌宣传
@property (nonatomic, strong) CAShapeLayer *containerLayer;                ///< 容器图层
@property (nonatomic, strong) CAShapeLayer *coverViewLayer;                ///< 覆盖层图层
@property (nonatomic, strong) HDPaymentCodeZoomInShowView *codeZoomInView; ///< 预览放大显示层
@property (nonatomic, assign) HDPaymentCodeShowViewCoverType type;         ///< 记录类型
@property (nonatomic, copy) NSString *contentStr;                          ///< 码内容
@property (nonatomic, copy) NSString *tipStr;                              ///< 提示内容
@property (nonatomic, copy) NSString *buttonTitle;                         ///< 按钮标题
@end


@implementation HDPaymentCodeShowView

#pragma mark - life cycle
- (void)commonInit {
    _barCode = [[UIImageView alloc] init];
    _barCode.userInteractionEnabled = true;
    [_barCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBarCode)]];
    _barCode.image = [UIImage imageNamed:@"barcode_placeholder"];
    [self addSubview:_barCode];

    _barCodeTip = [[UILabel alloc] init];
    _barCodeTip.textAlignment = NSTextAlignmentCenter;
    _barCodeTip.textColor = [HDAppTheme.color G3];
    _barCodeTip.font = [HDAppTheme.font standard3];
    _barCodeTip.numberOfLines = 0;
    _barCodeTip.text = [NSString stringWithFormat:@"2819 ****** %@", PNLocalizedString(@"paymentCode_check_num_txt", @"查看数字")];
    _barCodeTip.userInteractionEnabled = true;
    [_barCodeTip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBarCode)]];
    [self addSubview:_barCodeTip];

    _qrCode = [[UIImageView alloc] init];
    _qrCode.userInteractionEnabled = true;
    [_qrCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedQRCode)]];
    _qrCode.image = [UIImage imageNamed:@"qrcode_placeholder"];
    [self addSubview:_qrCode];

    _bottomTipLB = [[UILabel alloc] init];
    _bottomTipLB.textAlignment = NSTextAlignmentCenter;
    _bottomTipLB.textColor = [HDAppTheme.color G3];
    _bottomTipLB.font = [HDAppTheme.font standard4];
    _bottomTipLB.numberOfLines = 0;
    _bottomTipLB.hd_lineSpace = 1;
    _bottomTipLB.text = PNLocalizedString(@"paymentCode_overpay_txt", @"为了您的资金安全\n付款码单笔消费金额不超过$50或 ៛200,000");
    [self addSubview:_bottomTipLB];

    _coverView = [[UIView alloc] init];
    [self addSubview:_coverView];

    _logoIV = [[UIImageView alloc] init];
    _logoIV.image = [UIImage imageNamed:@"img_logo_vipay_2"];
    [_coverView addSubview:_logoIV];

    _titleLB = [[UILabel alloc] init];
    _titleLB.textAlignment = NSTextAlignmentCenter;
    _titleLB.textColor = [HDAppTheme.color G1];
    _titleLB.font = [HDAppTheme.font standard2Bold];
    _titleLB.numberOfLines = 0;
    _titleLB.text = PNLocalizedString(@"paymentCode_open_paycode", @"开启付款码");
    [_coverView addSubview:_titleLB];

    _hiddenSubViewsContainer = [[UIView alloc] init];
    _hiddenSubViewsContainer.hidden = true;
    [_coverView addSubview:_hiddenSubViewsContainer];

    _descLB = [[UILabel alloc] init];
    _descLB.textAlignment = NSTextAlignmentCenter;
    _descLB.textColor = [HDAppTheme.color G2];
    _descLB.font = [HDAppTheme.font standard3];
    _descLB.numberOfLines = 0;
    _descLB.hd_lineSpace = 5;
    [_hiddenSubViewsContainer addSubview:_descLB];

    _openBTN = [HDBaseButton buttonWithType:UIButtonTypeCustom];
    [_openBTN setTitle:PNLocalizedString(@"paymentCode_open", @"开启") forState:UIControlStateNormal];
    [_openBTN addTarget:self action:@selector(clickedOpenBTN) forControlEvents:UIControlEventTouchUpInside];
    [_hiddenSubViewsContainer addSubview:_openBTN];

    NSString *stringGray = PNLocalizedString(@"open_mean_to_agree", @"开启即表示同意");
    NSString *stringBlack = PNLocalizedString(@"ViPay_paymentCode_service_agreeMent", @"《ViPay付款码服务协议》");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[stringGray stringByAppendingString:stringBlack]];

    text.yy_font = [HDAppTheme.font standard4];
    text.yy_color = [HDAppTheme.color G2];

    _agreementLB = [[YYLabel alloc] init];
    _agreementLB.numberOfLines = 0;

    __weak __typeof(self) weakSelf = self;
    [text yy_setTextHighlightRange:NSMakeRange(stringGray.length, stringBlack.length) color:[UIColor hd_colorWithHexString:@"#FD7127"] backgroundColor:[UIColor clearColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             [strongSelf clickOnAgreement];
                         }];
    _agreementLB.attributedText = text;
    _agreementLB.textAlignment = NSTextAlignmentCenter;
    [_hiddenSubViewsContainer addSubview:_agreementLB];

    _brandLB = [[UILabel alloc] init];
    _brandLB.textAlignment = NSTextAlignmentCenter;
    _brandLB.textColor = [HDAppTheme.color G3];
    _brandLB.font = [HDAppTheme.font standard4];
    _brandLB.numberOfLines = 0;
    _brandLB.text = PNLocalizedString(@"paymentCode_save_your_money", @"ViPay，保障你的资金安全");
    [_coverView addSubview:_brandLB];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)updateConstraints {
    [self.barCode mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(30));
        make.centerX.equalTo(self);
        make.top.greaterThanOrEqualTo(self).offset(kRealHeight(50));
        make.height.equalTo(self.barCode.mas_width).multipliedBy(95.0 / 316.0);
    }];

    [self.barCodeTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(15));
        make.centerX.equalTo(self);
        make.top.equalTo(self.barCode.mas_bottom).offset(kRealWidth(23));
    }];

    [self.qrCode mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(200.0 / 375.0);
        make.centerX.equalTo(self);
        make.top.greaterThanOrEqualTo(self.barCodeTip.mas_bottom).offset(kRealWidth(20)).priority(750);
        make.top.lessThanOrEqualTo(self.barCodeTip.mas_bottom).offset(kRealWidth(30)).priority(1000);
        make.height.equalTo(self.qrCode.mas_width);
    }];

    [self.bottomTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(15));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(10));
    }];

    if (!self.coverView.isHidden) {
        [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.logoIV.image.size);
            make.centerX.equalTo(self.coverView);
            make.top.lessThanOrEqualTo(self.coverView).offset(kRealWidth(80));
            make.top.greaterThanOrEqualTo(self.coverView).offset(kRealWidth(30));
        }];

        if (!self.titleLB.isHidden) {
            [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
                make.centerX.equalTo(self.coverView);
                make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(15));
            }];
        }

        [self.hiddenSubViewsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLB);
            if (!self.agreementLB.isHidden) {
                make.bottom.equalTo(self.agreementLB);
            } else {
                make.bottom.equalTo(self.openBTN);
            }
            make.width.centerX.equalTo(self.coverView);
        }];

        [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.coverView);
            if (!self.titleLB.isHidden) {
                make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(20));
            } else {
                make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(20));
            }
        }];

        [self.openBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kRealWidth(45));
            make.width.mas_equalTo(200);
            make.centerX.equalTo(self.coverView);
            make.bottom.greaterThanOrEqualTo(self.brandLB.mas_top).offset(-kRealWidth(80));
        }];

        if (!self.agreementLB.isHidden) {
            [self.agreementLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
                make.centerX.equalTo(self.coverView);
                make.top.equalTo(self.openBTN.mas_bottom).offset(kRealWidth(10));
            }];
        }

        [self.brandLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.coverView);
            if (!self.agreementLB.isHidden) {
                make.top.greaterThanOrEqualTo(self.agreementLB.mas_bottom).offset(kRealWidth(20));
            } else {
                make.top.greaterThanOrEqualTo(self.openBTN.mas_bottom).offset(kRealWidth(20));
            }
            make.bottom.equalTo(self.coverView).offset(-kRealWidth(10));
        }];

        [self.openBTN setNeedsDisplay];
    }

    [super updateConstraints];
}

#pragma mark - private methods

#pragma mark - public methods
- (void)showCoverViewForType:(HDPaymentCodeShowViewCoverType)type {
    self.type = type;

    void (^showCoverViewBlock)(NSString *, NSString *) = ^(NSString *descLBText, NSString *buttonTitle) {
        self.descLB.text = descLBText;
        [self.openBTN setTitle:buttonTitle forState:UIControlStateNormal];

        self.hiddenSubViewsContainer.hidden = false;
        self.titleLB.hidden = type == HDPaymentCodeShowViewCoverTypeWarning || type == HDPaymentCodeShowViewCoverTypeOther || type == HDPaymentCodeShowViewCoverTypeOffline;
        self.agreementLB.hidden = type != HDPaymentCodeShowViewCoverTypeFirstTimeOpen;

        [self setNeedsUpdateConstraints];

        if (self.coverView.isHidden) {
            self.coverView.hidden = false;

            self.coverView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.coverView.alpha = 1;
            }];
        } else {
            self.hiddenSubViewsContainer.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.hiddenSubViewsContainer.alpha = 1;
            }];
        }
    };

    NSString *buttonTitle = @"", *descLBText = @"";
    if (type == HDPaymentCodeShowViewCoverTypeFirstTimeOpen) {
        descLBText = PNLocalizedString(@"open_paycode_desc", @"你尚未开启此功能，\n开启后默认同意扫码免密支付功能，\n向商家出示付款码，即可付款");
        buttonTitle = PNLocalizedString(@"paymentCode_open", @"开启");
    } else if (type == HDPaymentCodeShowViewCoverTypeReOpen) {
        descLBText = PNLocalizedString(@"open_paycode_again", @"需重新开启此功能,\n开启后向商家出示付款码即可快速支付");
        buttonTitle = PNLocalizedString(@"paymentCode_open", @"开启");
    } else if (type == HDPaymentCodeShowViewCoverTypeWarning) {
        descLBText = PNLocalizedString(@"paycode_saveuser_desc", @"付款码数字仅用于支付时向收银员展示，\n为防诈骗，请勿发送给他人。");
        buttonTitle = PNLocalizedString(@"btn_register_hint_known", @"我知道了");

        if (_codeZoomInView.isShowing) {
            __weak __typeof(self) weakSelf = self;
            _codeZoomInView.dismissCompletionHandler = ^{
                showCoverViewBlock(descLBText, buttonTitle);
                weakSelf.barCode.hidden = false;
                weakSelf.qrCode.hidden = false;
            };

            [_codeZoomInView dismiss];
        } else {
            showCoverViewBlock(descLBText, buttonTitle);
        }
    } else if (type == HDPaymentCodeShowViewCoverTypeOffline) {
        descLBText = PNLocalizedString(@"ALERT_MSG_NETWORK_ERROR", @"网络开小差了...");
        buttonTitle = PNLocalizedString(@"try_again", @"再试一次");
    } else if (type == HDPaymentCodeShowViewCoverTypeOther) {
        descLBText = self.tipStr;
        buttonTitle = self.buttonTitle;
    }

    if (type != HDPaymentCodeShowViewCoverTypeWarning) {
        showCoverViewBlock(descLBText, buttonTitle);
    }
}

- (void)showCoverViewForOtherTypeWithTip:(NSString *)tip buttonTitle:(NSString *)buttonTitle {
    self.tipStr = tip;
    self.buttonTitle = buttonTitle;

    [self showCoverViewForType:HDPaymentCodeShowViewCoverTypeOther];
}

- (void)hideCoverView {
    if (self.coverView.isHidden)
        return;

    self.coverView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.coverView.hidden = true;
    }];
}

- (void)updateBarCodeImage:(UIImage *)image contentStr:(NSString *)contentStr {
    [self.codeZoomInView updateCodeImage:image contentStr:contentStr type:HDPaymentCodeZoomInShowViewTypeBarCode];

    self.contentStr = contentStr;

    self.barCode.image = image;

    if (contentStr.length > 4) {
        NSString *barCodeStr = [contentStr substringToIndex:4];
        self.barCodeTip.text = [NSString stringWithFormat:@"%@ ****** %@", barCodeStr, PNLocalizedString(@"paymentCode_check_num_txt", @"查看数字")];
    }
}

- (void)updateQRCodeImage:(UIImage *)image contentStr:(NSString *)contentStr {
    [self.codeZoomInView updateCodeImage:image contentStr:contentStr type:HDPaymentCodeZoomInShowViewTypeQRCode];

    self.contentStr = contentStr;

    self.qrCode.image = image;
}

- (void)showLoading {
    HDTips *tip = [HDTips showLoadingInView:self];
    tip.offset = CGPointMake(0, 30);
}

- (void)dismissLoading {
    [HDTips hideAllTips];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.containerLayer) {
        [self.containerLayer removeFromSuperlayer];
        self.containerLayer = nil;
    }

    if (!CGSizeEqualToSize(CGSizeZero, self.frame.size)) {
        self.containerLayer = [self setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:15 shadowRadius:6 shadowOpacity:1
                                          shadowColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.16].CGColor
                                            fillColor:UIColor.whiteColor.CGColor
                                         shadowOffset:CGSizeMake(0, 3)];
    }

    if (!self.coverView.isHidden && !CGSizeEqualToSize(CGSizeZero, self.coverView.frame.size)) {
        if (self.coverViewLayer) {
            [self.coverViewLayer removeFromSuperlayer];
            self.coverViewLayer = nil;
        }

        self.coverViewLayer = [self.coverView setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:15 shadowRadius:6 shadowOpacity:1
                                                    shadowColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.16].CGColor
                                                      fillColor:[UIColor.whiteColor colorWithAlphaComponent:0.98].CGColor
                                                   shadowOffset:CGSizeMake(0, 3)];
    }
}

#pragma mark - getters and setters
- (BOOL)isShowingPaymentCode {
    return self.coverView.isHidden;
}

#pragma mark - event response
- (void)clickOnAgreement {
    !self.clickedAgreementLabelHandler ?: self.clickedAgreementLabelHandler();
}

- (void)clickedOpenBTN {
    if (self.type == HDPaymentCodeShowViewCoverTypeWarning) {
        [self hideCoverView];
    }

    !self.clickedCoverViewButtonHandler ?: self.clickedCoverViewButtonHandler(self.type);
}

- (void)tappedBarCode {
    if (_codeZoomInView.isShowing)
        return;

    _codeZoomInView = [[HDPaymentCodeZoomInShowView alloc] initWithType:HDPaymentCodeZoomInShowViewTypeBarCode codeImageView:self.barCode contentStr:self.contentStr];

    _barCode.userInteractionEnabled = false;

    __weak __typeof(self) weakSelf = self;
    [_codeZoomInView showCompletion:^{
        weakSelf.barCode.userInteractionEnabled = true;
    }];

    _barCode.hidden = true;
    _codeZoomInView.dismissCompletionHandler = ^{
        weakSelf.barCode.hidden = false;
    };
}

- (void)tappedQRCode {
    if (_codeZoomInView.isShowing)
        return;

    _codeZoomInView = [[HDPaymentCodeZoomInShowView alloc] initWithType:HDPaymentCodeZoomInShowViewTypeQRCode codeImageView:self.qrCode contentStr:self.contentStr];

    _qrCode.userInteractionEnabled = false;
    __weak __typeof(self) weakSelf = self;
    [_codeZoomInView showCompletion:^{
        weakSelf.qrCode.userInteractionEnabled = true;
    }];

    _qrCode.hidden = true;
    _codeZoomInView.dismissCompletionHandler = ^{
        weakSelf.qrCode.hidden = false;
    };
}
@end
