//
//  GNOrderTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderTableViewCell.h"
#import "GNCouPonImageView.h"
#import "HDMediator+GroupOn.h"
#import "SAGeneralUtil.h"


@interface GNOrderTableViewCell ()
///商品图片
@property (nonatomic, strong) GNCouPonImageView *iconIV;
///过期文字
@property (nonatomic, strong) HDLabel *expireLB;
///标题
@property (nonatomic, strong) HDLabel *titleLB;
///商品名字
@property (nonatomic, strong) HDLabel *nameLB;
///下单时间
@property (nonatomic, strong) HDLabel *timeLB;
///取消时间
@property (nonatomic, strong) HDLabel *cancelTimeLB;
///支付类型
@property (nonatomic, strong) HDLabel *payTypeLB;
///订单类型
@property (nonatomic, strong) HDUIButton *orderTypeLB;
///数量
@property (nonatomic, strong) HDLabel *amountLB;
///价格
@property (nonatomic, strong) HDLabel *priceLB;
///操作
@property (nonatomic, strong) HDUIButton *operationBtn;
///退款详情
@property (nonatomic, strong) HDUIButton *refundDetailBTN;
///卡片
@property (nonatomic, strong) UIView *view;
/// headView
@property (nonatomic, strong) UIView *headView;
/// lineView
@property (nonatomic, strong) UIView *lineOne;
///倒计时
@property (nonatomic, strong) YYLabel *countTimeLB;
///退款状态
@property (nonatomic, strong) HDUIButton *refundLB;
/// lineView
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation GNOrderTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.view];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.orderTypeLB];
    [self.headView addSubview:self.titleLB];
    [self.headView addSubview:self.refundLB];
    [self.headView addSubview:self.lineOne];
    [self.view addSubview:self.iconIV];
    [self.view addSubview:self.nameLB];
    [self.view addSubview:self.timeLB];
    [self.view addSubview:self.payTypeLB];
    [self.view addSubview:self.amountLB];
    [self.view addSubview:self.priceLB];
    [self.view addSubview:self.operationBtn];
    [self.view addSubview:self.countTimeLB];
    [self.view addSubview:self.refundDetailBTN];
    [self.iconIV addSubview:self.expireLB];
    [self.view addSubview:self.bottomLine];
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        if (self.model.first) {
            make.top.mas_equalTo(kRealWidth(12));
            make.bottom.mas_equalTo(-kRealWidth(4));
        } else if (self.model.last) {
            make.top.mas_equalTo(kRealWidth(4));
            make.bottom.mas_equalTo(-kRealWidth(12));
        } else {
            make.top.mas_equalTo(kRealWidth(4));
            make.bottom.mas_equalTo(-kRealWidth(4));
        }
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];

    [self.orderTypeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(16));
        make.height.mas_equalTo(kRealWidth(24));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.centerY.equalTo(self.orderTypeLB);
        make.right.equalTo(self.orderTypeLB.mas_left).offset(-kRealWidth(5));
    }];

    [self.lineOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.headView.mas_bottom).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealHeight(48), kRealHeight(48)));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(12));
        make.top.equalTo(self.iconIV.mas_top).offset(-kRealWidth(4));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(5));
    }];

    [self.payTypeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];
    __block UIView *view = self.priceLB;
    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.payTypeLB.mas_bottom).offset(kRealWidth(5));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [self.countTimeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countTimeLB.isHidden) {
            make.left.right.equalTo(self.nameLB);
            make.top.equalTo(self.priceLB.mas_bottom).offset(kRealWidth(5));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            view = self.countTimeLB;
        }
    }];

    [self.refundLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.refundLB.isHidden) {
            make.right.equalTo(self.orderTypeLB.mas_right);
            make.top.equalTo(self.priceLB.mas_bottom).offset(kRealWidth(8));
            make.height.mas_equalTo(kRealWidth(26));
            view = self.refundLB;
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(view.mas_bottom).offset(kRealWidth(17));
    }];

    [self.operationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(kRealWidth(15));
        make.bottom.mas_equalTo(-kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(28));
    }];

    [self.refundDetailBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.refundDetailBTN.isHidden) {
            make.centerY.height.equalTo(self.operationBtn);
            make.right.mas_equalTo(self.operationBtn.mas_left).offset(-kRealWidth(12));
        }
    }];

    [self.orderTypeLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.orderTypeLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.operationBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.operationBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.refundDetailBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.refundDetailBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setGNModel:(GNOrderCellModel *)data {
    self.model = data;
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    self.titleLB.text = GNFillEmpty(data.merchantInfo.name.desc);
    [self.orderTypeLB setTitle:data.bitStateStr forState:UIControlStateNormal];
    [self.orderTypeLB setImage:[UIImage imageNamed:data.bitStateImageStr] forState:UIControlStateNormal];
    self.nameLB.text = GNFillEmpty(data.productInfo.name.desc);

    NSString *time = [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", GNLocalizedString(@"gn_order_time", @"下单时间"), time]];
    timeStr.yy_font = [HDAppTheme.font gn_ForSize:12];
    timeStr.yy_color = HDAppTheme.color.gn_999Color;
    [timeStr yy_setColor:HDAppTheme.color.gn_333Color range:[timeStr.string rangeOfString:time]];
    self.timeLB.attributedText = timeStr;

    NSMutableAttributedString *payTypeStr =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", GNLocalizedString(@"gn_order_paymethor", @"支付方式"), data.paymentMethodStr]];
    payTypeStr.yy_font = [HDAppTheme.font gn_ForSize:12];
    payTypeStr.yy_color = HDAppTheme.color.gn_999Color;
    [payTypeStr yy_setColor:HDAppTheme.color.gn_333Color range:[payTypeStr.string rangeOfString:data.paymentMethodStr]];
    self.payTypeLB.attributedText = payTypeStr;

    NSMutableAttributedString *priceStr =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", GNLocalizedString(@"gn_order_price_inface", @"金额"), GNFillMonEmpty(data.actualAmount)]];
    priceStr.yy_font = [HDAppTheme.font gn_ForSize:12];
    priceStr.yy_color = HDAppTheme.color.gn_999Color;
    [priceStr yy_setColor:HDAppTheme.color.gn_mainColor range:[priceStr.string rangeOfString:GNFillMonEmpty(data.actualAmount)]];
    [priceStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Bold"] range:[priceStr.string rangeOfString:GNFillMonEmpty(data.actualAmount)]];
    self.priceLB.attributedText = priceStr;

    if ([data.productInfo.type.codeId isEqualToString:GNProductTypeP2]) {
        self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
    } else {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.productInfo.imagePath] placeholderImage:HDHelper.placeholderImage];
    }
    NSString *operationStr = @"";
    self.operationBtn.userInteractionEnabled = YES;
    if ([data.bizState.codeId isEqualToString:GNOrderStatusUse]) {
        operationStr = GNLocalizedString(@"gn_order_go_use", @"去使用");
        self.operationBtn.userInteractionEnabled = NO;
    } else if ([data.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
        operationStr = GNLocalizedString(@"gn_to_pay", @"去付款");
    } else {
        operationStr = GNLocalizedString(@"gn_order_again", @"再来一单");
    }

    [self.operationBtn setTitle:operationStr forState:UIControlStateNormal];
    self.expireLB.hidden = !([data.bizState.codeId isEqualToString:GNOrderStatusCancel] && [data.neCancelState isEqualToString:GNOrderCancelTypeTime]);
    self.countTimeLB.hidden = !(data.payFailureTime > 0 && [data.paymentMethod.codeId isEqualToString:GNPayMetnodTypeOnline]);
    self.countTime = self.model.payFailureTime;

    self.refundLB.hidden = (!data.refundState || [data.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash]);
    self.refundDetailBTN.hidden = (!data.refundState || [data.paymentMethod.codeId isEqualToString:GNPayMetnodTypeCash] || ([data.refundState.codeId isEqualToString:GNOrderRefundStatusWait]));
    [self.refundLB setTitle:self.model.refundStr forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (void)setCountTime:(long)countTime {
    _countTime = countTime;
    NSArray *strArr = [[self lessSecondToDay:self.model.payFailureTime / 1000] componentsSeparatedByString:@":"];
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:GNLocalizedString(@"gn_payment_time", @"剩余支付时间")];
    timeStr.yy_font = [HDAppTheme.font gn_ForSize:12];
    timeStr.yy_color = HDAppTheme.color.gn_999Color;

    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                      attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                                                           alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:strArr.firstObject];
    getStr.yy_color = UIColor.whiteColor;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    YYTextBorder *getBorder = YYTextBorder.new;
    getBorder.insets = UIEdgeInsetsMake(-kRealWidth(2), -kRealWidth(4), -kRealWidth(2), -kRealWidth(4));
    getBorder.fillColor = HDAppTheme.WMColor.mainRed;
    getBorder.cornerRadius = kRealWidth(4);
    getStr.yy_textBackgroundBorder = getBorder;
    [timeStr appendAttributedString:getStr];

    spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                              alignToFont:[UIFont systemFontOfSize:0]
                                                                alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    getStr = [[NSMutableAttributedString alloc] initWithString:@":"];
    getStr.yy_color = HDAppTheme.WMColor.mainRed;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    [timeStr appendAttributedString:getStr];

    spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                              alignToFont:[UIFont systemFontOfSize:0]
                                                                alignment:YYTextVerticalAlignmentCenter];
    [timeStr appendAttributedString:spaceText];

    getStr = [[NSMutableAttributedString alloc] initWithString:strArr.lastObject];
    getStr.yy_color = UIColor.whiteColor;
    getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    getBorder = YYTextBorder.new;
    getBorder.insets = UIEdgeInsetsMake(-kRealWidth(2), -kRealWidth(4), -kRealWidth(2), -kRealWidth(4));
    getBorder.fillColor = HDAppTheme.WMColor.mainRed;
    getBorder.cornerRadius = kRealWidth(4);
    getStr.yy_textBackgroundBorder = getBorder;
    [timeStr appendAttributedString:getStr];

    self.countTimeLB.attributedText = timeStr;
}

- (NSString *)lessSecondToDay:(long)seconds {
    if (seconds <= 0)
        return @"";
    long min = (long)(seconds % (3600)) / 60;
    long second = (long)(seconds % 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}

- (void)storeAction {
    [GNEvent eventResponder:self target:self.titleLB key:@"storeAction" indexPath:self.model.indexPath info:@{@"storeNo": self.model.merchantInfo.storeNo ?: @""}];
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _bottomLine;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.font = [HDAppTheme.font gn_boldForSize:16.0f];
        _titleLB.userInteractionEnabled = YES;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeAction)];
        [_titleLB addGestureRecognizer:ta];
    }
    return _titleLB;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        _timeLB = HDLabel.new;
    }
    return _timeLB;
}

- (HDLabel *)amountLB {
    if (!_amountLB) {
        _amountLB = HDLabel.new;
        _amountLB.font = HDAppTheme.font.gn_12;
    }
    return _amountLB;
}
- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
        _priceLB.font = HDAppTheme.font.gn_12;
    }
    return _priceLB;
}

- (HDLabel *)payTypeLB {
    if (!_payTypeLB) {
        _payTypeLB = HDLabel.new;
        _payTypeLB.font = HDAppTheme.font.gn_12;
    }
    return _payTypeLB;
}

- (HDLabel *)cancelTimeLB {
    if (!_cancelTimeLB) {
        _cancelTimeLB = HDLabel.new;
        _cancelTimeLB.font = HDAppTheme.font.gn_12;
    }
    return _cancelTimeLB;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightMedium];
        _nameLB.textColor = HDAppTheme.color.gn_333Color;
    }
    return _nameLB;
}

- (YYLabel *)countTimeLB {
    if (!_countTimeLB) {
        _countTimeLB = YYLabel.new;
    }
    return _countTimeLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = GNCouPonImageView.new;
        _iconIV.layer.cornerRadius = kRealWidth(4);
        _iconIV.couponLB.hidden = YES;
    }
    return _iconIV;
}

- (HDUIButton *)operationBtn {
    if (!_operationBtn) {
        _operationBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _operationBtn.layer.cornerRadius = kRealWidth(3);
        [_operationBtn setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _operationBtn.layer.borderWidth = HDAppTheme.value.gn_border;
        _operationBtn.titleLabel.font = [HDAppTheme.font gn_ForSize:11];
        _operationBtn.layer.borderColor = HDAppTheme.color.gn_cccccc.CGColor;
        _operationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        @HDWeakify(self)[_operationBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (GNStringNotEmpty(self.model.bizState.codeId)) {
                if ([self.model.bizState.codeId isEqualToString:GNOrderStatusFinish] || [self.model.bizState.codeId isEqualToString:GNOrderStatusCancel]) {
                    [GNEvent eventResponder:self target:btn key:@"bugAgain" indexPath:self.model.indexPath];
                } else if ([self.model.bizState.codeId isEqualToString:GNOrderStatusUnPay]) {
                    [GNEvent eventResponder:self target:btn key:@"onlinePayAction" indexPath:self.model.indexPath info:@{@"model": self.model}];
                }
            }
        }];
    }
    return _operationBtn;
}

- (HDUIButton *)refundDetailBTN {
    if (!_refundDetailBTN) {
        _refundDetailBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_refundDetailBTN setTitle:SALocalizedString(@"refund_detail", @"退款详情") forState:UIControlStateNormal];
        _refundDetailBTN.layer.cornerRadius = kRealWidth(3);
        [_refundDetailBTN setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _refundDetailBTN.layer.borderWidth = HDAppTheme.value.gn_border;
        _refundDetailBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:11];
        _refundDetailBTN.layer.borderColor = HDAppTheme.color.gn_cccccc.CGColor;
        _refundDetailBTN.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        @HDWeakify(self)[_refundDetailBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (GNStringNotEmpty(self.model.refundState.codeId)) {
                [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": GNFillEmpty(self.model.aggregateOrderNo)}];

                //                [HDMediator.sharedInstance navigaveToGNRefundDetailViewController:@{
                //                    @"aggregateOrderNo" : GNFillEmpty(self.model.aggregateOrderNo),
                //                    @"businessPhone":self.model.merchantInfo.businessPhone,
                //                    @"cancelTime":@(self.model.cancelTime),
                //                    @"cancelState":self.model.cancelState.codeId}];
            }
        }];
    }
    return _refundDetailBTN;
}

- (HDUIButton *)orderTypeLB {
    if (!_orderTypeLB) {
        _orderTypeLB = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _orderTypeLB.titleLabel.font = [HDAppTheme.font gn_ForSize:12.0f];
        _orderTypeLB.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
        _orderTypeLB.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8));
        [_orderTypeLB setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _orderTypeLB.highlighted = NO;
        _orderTypeLB.imagePosition = HDUIButtonImagePositionLeft;
        _orderTypeLB.spacingBetweenImageAndTitle = 1;
        _orderTypeLB.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
        _orderTypeLB.layer.cornerRadius = kRealWidth(3);
        _orderTypeLB.userInteractionEnabled = YES;
        @HDWeakify(self)[_orderTypeLB addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self storeAction];
        }];
    }
    return _orderTypeLB;
}

- (UIView *)view {
    if (!_view) {
        _view = UIView.new;
        _view.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
        _view.layer.cornerRadius = kRealWidth(4);
        _view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0400].CGColor;
        _view.layer.shadowOffset = CGSizeMake(0, 4);
        _view.layer.shadowOpacity = 1;
        _view.layer.shadowRadius = 12;
    }
    return _view;
}

- (HDUIButton *)refundLB {
    if (!_refundLB) {
        HDUIButton *label = [HDUIButton buttonWithType:UIButtonTypeCustom];
        label.highlighted = NO;
        label.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, kRealWidth(12));
        [label setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        label.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
        [label setBackgroundImage:[UIImage imageNamed:@"gn_order_icon_refund"] forState:UIControlStateNormal];
        _refundLB = label;
    }
    return _refundLB;
}

- (HDLabel *)expireLB {
    if (!_expireLB) {
        _expireLB = HDLabel.new;
        _expireLB.font = [HDAppTheme.font gn_ForSize:6];
        _expireLB.layer.backgroundColor = HDAppTheme.color.gn_666Color.CGColor;
        _expireLB.textColor = HDAppTheme.color.gn_whiteColor;
        _expireLB.textAlignment = NSTextAlignmentCenter;
        _expireLB.hd_edgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        _expireLB.text = GNLocalizedString(@"gn_order_user_expire", @"已过期");
        _expireLB.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }
    return _expireLB;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = UIView.new;
        _headView.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
        _headView.layer.cornerRadius = kRealHeight(8);
    }
    return _headView;
}

- (UIView *)lineOne {
    if (!_lineOne) {
        _lineOne = UIView.new;
        _lineOne.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _lineOne;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    const CGFloat iconW = 80;
    CGFloat margin = 10;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    circle.skeletonCornerRadius = 8;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(r0.hd_bottom + margin);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width - 60);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.right.hd_equalTo(self.hd_width - 60);
        make.top.hd_equalTo(r1.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.right.hd_equalTo(self.hd_width - 60);
        make.top.hd_equalTo(r2.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(circle.hd_bottom + margin);
        make.height.hd_equalTo(r3.hd_height);
    }];
    return @[r0, circle, r1, r2, r3, r4];
}

+ (CGFloat)skeletonViewHeight {
    return 165;
}

@end
