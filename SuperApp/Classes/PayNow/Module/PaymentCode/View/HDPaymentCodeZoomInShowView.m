//
//  HDPaymentCodeZoomInShowView.m
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPaymentCodeZoomInShowView.h"
#import "HDBaseButton.h"
#import "NSString+HD_Util.h"


@interface HDPaymentCodeZoomInShowView ()
@property (nonatomic, strong) UIView *containerView;                ///< 容器
@property (nonatomic, strong) UIView *containerStackView;           ///< Stack，用户控制整体垂直居中
@property (nonatomic, strong) UIView *coverView;                    ///< 覆盖层
@property (nonatomic, strong) UIView *coverStackView;               ///< 覆盖层 Stack, 用户控制整体垂直居中
@property (nonatomic, strong) UIImageView *logoIV;                  ///< logo
@property (nonatomic, strong) UILabel *titleLB;                     ///< 标题
@property (nonatomic, strong) UIImageView *codeIV;                  ///< 码
@property (nonatomic, strong) UILabel *codeLB;                      ///< 码内容
@property (nonatomic, strong) HDBaseButton *confirmBTN;             ///< 我知道了按钮
@property (nonatomic, assign) HDPaymentCodeZoomInShowViewType type; ///< 类型
@property (nonatomic, weak) UIImage *codeImage;                     ///< 图片
@property (nonatomic, assign) CGRect originFrame;                   ///< 原始坐标
@property (nonatomic, copy) NSString *contentStr;                   ///< 码内容

@property (nonatomic, assign) BOOL __isShowing;

@end


@implementation HDPaymentCodeZoomInShowView
#pragma mark - life cycle
- (void)commonInit {
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_containerView];

    _containerStackView = [[UIView alloc] init];
    [_containerView addSubview:_containerStackView];

    _codeIV = [[UIImageView alloc] initWithImage:self.codeImage];
    [self addSubview:_codeIV];

    [_containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)]];

    [self setNeedsUpdateConstraints];

    if (self.type == HDPaymentCodeZoomInShowViewTypeQRCode)
        return;

    _codeLB = [[UILabel alloc] init];
    _codeLB.textAlignment = NSTextAlignmentCenter;
    _codeLB.textColor = [HDAppTheme.color G1];
    _codeLB.font = [HDAppTheme.font forSize:30];
    _codeLB.text = [self.contentStr hd_componentsSeparatedStringByString:@"  " unitLength:4];
    [_containerView addSubview:_codeLB];

    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.98];
    [self addSubview:_coverView];

    _coverStackView = [[UIView alloc] init];
    [_coverView addSubview:_coverStackView];

    _logoIV = [[UIImageView alloc] init];
    _logoIV.image = [UIImage imageNamed:@"img_logo_vipay_2"];
    [_coverView addSubview:_logoIV];

    _titleLB = [[UILabel alloc] init];
    _titleLB.textAlignment = NSTextAlignmentCenter;
    _titleLB.textColor = [HDAppTheme.color G2];
    _titleLB.font = [HDAppTheme.font standard3];
    _titleLB.numberOfLines = 0;
    _titleLB.text = PNLocalizedString(@"paycode_saveuser_desc", @"付款码数字仅用于支付时向收银员展示，\n为防诈骗，请勿发送给他人。");
    [_coverView addSubview:_titleLB];

    _confirmBTN = [HDBaseButton buttonWithType:UIButtonTypeCustom];
    [_confirmBTN setTitle:PNLocalizedString(@"btn_register_hint_known", @"我知道了") forState:UIControlStateNormal];
    [_confirmBTN addTarget:self action:@selector(clickedConfirmBTN) forControlEvents:UIControlEventTouchUpInside];
    [_coverView addSubview:_confirmBTN];

    [self setNeedsUpdateConstraints];
}

- (instancetype)initWithType:(HDPaymentCodeZoomInShowViewType)type codeImageView:(UIImageView *)codeImageView contentStr:(NSString *)contentStr {
    self = [super init];
    if (self) {
        self.type = type;
        self.codeImage = codeImageView.image;
        // 坐标转换
        self.originFrame = [codeImageView convertRect:codeImageView.bounds toView:[UIApplication sharedApplication].keyWindow];

        self.contentStr = [contentStr copy];

        [self commonInit];
    }
    return self;
}

- (void)updateConstraints {
    if (self.type == HDPaymentCodeZoomInShowViewTypeQRCode) {
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.codeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).multipliedBy(0.8);
            make.height.equalTo(self.codeIV.mas_width);
            make.center.equalTo(self);
        }];
    } else if (self.type == HDPaymentCodeZoomInShowViewTypeBarCode) {
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self.codeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self);
            make.top.equalTo(self.codeIV.mas_bottom).offset(kRealWidth(10));
        }];

        [self.containerStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeIV);
            make.bottom.equalTo(self.codeLB);
            make.left.right.centerY.equalTo(self);
        }];

        if (!self.coverView.isHidden) {
            [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];

            [self.coverStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.logoIV);
                make.bottom.equalTo(self.confirmBTN);
                make.left.right.centerY.equalTo(self);
            }];

            [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.logoIV.image.size);
                make.centerX.equalTo(self.coverView);
            }];

            [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
                make.centerX.equalTo(self.coverView);
                make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(25));
            }];

            [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealWidth(45));
                make.width.mas_equalTo(200);
                make.centerX.equalTo(self.coverView);
                make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(50));
            }];

            [self.confirmBTN setNeedsDisplay];
        }
    }

    [super updateConstraints];
}

#pragma mark - public methods
- (void)showCompletion:(void (^__nullable)(void))completion {
    self.__isShowing = true;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    if (self.type == HDPaymentCodeZoomInShowViewTypeQRCode) {
        [keyWindow addSubview:self];
        self.frame = keyWindow.bounds;

        [self setNeedsLayout];
        [self layoutIfNeeded];

        // 动画出现
        self.containerView.alpha = 0;
        CGRect oldFrame = self.codeIV.frame;

        self.codeIV.frame = self.originFrame;
        self.userInteractionEnabled = false;

        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.alpha = 1;
            self.codeIV.frame = oldFrame;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = true;

            !completion ?: completion();
        }];
    } else if (self.type == HDPaymentCodeZoomInShowViewTypeBarCode) {
        [keyWindow addSubview:self];
        self.codeIV.frame = self.originFrame;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(keyWindow.frame), CGRectGetWidth(keyWindow.frame) / CGRectGetHeight(keyWindow.frame) * CGRectGetWidth(keyWindow.frame));

        [self setNeedsLayout];
        [self layoutIfNeeded];

        self.userInteractionEnabled = false;
        self.containerView.alpha = 0;
        self.coverView.alpha = 0;

        const CGFloat codeIVWidth = kScreenHeight * 0.7;
        const CGFloat codeIVHeight = codeIVWidth * 158 / 518.0;
        // Y 坐标
        const CGSize codeLBSize = [self.codeLB sizeThatFits:CGSizeMake(kScreenWidth - 2 * kRealWidth(15), CGFLOAT_MAX)];
        const CGFloat codeIVTop = (kScreenWidth - codeIVHeight - kRealWidth(10) - codeLBSize.height) * 0.5;

        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            self.codeIV.frame = CGRectMake((kScreenHeight - codeIVWidth) * 0.5, codeIVTop, codeIVWidth, codeIVHeight);
            self.containerView.alpha = 1;
            self.coverView.alpha = 1;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = true;
            !completion ?: completion();
        }];
    }
}

- (void)dismiss {
    if (self.type == HDPaymentCodeZoomInShowViewTypeQRCode) {
        [UIView animateWithDuration:0.3 animations:^{
            self.codeIV.frame = self.originFrame;
            self.containerView.alpha = 0;
        } completion:^(BOOL finished) {
            !self.dismissCompletionHandler ?: self.dismissCompletionHandler();
            self.__isShowing = false;
            [self removeFromSuperview];
        }];
    } else if (self.type == HDPaymentCodeZoomInShowViewTypeBarCode) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectMake(0, 0, CGRectGetWidth(keyWindow.frame), CGRectGetWidth(keyWindow.frame) / CGRectGetHeight(keyWindow.frame) * CGRectGetWidth(keyWindow.frame));
            self.codeIV.frame = self.originFrame;
            self.containerView.alpha = 0;
            self.coverView.alpha = 0;
        } completion:^(BOOL finished) {
            !self.dismissCompletionHandler ?: self.dismissCompletionHandler();
            self.__isShowing = false;
            [self removeFromSuperview];
        }];
    }
}

- (void)updateCodeImage:(UIImage *)image contentStr:(NSString *)contentStr type:(HDPaymentCodeZoomInShowViewType)type {
    if (self.type != type)
        return;

    if (image) {
        self.codeIV.image = image;
    }
    if (contentStr.length > 0) {
        self.contentStr = [contentStr copy];
        self.codeLB.text = [self.contentStr hd_componentsSeparatedStringByString:@"  " unitLength:4];
    }
}

#pragma mark - event response
- (void)tappedView {
    [self dismiss];
}

- (void)clickedConfirmBTN {
    self.coverView.userInteractionEnabled = false;

    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.coverView.hidden = true;
        self.coverView.userInteractionEnabled = true;
    }];
}

#pragma mark - getters and setters
- (BOOL)isShowing {
    return self.__isShowing;
}
@end
