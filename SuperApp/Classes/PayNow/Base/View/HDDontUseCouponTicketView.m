//
//  HDDontUseCouponTicketView.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDDontUseCouponTicketView.h"
#import "HDAppTheme.h"
#import "HDCommonLabel.h"
#import "HDCouponTicketBgView.h"
#import "Masonry.h"


@interface HDDontUseCouponTicketView ()
@property (nonatomic, strong) HDCouponTicketBgView *bgView; ///< 背景
@property (nonatomic, strong) UIImageView *logoIV;          ///< logo
@property (nonatomic, strong) HDCommonLabel *titleLB;       ///< 标题
@property (nonatomic, strong) UIView *leftViewContainer;    ///< 左边容器
@property (nonatomic, strong) UIView *rightViewContainer;   ///< 右边容器
@end


@implementation HDDontUseCouponTicketView
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
    _bgView.gradientLayerWidth = kRealWidth(110);
    // 默认灰色
    _bgView.gradientLayerColors = @[(__bridge id)HexColor(0xE4E5EA).CGColor, (__bridge id)HexColor(0xE4E5EA).CGColor];
    [self addSubview:_bgView];

    _leftViewContainer = [[UIView alloc] init];
    [self addSubview:_leftViewContainer];

    _rightViewContainer = [[UIView alloc] init];
    [self addSubview:_rightViewContainer];

    _logoIV = [[UIImageView alloc] init];
    _logoIV.image = [UIImage imageNamed:@"ic_nav_logo"];
    [_leftViewContainer addSubview:_logoIV];

    _titleLB = [[HDCommonLabel alloc] init];
    _titleLB.numberOfLines = 0;
    _titleLB.text = PNLocalizedString(@"coupon_title_no_use", @"不使用优惠");
    _titleLB.font = [HDAppTheme.font standard3];
    _titleLB.textColor = [HDAppTheme.color G2];
    [_rightViewContainer addSubview:_titleLB];
}

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat HMiniumMargin = kRealWidth(10), VMinimumMargin = kRealWidth(20);

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.leftViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.mas_equalTo(self.bgView.gradientLayerWidth);
    }];

    [self.rightViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self);
        make.left.equalTo(self.leftViewContainer.mas_right);
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self).offset(VMinimumMargin);
        }
        make.size.mas_equalTo(self.logoIV.image.size);
        make.center.equalTo(self.leftViewContainer);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.model.isFixedHeight) {
            make.top.greaterThanOrEqualTo(self).offset(VMinimumMargin);
        }
        make.width.equalTo(self.rightViewContainer).offset(-2 * HMiniumMargin);
        make.center.equalTo(self.rightViewContainer);
    }];
}

#pragma mark - getters and setters
- (void)setModel:(HDCouponTicketModel *)model {
    _model = model;

    _titleLB.numberOfLines = model.numbersOfLineOfTitle;

    [self setNeedsUpdateConstraints];
}
@end
