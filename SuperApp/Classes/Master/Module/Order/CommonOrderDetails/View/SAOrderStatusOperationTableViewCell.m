//
//  SAOrderStatusOperationTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOrderStatusOperationTableViewCell.h"
#import "SAGeneralUtil.h"
#import "SAOperationButton.h"


@interface SAOrderStatusOperationTableViewCell ()
///< 状态
@property (nonatomic, strong) SALabel *statusLabel;
///< 状态描述
@property (nonatomic, strong) SALabel *statusDescLabel;

/// 按钮所在view
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 立即支付
@property (nonatomic, strong) SAOperationButton *payNowBTN;
///< 按钮列表
@property (nonatomic, strong) NSArray<SAOperationButton *> *allOperationButton;
/// 待支付倒计时定时器
@property (nonatomic, strong) NSTimer *payTimer;
/// 倒计时支付总时长
@property (nonatomic, assign) NSInteger payTimerSecondsTotal;
/// 倒计时支付剩余时长
@property (nonatomic, assign) NSInteger payTimerSecondsLeft;
/// 开始时间
@property (nonatomic, strong) NSDate *payTimerStartDate;

@end


@implementation SAOrderStatusOperationTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.statusDescLabel];
    [self.contentView addSubview:self.floatLayoutView];
}

- (void)updateConstraints {
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(18));
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.statusDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealHeight(10));
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            CGFloat width = kScreenWidth - 2 * HDAppTheme.value.padding.left;
            make.top.equalTo(self.statusDescLabel.mas_bottom).offset(kRealWidth(15));
            make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
        }
    }];

    [super updateConstraints];
}

- (void)dealloc {
    [_payTimer invalidate];
    _payTimer = nil;
}

#pragma mark - setter
- (void)setModel:(SAOrderStatusOperationTableViewCellModel *)model {
    _model = model;
    if (model.aggregateOrderState == SAAggregateOrderStateComplete) {
        self.statusLabel.text = [SAGeneralUtil getAggregateOrderFinalStateWithCode:model.aggregateOrderFinalState];
    } else {
        self.statusLabel.text = [SAGeneralUtil getAggregateOrderStateWithCode:model.aggregateOrderState];
    }
    self.statusDescLabel.text = @"";

    self.payNowBTN.hidden = YES;

    @HDWeakify(self);
    [model.operationList enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        if ([obj isEqualToString:SAOrderListOperationEventNamePay]) {
            self.payNowBTN.hidden = NO;
        }
    }];
    [self configFloatLayoutView];
    if (model.aggregateOrderState == SAAggregateOrderStatePaying) {
        [self configTimerWithModel:model];
    } else {
        if (_payTimer) {
            [_payTimer invalidate];
            _payTimer = nil;
        }
    }

    [self setNeedsUpdateConstraints];
}
#pragma mark - private methods
- (void)configTimerWithModel:(SAOrderStatusOperationTableViewCellModel *)model {
    // 计算剩余时间秒数
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval orderPassedSeconds = (nowInterval - model.createTime.longLongValue / 1000.0);
    // HDLog(@"订单号：%@ 当前时间：%.0f 订单时间：%.0f 订单产生已过去：%.0f 秒", orderSimpleInfo.orderNo, nowInterval, orderSimpleInfo.orderTimeStamp.longLongValue / 1000.0, orderPassedSeconds);
    NSUInteger maxSeconds = (model.expireTime <= 0 ? 15 : model.expireTime) * 60;

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

        self.statusDescLabel.textColor = HDAppTheme.color.C1;
        self.statusDescLabel.text =
            [NSString stringWithFormat:SALocalizedString(@"order_submit_tips", @"您的订单已提交，请在 %@ 内完成支付， 超时订单会自动取消"), [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft]];
    }
}

- (void)configFloatLayoutView {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.allOperationButton enumerateObjectsUsingBlock:^(SAOperationButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.isHidden) {
            [self.floatLayoutView addSubview:obj];
        }
    }];
}

- (void)payTimerInvoked {
    HDLog(@"定时器轮询...");
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_payTimerStartDate];

    self.payTimerSecondsLeft = self.payTimerSecondsTotal - (NSInteger)(deltaTime + 0.5);
    if (self.payTimerSecondsLeft < 0) {
        self.payTimerSecondsLeft = 0;
    }
    NSString *desc =
        [NSString stringWithFormat:SALocalizedString(@"order_submit_tips", @"您的订单已提交，请在 %@ 内完成支付， 超时订单会自动取消"), [SAGeneralUtil timeWithSeconds:self.payTimerSecondsLeft]];
    self.statusDescLabel.text = desc;
    [self setNeedsUpdateConstraints];

    if (self.payTimerSecondsLeft <= 0.0) {
        [self invalidatePayTimer];
    }
}
// 关闭定时器
- (void)invalidatePayTimer {
    if (_payTimer) {
        if ([_payTimer respondsToSelector:@selector(isValid)]) {
            if ([_payTimer isValid]) {
                [_payTimer invalidate];
                _payTimer = nil;
                // 倒计时结束，应该通知业务方刷新
                !self.timerInvalidateHandler ?: self.timerInvalidateHandler(self.model);
            }
        }
    }
}

#pragma mark - Action
- (void)clickedPayNowBTNHandler {
    !self.payNowClickedHandler ?: self.payNowClickedHandler(self.model);
}

#pragma mark - lazy load
- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.text = @" ";
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (SALabel *)statusDescLabel {
    if (!_statusDescLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        _statusDescLabel = label;
    }
    return _statusDescLabel;
}

- (SAOperationButton *)payNowBTN {
    if (!_payNowBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(6, 15, 6, 15);
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:SALocalizedString(@"top_up_pay_now", @"立即支付") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedPayNowBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        [button applyHollowPropertiesWithTintColor:HDAppTheme.color.G2];
        _payNowBTN = button;
    }
    return _payNowBTN;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 5, 5);
    }
    return _floatLayoutView;
}

- (NSArray<SAOperationButton *> *)allOperationButton {
    return @[self.payNowBTN];
}

- (NSTimer *)payTimer {
    if (!_payTimer) {
        _payTimer = [HDWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(payTimerInvoked) userInfo:nil repeats:true];
    }
    return _payTimer;
}

@end


@implementation SAOrderStatusOperationTableViewCellModel

@end
