//
//  HDCouponTicketView.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketView.h"
#import "HDAppTheme.h"
#import "HDCommonLabel.h"
#import "HDCouponTicketBgView.h"
#import "Masonry.h"
#import "PNCommonUtils.h"


@interface HDCouponTicketView ()
@property (nonatomic, strong) HDCouponTicketBgView *bgView;            ///< 背景
@property (nonatomic, strong) HDCommonLabel *discountOrCouponAmountLB; ///< 折扣或优惠金额
@property (nonatomic, strong) HDCommonLabel *thresholdDescLB;          ///< 消费门槛
@property (nonatomic, strong) HDCommonLabel *titleLB;                  ///< 标题
@property (nonatomic, strong) HDCommonLabel *merchantNameLB;           ///< 商户名称
@property (nonatomic, strong) HDCommonLabel *dateLB;                   ///< 日期
@property (nonatomic, strong) HDCommonLabel *remarkLB;                 ///< 状态提示
@property (nonatomic, strong) HDCommonLabel *offLB;                    ///< 折扣 off
@property (nonatomic, strong) UIView *leftViewContainer;               ///< 左边容器
@property (nonatomic, strong) UIView *rightViewContainer;              ///< 右边容器

@property (nonatomic, strong) UIView *discountOffStack; ///< 折扣和 off Stack
@property (nonatomic, strong) UIView *leftStack;        ///< 左边 Stack
@property (nonatomic, strong) UIView *rightStack;       ///< 右边 Stack
@end


@implementation HDCouponTicketView
#pragma mark - life cycle
- (void)commonInit {
    // 初始化子控件
    [self setupSubViews];
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

- (void)setupSubViews {
    _bgView = [[HDCouponTicketBgView alloc] init];
    // 默认灰色
    _bgView.gradientLayerColors = @[(__bridge id)HexColor(0xE4E5EA).CGColor, (__bridge id)HexColor(0xE4E5EA).CGColor];
    [self addSubview:_bgView];

    _leftViewContainer = [[UIView alloc] init];
    [self addSubview:_leftViewContainer];

    _rightViewContainer = [[UIView alloc] init];
    [self addSubview:_rightViewContainer];

    _leftStack = [[UIView alloc] init];
    [self addSubview:_leftStack];

    _discountOffStack = [[UIView alloc] init];
    [self addSubview:_discountOffStack];

    _rightStack = [[UIView alloc] init];
    [self addSubview:_rightStack];

    _discountOrCouponAmountLB = [[HDCommonLabel alloc] init];
    _discountOrCouponAmountLB.adjustsFontSizeToFitWidth = YES;
    _discountOrCouponAmountLB.minimumScaleFactor = 0.3;
    _discountOrCouponAmountLB.font = [HDAppTheme.font boldForSize:23];
    _discountOrCouponAmountLB.textAlignment = NSTextAlignmentCenter;
    _discountOrCouponAmountLB.textColor = UIColor.whiteColor;
    [_leftViewContainer addSubview:_discountOrCouponAmountLB];

    _offLB = [[HDCommonLabel alloc] init];
    _offLB.textAlignment = NSTextAlignmentRight;
    _offLB.font = [HDAppTheme.font standard3];
    _offLB.textColor = UIColor.whiteColor;
    _offLB.text = @"off";
    [_leftViewContainer addSubview:_offLB];

    _thresholdDescLB = [[HDCommonLabel alloc] init];
    _thresholdDescLB.textAlignment = NSTextAlignmentCenter;
    _thresholdDescLB.numberOfLines = 0;
    _thresholdDescLB.font = [HDAppTheme.font standard4];
    _thresholdDescLB.textColor = UIColor.whiteColor;
    [_leftViewContainer addSubview:_thresholdDescLB];

    _titleLB = [[HDCommonLabel alloc] init];
    _titleLB.font = [HDAppTheme.font standard3];
    _titleLB.textColor = [HDAppTheme.color G2];
    [_rightViewContainer addSubview:_titleLB];

    _merchantNameLB = [[HDCommonLabel alloc] init];
    _merchantNameLB.numberOfLines = 1;
    _merchantNameLB.font = [HDAppTheme.font standard3];
    _merchantNameLB.textColor = [HDAppTheme.color G2];
    [_rightViewContainer addSubview:_merchantNameLB];

    _dateLB = [[HDCommonLabel alloc] init];
    _dateLB.font = [HDAppTheme.font standard4];
    _dateLB.textColor = [HDAppTheme.color G3];
    [_rightViewContainer addSubview:_dateLB];

    _remarkLB = [[HDCommonLabel alloc] init];
    _remarkLB.textAlignment = NSTextAlignmentRight;
    _remarkLB.font = [HDAppTheme.font standard4];
    _remarkLB.textColor = [HDAppTheme.color G3];
    [self addSubview:_remarkLB];
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat HMinimumMargin = kRealWidth(isScreenWidthEqualTo4Inch ? 6 : 8), VMinimumMargin = kRealWidth(isScreenWidthEqualTo4Inch ? 18 : 20);

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    if (!self.offLB.isHidden) {
        [self.offLB sizeToFit];
        [self.offLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.discountOrCouponAmountLB).offset(-3);
            make.left.equalTo(self.discountOrCouponAmountLB.mas_right);
            make.size.mas_equalTo(self.offLB.bounds.size);
            make.right.lessThanOrEqualTo(self.leftViewContainer).offset(-HMinimumMargin);
        }];
    }

    [self.leftViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.top.equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView.gradientLayerWidth);
    }];

    [self.rightViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.top.equalTo(self.bgView);
        make.left.equalTo(self.leftViewContainer.mas_right);
    }];

    [self.discountOffStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftViewContainer);
        make.top.equalTo(self.leftStack);
        make.left.equalTo(self.discountOrCouponAmountLB);
        if (self.offLB.isHidden) {
            make.right.equalTo(self.discountOrCouponAmountLB);
        } else {
            make.right.equalTo(self.offLB);
        }
        make.height.equalTo(self.discountOrCouponAmountLB);
    }];

    [self.leftStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.lessThanOrEqualTo(self.discountOrCouponAmountLB);

        if (self.offLB.isHidden) {
            make.right.greaterThanOrEqualTo(self.discountOrCouponAmountLB);
        } else {
            make.right.greaterThanOrEqualTo(self.offLB);
        }

        make.top.equalTo(self.discountOrCouponAmountLB);
        if (self.thresholdDescLB.isHidden) {
            make.bottom.equalTo(self.discountOrCouponAmountLB);
        } else {
            make.left.lessThanOrEqualTo(self.thresholdDescLB);
            make.bottom.equalTo(self.thresholdDescLB);
        }
    }];

    [self.rightStack mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.lessThanOrEqualTo(self.titleLB);
        make.right.greaterThanOrEqualTo(self.titleLB);
        make.left.lessThanOrEqualTo(self.dateLB);
        make.right.greaterThanOrEqualTo(self.dateLB);

        if (!self.merchantNameLB.isHidden) {
            make.top.equalTo(self.merchantNameLB);
            make.left.lessThanOrEqualTo(self.merchantNameLB);
            make.right.greaterThanOrEqualTo(self.merchantNameLB);
        } else {
            make.top.equalTo(self.titleLB);
        }

        make.bottom.equalTo(self.dateLB);
    }];

    [self.discountOrCouponAmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self.bgView).offset(VMinimumMargin);
        }

        make.left.greaterThanOrEqualTo(self.leftViewContainer).offset(HMinimumMargin);

        if (self.offLB.isHidden) {
            make.right.lessThanOrEqualTo(self.leftViewContainer).offset(-HMinimumMargin);
        }
    }];

    if (!self.thresholdDescLB.isHidden) {
        [self.thresholdDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountOrCouponAmountLB.mas_bottom).offset(2);
            make.left.greaterThanOrEqualTo(self.leftViewContainer).offset(HMinimumMargin);
            make.centerX.equalTo(self.leftViewContainer);
            if (!self.model.isFixedHeight) {
                make.bottom.lessThanOrEqualTo(self.bgView).offset(-VMinimumMargin);
            }
        }];
    }

    if (!self.merchantNameLB.isHidden) {
        [self.merchantNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.model.isFixedHeight) {
                make.top.greaterThanOrEqualTo(self.bgView).offset(VMinimumMargin);
            }
            make.left.equalTo(self.rightViewContainer).offset(kRealWidth(15));
            make.right.equalTo(self.rightViewContainer).offset(-kRealWidth(25));
        }];
    }

    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.merchantNameLB.isHidden) {
            make.top.equalTo(self.merchantNameLB.mas_bottom).offset(2);
        } else {
            if (!self.model.isFixedHeight) {
                make.top.greaterThanOrEqualTo(self.bgView).offset(VMinimumMargin);
            }
        }
        make.left.equalTo(self.rightViewContainer).offset(kRealWidth(15));
        make.right.equalTo(self.rightViewContainer).offset(-kRealWidth(25));
    }];

    [self.dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightViewContainer).offset(kRealWidth(15));
        make.right.equalTo(self.rightViewContainer).offset(-kRealWidth(25));
        make.top.equalTo(self.titleLB.mas_bottom).offset(7);
        if (!self.model.isFixedHeight) {
            make.bottom.lessThanOrEqualTo(self.bgView).offset(-VMinimumMargin);
        }
    }];

    if (!self.remarkLB.isHidden) {
        [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(5);
            make.right.equalTo(self.bgView).offset(-kRealWidth(20));
        }];
    }
}

#pragma mark - getters and setters
- (void)setModel:(HDCouponTicketModel *)model {
    _model = model;

    _bgView.gradientLayerWidth = model.gradientLayerWidth;
    _titleLB.numberOfLines = model.sceneType == HDCouponTicketSceneTypeMerchant ? 1 : model.numbersOfLineOfTitle;
    _dateLB.numberOfLines = model.numbersOfLineOfDate;

    if (model.couponState == PNCouponTicketStatusUnUsed || model.couponState == PNCouponTicketStatusIneffective) {
        // 商户券都用蓝色
        if (model.sceneType == HDCouponTicketSceneTypeMerchant) {
            _bgView.gradientLayerColors = @[
                (__bridge id)[UIColor colorWithRed:75 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:3 / 255.0 green:112 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor
            ];
        } else {
            if (model.couponType == PNTradePreferentialTypeDiscountTicket) {
                _bgView.gradientLayerColors = @[
                    (__bridge id)[UIColor colorWithRed:249 / 255.0 green:68 / 255.0 blue:130 / 255.0 alpha:1.0].CGColor,
                    (__bridge id)[UIColor colorWithRed:239 / 255.0 green:24 / 255.0 blue:98 / 255.0 alpha:1.0].CGColor
                ];
            } else if (model.couponType == PNTradePreferentialTypeFullReduction) {
                _bgView.gradientLayerColors = @[
                    (__bridge id)[UIColor colorWithRed:252 / 255.0 green:126 / 255.0 blue:86 / 255.0 alpha:1.0].CGColor,
                    (__bridge id)[UIColor colorWithRed:255 / 255.0 green:86 / 255.0 blue:33 / 255.0 alpha:1.0].CGColor
                ];
            }
        }
    } else {
        _bgView.gradientLayerColors = @[(__bridge id)HexColor(0xE4E5EA).CGColor, (__bridge id)HexColor(0xE4E5EA).CGColor];
    }

    _offLB.hidden = model.couponType != PNTradePreferentialTypeDiscountTicket;
    _merchantNameLB.hidden = model.sceneType != HDCouponTicketSceneTypeMerchant;

    _remarkLB.hidden = model.couponState == PNCouponTicketStatusUnUsed || model.couponState == PNCouponTicketStatusIneffective;
    if (!_remarkLB.isHidden) {
        if (model.couponState == PNCouponTicketStatusUsed) {
            _remarkLB.text = PNLocalizedString(@"coupon_state_used", @"已使用");
        } else if (model.couponState == PNCouponTicketStatusOutDated) {
            _remarkLB.text = PNLocalizedString(@"coupon_state_expired", @"已过期");
        }
    }

    if (model.couponType == PNTradePreferentialTypeDiscountTicket) {
        _discountOrCouponAmountLB.text = model.discountRadioStr;
    } else if (model.couponType == PNTradePreferentialTypeFullReduction) {
        _discountOrCouponAmountLB.text = model.couponAmount.thousandSeparatorAmount;
    }

    if (!_thresholdDescLB.isHidden) {
        if (model.couponType == PNTradePreferentialTypeDiscountTicket) {
            _thresholdDescLB.text = model.usableCurrencyDesc;
        } else if (model.couponType == PNTradePreferentialTypeFullReduction) {
            NSString *thresholdDesc =
                [NSString stringWithFormat:@"%@ %@", model.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol, [PNCommonUtils getCurrenceNameByCode:model.thresholdAmount.cy]];
            _thresholdDescLB.text = [NSString stringWithFormat:PNLocalizedString(@"coupon_usable_at", @"满 xx 可用"), thresholdDesc];
        }
    }

    if (!_merchantNameLB.isHidden) {
        _merchantNameLB.text = model.merchantInfo.merchantName;
    }

    _titleLB.text = model.couponTitle;
    _dateLB.text = [NSString stringWithFormat:@"%@ - %@", model.effectiveDate, model.expireDate];

    [self setNeedsUpdateConstraints];
}
@end
