//
//  SASelectableCouponTicketView.m
//  SuperApp
//
//  Created by seeu on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SASelectableCouponTicketView.h"


@interface SASelectableCouponTicketView ()

/// 左边背景
@property (nonatomic, strong) UIView *leftView;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 日期
@property (nonatomic, strong) SALabel *dateLB;
///< 业务线标签
@property (nonatomic, strong) NSArray<HDLabel *> *businessTags;

/// 右边背景
@property (nonatomic, strong) UIView *rightView;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
///< 门槛值
@property (nonatomic, strong) SALabel *thresholdLB;

@property (nonatomic, strong) UIView *upDotView;   ///< 上部原点
@property (nonatomic, strong) UIView *downDotView; ///< 下部原点

/// 选中使用
@property (nonatomic, strong) HDUIButton *selectBTN;

@end


@implementation SASelectableCouponTicketView

- (void)hd_setupViews {
    [self addSubview:self.leftView];
    [self addSubview:self.moneyLB];
    [self addSubview:self.thresholdLB];

    [self addSubview:self.rightView];
    [self.rightView addSubview:self.nameLB];
    [self.rightView addSubview:self.dateLB];
    [self.rightView addSubview:self.selectBTN];

    [self addSubview:self.upDotView];
    [self addSubview:self.downDotView];

    @HDWeakify(self);
    self.leftView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        [self refreshLeftView];
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:8.0];
    };

    self.rightView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:8.0];
    };

    self.upDotView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height];
    };

    self.downDotView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height];
    };
}

- (void)updateConstraints {
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.top.bottom.equalTo(self.rightView);
        make.width.mas_equalTo(kRealWidth(100));
    }];

    [self.thresholdLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_left).offset(8);
        make.right.equalTo(self.leftView.mas_right).offset(-8);
        make.top.equalTo(self.moneyLB.mas_bottom).offset(kRealHeight(10));
    }];

    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_left).offset(8);
        make.right.equalTo(self.leftView.mas_right).offset(-8);
        make.bottom.equalTo(self.leftView.mas_centerY).offset(5);
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right);
        make.top.equalTo(self.mas_top).offset(kRealHeight(8));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealHeight(1));
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.width.mas_equalTo(kRealWidth(100));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightView.mas_top).offset(kRealHeight(19.5));
        make.left.equalTo(self.rightView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.selectBTN.mas_left).offset(-kRealWidth(8));
    }];

    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBTN.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(self.rightView.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.selectBTN.mas_left).offset(-kRealWidth(8));
        make.bottom.equalTo(self.rightView.mas_bottom).offset(-kRealHeight(19.5));
    }];
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-kRealWidth(10));
        make.centerY.equalTo(self.rightView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(13), kRealWidth(13)));
    }];

    [self.upDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(8), kRealWidth(8)));
        make.centerX.equalTo(self.rightView.mas_left);
        make.centerY.equalTo(self.rightView.mas_top);
    }];

    [self.downDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(8), kRealWidth(8)));
        make.centerX.equalTo(self.rightView.mas_left);
        make.centerY.equalTo(self.rightView.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACouponTicketModel *)model {
    _model = model;

    // 设置标题
    self.nameLB.attributedText = [self generalCouponTitleTagsWithBusinessLine:model.businessTypeList titleString:model.couponTitle];
    // 设置有效期
    self.dateLB.text = [NSString stringWithFormat:@"%@:%@ ~ %@", SALocalizedString(@"valid_time", @"有效期"), model.effectiveDate, model.expireDate];

    BOOL isCouponUnused = [model.couponState isEqualToString:SACouponTicketStateUnused];
    if (isCouponUnused) {
        self.rightView.alpha = 1;
    } else {
        self.rightView.alpha = 0.7;
    }

    if (model.couponType == SACouponTicketTypeDiscount) {
        // TODO: 后续上了折扣券需要补充逻辑
        self.moneyLB.text = [NSString stringWithFormat:@"%f%%off", model.couponDiscount];
    } else if (model.couponType == SACouponTicketTypeReduction || model.couponType == SACouponTicketTypeMinus || model.couponType == SACouponTicketTypeFreight) {
        NSString *currency = model.couponAmount.currencySymbol;
        NSString *amount = model.couponAmount.amount;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[currency stringByAppendingString:amount]];
        [attributeString addAttributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, currency.length)];
        [attributeString addAttributes:@{NSFontAttributeName: HDAppTheme.font.amountOnly, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(currency.length, amount.length)];
        self.moneyLB.attributedText = attributeString;
    } else {
    }

    //使用门槛
    if (model.thresholdAmount.cent.integerValue > 0) {
        self.thresholdLB.text = [NSString stringWithFormat:SALocalizedString(@"coupon_threshold", @"满%@可用"), model.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol];
    } else {
        self.thresholdLB.text = SALocalizedString(@"no_threshold", @"无门槛");
    }

    [self.selectBTN setSelected:model.isSelected];
    [self refreshLeftView];

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)refreshLeftView {
    NSArray<CALayer *> *layers = [self.leftView.layer.sublayers copy];
    for (CALayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
    if (self.model && [self.model.couponState isEqualToString:SACouponTicketStateUnused]) {
        if (self.model && (self.model.couponType == SACouponTicketTypeDiscount)) {
            [self.leftView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FF97B7"] toColor:[UIColor hd_colorWithHexString:@"#FF1572"] startPoint:CGPointMake(0, 0)
                                                   endPoint:CGPointMake(1, 1)];
        } else if (self.model && (self.model.couponType == SACouponTicketTypeFreight)) {
            [self.leftView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#64B4FF"] toColor:[UIColor hd_colorWithHexString:@"#387CFF"] startPoint:CGPointMake(0, 0)
                                                   endPoint:CGPointMake(1, 1)];
        } else {
            [self.leftView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FF9A15"] toColor:[UIColor hd_colorWithHexString:@"#FF591E"] startPoint:CGPointMake(0, 0)
                                                   endPoint:CGPointMake(1, 1)];
        }
    } else {
        [self.leftView setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#DEDDDD"] toColor:[UIColor hd_colorWithHexString:@"#DEDDDD"] startPoint:CGPointMake(0, 0)
                                               endPoint:CGPointMake(1, 1)];
    }
}
/// 生成带业务线标签的标题
/// @param list 业务线列表
/// @param title 标题
- (NSAttributedString *)generalCouponTitleTagsWithBusinessLine:(NSArray<NSNumber *> *)list titleString:(NSString *)title {
    NSMutableParagraphStyle *paragraStype = [[NSMutableParagraphStyle alloc] init];
    paragraStype.lineHeightMultiple = 0;

    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSParagraphStyleAttributeName: paragraStype}];
    ;
    NSArray<NSTextAttachment *> *attachments = [self generalTextAttachmentWithBusinessLine:list];
    for (NSTextAttachment *attach in attachments) {
        NSAttributedString *attachStr = [NSMutableAttributedString attributedStringWithAttachment:attach];
        [titleStr appendAttributedString:attachStr];
        [titleStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}]];
    }
    [titleStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:title attributes:@{
                  NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightBold],
                  NSForegroundColorAttributeName: HDAppTheme.color.G1,
                  NSParagraphStyleAttributeName: paragraStype
              }]];
    return titleStr;
}

/// 根据业务线生成图片标签
/// @param list 业务线
- (NSArray<NSTextAttachment *> *)generalTextAttachmentWithBusinessLine:(NSArray<NSNumber *> *)list {
    NSMutableArray<NSTextAttachment *> *attachments = [[NSMutableArray alloc] initWithCapacity:2];
    SALabel *label = SALabel.new;
    label.font = [UIFont systemFontOfSize:9 * 3];
    label.textColor = UIColor.whiteColor;
    label.hd_edgeInsets = UIEdgeInsetsMake(2 * 3, 8 * 3, 2 * 3, 8 * 3);
    for (NSNumber *bl in list) {
        if (bl.integerValue == SAMarketingBusinessTypeYumNow.integerValue) {
            label.text = SALocalizedString(@"SAMarketingBusinessTypeYumNow", @"外卖");
            label.backgroundColor = [UIColor hd_colorWithHexString:@"#387CFF"];
        } else if (bl.integerValue == SAMarketingBusinessTypeTinhNow.integerValue) {
            label.text = SALocalizedString(@"SAMarketingBusinessTypeTinhNow", @"电商");
            label.backgroundColor = [UIColor hd_colorWithHexString:@"#FF8812"];
        } else if (bl.integerValue == SAMarketingBusinessTypeTopUp.integerValue) {
            label.text = SALocalizedString(@"SAMarketingBusinessTypeTopUp", @"话费充值");
            label.backgroundColor = [UIColor hd_colorWithHexString:@"#30BD15"];
        } else if (bl.integerValue == SAMarketingBusinessTypeGame.integerValue) {
            label.text = SALocalizedString(@"SAMarketingBusinessTypeGame", @"游戏");
            label.backgroundColor = [UIColor hd_colorWithHexString:@"#7E19CF"];
        }

        [label sizeToFit];
        [label setRoundedCorners:UIRectCornerAllCorners radius:label.frame.size.height];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, label.frame.size.width / 3.0, label.frame.size.height / 3.0);
        attach.image = [self imageWithUIView:label];
        [attachments addObject:attach];
    }
    return attachments;
}

- (UIImage *)imageWithUIView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

#pragma mark - lazy load
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = UIView.new;
        _leftView.backgroundColor = UIColor.whiteColor;
    }
    return _leftView;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)dateLB {
    if (!_dateLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard5;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 2;
        _dateLB = label;
    }
    return _dateLB;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = UIView.new;
        _rightView.backgroundColor = UIColor.whiteColor;
    }
    return _rightView;
}

- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        _moneyLB = label;
    }
    return _moneyLB;
}

/** @lazy threo */
- (SALabel *)thresholdLB {
    if (!_thresholdLB) {
        _thresholdLB = [[SALabel alloc] init];
        _thresholdLB.numberOfLines = 2;
        _thresholdLB.textAlignment = NSTextAlignmentCenter;
        _thresholdLB.textColor = UIColor.whiteColor;
        _thresholdLB.font = HDAppTheme.font.standard5;
    }
    return _thresholdLB;
}

/** @lazy updotview */
- (UIView *)upDotView {
    if (!_upDotView) {
        _upDotView = [[UIView alloc] init];
        _upDotView.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    }
    return _upDotView;
}
/** @lazy downDotView */
- (UIView *)downDotView {
    if (!_downDotView) {
        _downDotView = [[UIView alloc] init];
        _downDotView.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    }
    return _downDotView;
}

/** @lazy selectBtn */
- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        _selectBTN = [[HDUIButton alloc] init];
        [_selectBTN setImage:[UIImage imageNamed:@"coupon_no_select"] forState:UIControlStateNormal];
        [_selectBTN setImage:[UIImage imageNamed:@"coupon_selected"] forState:UIControlStateSelected];
    }
    return _selectBTN;
}

@end
