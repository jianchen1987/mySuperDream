//
//  PNPaymentOrderDetailsView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPaymentOrderDetailsView.h"
#import "PNBillAmountView.h"
#import "PNCommonUtils.h"
#import "PNPaymentActionBarView.h"
#import "PNPaymentOrderDetailsViewModel.h"
#import "PNWaterBillModel.h"
#import "SAInfoView.h"


@interface PNPaymentOrderDetailsView ()
@property (nonatomic, strong) SAInfoView *sectionSupplierInfoView;
@property (nonatomic, strong) SAInfoView *billCodeInfoView;
@property (nonatomic, strong) SAInfoView *payToInfoView;

@property (nonatomic, strong) SAInfoView *sectionCustomerInfoView;
@property (nonatomic, strong) SAInfoView *customerIdInfoView;
@property (nonatomic, strong) SAInfoView *customerCodeInfoView;
@property (nonatomic, strong) SAInfoView *customerNameInfoView;

@property (nonatomic, strong) SAInfoView *sectionBalancesInfoView;
@property (nonatomic, strong) PNBillAmountView *billAmountView;
@property (nonatomic, strong) SAInfoView *totalAmountInfoView;
@property (nonatomic, strong) SAInfoView *billStatusInfoView;
//@property (nonatomic, strong) SAInfoView *lastBillDateInfoView;
//@property (nonatomic, strong) SAInfoView *lastDueDateInfoView;
//@property (nonatomic, strong) SAInfoView *lastPaymentDateInfoView;

@property (nonatomic, strong) SAInfoView *sectionPayerInfoView;
@property (nonatomic, strong) SAInfoView *customerPhoneInfoView;
@property (nonatomic, strong) SAInfoView *notesInfoView;

@property (nonatomic, strong) PNPaymentActionBarView *actionBarView;

@property (nonatomic, strong) PNPaymentOrderDetailsViewModel *viewModel;
@end


@implementation PNPaymentOrderDetailsView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel queryBillDetail];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateData];
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.sectionSupplierInfoView];
    [self.scrollViewContainer addSubview:self.billCodeInfoView];
    [self.scrollViewContainer addSubview:self.payToInfoView];

    [self.scrollViewContainer addSubview:self.sectionCustomerInfoView];
    [self.scrollViewContainer addSubview:self.customerCodeInfoView];
    [self.scrollViewContainer addSubview:self.customerNameInfoView];

    [self.scrollViewContainer addSubview:self.sectionBalancesInfoView];
    [self.scrollViewContainer addSubview:self.billAmountView];
    [self.scrollViewContainer addSubview:self.totalAmountInfoView];
    [self.scrollViewContainer addSubview:self.billStatusInfoView];
    //    [self.scrollViewContainer addSubview:self.lastBillDateInfoView];
    //    [self.scrollViewContainer addSubview:self.lastDueDateInfoView];
    //    [self.scrollViewContainer addSubview:self.lastPaymentDateInfoView];

    [self.scrollViewContainer addSubview:self.sectionPayerInfoView];
    [self.scrollViewContainer addSubview:self.customerPhoneInfoView];
    [self.scrollViewContainer addSubview:self.notesInfoView];

    [self addSubview:self.actionBarView];
}

- (void)updateConstraints {
    if (!self.actionBarView.hidden) {
        [self.actionBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneXSeries ? -kiPhoneXSeriesSafeBottomHeight : kRealWidth(-20));
            make.height.mas_equalTo(@(kRealWidth(64)));
        }];
    }

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        if (!self.actionBarView.hidden) {
            make.bottom.equalTo(self.actionBarView.mas_top);
        } else {
            make.bottom.equalTo(self);
        }
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;

    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }

            if (view.tag >= 8000) {
                make.height.equalTo(@(44));
            }
        }];
        lastView = view;
    }

    [super updateConstraints];
}

#pragma mark
- (void)updateData {
    PNWaterBillModel *model = self.viewModel.billModel;

    self.billCodeInfoView.model.valueText = model.supplier.code;
    [self.billCodeInfoView setNeedsUpdateContent];

    self.payToInfoView.model.valueText = model.supplier.name;
    [self.payToInfoView setNeedsUpdateContent];

    self.customerCodeInfoView.model.valueText = model.customer.code;
    [self.customerCodeInfoView setNeedsUpdateContent];

    self.customerNameInfoView.model.valueText = model.customer.name;
    [self.customerNameInfoView setNeedsUpdateContent];

    PNBalancesInfoModel *balancesInfoModel = model.balances.firstObject;

    if (balancesInfoModel.billState == PNBillPaymentStatusProcessing) {
        self.actionBarView.hidden = NO;
    } else {
        self.actionBarView.hidden = YES;
    }

    self.billAmountView.balancesInfoModel = balancesInfoModel;

    self.totalAmountInfoView.model.valueText = balancesInfoModel.totalAmount.thousandSeparatorAmount;
    [self.totalAmountInfoView setNeedsUpdateContent];

    self.billStatusInfoView.model.valueText = [PNCommonUtils getBillPayStatusName:balancesInfoModel.billState];
    [self.billStatusInfoView setNeedsUpdateContent];

    //    self.lastBillDateInfoView.model.valueText = @"01/01/2022";
    //    [self.lastBillDateInfoView setNeedsUpdateContent];
    //
    //    self.lastDueDateInfoView.model.valueText = @"02/02/2022";
    //    [self.lastDueDateInfoView setNeedsUpdateContent];
    //
    //    self.lastPaymentDateInfoView.model.valueText = @"02/02/2022";
    //    [self.lastPaymentDateInfoView setNeedsUpdateContent];

    self.customerPhoneInfoView.model.valueText = balancesInfoModel.customerPhone;
    [self.customerPhoneInfoView setNeedsUpdateContent];

    self.notesInfoView.model.valueText = balancesInfoModel.notes;
    [self.notesInfoView setNeedsUpdateContent];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.cC4C5C8;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
    return model;
}

- (SAInfoView *)sectionSupplierInfoView {
    if (!_sectionSupplierInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"biller_info", @"Biller Info")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        ;
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8000;
        _sectionSupplierInfoView = view;
    }
    return _sectionSupplierInfoView;
}

- (SAInfoView *)billCodeInfoView {
    if (!_billCodeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"bill_code", @"bill code")];
        view.model = model;
        _billCodeInfoView = view;
    }
    return _billCodeInfoView;
}

- (SAInfoView *)payToInfoView {
    if (!_payToInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pay_to", @"pay to")];
        model.valueNumbersOfLines = 0;
        model.lineWidth = 0;
        view.model = model;
        _payToInfoView = view;
    }
    return _payToInfoView;
}

- (SAInfoView *)sectionCustomerInfoView {
    if (!_sectionCustomerInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_info", @"Customer Info")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        ;
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8001;
        _sectionCustomerInfoView = view;
    }
    return _sectionCustomerInfoView;
}

- (SAInfoView *)customerCodeInfoView {
    if (!_customerCodeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_code", @"Customer Code")];
        view.model = model;
        _customerCodeInfoView = view;
    }
    return _customerCodeInfoView;
}

- (SAInfoView *)customerNameInfoView {
    if (!_customerNameInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_name", @"Customer Name")];
        model.lineWidth = 0;
        view.model = model;
        _customerNameInfoView = view;
    }
    return _customerNameInfoView;
}

- (SAInfoView *)sectionBalancesInfoView {
    if (!_sectionBalancesInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"balances_info", @"Balances Info")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        ;
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8002;
        _sectionBalancesInfoView = view;
    }
    return _sectionBalancesInfoView;
}

- (SAInfoView *)totalAmountInfoView {
    if (!_totalAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"total_amount", @"Total Amount")];
        view.model = model;
        _totalAmountInfoView = view;
    }
    return _totalAmountInfoView;
}

- (SAInfoView *)billStatusInfoView {
    if (!_billStatusInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"Status", @"状态")];
        view.model = model;
        _billStatusInfoView = view;
    }
    return _billStatusInfoView;
}

//- (SAInfoView *)lastBillDateInfoView {
//    if (!_lastBillDateInfoView) {
//        SAInfoView *view = SAInfoView.new;
//        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"last_bill_date", @"Last bill date")];
//        view.model = model;
//        _lastBillDateInfoView = view;
//    }
//    return _lastBillDateInfoView;
//}
//
//- (SAInfoView *)lastDueDateInfoView {
//    if (!_lastDueDateInfoView) {
//        SAInfoView *view = SAInfoView.new;
//        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"last_due_date", @"Last due date")];
//        model.valueText = @"02/02/2022";
//        _lastDueDateInfoView = view;
//    }
//    return _lastDueDateInfoView;
//}
//
//- (SAInfoView *)lastPaymentDateInfoView {
//    if (!_lastPaymentDateInfoView) {
//        SAInfoView *view = SAInfoView.new;
//        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"last_payment_date", @"Last payment date")];
//        model.lineWidth = 0;
//        view.model = model;
//        _lastPaymentDateInfoView = view;
//    }
//    return _lastPaymentDateInfoView;
//}

- (SAInfoView *)sectionPayerInfoView {
    if (!_sectionPayerInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"payer_info", @"Payer Info")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        ;
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8004;
        _sectionPayerInfoView = view;
    }
    return _sectionPayerInfoView;
}

- (SAInfoView *)customerPhoneInfoView {
    if (!_customerPhoneInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_phone", @"Customer_phone")];
        model.lineWidth = 0;
        view.model = model;
        _customerPhoneInfoView = view;
    }
    return _customerPhoneInfoView;
}

- (SAInfoView *)notesInfoView {
    if (!_notesInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"notes", @"Notes")];
        model.lineWidth = 0;
        model.valueNumbersOfLines = 0;
        view.model = model;
        _notesInfoView = view;
    }
    return _notesInfoView;
}

- (PNBillAmountView *)billAmountView {
    if (!_billAmountView) {
        _billAmountView = [[PNBillAmountView alloc] init];
        _billAmountView.canEdit = NO;
    }
    return _billAmountView;
}

- (PNPaymentActionBarView *)actionBarView {
    if (!_actionBarView) {
        _actionBarView = [[PNPaymentActionBarView alloc] init];
        _actionBarView.hidden = YES;
        @HDWeakify(self);
        _actionBarView.clickCloseActionBlock = ^{
            @HDStrongify(self);
            [self.viewModel closePaymentOrder];
        };
    }
    return _actionBarView;
}
@end
