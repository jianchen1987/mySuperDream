//
//  TNOrderListFooterView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListFooterView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"
#import <Masonry/Masonry.h>


@interface TNOrderListFooterView ()
/// 总计价格
@property (strong, nonatomic) UILabel *totolPriceLabel;
/// 总计数量
@property (strong, nonatomic) UILabel *totolQuantityLabel;
/// 配送时间
@property (strong, nonatomic) HDLabel *deliveryTimeLabel;
/// 操作按钮背景视图
@property (strong, nonatomic) UIStackView *oprateBtnsStackView;
/// 分隔线
@property (nonatomic, strong) UIView *sepLine;
/// 立即支付
@property (nonatomic, strong) SAOperationButton *payNowBTN;
/// 再次购买按钮
@property (nonatomic, strong) SAOperationButton *rebuyBTN;
/// 评价按钮
@property (nonatomic, strong) SAOperationButton *evaluationBTN;
/// 转账付款按钮
@property (nonatomic, strong) SAOperationButton *transferBTN;
/// 确认收货
@property (nonatomic, strong) SAOperationButton *confirmBTN;
///< 再来一单
@property (nonatomic, strong) SAOperationButton *oneMoreBTN;
/// 退款详情
@property (nonatomic, strong) SAOperationButton *refundDetailBTN;
/// 取消收货
@property (nonatomic, strong) SAOperationButton *cancelBTN;
@end


@implementation TNOrderListFooterView
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.totolPriceLabel];
    [self.contentView addSubview:self.totolQuantityLabel];
    [self.contentView addSubview:self.deliveryTimeLabel];
    [self.contentView addSubview:self.oprateBtnsStackView];
    [self.contentView addSubview:self.sepLine];
    [self.oprateBtnsStackView addArrangedSubview:self.cancelBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.refundDetailBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.oneMoreBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.evaluationBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.rebuyBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.transferBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.confirmBTN];
    [self.oprateBtnsStackView addArrangedSubview:self.payNowBTN];
}
- (void)setOrderModel:(TNOrderModel *)orderModel {
    _orderModel = orderModel;
    self.totolQuantityLabel.text = [NSString stringWithFormat:TNLocalizedString(@"mgIQzjJY", @"共%ld件商品"), orderModel.quantity];
    self.totolPriceLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"sub_total", @"总计"), orderModel.amount.thousandSeparatorAmount];

    self.confirmBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameConfirmReceiving];
    self.evaluationBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameEvaluation];
    self.refundDetailBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameRefundDetail];
    self.payNowBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNamePay];
    self.transferBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameTransfer];
    self.rebuyBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameReBuy];
    self.oneMoreBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameNearbyBuy];
    self.cancelBTN.hidden = ![orderModel.operationList containsObject:SAOrderListOperationEventNameCancel];
    // 全部按钮没有 才隐藏视图  orderModel.operationList 可能会有没有预先设置的按钮
    if (self.confirmBTN.isHidden && self.evaluationBTN.isHidden && self.refundDetailBTN.isHidden && self.payNowBTN.isHidden && self.transferBTN.isHidden && self.cancelBTN.isHidden
        && self.rebuyBTN.isHidden && self.oneMoreBTN.isHidden) {
        self.oprateBtnsStackView.hidden = YES;
        self.sepLine.hidden = YES;
    } else {
        self.oprateBtnsStackView.hidden = NO;
        self.sepLine.hidden = NO;
    }

    if (HDIsStringNotEmpty(orderModel.deliveryTime)
        && ([orderModel.status isEqualToString:TNOrderStatePendingReview] || [orderModel.status isEqualToString:TNOrderStatePendingPayment] ||
            [orderModel.status isEqualToString:TNOrderStatePendingShipment] || [orderModel.status isEqualToString:TNOrderStateShipped])) {
        self.deliveryTimeLabel.hidden = NO;
        self.deliveryTimeLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"Tw0pO3zY", @"送货时间"), orderModel.deliveryTime];
    } else {
        self.deliveryTimeLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (!self.deliveryTimeLabel.isHidden) {
        [self.deliveryTimeLabel sizeToFit];
        [self.deliveryTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.totolPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryTimeLabel.isHidden) {
            make.top.equalTo(self.deliveryTimeLabel.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        }

        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        if (self.oprateBtnsStackView.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }
    }];
    [self.totolQuantityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totolPriceLabel.mas_centerY);
        make.right.equalTo(self.totolPriceLabel.mas_left).offset(-kRealWidth(10));
    }];
    if (!self.oprateBtnsStackView.isHidden) {
        [self.sepLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.totolPriceLabel.mas_bottom).offset(kRealWidth(10));
            make.height.mas_equalTo(0.5);
        }];
        [self.oprateBtnsStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
            make.top.equalTo(self.sepLine.mas_bottom).offset(kRealWidth(15));
        }];
    }
    [super updateConstraints];
}
/** @lazy totolPriceLabel */
- (UILabel *)totolPriceLabel {
    if (!_totolPriceLabel) {
        _totolPriceLabel = [[UILabel alloc] init];
        _totolPriceLabel.textColor = HexColor(0xFF4444);
        _totolPriceLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
    }
    return _totolPriceLabel;
}
/** @lazy totolQuantityLabel */
- (UILabel *)totolQuantityLabel {
    if (!_totolQuantityLabel) {
        _totolQuantityLabel = [[UILabel alloc] init];
        _totolQuantityLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _totolQuantityLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _totolQuantityLabel;
}
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = UIView.new;
        _sepLine.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _sepLine;
}
/** @lazy oprateBtnsStackView */
- (UIStackView *)oprateBtnsStackView {
    if (!_oprateBtnsStackView) {
        _oprateBtnsStackView = [[UIStackView alloc] init];
        _oprateBtnsStackView.axis = UILayoutConstraintAxisHorizontal;
        _oprateBtnsStackView.distribution = UIStackViewDistributionEqualSpacing;
        _oprateBtnsStackView.spacing = 10;
    }
    return _oprateBtnsStackView;
}
- (SAOperationButton *)payNowBTN {
    if (!_payNowBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:SALocalizedString(@"top_up_pay_now", @"立即支付") forState:UIControlStateNormal];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedPayNowBlock ?: self.clickedPayNowBlock(self.orderModel);
        }];
        [button sizeToFit];
        _payNowBTN = button;
    }
    return _payNowBTN;
}
- (SAOperationButton *)rebuyBTN {
    if (!_rebuyBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:SALocalizedString(@"buy_again", @"再次购买") forState:UIControlStateNormal];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedRebuyBlock ?: self.clickedRebuyBlock(self.orderModel);
        }];
        [button sizeToFit];
        _rebuyBTN = button;
    }
    return _rebuyBTN;
}
- (SAOperationButton *)transferBTN {
    if (!_transferBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:TNLocalizedString(@"tn_transfer_pay", @"转账付款") forState:UIControlStateNormal];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedTransferBlock ?: self.clickedTransferBlock(self.orderModel);
        }];
        [button sizeToFit];
        _transferBTN = button;
    }
    return _transferBTN;
}

- (SAOperationButton *)refundDetailBTN {
    if (!_refundDetailBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:SALocalizedString(@"refund_detail", @"退款详情") forState:UIControlStateNormal];
        [button applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        button.borderWidth = 0.5;
        button.borderColor = HDAppTheme.TinhNowColor.G2;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedRefundDetailBlock ?: self.clickedRefundDetailBlock(self.orderModel);
        }];
        [button sizeToFit];
        _refundDetailBTN = button;
    }
    return _refundDetailBTN;
}

- (SAOperationButton *)oneMoreBTN {
    if (!_oneMoreBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:TNLocalizedString(@"btn_nearby_buy", @"附近购买") forState:UIControlStateNormal];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedOneMoreBlock ?: self.clickedOneMoreBlock(self.orderModel);
        }];
        [button sizeToFit];
        _oneMoreBTN = button;
    }
    return _oneMoreBTN;
}

- (SAOperationButton *)cancelBTN {
    if (!_cancelBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:TNLocalizedString(@"tn_button_cancel_order_title", @"取消订单") forState:UIControlStateNormal];
        [button applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        button.borderWidth = 0.5;
        button.borderColor = HDAppTheme.TinhNowColor.G2;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedCancelBlock ?: self.clickedCancelBlock(self.orderModel);
        }];
        [button sizeToFit];
        _cancelBTN = button;
    }
    return _cancelBTN;
}
- (SAOperationButton *)evaluationBTN {
    if (!_evaluationBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:SALocalizedString(@"evaluate", @"评价") forState:UIControlStateNormal];
        [button applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        button.borderWidth = 0.5;
        button.borderColor = HDAppTheme.TinhNowColor.G2;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedEvaluationOrderBlock ?: self.clickedEvaluationOrderBlock(self.orderModel);
        }];
        [button sizeToFit];
        _evaluationBTN = button;
    }
    return _evaluationBTN;
}
- (SAOperationButton *)confirmBTN {
    if (!_confirmBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button setTitle:SALocalizedString(@"confirm_received_goods", @"确认收货") forState:UIControlStateNormal];
        [button applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.G2];
        button.borderWidth = 0.5;
        button.borderColor = HDAppTheme.TinhNowColor.G2;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedConfirmReceivingBlock ?: self.clickedConfirmReceivingBlock(self.orderModel);
        }];
        [button sizeToFit];
        _confirmBTN = button;
    }
    return _confirmBTN;
}
/** @lazy deliveryTimeLabel */
- (HDLabel *)deliveryTimeLabel {
    if (!_deliveryTimeLabel) {
        _deliveryTimeLabel = [[HDLabel alloc] init];
        _deliveryTimeLabel.backgroundColor = [HDAppTheme.TinhNowColor.C1 colorWithAlphaComponent:0.1];
        _deliveryTimeLabel.textColor = HexColor(0x9F8153);
        _deliveryTimeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _deliveryTimeLabel.hd_edgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        _deliveryTimeLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _deliveryTimeLabel;
}
@end
