//
//  PNSubmitWaterPaymentView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNSubmitWaterPaymentView.h"
#import "HDCheckStandViewController.h"
#import "PNBillAmountView.h"
#import "PNBillModifyAmountItemView.h"
#import "PNBillModifyAmountModel.h"
#import "PNCreateAggregateOrderRspModel.h"
#import "PNWaterBillModel.h"
#import "PNWaterViewModel.h"
#import "SAInfoView.h"
#import "SAQueryOrderInfoRspModel.h"
#import "UIViewController+NavigationController.h"


@interface PNSubmitWaterPaymentView () <HDCheckStandViewControllerDelegate, HDTextViewDelegate>
@property (nonatomic, strong) SAOperationButton *confirmButton;
@property (nonatomic, strong) SAInfoView *sectionSupplierInfoView;
@property (nonatomic, strong) SAInfoView *billCodeInfoView;
@property (nonatomic, strong) SAInfoView *payToInfoView;

@property (nonatomic, strong) SAInfoView *sectionCustomerInfoView;
@property (nonatomic, strong) SAInfoView *paymentCategoryInfoView;
//@property (nonatomic, strong) SAInfoView *customerIdInfoView;
@property (nonatomic, strong) SAInfoView *customerCodeInfoView;
@property (nonatomic, strong) SAInfoView *customerNameInfoView;

@property (nonatomic, strong) SAInfoView *sectionBalancesInfoView;
//@property (nonatomic, strong) PNBillAmountView *billAmountView;
@property (nonatomic, strong) SAInfoView *feeInfoView;
@property (nonatomic, strong) SAInfoView *promotionInfoView;
@property (nonatomic, strong) SAInfoView *chargeTypeInfoView;
@property (nonatomic, strong) SAInfoView *totalAmountInfoView;
@property (nonatomic, strong) SAInfoView *otherTotalAmountInfoView;

@property (nonatomic, strong) PNBillModifyAmountItemView *billModifyAccountView;

//@property (nonatomic, strong) SAInfoView *lastBillDateInfoView;
//@property (nonatomic, strong) SAInfoView *lastDueDateInfoView;
//@property (nonatomic, strong) SAInfoView *lastPaymentDateInfoView;

@property (nonatomic, strong) SAInfoView *sectionPhoneInfoView;
@property (nonatomic, strong) UIView *phoneBgView;
@property (nonatomic, strong) HDUITextField *phoneTextFiled;

@property (nonatomic, strong) SAInfoView *sectionNotesInfoView;
@property (nonatomic, strong) UIView *notesBgView;
@property (nonatomic, strong) HDTextView *noteTextView;
@property (nonatomic, assign) CGFloat textViewHeight;

@property (nonatomic, strong) PNWaterViewModel *viewModel;
@end


@implementation PNSubmitWaterPaymentView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateData];
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self addSubview:self.confirmButton];

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.sectionSupplierInfoView];
    //    [self.scrollViewContainer addSubview:self.paymentCategoryInfoView];
    [self.scrollViewContainer addSubview:self.billCodeInfoView];
    [self.scrollViewContainer addSubview:self.payToInfoView];

    [self.scrollViewContainer addSubview:self.sectionCustomerInfoView];
    //    [self.scrollViewContainer addSubview:self.customerIdInfoView];
    [self.scrollViewContainer addSubview:self.customerCodeInfoView];
    [self.scrollViewContainer addSubview:self.customerNameInfoView];

    [self.scrollViewContainer addSubview:self.sectionBalancesInfoView];
    //    [self.scrollViewContainer addSubview:self.billAmountView];
    [self.scrollViewContainer addSubview:self.billModifyAccountView];
    //    [self.scrollViewContainer addSubview:self.feeInfoView];
    //    [self.scrollViewContainer addSubview:self.promotionInfoView];
    //    [self.scrollViewContainer addSubview:self.chargeTypeInfoView];
    //    [self.scrollViewContainer addSubview:self.totalAmountInfoView];
    //    [self.scrollViewContainer addSubview:self.otherTotalAmountInfoView];

    //    [self.scrollViewContainer addSubview:self.lastBillDateInfoView];
    //    [self.scrollViewContainer addSubview:self.lastDueDateInfoView];
    //    [self.scrollViewContainer addSubview:self.lastPaymentDateInfoView];

    [self.scrollViewContainer addSubview:self.sectionPhoneInfoView];
    [self.scrollViewContainer addSubview:self.phoneBgView];
    [self.phoneBgView addSubview:self.phoneTextFiled];

    [self.scrollViewContainer addSubview:self.sectionNotesInfoView];
    [self.scrollViewContainer addSubview:self.notesBgView];
    //    [self.notesBgView addSubview:self.notesTextField];
    [self.notesBgView addSubview:self.noteTextView];

    ///处理额外
    if (self.viewModel.paymentCategoryType == PNPaymentCategorySchool || self.viewModel.paymentCategoryType == PNPaymentCategoryInsurance) {
        self.phoneTextFiled.userInteractionEnabled = NO;
        self.noteTextView.userInteractionEnabled = NO;
    } else {
        self.phoneTextFiled.userInteractionEnabled = YES;
        self.noteTextView.userInteractionEnabled = YES;
        self.noteTextView.placeholder = PNLocalizedString(@"please_enter_notes", @"请填写备注");
    }

    [self.scrollViewContainer setFollowKeyBoardConfigEnable:YES margin:30 refView:nil];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(kRealWidth(-20));
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
            if (view.tag >= 10000) { // notesBgView
                make.top.equalTo(lastView.mas_bottom);
                make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
                make.right.equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
                if (view.tag == 10000) {
                    make.height.equalTo(@(44));
                }

                if (view == visableViews.lastObject) {
                    make.bottom.equalTo(self.scrollViewContainer);
                }
            } else {
                if (!lastView) {
                    make.top.equalTo(self.scrollViewContainer);
                } else {
                    make.top.equalTo(lastView.mas_bottom);
                }

                make.left.right.equalTo(self.scrollViewContainer);
                if (view == visableViews.lastObject) {
                    make.bottom.equalTo(self.scrollViewContainer);
                }
                /// section
                if (view.tag >= 8000) {
                    make.height.equalTo(@(44));
                }

                //                if (view.tag == 10) {
                //                    make.height.equalTo(@(kRealWidth(54)));
                //                }
            }
        }];
        lastView = view;
    }

    //    [self.notesTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.notesBgView.mas_left).offset(kRealWidth(15));
    //        make.right.mas_equalTo(self.notesBgView.mas_right).offset(kRealWidth(-15));
    //        make.centerY.mas_equalTo(self.notesBgView.mas_centerY).offset(kRealWidth(-6));
    //    }];
    [self.noteTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notesBgView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.notesBgView.mas_top).offset(kRealWidth(5));
        make.right.mas_equalTo(self.notesBgView.mas_right).offset(kRealWidth(-15));
        make.height.mas_equalTo(self.textViewHeight > 0 ? self.textViewHeight : kRealWidth(30));
        make.bottom.mas_equalTo(self.notesBgView.mas_bottom).offset(kRealWidth(-5));
    }];

    [self.phoneTextFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneBgView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.phoneBgView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.phoneBgView.mas_centerY).offset(kRealWidth(-6));
    }];

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneXSeries ? -kiPhoneXSeriesSafeBottomHeight : kRealWidth(-20));
        make.height.mas_equalTo(@(kRealWidth(44)));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)updateData {
    PNWaterBillModel *model = self.viewModel.billModel;
    self.billCodeInfoView.model.valueText = model.supplier.code;
    [self.billCodeInfoView setNeedsUpdateContent];

    self.payToInfoView.model.valueText = model.supplier.name;
    [self.payToInfoView setNeedsUpdateContent];

    //    self.customerIdInfoView.model.valueText = model.customer.idStr;
    //    [self.customerIdInfoView setNeedsUpdateContent];

    self.customerCodeInfoView.model.valueText = model.customer.code;
    [self.customerCodeInfoView setNeedsUpdateContent];

    self.customerNameInfoView.model.valueText = model.customer.name;
    [self.customerNameInfoView setNeedsUpdateContent];

    PNBalancesInfoModel *balancesInfoModel = model.balances.firstObject;

    //    self.paymentCategoryInfoView.model.valueText = balancesInfoModel.paymentCategoryName;
    //    [self.paymentCategoryInfoView setNeedsUpdateContent];

    self.totalAmountInfoView.model.valueText = balancesInfoModel.totalAmount.thousandSeparatorAmount;
    [self.totalAmountInfoView setNeedsUpdateContent];

    if (balancesInfoModel.feeAmount.amount.doubleValue > 0) {
        self.feeInfoView.hidden = NO;
        self.feeInfoView.model.valueText = balancesInfoModel.feeAmount.thousandSeparatorAmount;
        [self.feeInfoView setNeedsUpdateContent];
    } else {
        self.feeInfoView.hidden = YES;
    }

    if (balancesInfoModel.marketingBreaks.amount.doubleValue > 0) {
        self.promotionInfoView.hidden = NO;
        self.promotionInfoView.model.valueText = balancesInfoModel.marketingBreaks.thousandSeparatorAmount;
        [self.promotionInfoView setNeedsUpdateContent];
    } else {
        self.promotionInfoView.hidden = YES;
    }

    //    self.billAmountView.balancesInfoModel = balancesInfoModel;

    self.billModifyAccountView.balancesInfoModel = balancesInfoModel;
    // 控制是否显示 修改按钮  修改金额界面入口
    BOOL isShowModify = NO;
    if (model.supplier.allowExceedPayment || model.supplier.allowPartialPayment) {
        isShowModify = YES;
    }
    self.billModifyAccountView.isShowModifyButton = isShowModify;

    if (WJIsStringNotEmpty(balancesInfoModel.chargeType)) {
        self.chargeTypeInfoView.hidden = NO;
        self.chargeTypeInfoView.model.valueText = balancesInfoModel.chargeType;
        [self.chargeTypeInfoView setNeedsUpdateContent];
    } else {
        self.chargeTypeInfoView.hidden = YES;
    }

    if ([balancesInfoModel.currency isEqualToString:PNCurrencyTypeKHR]) {
        self.otherTotalAmountInfoView.hidden = NO;
        self.otherTotalAmountInfoView.model.valueText = balancesInfoModel.otherCurrencyAmounts.thousandSeparatorAmount;
        [self.otherTotalAmountInfoView setNeedsUpdateContent];
    } else {
        self.otherTotalAmountInfoView.hidden = YES;
    }

    //    self.lastBillDateInfoView.model.valueText = @"01/01/2022";
    //    [self.lastBillDateInfoView setNeedsUpdateContent];
    //
    //    self.lastDueDateInfoView.model.valueText = @"02/02/2022";
    //    [self.lastDueDateInfoView setNeedsUpdateContent];
    //
    //    self.lastPaymentDateInfoView.model.valueText = @"02/02/2022";
    //    [self.lastPaymentDateInfoView setNeedsUpdateContent];

    [self.phoneTextFiled setTextFieldText:self.viewModel.customerPhone];
    self.noteTextView.text = self.viewModel.notes;
    //    [self.notesTextField setTextFieldText:@"我是notes"];

    [self setNeedsUpdateConstraints];
}

#pragma mark
#pragma mark HDTextView Delegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    self.textViewHeight = height;

    [self setNeedsUpdateConstraints];

    HDLog(@"newHeightAfterTextChanged");
}

- (void)textViewDidChange:(UITextView *)textView {
    HDLog(@"textViewDidChange： %@", textView.text);
    self.viewModel.notes = textView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

#pragma mark
#pragma mark 打开收银台
///打开收银台
- (void)openCashRegisterWithModel:(NSString *)aggregateOrderNo outPayOrderNo:(NSString *)outPayOrderNo totalAmount:(SAMoneyModel *)totalAmount {
    [self.viewModel queryOrderInfoWithAggregationOrderNo:aggregateOrderNo completion:^(SAQueryOrderInfoRspModel *_Nullable rspModel) {
        if (rspModel) {
            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = aggregateOrderNo;
            buildModel.storeNo = rspModel.storeId;
            buildModel.merchantNo = rspModel.merchantNo;
            buildModel.payableAmount = totalAmount;
            buildModel.businessLine = SAClientTypeBillPayment;
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
            checkStandVC.resultDelegate = self;
            [self.viewController presentViewController:checkStandVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
    [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToPayNowPaymentResultVC:@{@"orderNo": controller.currentOrderNo}];
        [self.viewController remoteViewControllerWithSpecifiedClass:self.viewController.class];
    }];
}

#pragma mark
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.c9599A2;
    model.keyFont = HDAppTheme.PayNowFont.standard14;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.valueFont = HDAppTheme.PayNowFont.standard15;
    model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(18), kRealWidth(15), kRealWidth(18), kRealWidth(15));
    return model;
}

- (SAInfoView *)sectionSupplierInfoView {
    if (!_sectionSupplierInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"biller_info", @"biller_info")];
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
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"biller_code", @"Biller code")];
        view.model = model;
        _billCodeInfoView = view;
    }
    return _billCodeInfoView;
}

- (SAInfoView *)paymentCategoryInfoView {
    if (!_paymentCategoryInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"bill_type", @"bill type")];
        view.model = model;
        _paymentCategoryInfoView = view;
    }
    return _paymentCategoryInfoView;
}

- (SAInfoView *)payToInfoView {
    if (!_payToInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pay_to", @"Pay to")];
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
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8001;
        _sectionCustomerInfoView = view;
    }
    return _sectionCustomerInfoView;
}

//- (SAInfoView *)customerIdInfoView {
//    if (!_customerIdInfoView) {
//        SAInfoView *view = SAInfoView.new;
//        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_id", @"Customer id")];
//        view.model = model;
//        _customerIdInfoView = view;
//    }
//    return _customerIdInfoView;
//}

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
        view.model = model;
        view.tag = 8002;
        _sectionBalancesInfoView = view;
    }
    return _sectionBalancesInfoView;
}

//- (PNBillAmountView *)billAmountView {
//    if (!_billAmountView) {
//        _billAmountView  = [[PNBillAmountView alloc] init];
//        _billAmountView.canEdit = YES;
//    }
//    return _billAmountView;
//}

- (PNBillModifyAmountItemView *)billModifyAccountView {
    if (!_billModifyAccountView) {
        _billModifyAccountView = [[PNBillModifyAmountItemView alloc] init];
        _billModifyAccountView.tag = 10;

        @HDWeakify(self);
        _billModifyAccountView.modifyAccountBlock = ^{
            @HDStrongify(self);
            PNBalancesInfoModel *balancesInfoModel = self.viewModel.billModel.balances.firstObject;

            void (^modifyAccountBlock)(PNBalancesInfoModel *) = ^(PNBalancesInfoModel *model) {
                if (model) {
                    balancesInfoModel.feeAmount = model.feeAmount;
                    balancesInfoModel.billAmount = model.billAmount;
                    balancesInfoModel.totalAmount = model.totalAmount;
                    balancesInfoModel.paymentToken = model.paymentToken;
                    balancesInfoModel.otherCurrencyAmounts = model.otherCurrencyAmounts;

                    self.billModifyAccountView.balancesInfoModel = balancesInfoModel;

                    self.feeInfoView.model.valueText = balancesInfoModel.feeAmount.thousandSeparatorAmount;
                    [self.feeInfoView setNeedsUpdateContent];

                    self.totalAmountInfoView.model.valueText = balancesInfoModel.totalAmount.thousandSeparatorAmount;
                    [self.totalAmountInfoView setNeedsUpdateContent];

                    self.promotionInfoView.model.valueText = balancesInfoModel.marketingBreaks.thousandSeparatorAmount;
                    [self.promotionInfoView setNeedsUpdateContent];
                }
            };
            NSDictionary *dict = @{
                @"handle": modifyAccountBlock,
                @"data": [balancesInfoModel yy_modelToJSONObject],
                @"billNo": balancesInfoModel.billNo,
            };
            [HDMediator.sharedInstance navigaveToPayNowPaymentBillModifyAccountVC:dict];
        };
    }
    return _billModifyAccountView;
}

- (SAInfoView *)feeInfoView {
    if (!_feeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"fee", @"fee")];
        view.model = model;
        _feeInfoView = view;
    }
    return _feeInfoView;
}

- (SAInfoView *)promotionInfoView {
    if (!_promotionInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"promotion", @"promotion")];
        model.valueColor = HDAppTheme.PayNowColor.cFD7127;
        view.model = model;
        _promotionInfoView = view;
    }
    return _promotionInfoView;
}

- (SAInfoView *)chargeTypeInfoView {
    if (!_chargeTypeInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"charge_type", @"charge type")];
        model.valueColor = HDAppTheme.PayNowColor.cFD7127;
        view.model = model;
        _chargeTypeInfoView = view;
    }
    return _chargeTypeInfoView;
}

- (SAInfoView *)totalAmountInfoView {
    if (!_totalAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"total_amount", @"Total Amount")];
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:14.f];
        model.keyColor = HDAppTheme.PayNowColor.c9599A2;
        model.valueFont = HDAppTheme.PayNowFont.standard15B;
        model.lineWidth = 0;
        view.model = model;
        _totalAmountInfoView = view;
    }
    return _totalAmountInfoView;
}

- (SAInfoView *)otherTotalAmountInfoView {
    if (!_otherTotalAmountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"total_Amount_exchange_USD", @"支付合计（换算为USD）")];
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:14.f];
        model.keyColor = HDAppTheme.PayNowColor.c9599A2;
        model.valueFont = HDAppTheme.PayNowFont.standard15B;
        model.lineWidth = 0;

        view.model = model;
        view.hidden = YES;
        _otherTotalAmountInfoView = view;
    }
    return _otherTotalAmountInfoView;
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

- (SAInfoView *)sectionPhoneInfoView {
    if (!_sectionPhoneInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"customer_phone", @"Customer Phone")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8004;
        _sectionPhoneInfoView = view;
    }
    return _sectionPhoneInfoView;
}

- (UIView *)phoneBgView {
    if (!_phoneBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        //        view.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5) borderWidth:kRealWidth(1) borderColor:HDAppTheme.PayNowColor.cC4C5C8];
        //        };
        view.tag = 10000;
        _phoneBgView = view;
    }
    return _phoneBgView;
}

- (HDUITextField *)phoneTextFiled {
    if (!_phoneTextFiled) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:@"" leftLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.placeholderFont = HDAppTheme.PayNowFont.standard14;
        config.placeholderColor = HDAppTheme.PayNowColor.c9599A2;

        config.font = HDAppTheme.PayNowFont.standard15M;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.floatingText = @" ";
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.characterSetString = kCharacterSetStringNumber;
        config.keyboardType = UIKeyboardTypeNumberPad;
        [textField setConfig:config];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.viewModel.customerPhone = text;
        };
        _phoneTextFiled = textField;
    }
    return _phoneTextFiled;
}

- (SAInfoView *)sectionNotesInfoView {
    if (!_sectionNotesInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"notes", @"Notes")];
        model.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        model.keyColor = HDAppTheme.PayNowColor.c343B4D;
        model.keyFont = [HDAppTheme.PayNowFont fontSemibold:15];
        model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(12), kRealWidth(15));
        model.lineWidth = 0;
        view.model = model;
        view.tag = 8003;
        _sectionNotesInfoView = view;
    }
    return _sectionNotesInfoView;
}

- (UIView *)notesBgView {
    if (!_notesBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        //        view.layer.borderColor = HDAppTheme.PayNowColor.cC4C5C8.CGColor;
        //        view.layer.borderWidth = kRealWidth(1);
        view.layer.cornerRadius = kRealWidth(5);
        view.tag = 10001;
        _notesBgView = view;
    }
    return _notesBgView;
}

- (HDTextView *)noteTextView {
    if (!_noteTextView) {
        HDTextView *view = HDTextView.new;
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.textColor = HDAppTheme.PayNowColor.c343B4D;
        view.maximumTextLength = 500;
        view.delegate = self;
        //        view.placeholder = SALocalizedString(@"Optional_tips", @"选填");
        view.placeholderColor = HDAppTheme.color.G3;
        view.font = HDAppTheme.PayNowFont.standard15B;
        view.bounces = false;
        view.showsVerticalScrollIndicator = false;
        view.scrollEnabled = NO;
        _noteTextView = view;
    }
    return _noteTextView;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"pn_confirm", @"确认") forState:0];

        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            PNBalancesInfoModel *balancesInfoModel = self.viewModel.billModel.balances.firstObject;

            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"billNo"] = balancesInfoModel.billNo;
            params[@"businessOrderId"] = balancesInfoModel.billNo;
            params[@"billCode"] = balancesInfoModel.billCode;
            params[@"businessLine"] = SAClientTypeBillPayment;
            params[@"payType"] = @(SAOrderPaymentTypeOnline);
            params[@"currency"] = balancesInfoModel.currency;
            params[@"notes"] = self.viewModel.notes;
            params[@"billingSource"] = @"10";

            params[@"returnUrl"] = [NSString stringWithFormat:@"SuperApp://PayNow/paymentResult?businessLine=%@&orderNo=", SAClientTypeBillPayment];
            /// 目前只支持美元USD , 如果账单是瑞尔，则取 兑换成usd 的字段金额
            if ([balancesInfoModel.currency isEqualToString:PNCurrencyTypeKHR]) {
                params[@"totalPayableAmount"] = balancesInfoModel.otherCurrencyAmounts.cent;
                params[@"actualPayAmount"] = balancesInfoModel.otherCurrencyAmounts.cent;
            } else {
                params[@"totalPayableAmount"] = balancesInfoModel.totalAmount.cent;
                params[@"actualPayAmount"] = balancesInfoModel.totalAmount.cent;
            }

            params[@"paymentCategory"] = @(self.viewModel.paymentCategoryType);
            params[@"operatorNo"] = SAUser.shared.operatorNo;
            params[@"customerPhone"] = self.viewModel.customerPhone;
            HDLog(@"提交参数： %@", params);

            [self.viewModel submitBillOrder:params success:^(PNCreateAggregateOrderRspModel *_Nonnull rspModel) {
                [self openCashRegisterWithModel:rspModel.aggregateOrderNo outPayOrderNo:rspModel.outPayOrderNo totalAmount:rspModel.totalAmount];
            }];
            HDLog(@"click");
        }];
    }
    return _confirmButton;
}

@end
