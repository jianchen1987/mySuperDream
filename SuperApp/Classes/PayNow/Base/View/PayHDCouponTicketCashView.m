//
//  PayHDCouponTicketCashView.m
//  ViPay
//
//  Created by VanJay on 2019/9/10.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCouponTicketCashView.h"
#import "HDAppTheme.h"
#import "HDCommonLabel.h"
#import "Masonry.h"
#import "UIView+HDFrameLayout.h"


@interface PayHDCouponTicketCashView ()
@property (nonatomic, strong) UIImageView *backgroundImage; ///< 背景图
@property (nonatomic, strong) UIView *imagePlaceHolderView; ///< 左边图片部分占位，便于布局
@property (nonatomic, strong) HDCommonLabel *moneyLabel;    ///< 金额
@property (nonatomic, strong) HDCommonLabel *descLabel;     ///< 描述
@property (nonatomic, strong) HDCommonLabel *dateLabel;     ///< 有效期
@property (nonatomic, strong) HDCommonLabel *noChangeLabel; ///< 不设找零
@property (nonatomic, strong) HDCommonLabel *remarkLB;      ///< 状态提示
@property (nonatomic, strong) UIView *labelStack;           ///< Stack
@property (nonatomic, strong) CAShapeLayer *borderLayder;   ///< 圆角和边框图层
@end


@implementation PayHDCouponTicketCashView

#pragma mark - life cycle
- (void)commonInit {
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red envelope"]];
    [self addSubview:self.backgroundImage];

    self.labelStack = UIView.new;
    [self addSubview:self.labelStack];

    _imagePlaceHolderView = UIView.new;
    [self addSubview:self.imagePlaceHolderView];

    self.moneyLabel = ({
        HDCommonLabel *label = HDCommonLabel.new;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [HDAppTheme.font boldForSize:30];
        label.textColor = HexColor(0xE33C19);
        [self addSubview:label];
        label;
    });

    self.descLabel = ({
        HDCommonLabel *label = HDCommonLabel.new;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [HDAppTheme.font standard4];
        label.textColor = HexColor(0xE33C19);
        label.text = PNLocalizedString(@"redpacket", @"红包");
        [self addSubview:label];
        label;
    });

    self.dateLabel = ({
        HDCommonLabel *label = HDCommonLabel.new;
        label.font = [HDAppTheme.font standard4];
        label.textColor = HexColor(0xE33C19);
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label;
    });

    self.noChangeLabel = ({
        HDCommonLabel *label = HDCommonLabel.new;
        label.font = [HDAppTheme.font standard4];
        label.textColor = HexColor(0xE33C19);
        label.text = PNLocalizedString(@"coupon_no_change", @"不设找零");
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label;
    });

    self.remarkLB = ({
        HDCommonLabel *label = HDCommonLabel.new;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [HDAppTheme.font standard4];
        label.textColor = HexColor(0xE33C19);
        [self addSubview:label];
        label;
    });
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
    [self.backgroundImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.labelStack mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self).offset(kRealWidth(10));
        }
        make.width.centerX.equalTo(self);
        make.centerY.equalTo(self);
        if (self.moneyLabel.text.length <= 0) {
            make.top.equalTo(self.descLabel);
        } else {
            make.top.equalTo(self.moneyLabel);
        }
        make.bottom.equalTo(self.noChangeLabel);
    }];

    [self.imagePlaceHolderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.backgroundImage);
        make.width.equalTo(self.backgroundImage).multipliedBy(120 / 345.0);
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self.moneyLabel).offset(-2);
    }];

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagePlaceHolderView.mas_right);
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagePlaceHolderView.mas_right);
        make.right.lessThanOrEqualTo(self).offset(-kRealWidth(25));
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.noChangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagePlaceHolderView.mas_right);
        make.right.lessThanOrEqualTo(self).offset(-kRealWidth(25));
        make.top.equalTo(self.dateLabel.mas_bottom).offset(kRealWidth(5));
    }];

    if (!self.remarkLB.isHidden) {
        [self.remarkLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-kRealWidth(20));
        }];
    }

    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(HDCouponTicketModel *)model {
    _model = model;

    self.moneyLabel.text = model.couponAmount.thousandSeparatorAmount;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", model.effectiveDate, model.expireDate];

    BOOL canUse = model.couponState == PNCouponTicketStatusUnUsed || model.couponState == PNCouponTicketStatusIneffective;

    _remarkLB.hidden = canUse;
    self.alpha = canUse ? 1 : 0.5;

    if (!_remarkLB.isHidden) {
        if (model.couponState == PNCouponTicketStatusUsed) {
            _remarkLB.text = PNLocalizedString(@"coupon_state_used", @"已使用");
        } else if (model.couponState == PNCouponTicketStatusOutDated) {
            _remarkLB.text = PNLocalizedString(@"coupon_state_expired", @"已过期");
        }
    }

    [self setNeedsUpdateConstraints];
}
@end
