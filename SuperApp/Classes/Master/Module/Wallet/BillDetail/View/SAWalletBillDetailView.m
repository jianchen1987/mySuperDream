//
//  SAWalletBillDetailView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillDetailView.h"
#import "SAInfoView.h"
#import "SAWalletBillDetailHeaderView.h"
#import "SAWalletBillDetailViewModel.h"


@interface SAWalletBillDetailView ()
/// VM
@property (nonatomic, strong) SAWalletBillDetailViewModel *viewModel;
/// 头部
@property (nonatomic, strong) SAWalletBillDetailHeaderView *headerView;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray *infoViewList;
/// 金额
@property (nonatomic, strong) SAInfoView *amountView;
/// 类型
@property (nonatomic, strong) SAInfoView *typeView;
/// 支付方式
@property (nonatomic, strong) SAInfoView *paymethodView;
/// 时间
@property (nonatomic, strong) SAInfoView *timeView;
/// 流水号
@property (nonatomic, strong) SAInfoView *serialNumberView;
@end


@implementation SAWalletBillDetailView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.headerView];
    [self.scrollViewContainer addSubview:self.amountView];
    [self.scrollViewContainer addSubview:self.typeView];
    [self.scrollViewContainer addSubview:self.paymethodView];
    [self.scrollViewContainer addSubview:self.timeView];
    [self.scrollViewContainer addSubview:self.serialNumberView];

    [self.infoViewList addObject:self.amountView];
    [self.infoViewList addObject:self.typeView];
    [self.infoViewList addObject:self.paymethodView];
    [self.infoViewList addObject:self.timeView];
    [self.infoViewList addObject:self.serialNumberView];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"isLoading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            [self showloading];
        } else {
            [self dismissLoading];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"detailRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        SAWalletBillDetailRspModel *detailRspModel = change[NSKeyValueChangeNewKey];
        if ([detailRspModel isKindOfClass:SAWalletBillDetailRspModel.class]) {
            @HDStrongify(self);
            [self updateUIWithDetailRspModel:detailRspModel];
        }
    }];
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods
CG_INLINE SAInfoViewModel *infoViewModelWithKey(NSString *key) {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G3;
    model.valueColor = HDAppTheme.color.G2;
    model.keyText = key;
    return model;
}

- (void)updateUIWithDetailRspModel:(SAWalletBillDetailRspModel *)detailRspModel {
    [self.headerView updateTitle:[SAGeneralUtil getTradeTypeNameByCode:detailRspModel.tradeType]
                            desc:[NSString stringWithFormat:@"%@%@", detailRspModel.incomeFlag ?: @"", detailRspModel.orderAmt.thousandSeparatorAmount]];

    self.amountView.hidden = false;
    if (!self.amountView.isHidden) {
        self.amountView.model.valueText = detailRspModel.orderAmt.thousandSeparatorAmount;
        [self.amountView setNeedsUpdateContent];
    }
    self.typeView.hidden = detailRspModel.tradeType == HDWalletTransTypeDefault;
    if (!self.typeView.isHidden) {
        self.typeView.model.valueText = [SAGeneralUtil getTradeTypeNameByCode:detailRspModel.tradeType];
        [self.typeView setNeedsUpdateContent];
    }
    self.paymethodView.hidden = detailRspModel.payWay == HDWalletPaymethodDefault;
    if (!self.paymethodView.isHidden) {
        self.paymethodView.model.valueText = [SAGeneralUtil getWalletPaymethodDescWithPaymethod:detailRspModel.payWay];
        [self.paymethodView setNeedsUpdateContent];
    }
    self.timeView.hidden = HDIsStringEmpty(detailRspModel.finishTime);
    if (!self.timeView.isHidden) {
        self.timeView.model.valueText = [SAGeneralUtil getDateStrWithTimeInterval:detailRspModel.finishTime.doubleValue / 1000.0 format:@"dd/MM/yyyy HH:mm"];
        [self.timeView setNeedsUpdateContent];
    }
    self.serialNumberView.hidden = HDIsStringEmpty(detailRspModel.tradeNo);
    if (!self.serialNumberView.isHidden) {
        self.serialNumberView.model.valueText = detailRspModel.tradeNo;
        [self.serialNumberView setNeedsUpdateContent];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.scrollViewContainer);
        if (HDIsArrayEmpty(visableInfoViews)) {
            make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(15));
        }
    }];

    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        if (infoView != visableInfoViews.firstObject) {
            infoView.model.lineWidth = 0;
        } else {
            infoView.model.lineWidth = PixelOne;
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.headerView.mas_bottom);
            }
            make.left.equalTo(self.scrollViewContainer);
            make.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateConstraints];
}

#pragma mark - lazy load
- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:5];
    }
    return _infoViewList;
}

- (SAWalletBillDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = SAWalletBillDetailHeaderView.new;
    }
    return _headerView;
}

- (SAInfoView *)amountView {
    if (!_amountView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"money", @"金额"));
        _amountView = view;
    }
    return _amountView;
}

- (SAInfoView *)typeView {
    if (!_typeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"type", @"类型"));
        _typeView = view;
    }
    return _typeView;
}

- (SAInfoView *)paymethodView {
    if (!_paymethodView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"payment_method", @"支付方式"));
        _paymethodView = view;
    }
    return _paymethodView;
}

- (SAInfoView *)timeView {
    if (!_timeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"payment_time", @"支付时间"));
        _timeView = view;
    }
    return _timeView;
}

- (SAInfoView *)serialNumberView {
    if (!_serialNumberView) {
        SAInfoView *view = SAInfoView.new;
        view.model = infoViewModelWithKey(SALocalizedString(@"payment_number", @"流水号"));
        view.model.keyToValueWidthRate = 0.6;
        _serialNumberView = view;
    }
    return _serialNumberView;
}
@end
