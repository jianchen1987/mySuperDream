//
//  PNWaterPaymentResultView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWaterPaymentResultView.h"
#import "PNBillPayInfoModel.h"
#import "PNCommonUtils.h"
#import "PNWaterViewModel.h"
#import "SAInfoView.h"


@interface PNWaterPaymentResultView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SAInfoView *billCustomerView; // 娱乐缴费卡密
@property (nonatomic, strong) SAInfoView *billNoInfoView;
@property (nonatomic, strong) SAInfoView *amountInfoView;
@property (nonatomic, strong) SAInfoView *feeMoneyInfoView;
@property (nonatomic, strong) SAInfoView *promotionInfoView;
@property (nonatomic, strong) SAInfoView *payMoneyInfoView;
@property (nonatomic, strong) SAInfoView *payDiscountAmountInfoView;
@property (nonatomic, strong) SAInfoView *payActualPayAmountInfoView;
@property (nonatomic, strong) SAInfoView *refNoInfoView; // 外部流水号
@property (nonatomic, strong) SAOperationButton *confirmButton;

@property (nonatomic, strong) PNWaterViewModel *viewModel;

@property (nonatomic, strong) dispatch_source_t timer; ///< 定时查询在线付款码支付结果
@property (nonatomic, assign) BOOL isTimerRunning;     ///< 查询付款结果定时器是否在运行
@end


@implementation PNWaterPaymentResultView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self startQueryOnlinePaymentResult];
}

- (void)queryResult:(BOOL)isShowLoading {
    @HDWeakify(self);
    [self.viewModel queryPaymentResult:isShowLoading];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateData];
        if ([self isNeedStop]) {
            [self stopQueryOnline];
        }
    }];
}

/// 是否需要停止这个轮询
- (BOOL)isNeedStop {
    /// 当 billState 是 缴费确认中 或者  确认成功，但还没有进行验证  才需要进行轮询
    if (self.viewModel.payInfoModel.billState == PNBillPaymentStatusConfirmIng || self.viewModel.payInfoModel.billState == PNBillPaymentStatusConfirmSuccess
        || self.viewModel.payInfoModel.billState == PNBillPaymentStatusProcessing) {
        return NO;
    } else {
        return YES;
    }
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.iconImgView];
    [self.scrollViewContainer addSubview:self.statusLabel];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.lineView];
    [self.scrollViewContainer addSubview:self.billCustomerView];
    [self.scrollViewContainer addSubview:self.billNoInfoView];
    [self.scrollViewContainer addSubview:self.amountInfoView];
    [self.scrollViewContainer addSubview:self.feeMoneyInfoView];
    [self.scrollViewContainer addSubview:self.promotionInfoView];
    [self.scrollViewContainer addSubview:self.payMoneyInfoView];
    [self.scrollViewContainer addSubview:self.payDiscountAmountInfoView];
    [self.scrollViewContainer addSubview:self.payActualPayAmountInfoView];
    [self.scrollViewContainer addSubview:self.refNoInfoView];
    [self.scrollViewContainer addSubview:self.confirmButton];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.top.mas_equalTo(@(kRealWidth(30)));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(15));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(30));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.height.equalTo(@(PixelOne));
    }];

    if (!self.billCustomerView.isHidden) {
        [self.billCustomerView sizeToFit];
        [self.billCustomerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(30));
            make.left.right.equalTo(self.scrollViewContainer);
        }];
    }

    [self.billNoInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.billCustomerView.isHidden) {
            make.top.equalTo(self.billCustomerView.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(30));
        }
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(22)));
    }];

    [self.amountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.billNoInfoView.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(22)));
    }];

    UIView *lastView = self.feeMoneyInfoView;
    [self.feeMoneyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountInfoView.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(22)));
    }];

    if (!self.promotionInfoView.hidden) {
        lastView = self.promotionInfoView;
        [self.promotionInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.feeMoneyInfoView.mas_bottom).offset(kRealWidth(10));
            make.left.right.equalTo(self.scrollViewContainer);
            make.height.equalTo(@(kRealWidth(22)));
        }];
    }

    [self.payMoneyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.scrollViewContainer);
        make.height.equalTo(@(kRealWidth(22)));
    }];

    UIView *lastInfoView = self.payMoneyInfoView;

    if (!self.payDiscountAmountInfoView.hidden) {
        [self.payDiscountAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payMoneyInfoView.mas_bottom).offset(kRealWidth(10));
            make.left.right.equalTo(self.scrollViewContainer);
            make.height.equalTo(@(kRealWidth(22)));
        }];

        [self.payActualPayAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payDiscountAmountInfoView.mas_bottom).offset(kRealWidth(10));
            make.left.right.equalTo(self.scrollViewContainer);
            make.height.equalTo(@(kRealWidth(22)));
        }];

        lastInfoView = self.payActualPayAmountInfoView;
    }
    if (!self.refNoInfoView.isHidden) {
        [self.refNoInfoView sizeToFit];
        [self.refNoInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payMoneyInfoView.mas_bottom).offset(kRealWidth(10));
            make.left.right.equalTo(self.scrollViewContainer);
        }];

        lastInfoView = self.refNoInfoView;
    }

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastInfoView.mas_bottom).offset(kRealWidth(75));
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.bottom.equalTo(self.scrollViewContainer).offset(kRealWidth(-20));
    }];

    [super updateConstraints];
}

- (void)updateData {
    self.iconImgView.image = [UIImage imageNamed:[PNCommonUtils getBillPayStatusResultIconName:self.viewModel.payInfoModel.billState]];
    self.statusLabel.text = [PNCommonUtils getBillPayStatusName:self.viewModel.payInfoModel.billState];
    self.tipsLabel.text = self.viewModel.payInfoModel.text;

    if (HDIsStringNotEmpty(self.viewModel.payInfoModel.billCustomerName)) {
        if (self.viewModel.payInfoModel.group == 11) {
            self.billCustomerView.model.keyText = PNLocalizedString(@"pn_customer_name", @"客户名称");
        }
        self.billCustomerView.hidden = NO;
        self.billCustomerView.model.valueText = self.viewModel.payInfoModel.billCustomerName;
        [self.billCustomerView setNeedsUpdateContent];
    }

    self.billNoInfoView.model.valueText = self.viewModel.payInfoModel.billNo;
    [self.billNoInfoView setNeedsUpdateContent];

    self.amountInfoView.model.valueText = self.viewModel.payInfoModel.billAmount.thousandSeparatorAmount;
    [self.amountInfoView setNeedsUpdateContent];

    self.feeMoneyInfoView.model.valueText = self.viewModel.payInfoModel.feeAmount.thousandSeparatorAmount;
    [self.feeMoneyInfoView setNeedsUpdateContent];

    if ([self.viewModel.payInfoModel.totalAmount.cy isEqualToString:PNCurrencyTypeKHR]) {
        self.payMoneyInfoView.model.valueText = self.viewModel.payInfoModel.otherCurrencyAmounts.thousandSeparatorAmount;
    } else {
        self.payMoneyInfoView.model.valueText = self.viewModel.payInfoModel.totalAmount.thousandSeparatorAmount;
    }
    [self.payMoneyInfoView setNeedsUpdateContent];

    if (self.viewModel.payInfoModel.marketingBreaks.amount.doubleValue > 0) {
        self.promotionInfoView.hidden = NO;
        self.promotionInfoView.model.valueText = [NSString stringWithFormat:@"-%@", self.viewModel.payInfoModel.marketingBreaks.thousandSeparatorAmount];
        [self.promotionInfoView setNeedsUpdateContent];
    } else {
        self.promotionInfoView.hidden = YES;
    }

    /// payDiscountAmount不为空 且大于0， 就显示 支付优惠, 然后支付金额用payActualPayAmount
    if (!HDIsObjectNil(self.viewModel.payInfoModel.payDiscountAmount) && self.viewModel.payInfoModel.payDiscountAmount.cent.integerValue > 0) {
        self.payDiscountAmountInfoView.hidden = NO;
        self.payActualPayAmountInfoView.hidden = NO;

        self.payDiscountAmountInfoView.model.valueText = [NSString stringWithFormat:@"-%@", self.viewModel.payInfoModel.payDiscountAmount.thousandSeparatorAmount];
        [self.payDiscountAmountInfoView setNeedsUpdateContent];

        self.payActualPayAmountInfoView.model.valueText = self.viewModel.payInfoModel.payActualPayAmount.thousandSeparatorAmount;

        [self.payActualPayAmountInfoView setNeedsUpdateContent];
    }
    if (HDIsStringNotEmpty(self.viewModel.payInfoModel.refNo)) {
        self.refNoInfoView.hidden = NO;
        self.refNoInfoView.model.valueText = self.viewModel.payInfoModel.refNo;
        [self.refNoInfoView setNeedsUpdateContent];
    }

    [self setNeedsUpdateConstraints];
}

/** 开始轮询在线付款码结果 */
- (void)startQueryOnlinePaymentResult {
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个 timer 类型定时器
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    // 设置定时器的各种属性（何时开始，间隔多久执行）
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);
    // 任务回调
    //    @HDWeakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        // 查询结果
        HDLog(@"触发了轮询的调用接口");
        [self queryResult:NO];
    });

    //    dispatch_source_set_event_handler(_timer, ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            @HDStrongify(self);
    //            HDLog(@"触发了轮询的调用接口");
    //            [self queryResult:NO];
    //        });
    //    });
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    if (_timer && !_isTimerRunning) {
        HDLog(@"开启了轮询定时器");
        dispatch_resume(_timer);
        _isTimerRunning = YES;
    }
}

/** 结束轮询在线付款码结果 */
- (void)stopQueryOnline {
    if (_timer && _isTimerRunning) {
        HDLog(@"关闭了轮询定时器");
        dispatch_source_cancel(_timer);
        _timer = nil;
        _isTimerRunning = NO;
    }
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_utilities_result_success"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard17B;
        label.textAlignment = NSTextAlignmentCenter;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.cC4C5C8;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.valueFont = HDAppTheme.PayNowFont.standard15;
    model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
    return model;
}

- (SAInfoView *)billNoInfoView {
    if (!_billNoInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Invoice_No", @"Invoice_No")];
        model.lineWidth = 0;
        view.model = model;
        _billNoInfoView = view;
    }
    return _billNoInfoView;
}

- (SAInfoView *)amountInfoView {
    if (!_amountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"bill_amount", @"账单金额")];
        model.lineWidth = 0;
        view.model = model;
        _amountInfoView = view;
    }
    return _amountInfoView;
}

- (SAInfoView *)feeMoneyInfoView {
    if (!_feeMoneyInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"fee", @"代缴金额")];
        model.lineWidth = 0;
        view.model = model;
        _feeMoneyInfoView = view;
    }
    return _feeMoneyInfoView;
}

- (SAInfoView *)promotionInfoView {
    if (!_promotionInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"promotion", @"promotion")];
        model.lineWidth = 0;
        view.model = model;
        _promotionInfoView = view;
    }
    return _promotionInfoView;
}

- (SAInfoView *)payMoneyInfoView {
    if (!_payMoneyInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"total_amount", @"支付金额")];
        model.lineWidth = 0;
        view.model = model;
        _payMoneyInfoView = view;
    }
    return _payMoneyInfoView;
}

- (SAInfoView *)payDiscountAmountInfoView {
    if (!_payDiscountAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"payment_coupon", @"支付优惠")];
        model.lineWidth = 0;
        view.model = model;
        view.hidden = YES;
        _payDiscountAmountInfoView = view;
    }
    return _payDiscountAmountInfoView;
}

- (SAInfoView *)payActualPayAmountInfoView {
    if (!_payActualPayAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"PAGE_TEXT_REAL_AMOUNT", @"实付金额")];
        model.lineWidth = 0;
        view.model = model;
        view.hidden = YES;
        _payActualPayAmountInfoView = view;
    }
    return _payActualPayAmountInfoView;
}
/** @lazy  refNoInfoView*/
- (SAInfoView *)refNoInfoView {
    if (!_refNoInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_ref_number", @"支付流水号")];
        model.lineWidth = 0;
        view.model = model;
        view.hidden = YES;
        _refNoInfoView = view;
    }
    return _refNoInfoView;
}
/** @lazy  billCustomerView*/
- (SAInfoView *)billCustomerView {
    if (!_billCustomerView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:SALocalizedString(@"pn_pincode", @"卡密")];
        model.lineWidth = 0;
        view.model = model;
        view.hidden = YES;
        _billCustomerView = view;
    }
    return _billCustomerView;
}
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") forState:0];
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            [self.viewController.navigationController popToViewControllerClass:NSClassFromString(@"PNUtilitiesViewController") animated:YES];
        }];
    }
    return _confirmButton;
}

@end
