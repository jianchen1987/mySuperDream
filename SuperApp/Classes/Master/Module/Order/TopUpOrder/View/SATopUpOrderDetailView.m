//
//  WMTopUpOrderDetailView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailView.h"
#import "HDTradeBuildOrderModel.h"
#import "SAContactPhoneView.h"
#import "SAInfoView.h"
#import "SAOrderDetailRowView.h"
#import "SAQueryOrderDetailsRspModel.h"
#import "SATopUpOrderDetailRspModel.h"
#import "SATopUpOrderDetailViewModel.h"


@interface SATopUpOrderDetailView ()

/// 状态背景
@property (nonatomic, strong) UIView *statusBgView;
/// 状态
@property (nonatomic, strong) SALabel *statusLabel;
/// 状态按钮
@property (nonatomic, strong) HDUIGhostButton *statusBtn;
/// 去支付按钮
@property (nonatomic, strong) HDUIGhostButton *payBtn;
/// 状态线
@property (nonatomic, strong) UIView *statusLine;

/// 退款详情
@property (nonatomic, strong) SAOrderDetailRowView *refundDetailView;
/// 顶部背景
@property (nonatomic, strong) UIView *topBgView;
/// 充值中心按钮
@property (nonatomic, strong) UIControl *topUpCenterView;
/// 充值按钮
@property (nonatomic, strong) HDUIGhostButton *topUpCenterIcon;
/// 充值中心标题
@property (nonatomic, strong) SALabel *topUpCenterLabel;
/// 充值中心右箭头
@property (nonatomic, strong) UIImageView *topUpCenterRightIcon;

/// 充值图标
@property (nonatomic, strong) UIImageView *topUpIcon;
/// 充值号码
@property (nonatomic, strong) SALabel *accountLabel;
/// 充值金额
@property (nonatomic, strong) SALabel *topUpLabel;
/// 中间线
@property (nonatomic, strong) UIView *topUpLine;

/// 底部背景
@property (nonatomic, strong) UIView *bottomBgView;
/// infoView 数组
@property (nonatomic, strong) NSArray<SAInfoView *> *infoViewArray;
/// 创建时间
@property (nonatomic, strong) SAInfoView *createTimeView;
/// 订单号
@property (nonatomic, strong) SAInfoView *orderNoInfoView;
///< 支付减免
@property (nonatomic, strong) SAInfoView *payDiscountInfoView;
/// 支付金额
@property (nonatomic, strong) SAInfoView *orderMoneyInfoView;
/// 充值时间
@property (nonatomic, strong) SAInfoView *topUpTimeInfoView;

/// 状态描述
@property (nonatomic, strong) SALabel *statusDescLB;
/// 待支付倒计时定时器
@property (nonatomic, strong) NSTimer *payTimer;
/// 倒计时支付总时长
@property (nonatomic, assign) NSInteger payTimerSecondsTotal;
/// 倒计时支付剩余时长
@property (nonatomic, assign) NSInteger payTimerSecondsLeft;
/// 开始时间
@property (nonatomic, strong) NSDate *payTimerStartDate;

@end


@implementation SATopUpOrderDetailView

- (void)hd_setupViews {
    [self addSubview:self.statusBgView];
    [self.statusBgView addSubview:self.statusLabel];
    [self.statusBgView addSubview:self.statusBtn];
    [self.statusBgView addSubview:self.payBtn];
    [self.statusBgView addSubview:self.statusLine];
    [self.statusBgView addSubview:self.statusDescLB];

    [self addSubview:self.refundDetailView];

    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.topUpCenterView];
    [self.topUpCenterView addSubview:self.topUpCenterIcon];
    [self.topUpCenterView addSubview:self.topUpCenterLabel];
    [self.topUpCenterView addSubview:self.topUpCenterRightIcon];

    [self.topBgView addSubview:self.topUpIcon];
    [self.topBgView addSubview:self.accountLabel];
    [self.topBgView addSubview:self.topUpLabel];
    [self.topBgView addSubview:self.topUpLine];

    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.orderNoInfoView];
    [self.bottomBgView addSubview:self.payDiscountInfoView];
    [self.bottomBgView addSubview:self.orderMoneyInfoView];
    [self.bottomBgView addSubview:self.createTimeView];
    [self.bottomBgView addSubview:self.topUpTimeInfoView];

    self.infoViewArray = @[self.orderNoInfoView, self.payDiscountInfoView, self.orderMoneyInfoView, self.createTimeView, self.topUpTimeInfoView];
}

- (void)dealloc {
    [_payTimer invalidate];
    _payTimer = nil;
}

- (void)updateConstraints {
    [self.statusBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBgView.mas_top).offset(kRealWidth(15));
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.statusDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.statusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel);
        if (!self.statusLabel.isHidden) {
            make.top.equalTo(self.statusDescLB.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(10));
        }
    }];

    [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.statusBtn);
    }];

    [self.statusLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.statusBtn.isHidden) {
            make.top.equalTo(self.payBtn.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.statusBtn.mas_bottom).offset(kRealWidth(15));
        }
        make.height.mas_equalTo(kRealWidth(10));
        make.left.bottom.right.equalTo(self.statusBgView);
    }];

    [self.refundDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.refundDetailView.isHidden) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.statusBgView.mas_bottom);
        }
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *view = self.refundDetailView.isHidden ? self.statusBgView : self.refundDetailView;
        make.top.equalTo(view.mas_bottom);
        make.left.right.equalTo(self);
    }];

    [self.topUpCenterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.topBgView);
    }];

    [self.topUpCenterIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topUpCenterView).offset(kRealWidth(20));
        make.left.equalTo(self.topUpCenterView.mas_left).offset(HDAppTheme.value.padding.left);
        make.width.height.mas_equalTo(kRealWidth(30));
        make.bottom.equalTo(self.topUpCenterView);
    }];

    [self.topUpCenterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topUpCenterIcon.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self.topUpCenterIcon.mas_centerY);
    }];

    [self.topUpCenterRightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topUpCenterIcon.mas_centerY);
        make.left.equalTo(self.topUpCenterLabel.mas_right).offset(kRealWidth(5));
        make.width.height.mas_equalTo(kRealWidth(30));
    }];

    [self.topUpIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topUpCenterView.mas_bottom).offset(kRealWidth(16));
        make.left.equalTo(self.topBgView.mas_left).offset(HDAppTheme.value.padding.left);
        make.width.height.mas_equalTo(kRealWidth(81));
        make.bottom.equalTo(self.topBgView.mas_bottom).offset(-kRealWidth(30));
    }];

    [self.accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topUpIcon.mas_top);
        make.left.equalTo(self.topUpIcon.mas_right).offset(kRealWidth(9));
        make.right.equalTo(self.topBgView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.topUpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountLabel);
        make.bottom.equalTo(self.topUpIcon.mas_bottom);
    }];

    [self.topUpLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.topBgView);
        make.height.mas_equalTo(kRealWidth(10));
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView.mas_bottom).offset(kRealWidth(14));
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];

    NSArray<SAInfoView *> *infoViewArray = [self.infoViewArray hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView = nil;
    for (SAInfoView *infoView in infoViewArray) {
        if (infoView.isHidden) {
            continue;
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.greaterThanOrEqualTo(self.bottomBgView.mas_right).offset(-HDAppTheme.value.padding.right);
            if (!lastView) {
                make.top.equalTo(self.bottomBgView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(15));
            }
            if (infoView == infoViewArray.lastObject) {
                make.bottom.equalTo(self.bottomBgView.mas_bottom);
            }
        }];
        lastView = infoView;
    }

    [super updateConstraints];
}

#pragma mark - private methods
- (void)payTimerInvoked {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_payTimerStartDate];

    self.payTimerSecondsLeft = self.payTimerSecondsTotal - (NSInteger)(deltaTime + 0.5);
    if (self.payTimerSecondsLeft < 0) {
        self.payTimerSecondsLeft = 0;
    }
    NSString *desc =
        [NSString stringWithFormat:SALocalizedString(@"order_submit_tips", @"您的订单已提交，请在 %@ 内完成支付， 超时订单会自动取消"), [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft]];
    self.statusDescLB.text = desc;
    [self setNeedsUpdateConstraints];

    if (self.payTimerSecondsLeft <= 0.0) {
        [self invalidatePayTimer];
    }
}

- (void)invalidatePayTimer {
    if (_payTimer) {
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
                [self.model getTopUpOrderDetail];
            }
        }
    }
}

- (void)topUpCenterButtonHandler {
}

- (void)contactButtonHandler {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.contentHorizontalEdgeMargin = 0;
    config.title = WMLocalizedString(@"you_can_contact", @"你可以联系");
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.textAlignment = HDCustomViewActionViewTextAlignmentCenter;
    config.needTopSepLine = true;
    const CGFloat width = kScreenWidth - 2 * config.contentHorizontalEdgeMargin;
    SAContactPhoneView *view = [[SAContactPhoneView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    [view layoutyImmediately];

    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];

    @HDWeakify(actionView);
    view.clickedPhoneNumberBlock = ^(NSString *_Nonnull phoneNumber) {
        @HDStrongify(actionView);
        [actionView dismiss];
        [HDSystemCapabilityUtil makePhoneCall:phoneNumber];
    };
    [actionView show];
}

- (void)payButtonHandler {
    if (_BlockOnToPay) {
        _BlockOnToPay();
    }
}

#pragma mark - setter
- (void)setModel:(SATopUpOrderDetailViewModel *)model {
    _model = model;

    self.payBtn.hidden = !self.model.isShowPayButton;
    self.statusBtn.hidden = self.model.isShowPayButton;
    self.statusLabel.text = self.model.status;
    self.accountLabel.text = self.model.account;
    self.topUpLabel.attributedText = self.model.topUpMoney;
    [HDWebImageManager setImageWithURL:self.model.storeIcon placeholderImage:HDHelper.placeholderImage imageView:self.topUpIcon];
    self.orderNoInfoView.model.valueText = self.model.orderNo;

    if (self.model.orderInfo.payDiscountAmount && self.model.orderInfo.payDiscountAmount.cent.integerValue > 0) {
        self.payDiscountInfoView.hidden = NO;
        self.payDiscountInfoView.model.valueText = [NSString stringWithFormat:@"-%@", self.model.orderInfo.payDiscountAmount.thousandSeparatorAmount];
        self.orderMoneyInfoView.model.valueText = self.model.orderInfo.payActualPayAmount.thousandSeparatorAmount;
    } else {
        self.payDiscountInfoView.hidden = YES;
        self.orderMoneyInfoView.model.valueText = self.model.payMoney;
    }

    self.createTimeView.model.valueText = self.model.createTime;
    self.topUpTimeInfoView.hidden = HDIsStringEmpty(self.model.orderTime);
    self.topUpTimeInfoView.model.valueText = self.model.orderTime;
    [self.infoViewArray enumerateObjectsUsingBlock:^(SAInfoView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj setNeedsUpdateContent];
    }];

    if (self.model.model.orderStatus == HDPayOrderStatusCreated) {
        self.statusDescLB.hidden = false;
        [self configTimer];
    } else {
        self.statusDescLB.hidden = true;
    }

    self.refundDetailView.hidden = !self.model.model.refundInfo;

    [self setNeedsUpdateConstraints];
}

- (void)configTimer {
    // 计算剩余时间秒数
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval orderPassedSeconds = (nowInterval - self.model.model.createTime.longLongValue / 1000.0);
    // HDLog(@"订单号：%@ 当前时间：%.0f 订单时间：%.0f 订单产生已过去：%.0f 秒", orderSimpleInfo.orderNo, nowInterval, orderSimpleInfo.orderTimeStamp.longLongValue / 1000.0, orderPassedSeconds);
    NSUInteger maxSeconds = (self.model.model.expirationTime <= 0 ? 30 : self.model.model.expirationTime) * 60;

    if (orderPassedSeconds >= maxSeconds) {
        HDLog(@"订单已到最大待支付时间，后端未做取消处理");
    } else {
        // 开启倒计时
        if (_payTimer) {
            [_payTimer invalidate];
            _payTimer = nil;
        }
        _payTimerStartDate = [NSDate date];
        self.payTimer.fireDate = [NSDate distantPast];

        self.payTimerSecondsTotal = maxSeconds - orderPassedSeconds;
        self.payTimerSecondsLeft = self.payTimerSecondsTotal;
        [[NSRunLoop currentRunLoop] addTimer:self.payTimer forMode:NSRunLoopCommonModes];

        self.statusDescLB.textColor = HDAppTheme.color.C1;
        self.statusDescLB.text =
            [NSString stringWithFormat:SALocalizedString(@"order_submit_tips", @"您的订单已提交，请在 %@ 内完成支付， 超时订单会自动取消"), [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft]];
    }
}

#pragma mark - lazy load
- (UIView *)statusBgView {
    if (!_statusBgView) {
        _statusBgView = [[UIView alloc] init];
    }
    return _statusBgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[SALabel alloc] init];
        _statusLabel.textColor = HDAppTheme.color.G1;
        _statusLabel.font = HDAppTheme.font.standard2Bold;
    }
    return _statusLabel;
}

- (HDUIGhostButton *)statusBtn {
    if (!_statusBtn) {
        HDUIGhostButton *button = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateNormal];
        [button setTitle:SALocalizedString(@"top_up_contact", @"联系") forState:UIControlStateNormal];
        button.borderWidth = PixelOne;
        button.ghostColor = HDAppTheme.color.G2;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 10);
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
        [button addTarget:self action:@selector(contactButtonHandler) forControlEvents:UIControlEventTouchUpInside];

        _statusBtn = button;
    }
    return _statusBtn;
}

- (HDUIGhostButton *)payBtn {
    if (!_payBtn) {
        HDUIGhostButton *button = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:29 / 255.0 blue:57 / 255.0 alpha:1.0];
        [button setTitle:SALocalizedString(@"top_up_to_pay", @"去支付") forState:UIControlStateNormal];
        button.hidden = YES;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        [button addTarget:self action:@selector(payButtonHandler) forControlEvents:UIControlEventTouchUpInside];

        _payBtn = button;
    }
    return _payBtn;
}

- (UIView *)statusLine {
    if (!_statusLine) {
        _statusLine = [[UIView alloc] init];
        _statusLine.backgroundColor = HDAppTheme.color.G5;
    }
    return _statusLine;
}

- (SAOrderDetailRowView *)refundDetailView {
    if (!_refundDetailView) {
        _refundDetailView = SAOrderDetailRowView.new;
        _refundDetailView.model.keyText = SALocalizedString(@"refund_detail", @"退款详情");
        _refundDetailView.model.keyFont = HDAppTheme.font.standard2Bold;
        _refundDetailView.model.keyColor = HDAppTheme.color.G1;
        _refundDetailView.model.valueFont = HDAppTheme.font.standard3;
        _refundDetailView.model.valueColor = HDAppTheme.color.C1;
        _refundDetailView.model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];

        @HDWeakify(self);
        _refundDetailView.model.eventHandler = ^{
            @HDStrongify(self);
            //            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            //            params[@"orderNo"] = self.model.orderNo;
            //            [HDMediator.sharedInstance navigaveToTopUpRefundDetailViewController:params];
            [HDMediator.sharedInstance navigaveToCommonRefundDetailViewController:@{@"aggregateOrderNo": self.model.orderNo}];
        };
        [_refundDetailView setNeedsUpdateContent];
    }
    return _refundDetailView;
}

- (UIControl *)topUpCenterView {
    if (!_topUpCenterView) {
        _topUpCenterView = [[UIControl alloc] init];
        [_topUpCenterView addTarget:self action:@selector(topUpCenterButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topUpCenterView;
}

- (HDUIGhostButton *)topUpCenterIcon {
    if (!_topUpCenterIcon) {
        HDUIGhostButton *button = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"icon-phoneCharge"] forState:UIControlStateNormal];
        button.borderWidth = PixelOne;
        button.ghostColor = HDAppTheme.color.G4;
        button.backgroundColor = HDAppTheme.color.G5;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);

        _topUpCenterIcon = button;
    }
    return _topUpCenterIcon;
}

- (SALabel *)topUpCenterLabel {
    if (!_topUpCenterLabel) {
        _topUpCenterLabel = [[SALabel alloc] init];
        _topUpCenterLabel.textColor = HDAppTheme.color.G1;
        _topUpCenterLabel.font = HDAppTheme.font.standard2Bold;
        _topUpCenterLabel.text = SALocalizedString(@"top_up_center", @"Topup center");
    }
    return _topUpCenterLabel;
}

- (UIImageView *)topUpCenterRightIcon {
    if (!_topUpCenterRightIcon) {
        _topUpCenterRightIcon = [[UIImageView alloc] init];
        _topUpCenterRightIcon.image = [UIImage imageNamed:@"top_up_right_icon"];
        _topUpCenterRightIcon.hidden = YES;
    }
    return _topUpCenterRightIcon;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
    }
    return _topBgView;
}

- (UIImageView *)topUpIcon {
    if (!_topUpIcon) {
        _topUpIcon = [[UIImageView alloc] init];
        _topUpIcon.image = HDHelper.placeholderImage;
    }
    return _topUpIcon;
}

- (SALabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[SALabel alloc] init];
        _accountLabel.textColor = HDAppTheme.color.G1;
        _accountLabel.font = HDAppTheme.font.standard3Bold;
    }
    return _accountLabel;
}

- (SALabel *)topUpLabel {
    if (!_topUpLabel) {
        _topUpLabel = [[SALabel alloc] init];
        _topUpLabel.textColor = HDAppTheme.color.G1;
        _topUpLabel.font = HDAppTheme.font.standard3Bold;
    }
    return _topUpLabel;
}

- (UIView *)topUpLine {
    if (!_topUpLine) {
        _topUpLine = [[UIView alloc] init];
        _topUpLine.backgroundColor = HDAppTheme.color.G5;
    }
    return _topUpLine;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
    }
    return _bottomBgView;
}

/** @lazy payDiscountInfoView */
- (SAInfoView *)payDiscountInfoView {
    if (!_payDiscountInfoView) {
        _payDiscountInfoView = [[SAInfoView alloc] init];
        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = SALocalizedString(@"payment_coupon", @"支付优惠");
        model.valueTextAlignment = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard3;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        model.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _payDiscountInfoView.model = model;
    }
    return _payDiscountInfoView;
}

- (SAInfoView *)orderMoneyInfoView {
    if (!_orderMoneyInfoView) {
        _orderMoneyInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = SALocalizedString(@"top_up_amount_paid", @"支付金额");
        model.valueTextAlignment = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard3;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = HDAppTheme.color.G1;
        model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        model.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _orderMoneyInfoView.model = model;
    }
    return _orderMoneyInfoView;
}

- (SAInfoView *)topUpTimeInfoView {
    if (!_topUpTimeInfoView) {
        _topUpTimeInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = SALocalizedString(@"top_up_pay_time", @"充值时间");
        model.valueTextAlignment = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard3;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = HDAppTheme.color.G1;
        model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        model.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _topUpTimeInfoView.model = model;
    }
    return _topUpTimeInfoView;
}

- (SAInfoView *)createTimeView {
    if (!_createTimeView) {
        _createTimeView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = SALocalizedString(@"top_up_order_time", @"下单时间");
        model.valueTextAlignment = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard3;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = HDAppTheme.color.G1;
        model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        model.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _createTimeView.model = model;
    }
    return _createTimeView;
}

- (SAInfoView *)orderNoInfoView {
    if (!_orderNoInfoView) {
        _orderNoInfoView = [[SAInfoView alloc] init];

        SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
        model.keyText = SALocalizedString(@"top_up_order_no", @"订单编号");
        model.valueTextAlignment = NSTextAlignmentLeft;
        model.keyFont = HDAppTheme.font.standard3;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = HDAppTheme.color.G1;
        model.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        model.lineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _orderNoInfoView.model = model;
    }
    return _orderNoInfoView;
}

- (SALabel *)statusDescLB {
    if (!_statusDescLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        _statusDescLB = label;
    }
    return _statusDescLB;
}

- (NSTimer *)payTimer {
    if (!_payTimer) {
        _payTimer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimerInvoked) userInfo:nil repeats:true];
    }
    return _payTimer;
}

@end
