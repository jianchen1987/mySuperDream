//
//  PNTermsViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTermsViewController.h"
#import "SAInfoView.h"


@interface PNTermsViewController ()
@property (nonatomic, strong) SAInfoView *coolcashInfoView;
@property (nonatomic, strong) SAInfoView *coolcashOCTInfoView;
@property (nonatomic, strong) SAInfoView *disclaimerInfoView;
@end


@implementation PNTermsViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_terms", @"协议和条款");
}

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.coolcashInfoView];
    [self.scrollViewContainer addSubview:self.coolcashOCTInfoView];
    [self.scrollViewContainer addSubview:self.disclaimerInfoView];
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
            make.left.equalTo(self.scrollViewContainer);
            make.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateViewConstraints];
}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    return model;
}

- (SAInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    SAInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
    return model;
}

#pragma mark
- (SAInfoView *)coolcashInfoView {
    if (!_coolcashInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"Terms_and_Conditions_for_CoolCash", @"CoolCash服务协议")];
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"CoolCash", @"navTitle": PNLocalizedString(@"Terms_and_Conditions_for_CoolCash", @"CoolCash服务协议")}];
        };
        view.model = model;
        _coolcashInfoView = view;
    }
    return _coolcashInfoView;
}

- (SAInfoView *)coolcashOCTInfoView {
    if (!_coolcashOCTInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"Terms_and_Conditions_for_OTC_Transactions", @"CoolCash OTC服务协议")];
        model.eventHandler = ^{
            [HDMediator.sharedInstance
                navigaveToPayNowPayWebViewVC:@{@"htmlName": @"CoolCashOCT", @"navTitle": PNLocalizedString(@"Terms_and_Conditions_for_OTC_Transactions", @"CoolCash OTC服务协议")}];
        };
        view.model = model;
        _coolcashOCTInfoView = view;
    }
    return _coolcashOCTInfoView;
}

- (SAInfoView *)disclaimerInfoView {
    if (!_disclaimerInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"disclaimer", @"免责声明")];
        model.eventHandler = ^{
            [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"Disclaimer", @"navTitle": PNLocalizedString(@"disclaimer", @"免责声明")}];
        };
        view.model = model;
        _disclaimerInfoView = view;
    }
    return _disclaimerInfoView;
}


@end
