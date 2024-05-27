//
//  WMOrderModifyAddressHistoryTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderModifyAddressHistoryTableViewCell.h"
#import "SAGeneralUtil.h"
#import "SAInfoView.h"
#import "WMOrderModifyAddressHistoryPayView.h"


@interface WMOrderModifyAddressHistoryTableViewCell ()
/// bg
@property (nonatomic, strong) UIView *bgView;
/// new address tip
@property (nonatomic, strong) HDUIButton *statusBTN;
/// new address tip
@property (nonatomic, strong) HDLabel *neAddresTipLB;
/// old address tip
@property (nonatomic, strong) HDLabel *oldAddresTipLB;
/// new address
@property (nonatomic, strong) HDLabel *neAddresLB;
/// old address
@property (nonatomic, strong) HDLabel *oldAddresLB;
/// line
@property (nonatomic, strong) UIView *addressLine;
/// line
@property (nonatomic, strong) UIView *statusLine;
/// timeView
@property (nonatomic, strong) SAInfoView *timeView;
/// new shipping fee
@property (nonatomic, strong) SAInfoView *neShippingFeeView;
/// original delivery fe
@property (nonatomic, strong) SAInfoView *originalFeeView;
/// payment method
@property (nonatomic, strong) SAInfoView *paymentView;
/// Amounts payable
@property (nonatomic, strong) SAInfoView *amountsPayView;
/// submissionTime
@property (nonatomic, strong) SAInfoView *submissionTimeView;
/// Modify success time
@property (nonatomic, strong) SAInfoView *modifySuccessTimeView;
/// refundStatus
@property (nonatomic, strong) SAInfoView *refundStatusView;
/// payView
@property (nonatomic, strong) WMOrderModifyAddressHistoryPayView *payView;
/// infoArr
@property (nonatomic, strong) NSMutableArray<UIView *> *infoArr;

@end


@implementation WMOrderModifyAddressHistoryTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.statusBTN];
    [self.bgView addSubview:self.statusLine];
    [self.bgView addSubview:self.neAddresTipLB];
    [self.bgView addSubview:self.oldAddresTipLB];
    [self.bgView addSubview:self.neAddresLB];
    [self.bgView addSubview:self.oldAddresLB];
    [self.bgView addSubview:self.addressLine];

    [self.bgView addSubview:self.timeView];
    [self.bgView addSubview:self.neShippingFeeView];
    [self.bgView addSubview:self.originalFeeView];
    [self.bgView addSubview:self.paymentView];
    [self.bgView addSubview:self.amountsPayView];
    [self.bgView addSubview:self.submissionTimeView];
    [self.bgView addSubview:self.modifySuccessTimeView];
    [self.bgView addSubview:self.refundStatusView];
    [self.bgView addSubview:self.amountsPayView];
    [self.bgView addSubview:self.payView];

    [self.infoArr addObject:self.timeView];
    [self.infoArr addObject:self.neShippingFeeView];
    [self.infoArr addObject:self.originalFeeView];
    [self.infoArr addObject:self.paymentView];
    [self.infoArr addObject:self.amountsPayView];
    [self.infoArr addObject:self.submissionTimeView];
    [self.infoArr addObject:self.modifySuccessTimeView];
    [self.infoArr addObject:self.refundStatusView];
    [self.infoArr addObject:self.payView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(8));
        make.left.mas_equalTo(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(8));
        make.bottom.mas_equalTo(0);
    }];

    [self.statusBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(53));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(0);
    }];

    [self.statusLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBTN.mas_bottom);
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.left.right.mas_equalTo(0);
    }];

    [self.neAddresTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.statusLine.mas_bottom).offset(kRealWidth(11));
    }];

    [self.neAddresLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.neAddresTipLB.mas_right);
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.neAddresTipLB).offset(-kRealWidth(2));
    }];

    [self.oldAddresTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.neAddresTipLB);
        make.top.equalTo(self.neAddresLB.mas_bottom).offset(kRealWidth(16));
    }];

    [self.oldAddresLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.oldAddresTipLB.mas_right);
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.oldAddresTipLB).offset(-kRealWidth(2));
    }];

    [self.addressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldAddresLB.mas_bottom).offset(kRealWidth(13));
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.left.right.mas_equalTo(0);
    }];

    NSArray *invisitArr = [self.infoArr hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        if (item.isHidden) {
            [item mas_remakeConstraints:^(MASConstraintMaker *make){

            }];
        }
        return !item.isHidden;
    }];
    __block SAInfoView *tmpView;
    [invisitArr enumerateObjectsUsingBlock:^(SAInfoView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!tmpView) {
                make.top.equalTo(self.addressLine.mas_bottom);
            } else {
                make.top.equalTo(tmpView.mas_bottom);
            }
            make.left.right.mas_equalTo(0);
            if (idx == invisitArr.count - 1) {
                make.bottom.mas_lessThanOrEqualTo(0);
            }
        }];
        tmpView = obj;
    }];

    [self.neAddresTipLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.neAddresTipLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.oldAddresTipLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.oldAddresTipLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(WMModifyAddressListModel *)data {
    self.model = data;
    self.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;

    if (data.status == WMModifyOrderSuccess) {
        [self.statusBTN setTitle:WMLocalizedString(@"wm_modify_address_order_success", @"修改成功") forState:UIControlStateNormal];
        [self.statusBTN setImage:[UIImage imageNamed:@"yn_address_status_finish"] forState:UIControlStateNormal];
    } else if (data.status == WMModifyOrderIng) {
        [self.statusBTN setTitle:WMLocalizedString(@"wm_modify_address_order_ing", @"修改中") forState:UIControlStateNormal];
        [self.statusBTN setImage:[UIImage imageNamed:@"yn_address_status_use"] forState:UIControlStateNormal];
    } else if (data.status == WMModifyOrderCancel) {
        [self.statusBTN setTitle:WMLocalizedString(@"wm_modify_address_order_fail", @"修改失败") forState:UIControlStateNormal];
        [self.statusBTN setImage:[UIImage imageNamed:@"yn_address_status_cancel"] forState:UIControlStateNormal];
    }

    NSString *neKey = [NSString stringWithFormat:@"wm_gender_%@", data.receiverGender];
    NSMutableAttributedString *neAddresStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(data.receiverAddress)];
    [neAddresStr yy_appendString:@"\n"];
    [neAddresStr yy_appendString:WMFillEmpty(data.receiverName)];
    [neAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [neAddresStr yy_appendString:WMLocalizedString(neKey, neKey)];
    [neAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [neAddresStr yy_appendString:WMFillEmpty(data.receiverPhone)];
    neAddresStr.yy_lineSpacing = kRealWidth(4);
    neAddresStr.yy_color = HDAppTheme.WMColor.B3;
    neAddresStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    neAddresStr.yy_minimumLineHeight = kRealWidth(18);
    self.neAddresLB.attributedText = neAddresStr;

    NSString *oldKey = [NSString stringWithFormat:@"wm_gender_%@", data.oldReceiverGender];
    NSMutableAttributedString *oldAddresStr = [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(data.oldReceiverAddress)];
    [oldAddresStr yy_appendString:@"\n"];
    [oldAddresStr yy_appendString:WMFillEmpty(data.oldReceiverName)];
    [oldAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [oldAddresStr yy_appendString:WMLocalizedString(oldKey, oldKey)];
    [oldAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
    [oldAddresStr yy_appendString:WMFillEmpty(data.oldReceiverPhone)];
    oldAddresStr.yy_lineSpacing = kRealWidth(4);
    oldAddresStr.yy_color = HDAppTheme.WMColor.B9;
    oldAddresStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
    oldAddresStr.yy_minimumLineHeight = kRealWidth(18);
    self.oldAddresLB.attributedText = oldAddresStr;

    [self.infoArr enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.hidden = YES;
    }];
    self.modifySuccessTimeView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(7), kRealWidth(12));

    if (data.addDeliveryTime > 0) {
        ///时长
        self.timeView.model.valueText = [NSString stringWithFormat:@"%zdmin", data.addDeliveryTime];
        self.timeView.hidden = NO;
        [self.timeView setNeedsUpdateContent];
    }

    ///有增加配送费
    if (data.payPrice.cent.integerValue > 0) {
        ///新配送费
        if (!data.deliveryPrice) {
            data.deliveryPrice = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", data.oldDeliveryPrice.cent.integerValue + data.payPrice.cent.integerValue]
                                                      currency:data.oldDeliveryPrice.cy];
        }
        self.neShippingFeeView.model.valueText = data.deliveryPrice.thousandSeparatorAmount;
        self.neShippingFeeView.hidden = NO;
        [self.neShippingFeeView setNeedsUpdateContent];

        ///旧配送费
        self.originalFeeView.model.valueText = data.oldDeliveryPrice.thousandSeparatorAmount;
        self.originalFeeView.hidden = NO;
        [self.originalFeeView setNeedsUpdateContent];

        ///支付方式
        NSString *paymentMethodStr = @"";
        if (data.paymentMethod == SAOrderPaymentTypeOnline) {
            paymentMethodStr = WMLocalizedString(@"order_payment_method_online", @"线上付款");
        } else if (data.paymentMethod == SAOrderPaymentTypeCashOnDelivery) {
            paymentMethodStr = WMLocalizedString(@"order_payment_method_offline", @"货到付款");
        }
        self.paymentView.model.valueText = paymentMethodStr;
        self.paymentView.hidden = NO;
        [self.paymentView setNeedsUpdateContent];

        ///应付配送费
        self.amountsPayView.model.valueText = data.payPrice.thousandSeparatorAmount;
        self.amountsPayView.hidden = NO;
        [self.amountsPayView setNeedsUpdateContent];

        ///提交时间
        self.submissionTimeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
        self.submissionTimeView.hidden = NO;
        [self.submissionTimeView setNeedsUpdateContent];

        ///倒计时
        if (data.paymentMethod == SAOrderPaymentTypeOnline && data.paymentState == WMModifyOrderPayUn && data.remainingPaymentTime && data.status == WMModifyOrderIng) {
            self.payView.hidden = NO;
            self.payView.model = data;
        }

        ///退款
        if (data.refundState) {
            self.refundStatusView.hidden = NO;
            self.refundStatusView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(17), kRealWidth(12));
            if (data.refundState == WMOrderDetailRefundStateSuccess) {
                self.refundStatusView.model.valueText = WMLocalizedString(@"refunded_success", @"退款成功");
            } else if (data.refundState == WMOrderDetailRefundStateApplying) {
                self.refundStatusView.model.valueText = WMLocalizedString(@"refunding", @"退款中");
            }
            [self.refundStatusView setNeedsUpdateContent];
        }

        ///失败或成功的时间
        if (data.status != WMModifyOrderIng) {
            if (data.status == WMModifyOrderSuccess) {
                self.modifySuccessTimeView.model.keyText = WMLocalizedString(@"wm_modify_address_modify_success_time", @"修改成功时间");
            } else if (data.status == WMModifyOrderCancel) {
                self.modifySuccessTimeView.model.keyText = WMLocalizedString(@"wm_modify_address_modify_fail_time", @"修改失败时间");
            }
            self.modifySuccessTimeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:data.updateToEndTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
            self.modifySuccessTimeView.hidden = NO;
            if (self.refundStatusView.isHidden) {
                self.modifySuccessTimeView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(17), kRealWidth(12));
            }
            [self.modifySuccessTimeView setNeedsUpdateContent];
        }

    } else {
        ///提交时间
        self.submissionTimeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
        self.submissionTimeView.hidden = NO;
        [self.submissionTimeView setNeedsUpdateContent];

        ///修改成功时间
        self.modifySuccessTimeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:data.updateToEndTime / 1000 format:@"dd/MM/yyyy HH:mm:ss"];
        self.modifySuccessTimeView.hidden = NO;
        self.modifySuccessTimeView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(17), kRealWidth(12));
        [self.modifySuccessTimeView setNeedsUpdateContent];
    }
    [self setNeedsUpdateConstraints];
}

- (NSMutableAttributedString *)emptySpace:(CGFloat)space {
    return [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(space, 1)
                                                         alignToFont:[UIFont systemFontOfSize:0]
                                                           alignment:YYTextVerticalAlignmentCenter];
}

- (SAInfoViewModel *)customModelWithColor:(nullable UIColor *)color keyText:(NSString *)keyText {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.WMColor.B9;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:12];
    model.valueColor = color ?: HDAppTheme.WMColor.B3;
    model.keyText = keyText;
    model.lineWidth = 0;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DIN-Medium"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(7), kRealWidth(12));
    return model;
}

- (SAInfoView *)neShippingFeeView {
    if (!_neShippingFeeView) {
        _neShippingFeeView = SAInfoView.new;
        _neShippingFeeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_new_fee", @"new shipping fee")];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(13), kRealWidth(12), kRealWidth(7), kRealWidth(12));
        _neShippingFeeView.model = model;
    }
    return _neShippingFeeView;
}

- (SAInfoView *)originalFeeView {
    if (!_originalFeeView) {
        _originalFeeView = SAInfoView.new;
        _originalFeeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_old_fee", @"original delivery fee")];
        _originalFeeView.model = model;
    }
    return _originalFeeView;
}

- (SAInfoView *)paymentView {
    if (!_paymentView) {
        _paymentView = SAInfoView.new;
        _paymentView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:GNLocalizedString(@"gn_order_paymethor", @"支付方式")];
        _paymentView.model = model;
    }
    return _paymentView;
}

- (SAInfoView *)amountsPayView {
    if (!_amountsPayView) {
        _amountsPayView = SAInfoView.new;
        _amountsPayView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.mainRed keyText:WMLocalizedString(@"wm_modify_address_modify_order_payable", @"Amounts payable")];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(12), kRealWidth(13), kRealWidth(12));
        model.lineWidth = HDAppTheme.WMValue.line;
        model.lineColor = HDAppTheme.WMColor.lineColorE9;
        model.lineEdgeInsets = UIEdgeInsetsZero;
        _amountsPayView.model = model;
    }
    return _amountsPayView;
}

- (SAInfoView *)timeView {
    if (!_timeView) {
        _timeView = SAInfoView.new;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.mainRed keyText:WMLocalizedString(@"wm_modify_address_increase_time", @"Delivery time increased")];
        _timeView.hidden = YES;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(13), kRealWidth(12), kRealWidth(13), kRealWidth(12));
        model.lineWidth = HDAppTheme.WMValue.line;
        model.lineColor = HDAppTheme.WMColor.lineColorE9;
        model.lineEdgeInsets = UIEdgeInsetsZero;
        _timeView.model = model;
    }
    return _timeView;
}

- (SAInfoView *)submissionTimeView {
    if (!_submissionTimeView) {
        _submissionTimeView = SAInfoView.new;
        _submissionTimeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_submission_time", @"submission time")];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(11), kRealWidth(12), kRealWidth(6), kRealWidth(12));
        _submissionTimeView.model = model;
    }
    return _submissionTimeView;
}

- (SAInfoView *)modifySuccessTimeView {
    if (!_modifySuccessTimeView) {
        _modifySuccessTimeView = SAInfoView.new;
        _modifySuccessTimeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_modify_success_time", @"Modify success time")];
        _modifySuccessTimeView.model = model;
    }
    return _modifySuccessTimeView;
}

- (SAInfoView *)refundStatusView {
    if (!_refundStatusView) {
        _refundStatusView = SAInfoView.new;
        _refundStatusView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.mainRed keyText:SALocalizedString(@"userRefundBill_refundState", @"退款状态")];
        _refundStatusView.model = model;
    }
    return _refundStatusView;
}

- (HDLabel *)oldAddresLB {
    if (!_oldAddresLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        _oldAddresLB = label;
    }
    return _oldAddresLB;
}

- (HDLabel *)neAddresLB {
    if (!_neAddresLB) {
        HDLabel *label = HDLabel.new;
        label.numberOfLines = 0;
        _neAddresLB = label;
    }
    return _neAddresLB;
}

- (HDLabel *)oldAddresTipLB {
    if (!_oldAddresTipLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.text = [NSString stringWithFormat:@"%@: ", WMLocalizedString(@"wm_modify_address_old_address", @"")];
        _oldAddresTipLB = label;
    }
    return _oldAddresTipLB;
}

- (HDLabel *)neAddresTipLB {
    if (!_neAddresTipLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.text = [NSString stringWithFormat:@"%@: ", WMLocalizedString(@"wm_modify_address_new_address", @"")];
        _neAddresTipLB = label;
    }
    return _neAddresTipLB;
}

- (UIView *)addressLine {
    if (!_addressLine) {
        _addressLine = UIView.new;
        _addressLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _addressLine;
}

- (UIView *)statusLine {
    if (!_statusLine) {
        _statusLine = UIView.new;
        _statusLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _statusLine;
}

- (HDUIButton *)statusBTN {
    if (!_statusBTN) {
        _statusBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _statusBTN.highlighted = NO;
        _statusBTN.userInteractionEnabled = NO;
        [_statusBTN setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        _statusBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        _statusBTN.imagePosition = HDUIButtonImagePositionLeft;
        _statusBTN.spacingBetweenImageAndTitle = kRealWidth(4);
    }
    return _statusBTN;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _bgView.layer.cornerRadius = kRealWidth(8);
    }
    return _bgView;
}

- (WMOrderModifyAddressHistoryPayView *)payView {
    if (!_payView) {
        _payView = WMOrderModifyAddressHistoryPayView.new;
        _payView.hidden = YES;
    }
    return _payView;
}

- (NSMutableArray<UIView *> *)infoArr {
    if (!_infoArr) {
        _infoArr = NSMutableArray.new;
    }
    return _infoArr;
}

@end
