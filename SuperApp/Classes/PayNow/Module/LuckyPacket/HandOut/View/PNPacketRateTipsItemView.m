//
//  PNPacketRateTipsItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRateTipsItemView.h"
#import "PNHandOutViewModel.h"


@interface PNPacketRateTipsItemView ()
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) SALabel *tipsLabel;

@end


@implementation PNPacketRateTipsItemView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.KVOController hd_observe:self.viewModel keyPath:@"exchangeRateModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        NSString *str = PNLocalizedString(@"pn_packet_balance_of_KHR_wallet_insufficient", @"KHR账户余额不足时，支持使用USD账户余额支付\n");
        if (!WJIsObjectNil(self.viewModel.exchangeRateModel)) {
            str = [str stringByAppendingFormat:PNLocalizedString(@"pn_current_packet_rate", @"当前汇率：1 USD=%@KHR"), self.viewModel.exchangeRateModel.usdBuyKhr];
        }

        self.tipsStr = str;
        [self setNeedsUpdateConstraints];
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.tipsLabel];
}

- (void)updateConstraints {
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)setTipsStr:(NSString *)tipsStr {
    _tipsStr = tipsStr;

    self.tipsLabel.text = self.tipsStr;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        _tipsLabel = label;
    }
    return _tipsLabel;
}
@end
