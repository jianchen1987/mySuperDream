//
//  HDCommonCouponTicketView.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonCouponTicketView.h"
#import "HDAppTheme.h"
#import "HDCommonLabel.h"
#import "HDCouponTicketBgView.h"
#import "Masonry.h"


@interface HDCommonCouponTicketView ()
@property (nonatomic, strong) HDCouponTicketBgView *bgView;            ///< 背景
@property (nonatomic, strong) CALayer *whiteLineLayer;                 ///< 色块内白线
@property (nonatomic, strong) HDCommonLabel *discountOrCouponAmountLB; ///< 折扣或优惠金额
@property (nonatomic, strong) HDCommonLabel *thresholdDescLB;          ///< 消费门槛
@property (nonatomic, strong) HDCommonLabel *titleLB;                  ///< 标题
@property (nonatomic, strong) HDCommonLabel *offLB;                    ///< 折扣 off
@property (nonatomic, strong) UIView *leftViewContainer;               ///< 左边容器
@property (nonatomic, strong) UIView *rightViewContainer;              ///< 右边容器

@property (nonatomic, strong) UIView *discountOffStack; ///< 折扣和 off Stack
@property (nonatomic, strong) UIView *leftStack;        ///< 左边Stack
@property (nonatomic, strong) UIView *rightStack;       ///< 右边Stack
@end


@implementation HDCommonCouponTicketView
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
    _bgView.isFullRenderedGradientLayer = YES;
    _bgView.toothRadius = 4;
    _bgView.toothMargin = 4;
    _bgView.toothHEdgeMargin = 6;
    _bgView.borderRadius = 8;
    // 默认灰色
    _bgView.gradientLayerColors = @[
        (__bridge id)[UIColor colorWithRed:239 / 255.0 green:196 / 255.0 blue:113 / 255.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:226 / 255.0 green:181 / 255.0 blue:98 / 255.0 alpha:1.0].CGColor
    ];
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

    _whiteLineLayer = [CALayer layer];
    _whiteLineLayer.borderColor = UIColor.whiteColor.CGColor;
    _whiteLineLayer.borderWidth = 0.5;
    _whiteLineLayer.cornerRadius = 5;
    [_leftViewContainer.layer addSublayer:_whiteLineLayer];

    _discountOrCouponAmountLB = [[HDCommonLabel alloc] init];
    _discountOrCouponAmountLB.adjustsFontSizeToFitWidth = YES;
    _discountOrCouponAmountLB.minimumScaleFactor = 0.5;
    _discountOrCouponAmountLB.textAlignment = NSTextAlignmentCenter;
    _discountOrCouponAmountLB.font = [HDAppTheme.font boldForSize:23];
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
    _titleLB.numberOfLines = 0;
    _titleLB.font = [HDAppTheme.font standard3];
    _titleLB.textColor = [HDAppTheme.color G2];
    [_rightViewContainer addSubview:_titleLB];
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat HMiniumMargin = kRealWidth(15), VMinimumMargin = kRealWidth(20);

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(kRealWidth(115));
    }];

    if (!self.offLB.isHidden) {
        [self.offLB sizeToFit];
        [self.offLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.discountOrCouponAmountLB);
            make.left.equalTo(self.discountOrCouponAmountLB.mas_right);
            make.size.mas_equalTo(self.offLB.bounds.size);
            make.right.lessThanOrEqualTo(self.leftViewContainer).offset(-HMiniumMargin);
        }];
    }

    [self.leftViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.top.equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView);
    }];

    [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.height.top.equalTo(self);
        make.left.equalTo(self.leftViewContainer.mas_right);
    }];

    [self.discountOffStack mas_remakeConstraints:^(MASConstraintMaker *make) {
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

    [self.leftStack mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);

        make.left.equalTo(self.discountOrCouponAmountLB);
        if (self.offLB.isHidden) {
            make.right.equalTo(self.discountOrCouponAmountLB);
        } else {
            make.right.equalTo(self.offLB);
        }

        make.top.equalTo(self.discountOrCouponAmountLB);
        if (self.thresholdDescLB.isHidden) {
            make.bottom.equalTo(self.discountOrCouponAmountLB);
        } else {
            make.bottom.equalTo(self.thresholdDescLB);
        }
    }];

    [self.rightStack mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB);
        make.bottom.equalTo(self.titleLB);
    }];

    [self.discountOrCouponAmountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self.bgView).offset(VMinimumMargin);
        }
        make.left.greaterThanOrEqualTo(self.leftViewContainer).offset(HMiniumMargin);

        if (self.offLB.isHidden) {
            make.right.lessThanOrEqualTo(self.leftViewContainer).offset(-HMiniumMargin);
        }
    }];

    if (!self.thresholdDescLB.isHidden) {
        [self.thresholdDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountOrCouponAmountLB.mas_bottom).offset(2);
            make.left.equalTo(self.discountOrCouponAmountLB);
            if (self.offLB.isHidden) {
                make.right.equalTo(self.discountOrCouponAmountLB);
            } else {
                make.right.equalTo(self.offLB);
            }
            if (!self.model.isFixedHeight) {
                make.bottom.lessThanOrEqualTo(self.bgView).offset(-VMinimumMargin);
            }
        }];
    }

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self.bgView).offset(VMinimumMargin);
        }
        make.width.equalTo(self.rightViewContainer).offset(-2 * HMiniumMargin);
        make.center.equalTo(self.rightViewContainer);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _whiteLineLayer.frame = CGRectMake(kRealWidth(14), kRealWidth(8), _leftViewContainer.bounds.size.width - 2 * kRealWidth(14), _leftViewContainer.bounds.size.height - 2 * kRealWidth(8));
}

#pragma mark - getters and setters
- (void)setModel:(HDCouponTicketModel *)model {
    _model = model;

    _titleLB.numberOfLines = model.numbersOfLineOfTitle;

    _offLB.hidden = model.couponType != PNTradePreferentialTypeDiscount;

    if (model.couponType == PNTradePreferentialTypeCashBack) {
        _discountOrCouponAmountLB.text = model.couponAmount.thousandSeparatorAmount;
        _thresholdDescLB.text = PNLocalizedString(@"coupon_type_desc_cash_back", @"返现");
    } else if (model.couponType == PNTradePreferentialTypeMinus) {
        _discountOrCouponAmountLB.text = model.couponAmount.thousandSeparatorAmount;
        _thresholdDescLB.text = PNLocalizedString(@"coupon_type_desc_minus", @"立减");
    } else if (model.couponType == PNTradePreferentialTypeDiscount) {
        _discountOrCouponAmountLB.text = model.discountRadioStr;
        _thresholdDescLB.text = PNLocalizedString(@"coupon_type_desc_discount", @"折扣");
    }

    _titleLB.text = model.couponTitle;

    [self setNeedsUpdateConstraints];
}
@end
