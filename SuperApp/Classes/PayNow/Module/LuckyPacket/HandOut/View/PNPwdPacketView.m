//
//  PNPwdPacketView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPwdPacketView.h"
#import "NSString+matchs.h"
#import "PNHandOutViewModel.h"
#import "PNPacketAmountItemView.h"
#import "PNPacketCoverItemView.h"
#import "PNPacketPasswordItemView.h"
#import "PNPacketQuantifyItemView.h"
#import "PNPacketRateTipsItemView.h"
#import "PNPacketSendToItemView.h"
#import "PNPacketSwitchHandOutItemView.h"
#import "PNPacketWishesItemView.h"


@interface PNPwdPacketView ()
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNPacketSwitchHandOutItemView *switchItemView;
@property (nonatomic, strong) PNPacketQuantifyItemView *quantifyItemView;
@property (nonatomic, strong) PNPacketAmountItemView *amountItemView;
@property (nonatomic, strong) PNPacketRateTipsItemView *tipsItemView;
@property (nonatomic, strong) PNPacketCoverItemView *coverItemView;
@property (nonatomic, strong) PNPacketWishesItemView *wishesItemView;
@property (nonatomic, strong) PNPacketSendToItemView *sendToItemView;
@property (nonatomic, strong) PNPacketPasswordItemView *passwordItemView;
@property (nonatomic, strong) PNOperationButton *sendBtn;
@end


@implementation PNPwdPacketView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.viewModel.model.splitType = PNPacketSplitType_Lucky;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    [self.KVOController hd_observe:self.viewModel keyPath:@"ruleLimitFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self ruleLimit];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (!WJIsObjectNil(self.viewModel.exchangeRateModel)) {
            NSString *str = [NSString stringWithFormat:PNLocalizedString(@"pn_packet_balance_of_KHR_wallet_insufficient", @"KHR账户余额不足时，支持使用USD账户余额支付\n"),
                                                       PNLocalizedString(@"pn_current_packet_rate", @"当前汇率：1 USD=%@KHR"),
                                                       self.viewModel.exchangeRateModel.usdBuyKhr];
            self.tipsItemView.tipsStr = str;
            [self.coverItemView refreshFlagImage];

            [self setNeedsUpdateConstraints];
        }
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.switchItemView];
    [self.scrollViewContainer addSubview:self.quantifyItemView];
    [self.scrollViewContainer addSubview:self.amountItemView];
    [self.scrollViewContainer addSubview:self.tipsItemView];
    [self.scrollViewContainer addSubview:self.passwordItemView];
    [self.scrollViewContainer addSubview:self.coverItemView];
    [self.scrollViewContainer addSubview:self.wishesItemView];
    [self.scrollViewContainer addSubview:self.sendToItemView];
    [self.scrollViewContainer addSubview:self.sendBtn];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.switchItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(16));
    }];

    [self.quantifyItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.switchItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.amountItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.quantifyItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.tipsItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.amountItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.passwordItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.tipsItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.wishesItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.passwordItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.coverItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.wishesItemView.mas_bottom);
    }];

    [self.sendToItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.switchItemView);
        make.top.mas_equalTo(self.coverItemView.mas_bottom).offset(kRealWidth(8));
    }];

    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.sendToItemView.mas_bottom).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)ruleLimit {
    PNHandOutModel *model = self.viewModel.model;
    if (model.qty > 0 && model.amt.doubleValue > 0 && [model.amt matches:REGEX_AMOUNT] && model.grantObject > PNPacketGrantObject_Non) {
        self.sendBtn.enabled = YES;

        if (model.grantObject == PNPacketGrantObject_In && model.receivers.count <= 0) {
            self.sendBtn.enabled = NO;
        }
    } else {
        self.sendBtn.enabled = NO;
    }
}

#pragma mark

#pragma mark
- (PNPacketSwitchHandOutItemView *)switchItemView {
    if (!_switchItemView) {
        _switchItemView = [[PNPacketSwitchHandOutItemView alloc] initWithViewModel:self.viewModel];
        _switchItemView.packetType = PNPacketType_Password;
    }
    return _switchItemView;
}

- (PNPacketQuantifyItemView *)quantifyItemView {
    if (!_quantifyItemView) {
        _quantifyItemView = [[PNPacketQuantifyItemView alloc] initWithViewModel:self.viewModel];
    }
    return _quantifyItemView;
}

- (PNPacketAmountItemView *)amountItemView {
    if (!_amountItemView) {
        _amountItemView = [[PNPacketAmountItemView alloc] initWithViewModel:self.viewModel];
    }
    return _amountItemView;
}

- (PNPacketPasswordItemView *)passwordItemView {
    if (!_passwordItemView) {
        _passwordItemView = [[PNPacketPasswordItemView alloc] initWithViewModel:self.viewModel];
    }
    return _passwordItemView;
}

- (PNPacketRateTipsItemView *)tipsItemView {
    if (!_tipsItemView) {
        _tipsItemView = [[PNPacketRateTipsItemView alloc] initWithViewModel:self.viewModel];
    }
    return _tipsItemView;
}

- (PNPacketCoverItemView *)coverItemView {
    if (!_coverItemView) {
        _coverItemView = [[PNPacketCoverItemView alloc] initWithViewModel:self.viewModel];
    }
    return _coverItemView;
}

- (PNPacketWishesItemView *)wishesItemView {
    if (!_wishesItemView) {
        _wishesItemView = [[PNPacketWishesItemView alloc] initWithViewModel:self.viewModel];
    }
    return _wishesItemView;
}

- (PNPacketSendToItemView *)sendToItemView {
    if (!_sendToItemView) {
        _sendToItemView = [[PNPacketSendToItemView alloc] initWithViewModel:self.viewModel];
    }
    return _sendToItemView;
}

- (PNOperationButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _sendBtn.enabled = NO;
        [_sendBtn setTitle:PNLocalizedString(@"pn_prepre_red_packet", @"塞钱进钱包") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_sendBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.handOutBtnClickBlock ?: self.handOutBtnClickBlock();
        }];
    }
    return _sendBtn;
}
@end
