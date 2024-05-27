//
//  PNApartmentComfirmSingleView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentComfirmSingleView.h"
#import "PNInfoView.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNApartmentComfirmSingleView ()
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) SALabel *tipsLabel;

@property (nonatomic, strong) PNInfoView *createTimeInfoView;
@property (nonatomic, strong) PNInfoView *numberInfoView;
@property (nonatomic, strong) PNInfoView *statusInfoView;
@property (nonatomic, strong) PNInfoView *merchantNameInfoView;
@property (nonatomic, strong) PNInfoView *itemNameInfoView;
@property (nonatomic, strong) PNInfoView *roomNoInfoView;
@property (nonatomic, strong) PNInfoView *payAmountInfoView;
@property (nonatomic, strong) PNInfoView *remarkInfoView;

@property (nonatomic, strong) PNOperationButton *payNowBtn;
@property (nonatomic, strong) PNOperationButton *refusedBtn;
@property (nonatomic, strong) HDUIButton *uploadBtn;

@end


@implementation PNApartmentComfirmSingleView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.amountLabel];
    [self.scrollViewContainer addSubview:self.tipsLabel];

    [self.scrollViewContainer addSubview:self.createTimeInfoView];
    [self.scrollViewContainer addSubview:self.numberInfoView];
    [self.scrollViewContainer addSubview:self.statusInfoView];
    [self.scrollViewContainer addSubview:self.merchantNameInfoView];
    [self.scrollViewContainer addSubview:self.itemNameInfoView];
    [self.scrollViewContainer addSubview:self.roomNoInfoView];
    [self.scrollViewContainer addSubview:self.payAmountInfoView];
    [self.scrollViewContainer addSubview:self.remarkInfoView];

    [self addSubview:self.refusedBtn];
    [self addSubview:self.payNowBtn];
    [self addSubview:self.uploadBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_equalTo(self.refusedBtn.mas_top).offset(-kRealWidth(20));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(30));
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kRealWidth(4));
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
    }];

    [self.createTimeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(20));
    }];

    [self.numberInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.createTimeInfoView.mas_bottom);
    }];

    [self.statusInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.numberInfoView.mas_bottom);
    }];

    [self.merchantNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.statusInfoView.mas_bottom);
    }];


    [self.itemNameInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.merchantNameInfoView.mas_bottom);
    }];


    [self.roomNoInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.itemNameInfoView.mas_bottom);
    }];

    [self.payAmountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.roomNoInfoView.mas_bottom);
    }];

    [self.remarkInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.payAmountInfoView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.uploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(12) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [self.refusedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kRealWidth(48)));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.uploadBtn.mas_top).offset(-kRealWidth(8));
    }];

    [self.payNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.bottom.equalTo(self.refusedBtn);
        make.left.mas_equalTo(self.refusedBtn.mas_right).offset(kRealWidth(8));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNApartmentListItemModel *)model {
    _model = model;

    NSString *hightStr = [self.model.paymentAmount thousandSeparatorAmountNoCurrencySymbol];
    NSString *allStr = [NSString stringWithFormat:@"%@%@", [PNCommonUtils getCurrencySymbolByCode:self.model.paymentAmount.cy], hightStr];
    self.amountLabel.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:32]
                                                                  highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                         norFont:[HDAppTheme.PayNowFont fontDINBold:14]
                                                                        norColor:HDAppTheme.PayNowColor.mainThemeColor];

    self.createTimeInfoView.model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:self.model.createTime.floatValue / 1000]];
    [self.createTimeInfoView setNeedsUpdateContent];

    self.numberInfoView.model.valueText = self.model.paymentSlipNo;
    [self.numberInfoView setNeedsUpdateContent];

    self.statusInfoView.model.valueText = [PNCommonUtils getApartmentStatusName:self.model.paymentStatus];
    [self.statusInfoView setNeedsUpdateContent];

    self.merchantNameInfoView.model.valueText = self.model.merchantName;
    [self.merchantNameInfoView setNeedsUpdateContent];

    self.itemNameInfoView.model.valueText = self.model.paymentItems;
    [self.itemNameInfoView setNeedsUpdateContent];

    self.roomNoInfoView.model.valueText = self.model.roomNo;
    [self.roomNoInfoView setNeedsUpdateContent];

    self.payAmountInfoView.model.valueText = [self.model.paymentAmount thousandSeparatorAmount];
    [self.payAmountInfoView setNeedsUpdateContent];

    self.remarkInfoView.model.valueText = self.model.remark;
    [self.remarkInfoView setNeedsUpdateContent];


    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"bill_to_bo_paid", @"待缴费");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    model.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    model.valueFont = HDAppTheme.PayNowFont.standard15M;
    model.lineWidth = 0;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    model.valueNumbersOfLines = 0;
    return model;
}

- (PNInfoView *)createTimeInfoView {
    if (!_createTimeInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间")];
        view.model = model;
        _createTimeInfoView = view;
    }
    return _createTimeInfoView;
}

- (PNInfoView *)numberInfoView {
    if (!_numberInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_no", @"缴费单号")];
        view.model = model;
        _numberInfoView = view;
    }
    return _numberInfoView;
}

- (PNInfoView *)statusInfoView {
    if (!_statusInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_status", @"缴费状态")];
        view.model = model;
        _statusInfoView = view;
    }
    return _statusInfoView;
}

- (PNInfoView *)merchantNameInfoView {
    if (!_merchantNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"ms_merchant_name", @"商户名称")];
        view.model = model;
        _merchantNameInfoView = view;
    }
    return _merchantNameInfoView;
}

- (PNInfoView *)itemNameInfoView {
    if (!_itemNameInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_items", @"缴费项目")];
        view.model = model;
        _itemNameInfoView = view;
    }
    return _itemNameInfoView;
}

- (PNInfoView *)roomNoInfoView {
    if (!_roomNoInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_room_no", @"房号")];
        view.model = model;
        _roomNoInfoView = view;
    }
    return _roomNoInfoView;
}

- (PNInfoView *)payAmountInfoView {
    if (!_payAmountInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_amount", @"缴费金额")];
        view.model = model;
        _payAmountInfoView = view;
    }
    return _payAmountInfoView;
}

- (PNInfoView *)remarkInfoView {
    if (!_remarkInfoView) {
        PNInfoView *view = PNInfoView.new;
        PNInfoViewModel *model = [self infoViewModelWithKey:PNLocalizedString(@"pn_bill_remark", @"账单备注")];
        view.model = model;
        _remarkInfoView = view;
    }
    return _remarkInfoView;
}

- (PNOperationButton *)refusedBtn {
    if (!_refusedBtn) {
        _refusedBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_refusedBtn setTitle:PNLocalizedString(@"pn_Bill_info_incorrect", @"缴费信息有误，拒绝") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_refusedBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowApartmentRejectVC:@{
                @"paymentId": self.model.paymentId,
            }];
        }];
    }
    return _refusedBtn;
}

- (PNOperationButton *)payNowBtn {
    if (!_payNowBtn) {
        _payNowBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_payNowBtn setTitle:PNLocalizedString(@"pn_pay_now", @"立即缴费") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_payNowBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.payNowBlock ?: self.payNowBlock(@[self.model]);
        }];
    }
    return _payNowBtn;
}

- (HDUIButton *)uploadBtn {
    if (!_uploadBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_billed_and_uploaded", @"已缴费上传凭证") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(10), kRealWidth(10), kRealWidth(10));

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowApartmentUploadVoucherVC:@{
                @"paymentId": self.model.paymentId,
            }];
        }];

        _uploadBtn = button;
    }
    return _uploadBtn;
}
@end
