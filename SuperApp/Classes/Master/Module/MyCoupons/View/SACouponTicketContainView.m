//
//  SACouponTicketContainView.m
//  SuperApp
//
//  Created by Tia on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACouponTicketContainView.h"
#import "SAMultiLanguageManager.h"
#import "NSDate+SAExtension.h"


@interface SACouponTicketContainView ()
/// 优惠券UI容器
@property (nonatomic, strong) UIView *containView;
/// 背景图
@property (nonatomic, strong) UIImageView *bgIV;
/// 标签view
@property (nonatomic, strong) UIView *tagView;
/// 标签文本
@property (nonatomic, strong) SALabel *tagLB;
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 货币文本
@property (nonatomic, strong) UILabel *currencyLB;
/// 优惠券价格文本
@property (nonatomic, strong) UILabel *priceLB;
/// 优惠折扣展示文本
@property (nonatomic, strong) UILabel *discountLB;
/// 优惠券折扣描述文本
@property (nonatomic, strong) UILabel *discountDetailLB;
/// 优惠券描述
@property (nonatomic, strong) UILabel *descLB;
/// 优惠券名称文本
@property (nonatomic, strong) UILabel *titleLB;
/// applicable辅助文本
@property (nonatomic, strong) UILabel *applicableLeftLB;
/// 使用类型文本
@property (nonatomic, strong) UILabel *applicableLB;
/// 有效期文本
@property (nonatomic, strong) UILabel *dateLB;
/// 展开按钮
@property (nonatomic, strong) UIButton *extendBtn;
/// 增加展开按钮的点击范围
@property (nonatomic, strong) UIButton *realExtendBtn;
/// 优惠券状态icon
@property (nonatomic, strong) UIImageView *statusIV;
/// 使用按钮
@property (nonatomic, strong) SAOperationButton *useBtn;
/// 展开的视图容器
@property (nonatomic, strong) UIView *extendView;
/// 阴影
@property (nonatomic, strong) UIView *extendShadowView;
/// 展开视图的文本
@property (nonatomic, strong) UILabel *extendLB;
/// 使用日期文本
@property (nonatomic, strong) UILabel *useDateLB;
/// 白色遮罩
@property (nonatomic, strong) UIView *maskView;
/// 虚线
@property (nonatomic, strong) UIImageView *lineIV;

/// 待支付倒计时定时器
@property (nonatomic, strong) NSTimer *dateTimer;

@end


@implementation SACouponTicketContainView

- (void)hd_setupViews {
    [self addSubview:self.containView];
    [self.containView addSubview:self.bgIV];
    [self.containView addSubview:self.lineIV];
    [self.containView addSubview:self.tagView];
    [self.tagView addSubview:self.tagLB];

    [self.containView addSubview:self.iconIV];
    [self.containView addSubview:self.currencyLB];
    [self.containView addSubview:self.priceLB];
    [self.containView addSubview:self.discountLB];
    [self.containView addSubview:self.descLB];
    [self.containView addSubview:self.titleLB];
    [self.containView addSubview:self.discountDetailLB];
    [self.containView addSubview:self.applicableLeftLB];
    [self.containView addSubview:self.applicableLB];
    [self.containView addSubview:self.dateLB];
    [self.containView addSubview:self.extendBtn];
    [self.containView addSubview:self.realExtendBtn];

    //右边
    [self.containView addSubview:self.statusIV];
    [self.containView addSubview:self.useBtn];
    [self.containView addSubview:self.useDateLB];

    // extendView
    [self addSubview:self.extendView];
    [self.extendView addSubview:self.extendShadowView];
    [self.extendView addSubview:self.extendLB];

    //遮罩
    [self.containView addSubview:self.maskView];


    //    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.titleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)updateConstraints {
    BOOL hiddenIconIV = HDIsStringEmpty(self.model.iconUrl);
    BOOL hiddenExtendView = !self.model.isExpanded;

    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        if (hiddenExtendView) {
            make.bottom.equalTo(self);
        }
    }];

    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];

    [self.lineIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRealWidth(2));
        make.top.mas_equalTo(kRealWidth(16));
        make.bottom.mas_equalTo(-kRealWidth(16));
        make.right.mas_equalTo(-79);
    }];

    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containView);
        make.height.mas_equalTo(kRealWidth(18));
    }];

    [self.tagLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tagView);
    }];
    if (!hiddenIconIV) {
        self.iconIV.hidden = NO;
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(52), kRealWidth(52)));
            make.left.mas_equalTo(kRealWidth(12));
            make.top.equalTo(self.tagView.mas_bottom).offset(kRealWidth(12));
        }];
    } else {
        self.iconIV.hidden = YES;
    }

    CGFloat left = kRealWidth(72);
    if (hiddenIconIV) {
        left = kRealWidth(12);
    }

    if (!self.currencyLB.hidden) {
        [self.currencyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.top.equalTo(self.tagView.mas_bottom).offset(kRealWidth(20));
            make.height.mas_equalTo(kRealWidth(20));
        }];
    }

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.currencyLB.hidden) {
            make.left.equalTo(self.currencyLB.mas_right).offset(kRealWidth(2));
        } else {
            make.left.mas_equalTo(left);
        }
        make.top.equalTo(self.tagView.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(24));
    }];

    if (!self.discountLB.hidden) {
        [self.discountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceLB.mas_right);
            make.top.equalTo(self.tagView.mas_bottom).offset(kRealWidth(20));
            make.height.mas_equalTo(kRealWidth(20));
        }];
    }

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.discountLB.hidden) {
            make.left.equalTo(self.discountLB.mas_right).offset(kRealWidth(8));
        } else {
            make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(8));
        }
        make.top.equalTo(self.tagView.mas_bottom).offset(kRealWidth(22));
        make.height.mas_equalTo(kRealWidth(16));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.currencyLB.hidden) {
            make.top.equalTo(self.currencyLB.mas_bottom).offset(kRealWidth(4));
            make.left.equalTo(self.currencyLB);
        } else {
            make.top.equalTo(self.discountLB.mas_bottom).offset(kRealWidth(4));
            make.left.equalTo(self.priceLB);
        }
        make.right.mas_equalTo(-kRealWidth(92));
    }];

    if (!self.discountDetailLB.hidden) {
        [self.discountDetailLB sizeToFit];
        [self.discountDetailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(4));
            make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(4));
            make.left.mas_equalTo(kRealWidth(12));
            make.size.mas_equalTo(self.discountDetailLB.frame.size);
        }];
    }

    [self.applicableLeftLB sizeToFit];
    [self.applicableLeftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.discountDetailLB.hidden) {
            make.top.equalTo(self.discountDetailLB.mas_bottom).offset(kRealWidth(4));
        } else {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(4));
            make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(4));
        }
        make.left.mas_equalTo(kRealWidth(12));
        make.size.mas_equalTo(self.applicableLeftLB.frame.size);
    }];

    [self.applicableLB sizeToFit];
    [self.applicableLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.applicableLeftLB.mas_right).offset(kRealWidth(2));
        make.top.equalTo(self.applicableLeftLB.mas_top);
        make.right.mas_equalTo(-kRealWidth(92));
        make.height.mas_equalTo(self.applicableLB.frame.size.height);
    }];

    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.applicableLeftLB);
        make.top.equalTo(self.applicableLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];

    if (!self.extendBtn.hidden) {
        [self.extendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kRealWidth(92));
            make.centerY.equalTo(self.dateLB);
            make.left.greaterThanOrEqualTo(self.dateLB.mas_right).offset(kRealWidth(12));
        }];

        [self.realExtendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self.dateLB);
            make.right.equalTo(self.extendBtn);
        }];
    }

    //右边
    [self.statusIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.containView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(55 * 0.8), kRealWidth(52 * 0.8)));
    }];

    [self.useBtn sizeToFit];
    [self.useBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containView);
        make.right.mas_equalTo(-(80 / 2 - self.useBtn.width / 2));
        make.height.mas_equalTo(kRealWidth(28));
    }];

    // extendView
    self.extendView.hidden = hiddenExtendView;
    if (!hiddenExtendView) {
        [self.extendView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containView.mas_bottom);
            make.left.mas_equalTo(kRealWidth(18));
            make.right.mas_equalTo(-kRealWidth(18));
            make.bottom.equalTo(self);
        }];

        [self.extendShadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.extendView);
            make.height.mas_equalTo(kRealWidth(12));
        }];

        [self.extendLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.extendShadowView.mas_bottom);
            make.left.mas_equalTo(kRealWidth(12));
            make.right.bottom.mas_equalTo(-kRealWidth(12));
        }];
    }

    if (!self.useDateLB.hidden) {
        [self.useDateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containView);
            make.width.mas_equalTo(kRealWidth(80));
            make.bottom.mas_equalTo(-kRealWidth(24));
        }];
    }

    if (!self.maskView.hidden) {
        [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 0, 0, kRealWidth(85)));
        }];
    }

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACouponTicketModel *)model {
    _model = model;

    //标签
    NSString *text = nil;
    if (model.couponType == SACouponTicketTypeReduction) {
//        text = SALocalizedString(@"coupon_match_CashCoupon", @"现金券");
        text = SALocalizedString(@"coupon_match_APPCoupon", @"平台券");
        if([model.sceneType isEqualToString:WMCouponTicketSceneTypeMerchant] && model.storeName.length) {
            text = SALocalizedString(@"coupon_match_StoreCoupon", @"门店券");
        }
    } else if (model.couponType == SACouponTicketTypeFreight) {
        text = SALocalizedString(@"coupon_match_ExpressCoupon", @"运费券");
    } else if (model.couponType == SACouponTicketTypePayment) {
        text = SALocalizedString(@"coupon_match_PaymentCoupon", @"支付券");
    }
    self.tagLB.text = text;

    //手动刷新标签背景色
    self.tagView.hd_frameDidChangeBlock(self.tagView, CGRectZero);

    // icon
    self.iconIV.hidden = YES;
    if (HDIsStringNotEmpty(model.iconUrl)) {
        self.iconIV.hidden = NO;
        // 设置图标
        [HDWebImageManager setImageWithURL:model.iconUrl placeholderImage:[self generalCouponIconWithCouponType:model.couponType] imageView:self.iconIV];
    }


    self.currencyLB.hidden = NO;
    //货币
    self.currencyLB.text = model.couponAmount.currencySymbol;
    //金额
    self.priceLB.text = model.couponAmount.amount;

    self.discountLB.hidden = YES;
    self.discountDetailLB.hidden = YES;
    //描述
    //使用门槛
    text = @"";
    //    model.discountType = SACouponTicketDiscountTypeDiscountPercentage;
    if (model.discountType == SACouponTicketDiscountTypeDiscountPercentage) { //折扣比例
        //货币
        self.currencyLB.hidden = YES;

        //抵扣比例
        self.priceLB.text = model.strPreferRatio;

        self.discountLB.hidden = NO;
        self.discountLB.text = @"% off";
        self.discountDetailLB.hidden = NO;

        NSString *countStr = [NSString stringWithFormat:@"%@%@", model.preferLimitUsd.currencySymbol, model.preferLimitUsd.thousandSeparatorAmountNoCurrencySymbol];
        if (model.thresholdAmount.cent.integerValue > 0) {
            NSString *preText = [NSString stringWithFormat:@"%@%@", model.thresholdAmount.currencySymbol, model.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol];
            text = [NSString stringWithFormat:SALocalizedString(@"coupon_Full_discount", @"满%@可用,最高抵扣%@"), preText, countStr];
        } else {
            text = [NSString stringWithFormat:SALocalizedString(@"coupon_Unlimited_discount", @"无门槛,最高抵扣%@"), countStr];
        }
        self.discountDetailLB.text = text;

        text = @"";

    } else if (model.thresholdAmount.cent.integerValue > 0) {
        text = [NSString
            stringWithFormat:SALocalizedString(@"coupon_match_threshold", @"满%@%@可用"), model.thresholdAmount.currencySymbol, model.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol];
    }
    self.descLB.text = text;

    //设置标题
    self.titleLB.text = model.couponTitle;
    //使用范围
    text = [self getApplicableTextWithBusinessTypeList:model.businessTypeList andStoreName:model.storeName];
    self.applicableLB.text = text.length ? text : @" ";


    BOOL isCouponUnused = [model.couponState isEqualToString:SACouponTicketStateUnused];

    self.dateLB.text = [NSString stringWithFormat:@"%@ - %@", model.showCouponEffectiveDate, model.showCouponExpireDate];
    // 设置有效期
    if (isCouponUnused) {
        NSTimeInterval in24Time = [NSDate overtime:model.couponExpireDate format:@"yyyy-MM-dd HH:mm:ss" maxSecond:24 * 60 * 60];
//        HDLog(@"in24Time = %f", in24Time);
        if (in24Time > 0 && in24Time < 24 * 60 * 60) {
            // 开启倒计时
            if (_dateTimer) {
                [_dateTimer invalidate];
                _dateTimer = nil;
            }
            self.dateTimer.fireDate = [NSDate distantPast];
            [[NSRunLoop currentRunLoop] addTimer:self.dateTimer forMode:NSRunLoopCommonModes];
            NSString *timeStr = [SAGeneralUtil waitPayTimeWithSeconds:in24Time];

            NSMutableAttributedString *attStr =
                [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", SALocalizedString(@"coupon_Expiring_soon", @"即将过期："), timeStr]];
            [attStr addAttribute:NSForegroundColorAttributeName value:HDAppTheme.color.sa_C1 range:[attStr.string rangeOfString:timeStr]];

            self.dateLB.attributedText = attStr;
        } else {
            // 解决支付状态更新时倒计时未结束
            if ([_dateTimer respondsToSelector:@selector(isValid)]) {
                if ([_dateTimer isValid]) {
                    [_dateTimer invalidate];
                    _dateTimer = nil;
                }
            }
        }
    }


    self.extendBtn.selected = model.isExpanded;

    // status icon
    self.statusIV.image = [UIImage imageNamed:[self getImageByStatusIVWithCouponState:model]];


    self.useBtn.hidden = !isCouponUnused;
    self.maskView.hidden = isCouponUnused;

    self.useDateLB.hidden = YES;
    self.extendBtn.hidden = NO;
    self.realExtendBtn.hidden = NO;
    if (!isCouponUnused) {
        self.extendBtn.hidden = YES;
        self.realExtendBtn.hidden = YES;
        BOOL isUsed = [model.couponState isEqualToString:SACouponTicketStateUsed];

        if (isUsed) {
            self.useDateLB.hidden = NO;
            self.useDateLB.text =
                [NSString stringWithFormat:@"%@:\n%@", SALocalizedString(@"coupon_match_UseDate", @"使用日期"), [SAGeneralUtil getDateStrWithTimeInterval:model.useTime / 1000 format:@"dd/MM/yyyy"]];
        }

        BOOL isExpired = [model.couponState isEqualToString:SACouponTicketStateExpired];
        if (isExpired) {
            self.dateLB.text = [NSString stringWithFormat:@"%@:%@", SALocalizedString(@"coupon_Valid_until", @"有效期截止"), model.formatCouponExpireDate];
        }
    }

    //使用规则
    self.extendLB.text = model.couponUsageDescribe;

    [self setNeedsUpdateConstraints];
}

- (void)dateTimerInvoked {
    NSTimeInterval in24Time = [NSDate overtime:self.model.couponExpireDate format:@"yyyy-MM-dd HH:mm:ss" maxSecond:24 * 60 * 60];
//    HDLog(@"in24Time = %f", in24Time);
    if (in24Time > 0 && in24Time < 24 * 60 * 60) {
        // 开启倒计时
        NSString *timeStr = [SAGeneralUtil waitPayTimeWithSeconds:in24Time];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", SALocalizedString(@"coupon_Expiring_soon", @"即将过期："), timeStr]];
        [attStr addAttribute:NSForegroundColorAttributeName value:HDAppTheme.color.sa_C1 range:[attStr.string rangeOfString:timeStr]];

        self.dateLB.attributedText = attStr;
    } else {
        // 解决支付状态更新时倒计时未结束
        if ([_dateTimer respondsToSelector:@selector(isValid)]) {
            if ([_dateTimer isValid]) {
                [_dateTimer invalidate];
                _dateTimer = nil;
            }
        }
        self.dateLB.text = [NSString stringWithFormat:@"%@:%@-%@", SALocalizedString(@"coupon_match_Validity", @"有效期"), self.model.effectiveDate, self.model.expireDate];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (UIImage *)resizableImageWithName:(NSString *)imageName {
    // 加载原有图片
    UIImage *norImage = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];

    return newImage;
}

- (UIImage *)generalCouponIconWithCouponType:(SACouponTicketType)type {
    UIImage *placeHolderImage = nil;
    if (SACouponTicketTypeFreight == type) {
        placeHolderImage = [UIImage imageNamed:@"coupon_type_freight"];
    } else if (SACouponTicketTypeReduction == type) {
        placeHolderImage = [UIImage imageNamed:@"coupon_type_cash"];
    } else if (SACouponTicketTypePayment == type) {
        placeHolderImage = [UIImage imageNamed:@"coupon_type_payment"];
    } else {
        placeHolderImage = [HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(65), kRealWidth(65))];
    }
    return placeHolderImage;
}

- (NSString *)getApplicableTextWithBusinessTypeList:(NSArray *)list andStoreName:(NSString *)storeName {
    NSMutableString *text = [NSMutableString string];
    for (NSNumber *bl in list) {
        if (bl.integerValue == SAMarketingBusinessTypeYumNow.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_YumNow", @"外卖")];
        } else if (bl.integerValue == SAMarketingBusinessTypeTinhNow.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_TinhNow", @"电商")];
        } else if (bl.integerValue == SAMarketingBusinessTypeTopUp.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_PhoneTopUp", @"话费充值")];
        } else if (bl.integerValue == SAMarketingBusinessTypeGame.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_GameChannel", @"游戏")];
        } else if (bl.integerValue == SAMarketingBusinessTypeHotel.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_HotelChannel", @"酒店")];
        } else if (bl.integerValue == SAMarketingBusinessTypeGroupBuy.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_GroupBuy", @"团购")];
        } else if (bl.integerValue == SAMarketingBusinessTypeBillPayment.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_BillPayment", @"账单支付")];
        } else if (bl.integerValue == SAMarketingBusinessTypeAirTicket.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_AirTicket", @"机票")];
        } else if (bl.integerValue == SAMarketingBusinessTypeTravel.integerValue) {
            [text appendString:SALocalizedString(@"Coupon_bl_Travel", @"旅游")];
        } else {
            continue;
        }

        if ([self.model.sceneType isEqualToString:WMCouponTicketSceneTypeMerchant] && storeName.length) {
            //            [text appendString:[NSString stringWithFormat:@"(%@)", SALocalizedString(@"coupon_match_LimitedStore", @"限门店")]];
            [text appendString:[NSString stringWithFormat:@"(%@)", storeName]];
        }

        if (bl != list.lastObject) {
            [text appendString:@","];
        }
    }
    return text;
}

- (void)setLayerColor:(CAGradientLayer *)gl {
    if (!gl)
        return;

    if (self.model.couponType == SACouponTicketTypeReduction) { //现金券
        // red
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:88 / 255.0 blue:132 / 255.0 alpha:1.0].CGColor
        ];
    } else if (self.model.couponType == SACouponTicketTypeFreight) { //运费券
        // green
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:81 / 255.0 green:221 / 255.0 blue:115 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:112 / 255.0 green:230 / 255.0 blue:178 / 255.0 alpha:1.0].CGColor
        ];
    } else if (self.model.couponType == SACouponTicketTypePayment) { //支付券
        // purple
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:151 / 255.0 green:80 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:111 / 255.0 green:26 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor
        ];
    } else {
        // red
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:88 / 255.0 blue:132 / 255.0 alpha:1.0].CGColor
        ];
    }
}

- (NSString *)getImageByStatusIVWithCouponState:(SACouponTicketModel *)model {
    NSString *text = nil;
    NSString *state = model.couponState;
    if ([state isEqualToString:SACouponTicketStateUnused]) {
        if (model.couponTimeStatus == 11) { //新到
            text = @"new";
        } else if (model.couponTimeStatus == 12) { //快到期
            text = @"jjgq";
        } else {
            text = @"";
        }
    } else if ([state isEqualToString:SACouponTicketStateExpired]) { //已过期
        text = @"ygq";
    } else if ([state isEqualToString:SACouponTicketStateUsed]) { //已使用
        text = @"used";
    }

    NSString *lan = @"zh";
    if ([[SAMultiLanguageManager currentLanguage] isEqualToString:SALanguageTypeEN]) {
        lan = @"en";
    } else if ([[SAMultiLanguageManager currentLanguage] isEqualToString:SALanguageTypeKH]) {
        lan = @"km";
    }

    return [NSString stringWithFormat:@"coupon_%@_%@", text, lan];
}

#pragma mark - lazy load
- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _containView;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] initWithImage:[self resizableImageWithName:@"coupon_bg"]];
    }
    return _bgIV;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = UIView.new;
        @HDWeakify(self);
        _tagView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            CAGradientLayer *gl = nil;
            if (self.layer.sublayers.count && [self.layer.sublayers isKindOfClass:[CAGradientLayer class]]) {
                gl = self.layer.sublayers.lastObject;
                gl.frame = view.bounds;
            } else {
                gl = [CAGradientLayer layer];
                gl.startPoint = CGPointMake(0.5, 0);
                gl.endPoint = CGPointMake(0.5, 1);
                gl.locations = @[@(0), @(1.0f)];
                gl.frame = view.bounds;
                [view.layer addSublayer:gl];
            }
            [self setLayerColor:gl];
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:8];
            [self.tagView addSubview:self.tagLB];
        };
    }
    return _tagView;
}

- (SALabel *)tagLB {
    if (!_tagLB) {
        _tagLB = SALabel.new;
        _tagLB.hd_edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        _tagLB.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        _tagLB.textColor = UIColor.whiteColor;
        //        _tagLB.text = @"Freight Coupon";
        _tagLB.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_type_freight"]];
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _iconIV;
}

- (UILabel *)currencyLB {
    if (!_currencyLB) {
        _currencyLB = UILabel.new;
        _currencyLB.textColor = HDAppTheme.color.sa_C1;
        _currencyLB.font = [HDAppTheme.font boldForSize:14];
    }
    return _currencyLB;
}

- (UILabel *)priceLB {
    if (!_priceLB) {
        _priceLB = UILabel.new;
        _priceLB.font = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
        _priceLB.textColor = HDAppTheme.color.sa_C1;
    }
    return _priceLB;
}

- (UILabel *)discountLB {
    if (!_discountLB) {
        _discountLB = UILabel.new;
        _discountLB.textColor = HDAppTheme.color.sa_C1;
        _discountLB.font = [HDAppTheme.font boldForSize:14];
    }
    return _discountLB;
}

- (UILabel *)descLB {
    if (!_descLB) {
        _descLB = UILabel.new;
        _descLB.font = [HDAppTheme.font standard5];
        _descLB.textColor = [UIColor hd_colorWithHexString:@"666666"];
    }
    return _descLB;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = UILabel.new;
        _titleLB.font = [HDAppTheme.font boldForSize:14];
        _titleLB.hd_lineSpace = 6;
        _titleLB.numberOfLines = 2;
    }
    return _titleLB;
}

- (UILabel *)discountDetailLB {
    if (!_discountDetailLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        _discountDetailLB = l;
    }
    return _discountDetailLB;
}

- (UILabel *)applicableLeftLB {
    if (!_applicableLeftLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        _applicableLeftLB = l;
        l.text = [NSString stringWithFormat:@"%@:", SALocalizedString(@"coupon_match_UsedFor", @"可用于")];
    }
    return _applicableLeftLB;
}

- (UILabel *)applicableLB {
    if (!_applicableLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        l.textAlignment = NSTextAlignmentLeft;
        l.numberOfLines = 2;
        l.hd_lineSpace = 5;
        _applicableLB = l;
    }
    return _applicableLB;
}

- (UILabel *)dateLB {
    if (!_dateLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        _dateLB = l;
    }
    return _dateLB;
}

- (UIButton *)extendBtn {
    if (!_extendBtn) {
        _extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extendBtn setImage:[UIImage imageNamed:@"coupon_down_arrow"] forState:UIControlStateNormal];
        [_extendBtn setImage:[UIImage imageNamed:@"coupon_up_arrow"] forState:UIControlStateSelected];
        _extendBtn.userInteractionEnabled = NO;
    }
    return _extendBtn;
}

- (UIButton *)realExtendBtn {
    if (!_realExtendBtn) {
        _realExtendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [_realExtendBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.isExpanded = !self.model.isExpanded;
            !self.clickedViewDetailBlock ?: self.clickedViewDetailBlock();
        }];
    }
    return _realExtendBtn;
}

- (UIImageView *)statusIV {
    if (!_statusIV) {
        _statusIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_new_zh"]];
    }
    return _statusIV;
}

- (SAOperationButton *)useBtn {
    if (!_useBtn) {
        _useBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _useBtn.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _useBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(14), kRealWidth(4), kRealWidth(14));
        [_useBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
        [_useBtn setTitle:SALocalizedStringFromTable(@"use", @"去使用", @"Buttons") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_useBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedToUseBTNBlock ?: self.clickedToUseBTNBlock();
        }];
    }
    return _useBtn;
}

- (UIView *)extendView {
    if (!_extendView) {
        _extendView = UIView.new;
        _extendView.backgroundColor = UIColor.whiteColor;
        _extendView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _extendView;
}

- (UIView *)extendShadowView {
    if (!_extendShadowView) {
        _extendShadowView = UIView.new;
        @HDWeakify(self);
        _extendShadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            CAGradientLayer *gl = nil;
            if (self.layer.sublayers.count && [self.layer.sublayers isKindOfClass:[CAGradientLayer class]]) {
                gl = self.layer.sublayers.lastObject;
                gl.frame = view.bounds;
            } else {
                gl = [CAGradientLayer layer];
                gl.startPoint = CGPointMake(0.5, 0);
                gl.endPoint = CGPointMake(0.5, 1);
                gl.colors = @[
                    (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:1.0].CGColor,
                    (__bridge id)[UIColor colorWithRed:243 / 255.0 green:244 / 255.0 blue:250 / 255.0 alpha:0.0].CGColor
                ];
                gl.locations = @[@(0), @(1.0f)];
                gl.frame = view.bounds;
                [view.layer addSublayer:gl];
            }
        };
    }
    return _extendShadowView;
}

- (UILabel *)extendLB {
    if (!_extendLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        _extendLB = l;
    }
    return _extendLB;
}

- (UILabel *)useDateLB {
    if (!_useDateLB) {
        UILabel *l = UILabel.new;
        l.textColor = [UIColor hd_colorWithHexString:@"999999"];
        l.font = [HDAppTheme.font standard5];
        l.textAlignment = NSTextAlignmentCenter;
        l.numberOfLines = 0;
        l.hd_lineSpace = 5;
        _useDateLB = l;
        l.hidden = YES;
    }
    return _useDateLB;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = UIView.new;
        _maskView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIImageView *)lineIV {
    if (!_lineIV) {
        _lineIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_line"]];
    }
    return _lineIV;
}

- (NSTimer *)dateTimer {
    if (!_dateTimer) {
        _dateTimer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dateTimerInvoked) userInfo:nil repeats:true];
    }
    return _dateTimer;
}

- (void)dealloc {
    HDLog(@"%s", __func__);
    [_dateTimer invalidate];
    _dateTimer = nil;
}

@end
