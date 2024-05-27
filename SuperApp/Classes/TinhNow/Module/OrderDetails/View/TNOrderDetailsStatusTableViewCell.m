//
//  TNOrderDetailsStatusTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsStatusTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNOrderDetailsExpressView.h"


@interface TNOrderDetailsStatusTableViewCell ()
/// 状态标题
@property (nonatomic, strong) UILabel *statusLabel;
/// 状态描述
@property (nonatomic, strong) UILabel *statusDescribeLabel;
/// 配送时间
@property (strong, nonatomic) HDLabel *deliveryTimeLabel;

@end


@implementation TNOrderDetailsStatusTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.statusDescribeLabel];
    [self.contentView addSubview:self.deliveryTimeLabel];
}

- (void)updateConstraints {
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];

    [self.statusDescribeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(5));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        if (self.deliveryTimeLabel.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }
    }];
    if (!self.deliveryTimeLabel.isHidden) {
        [self.deliveryTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.statusLabel.mas_leading);
            make.top.equalTo(self.statusDescribeLabel.mas_bottom).offset(kRealWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(TNOrderDetailsStatusTableViewCellModel *)model {
    _model = model;
    self.statusLabel.text = model.statusTitle;
    self.statusDescribeLabel.text = model.statusDes;
    if (HDIsStringNotEmpty(model.deliverTime)) {
        self.deliveryTimeLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"Tw0pO3zY", @"送货时间"), model.deliverTime];
        self.deliveryTimeLabel.hidden = NO;
    } else {
        self.deliveryTimeLabel.hidden = YES;
    }

    if ([TNOrderStatePendingPayment isEqualToString:model.orderState]) {
        if ([model.paymentInfo.method isEqualToString:TNPaymentMethodOnLine]) {
            NSInteger surplus = model.expireTime / 1000.0 - [NSDate new].timeIntervalSince1970;
            NSString *des = TNLocalizedString(@"tn_pending_payment_desc", @"请在%@内支付，超时订单将自动取消");
            if (surplus > 0) {
                if (HDIsStringNotEmpty(model.statusDes) && [model.statusDes containsString:@"xxxx"]) {
                    des = [model.statusDes stringByReplacingOccurrencesOfString:@"xxxx" withString:@"%@"];
                }
                NSString *surplusStr = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", surplus / 3600, surplus / 60 % 60, surplus % 60];
                self.statusDescribeLabel.text = [NSString stringWithFormat:des, surplusStr];
            } else {
                if (HDIsStringNotEmpty(model.statusDes) && [model.statusDes containsString:@"xxxx"]) {
                    des = [model.statusDes stringByReplacingOccurrencesOfString:@"xxxx" withString:@"00:00:00"];
                }
                self.statusDescribeLabel.text = des;
            }
        }
    }

    //    if ([TNOrderStatePendingReview isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_pending_review", @"待审核");
    //        self.statusDescribeLabel.text = TNLocalizedString(@"tn_pending_review_desc", @"尊敬的客户，你的订单正在等待审核，请你耐心等待");
    //    } else if ([TNOrderStatePendingPayment isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_pending_payment", @"待付款");
    //        if ([model.paymentInfo.method isEqualToString:TNPaymentMethodTransfer]) {
    //            self.statusDescribeLabel.text = TNLocalizedString(@"tn_pending_transfer_pay", @"尊敬的客户，你的订单正在等待付款，请及时支付订单款项 !");
    //        } else {
    //            NSInteger surplus = model.expireTime / 1000.0 - [NSDate new].timeIntervalSince1970;
    //            if (surplus > 0) {
    //                NSString *surplusStr = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", surplus / 3600, surplus / 60, surplus % 60];
    //                self.statusDescribeLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_pending_payment_desc", @"请在%@内支付，超时订单将自动取消"), surplusStr];
    //            } else {
    //                self.statusDescribeLabel.text = TNLocalizedString(@"hh3w2LaU", @"请在00:00:00内支付，超时订单将自动取消");
    //        }
    //        }
    //    } else if ([TNOrderStatePendingShipment isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_pending_shipment", @"待发货");
    //        self.statusDescribeLabel.text = TNLocalizedString(@"tn_pending_shipment_desc", @"尊敬的客户，你的订单正在发货，请你耐心等待");
    //    } else if ([TNOrderStateShipped isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_shipped", @"待收货");
    //        self.statusDescribeLabel.text = TNLocalizedString(@"tn_shipped_desc", @"尊敬的客户，你的订单已发货，请你耐心等待");
    //    } else if ([TNOrderStateCompleted isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_order_completed", @"已完成");
    //        self.statusDescribeLabel.text = TNLocalizedString(@"tn_order_completed_desc", @"尊敬的客户，你的订单已完成，祝你购物愉快！");
    //    } else if ([TNOrderStateCanceled isEqualToString:model.orderState]) {
    //        self.statusLabel.text = TNLocalizedString(@"tn_order_canced", @"已取消");
    //        self.statusDescribeLabel.text = TNLocalizedString(@"tn_order_canced_desc", @"订单已取消");
    //    } else {
    //        self.statusLabel.text = model.statusTitle;
    //    }

    //    [self setShowExpressView];

    [self setNeedsUpdateConstraints];
}

//- (void)setShowExpressView {
//    //没有物流信息不显示
//    if (HDIsObjectNil(self.model.expressOrder)) {
//        self.expressView.hidden = YES;
//    } else {
//        self.expressView.hidden = NO;
//        self.expressView.expressOrderModel = self.model.expressOrder;
//    }
//}

#pragma mark - private methods
- (void)countDown {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - lazy load
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _statusLabel;
}
/** @lazy statusdescribeLabel */
- (UILabel *)statusDescribeLabel {
    if (!_statusDescribeLabel) {
        _statusDescribeLabel = [[UILabel alloc] init];
        _statusDescribeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _statusDescribeLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _statusDescribeLabel.numberOfLines = 0;
    }
    return _statusDescribeLabel;
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
//- (TNOrderDetailsExpressView *)expressView {
//    if (!_expressView) {
//        _expressView = [[TNOrderDetailsExpressView alloc] init];
//        _expressView.hidden = YES;
//    }
//    return _expressView;
//}

@end


@implementation TNOrderDetailsStatusTableViewCellModel

@end
