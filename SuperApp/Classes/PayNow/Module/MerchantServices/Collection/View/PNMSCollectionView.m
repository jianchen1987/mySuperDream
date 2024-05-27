//
//  PNMSCollectionView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionView.h"
#import "PNCommonUtils.h"
#import "PNMSCollectionCurrencyItemView.h"
#import "PNMSCollectionViewModel.h"
#import "SAInfoView.h"


@interface PNMSCollectionView ()
@property (nonatomic, strong) UIImageView *topBgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) PNMSCollectionCurrencyItemView *usdView;
@property (nonatomic, strong) PNMSCollectionCurrencyItemView *khrView;
@property (nonatomic, strong) SAInfoView *recordInfoView;

@property (nonatomic, strong) PNMSCollectionViewModel *viewModel;

@end


@implementation PNMSCollectionView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.viewModel getNewData];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        PNMSCollectionCurrencyItemModel *usdModel = [[PNMSCollectionCurrencyItemModel alloc] init];
        usdModel.money = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:self.viewModel.model.usdAmt.stringValue] currencyCode:PNCurrencyTypeUSD];
        usdModel.count = [NSString stringWithFormat:@"%zd", self.viewModel.model.usdNum];
        usdModel.currency = PNCurrencyTypeUSD;
        self.usdView.model = usdModel;

        PNMSCollectionCurrencyItemModel *khrModel = [[PNMSCollectionCurrencyItemModel alloc] init];
        khrModel.money = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:self.viewModel.model.khrAmt.stringValue] currencyCode:PNCurrencyTypeKHR];
        khrModel.count = [NSString stringWithFormat:@"%zd", self.viewModel.model.khrNum];
        khrModel.currency = PNCurrencyTypeKHR;
        self.khrView.model = khrModel;
    }];
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.topBgView];
    [self.topBgView addSubview:self.titleLabel];
    [self.topBgView addSubview:self.usdView];
    [self.topBgView addSubview:self.khrView];

    [self.scrollViewContainer addSubview:self.recordInfoView];
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

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(24));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.topBgView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.topBgView.mas_top).offset(kRealWidth(16));
    }];

    [self.usdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topBgView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
    }];

    [self.khrView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.topBgView);
        make.top.mas_equalTo(self.usdView.mas_bottom).offset(kRealWidth(20));
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(-32));
    }];

    [self.recordInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(24));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (UIImageView *)topBgView {
    if (!_topBgView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"pn_ms_collection_bg"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _topBgView = view;
    }
    return _topBgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.7];
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = PNLocalizedString(@"ms_today_collection", @"今日收款");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNMSCollectionCurrencyItemView *)usdView {
    if (!_usdView) {
        _usdView = [[PNMSCollectionCurrencyItemView alloc] init];
    }
    return _usdView;
}

- (PNMSCollectionCurrencyItemView *)khrView {
    if (!_khrView) {
        _khrView = [[PNMSCollectionCurrencyItemView alloc] init];
    }
    return _khrView;
}

- (SAInfoView *)recordInfoView {
    if (!_recordInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyText = PNLocalizedString(@"Transaction_record", @"交易记录");
        model.keyColor = HDAppTheme.PayNowColor.c333333;
        model.leftImage = [UIImage imageNamed:@"pn_transaction_record_icon"];
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.lineWidth = 0;
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        model.cornerRadius = kRealWidth(8);
        model.enableTapRecognizer = YES;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(15), kRealWidth(16), kRealWidth(15));
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesOrderListVC:@{
                @"merchantNo": self.viewModel.merchantNo,
            }];
        };

        view.model = model;
        _recordInfoView = view;
    }
    return _recordInfoView;
}

@end
