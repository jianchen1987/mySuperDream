//
//  WMModifyAddressPopView.m
//  SuperApp
//
//  Created by wmz on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModifyAddressPopView.h"
#import "SAInfoView.h"


@interface WMModifyAddressPopView ()
///标题
@property (nonatomic, strong) HDLabel *addressTitleLB;
/// new address tip
@property (nonatomic, strong) HDLabel *neAddresTipLB;
/// old address tip
@property (nonatomic, strong) HDLabel *oldAddresTipLB;
/// new address
@property (nonatomic, strong) YYLabel *neAddresLB;
/// old address
@property (nonatomic, strong) YYLabel *oldAddresLB;
/// line
@property (nonatomic, strong) UIView *addressLine;
///标题
@property (nonatomic, strong) HDLabel *timeTitleLB;
/// timeView
@property (nonatomic, strong) SAInfoView *timeView;
/// fee 标题
@property (nonatomic, strong) HDLabel *feeTitleLB;
///新配送费
@property (nonatomic, strong) SAInfoView *neShippingFeeView;
///旧配送费
@property (nonatomic, strong) SAInfoView *originalFeeView;
///支付方式
@property (nonatomic, strong) SAInfoView *paymentView;
///应付配送费
@property (nonatomic, strong) SAInfoView *amountsPayView;
///订单应付
@property (nonatomic, strong) SAInfoView *totalAmountView;
/// 提交按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;
/// infoArr
@property (nonatomic, strong) NSMutableArray<SAInfoView *> *infoArr;
@end


@implementation WMModifyAddressPopView

- (void)hd_setupViews {
    [self addSubview:self.addressTitleLB];
    [self addSubview:self.neAddresTipLB];
    [self addSubview:self.oldAddresTipLB];
    [self addSubview:self.neAddresLB];
    [self addSubview:self.oldAddresLB];
    [self addSubview:self.addressLine];

    [self addSubview:self.timeTitleLB];
    [self addSubview:self.timeView];

    [self addSubview:self.feeTitleLB];
    [self addSubview:self.neShippingFeeView];
    [self addSubview:self.originalFeeView];
    [self addSubview:self.paymentView];
    [self addSubview:self.amountsPayView];
    [self addSubview:self.totalAmountView];
    [self addSubview:self.submitBTN];

    [self.infoArr addObject:self.neShippingFeeView];
    [self.infoArr addObject:self.originalFeeView];
    [self.infoArr addObject:self.paymentView];
    [self.infoArr addObject:self.amountsPayView];
    [self.infoArr addObject:self.totalAmountView];
}

- (void)updateConstraints {
    [self.addressTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_offset(-kRealWidth(12));
        make.top.mas_equalTo(0);
    }];

    [self.neAddresTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.addressTitleLB.mas_bottom).offset(kRealWidth(12));
    }];

    [self.neAddresLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.neAddresTipLB.mas_right);
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.neAddresTipLB).offset(kRealWidth(2));
    }];
    [self.neAddresLB layoutIfNeeded];
    self.neAddresLB.preferredMaxLayoutWidth = self.neAddresLB.hd_width;

    [self.oldAddresTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.neAddresTipLB);
        make.top.equalTo(self.neAddresLB.mas_bottom).offset(kRealWidth(20));
    }];

    [self.oldAddresLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.left.equalTo(self.oldAddresTipLB.mas_right);
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.oldAddresTipLB).offset(kRealWidth(2));
    }];
    [self.oldAddresLB layoutIfNeeded];
    self.oldAddresLB.preferredMaxLayoutWidth = self.oldAddresLB.hd_width;

    self.addressLine.hidden = (self.timeView.isHidden && self.neShippingFeeView.isHidden);
    __block UIView *lastView = self.oldAddresLB;
    [self.addressLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.addressLine.isHidden) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(16));
            make.height.mas_equalTo(HDAppTheme.WMValue.line);
            make.left.right.mas_equalTo(0);
            lastView = self.addressLine;
        }
    }];

    [self.timeTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeView.isHidden) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_offset(-kRealWidth(12));
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(16));
        }
    }];

    [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeView.isHidden) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.timeTitleLB.mas_bottom);
            lastView = self.timeView;
        }
    }];

    NSArray<SAInfoView *> *invisitArr = [self.infoArr hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        if (item.isHidden) {
            [item mas_remakeConstraints:^(MASConstraintMaker *make){

            }];
        }
        return !item.isHidden;
    }];
    self.feeTitleLB.hidden = HDIsArrayEmpty(invisitArr);
    [self.feeTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.feeTitleLB.isHidden) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_offset(-kRealWidth(12));
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(16));
            lastView = self.feeTitleLB;
        }
    }];

    __block SAInfoView *tmpView;
    [invisitArr enumerateObjectsUsingBlock:^(SAInfoView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!tmpView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(tmpView.mas_bottom);
            }
            make.left.right.mas_equalTo(0);
        }];
        tmpView = obj;
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(44));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        if (tmpView) {
            make.top.equalTo(tmpView.mas_bottom).offset(kRealWidth(12));
        } else {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(12));
        }
    }];

    [self.neAddresTipLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.neAddresTipLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.oldAddresTipLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.oldAddresTipLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)layoutyImmediately {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.submitBTN.frame) + kRealWidth(8));
}

- (void)setModel:(WMModifyAddressPopModel *)model {
    _model = model;
    self.neAddresLB.hidden = HDIsObjectNil(model.neAddress);
    if (!self.oldAddresLB.isHidden) {
        NSString *neKey = [NSString stringWithFormat:@"wm_gender_%@", model.neAddress.gender];
        NSMutableAttributedString *neAddresStr =
            [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.neAddress.address, WMFillEmpty(model.neAddress.consigneeAddress)]];
        [neAddresStr yy_appendString:@"\n"];
        [neAddresStr yy_appendString:WMFillEmpty(model.neAddress.consigneeName)];
        [neAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
        [neAddresStr yy_appendString:WMLocalizedString(neKey, neKey)];
        [neAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
        [neAddresStr yy_appendString:WMFillEmpty(model.neAddress.mobile)];
        neAddresStr.yy_lineSpacing = kRealWidth(4);
        neAddresStr.yy_color = HDAppTheme.WMColor.B3;
        neAddresStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
        neAddresStr.yy_minimumLineHeight = kRealWidth(18);
        self.neAddresLB.attributedText = neAddresStr;
    }

    self.oldAddresLB.hidden = HDIsObjectNil(model.oldAddress);
    if (!self.oldAddresLB.isHidden) {
        NSString *oldKey = [NSString stringWithFormat:@"wm_gender_%@", model.oldAddress.gender];
        NSMutableAttributedString *oldAddresStr =
            [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.oldAddress.address, WMFillEmpty(model.oldAddress.consigneeAddress)]];
        [oldAddresStr yy_appendString:@"\n"];
        [oldAddresStr yy_appendString:WMFillEmpty(model.oldAddress.consigneeName)];
        [oldAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
        [oldAddresStr yy_appendString:WMLocalizedString(oldKey, oldKey)];
        [oldAddresStr appendAttributedString:[self emptySpace:kRealWidth(16)]];
        [oldAddresStr yy_appendString:WMFillEmpty(model.oldAddress.mobile)];
        oldAddresStr.yy_lineSpacing = kRealWidth(4);
        oldAddresStr.yy_color = HDAppTheme.WMColor.B9;
        oldAddresStr.yy_font = [HDAppTheme.WMFont wm_ForSize:12];
        oldAddresStr.yy_minimumLineHeight = kRealWidth(18);
        self.oldAddresLB.attributedText = oldAddresStr;
    }

    if (model.feeModel.inTime > 0) {
        ///时长
        self.timeView.model.valueText = [NSString stringWithFormat:@"%zdmin", model.feeModel.inTime];
        self.timeView.hidden = NO;
        self.timeTitleLB.hidden = NO;
        [self.timeView setNeedsUpdateContent];
    }

    ///有增加配送费
    if (model.feeModel.deliveryFee && model.feeModel.deliveryFee.cent.integerValue > 0) {
        ///新配送费
        SAMoneyModel *neShipMoney = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", model.feeModel.deliveryFee.cent.integerValue + model.oldDeliveryFee.cent.integerValue]
                                                         currency:model.feeModel.deliveryFee.cy];
        self.neShippingFeeView.model.valueText = neShipMoney.thousandSeparatorAmount;
        self.neShippingFeeView.hidden = NO;
        [self.neShippingFeeView setNeedsUpdateContent];

        ///旧配送费
        self.originalFeeView.model.valueText = model.oldDeliveryFee.thousandSeparatorAmount;
        self.originalFeeView.hidden = NO;
        [self.originalFeeView setNeedsUpdateContent];

        ///支付方式
        self.paymentView.model.valueText = model.paymentMethodStr;
        self.paymentView.hidden = NO;
        [self.paymentView setNeedsUpdateContent];

        ///应付配送费
        self.amountsPayView.model.valueText = model.feeModel.deliveryFee.thousandSeparatorAmount;
        self.amountsPayView.hidden = NO;
        [self.amountsPayView setNeedsUpdateContent];

        if (model.paymentMethod == SAOrderPaymentTypeCashOnDelivery) {
            ///订单应付
            SAMoneyModel *totalMoney = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", model.actualAmount.cent.integerValue + model.feeModel.deliveryFee.cent.integerValue]
                                                            currency:model.actualAmount.cy];
            self.totalAmountView.model.valueText = totalMoney.thousandSeparatorAmount;
            self.totalAmountView.hidden = NO;
            [self.totalAmountView setNeedsUpdateContent];
        }
    } else {
        self.timeView.model.lineWidth = 0;
        [self.timeView setNeedsUpdateContent];
    }
    if (model.paymentMethod == SAOrderPaymentTypeOnline && model.feeModel.deliveryFee && model.feeModel.deliveryFee.cent.integerValue > 0) {
        [self.submitBTN setTitle:WMLocalizedString(@"wm_modify_address_pay", @"") forState:UIControlStateNormal];
    } else {
        [self.submitBTN setTitle:WMLocalizedString(@"wm_modify_address_confirm", @"确认修改") forState:UIControlStateNormal];
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
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
    return model;
}

- (SAInfoView *)neShippingFeeView {
    if (!_neShippingFeeView) {
        _neShippingFeeView = SAInfoView.new;
        _neShippingFeeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_new_fee", @"new shipping fee")];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(4), kRealWidth(12));
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
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:SALocalizedString(@"payment_method", @"支付方式")];
        _paymentView.model = model;
    }
    return _paymentView;
}

- (SAInfoView *)amountsPayView {
    if (!_amountsPayView) {
        _amountsPayView = SAInfoView.new;
        _amountsPayView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.mainRed keyText:WMLocalizedString(@"wm_modify_address_pay_fee", @"Amounts payable")];
        _amountsPayView.model = model;
    }
    return _amountsPayView;
}

- (SAInfoView *)totalAmountView {
    if (!_totalAmountView) {
        _totalAmountView = SAInfoView.new;
        _totalAmountView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:WMLocalizedString(@"wm_modify_address_modify_order_payable", @"Total amount due for the order")];
        _totalAmountView.model = model;
    }
    return _totalAmountView;
}

- (SAInfoView *)timeView {
    if (!_timeView) {
        _timeView = SAInfoView.new;
        _timeView.hidden = YES;
        SAInfoViewModel *model = [self customModelWithColor:HDAppTheme.WMColor.mainRed keyText:WMLocalizedString(@"wm_modify_address_increase_time", @"Delivery time increased")];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        model.lineWidth = HDAppTheme.WMValue.line;
        model.lineColor = HDAppTheme.WMColor.lineColorE9;
        model.lineEdgeInsets = UIEdgeInsetsZero;
        _timeView.model = model;
    }
    return _timeView;
}

- (YYLabel *)oldAddresLB {
    if (!_oldAddresLB) {
        YYLabel *label = YYLabel.new;
        label.numberOfLines = 0;
        _oldAddresLB = label;
    }
    return _oldAddresLB;
}

- (YYLabel *)neAddresLB {
    if (!_neAddresLB) {
        YYLabel *label = YYLabel.new;
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

- (HDLabel *)addressTitleLB {
    if (!_addressTitleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.text = WMLocalizedString(@"address", @"Address");
        _addressTitleLB = label;
    }
    return _addressTitleLB;
}

- (HDLabel *)timeTitleLB {
    if (!_timeTitleLB) {
        HDLabel *label = HDLabel.new;
        label.hidden = YES;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.text = WMLocalizedString(@"sort_delivery_time", @"Delivery time");
        _timeTitleLB = label;
    }
    return _timeTitleLB;
}

- (HDLabel *)feeTitleLB {
    if (!_feeTitleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.text = WMLocalizedString(@"delivery_fee", @"delivery fee");
        _feeTitleLB = label;
    }
    return _feeTitleLB;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.layer.cornerRadius = kRealWidth(22);
        _submitBTN.layer.masksToBounds = YES;
        [_submitBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.mainColor];
        @HDWeakify(self)[_submitBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock();
            }
        }];
        [_submitBTN setTitle:WMLocalizedString(@"wm_modify_address_confirm", @"确认修改") forState:UIControlStateNormal];
    }
    return _submitBTN;
}

- (NSMutableArray<SAInfoView *> *)infoArr {
    if (!_infoArr) {
        _infoArr = NSMutableArray.new;
    }
    return _infoArr;
}

@end
