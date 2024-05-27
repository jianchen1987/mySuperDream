
//
//  SAWalletBillListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillListViewController.h"
#import "SAApolloManager.h"
#import "SAInternationalizationModel.h"
#import "SAWalletBillListView.h"
#import "SAWalletBillListViewModel.h"
#import "SAWalletHistoryBillListViewController.h"
#import "SAWriteDateReadableModel.h"


@interface SAWalletBillListViewController ()
@property (nonatomic, strong) SAWalletBillListView *contentView;    ///<
@property (nonatomic, strong) SAWalletBillListViewModel *viewModel; ///<
@end


@implementation SAWalletBillListViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"bill", @"账单");
    HDUIButton *historyBtn = [HDUIButton buttonWithType:UIButtonTypeSystem];
    [historyBtn setTitle:SALocalizedString(@"bill_history_btn", @"查看历史账单") forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor hd_colorWithHexString:@"#4176FF"] forState:UIControlStateNormal];
    historyBtn.titleLabel.font = HDAppTheme.font.standard3;
    [historyBtn addTarget:self action:@selector(clickedOnHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    self.hd_navigationItem.rightBarButtonItem = history;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self showAlert];
}

#pragma mark - private
- (void)showAlert {
    NSDictionary *dataDict = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyHistoryBillAlert];

    if (!HDIsObjectNil(dataDict)) {
        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kApolloSwitchKeyHistoryBillAlert type:SACacheTypeDocumentPublic];
        SAInternationalizationModel *cache = [SAInternationalizationModel yy_modelWithJSON:cacheModel.storeObj];

        SAInternationalizationModel *content = [SAInternationalizationModel yy_modelWithDictionary:dataDict];
        if (content && ![cache isEqual:content]) {
            HDAlertView *alertView = [[HDAlertView alloc] initWithTitle:SALocalizedString(@"wallet_notice", @"提示") message:content.desc config:nil];
            [alertView addButton:[HDAlertViewButton buttonWithTitle:SALocalizedString(@"i_know", @"我知道了") type:HDAlertViewButtonTypeDefault
                                                            handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                                [alertView dismiss];
                                                                // 写入缓存，不再提示
                                                                [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:content] forKey:kApolloSwitchKeyHistoryBillAlert
                                                                                            type:SACacheTypeDocumentPublic];
                                                            }]];

            [alertView show];
        }
    }
}

#pragma mark - action
- (void)clickedOnHistoryButton:(HDUIButton *)button {
    SAWalletHistoryBillListViewController *vc = [[SAWalletHistoryBillListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy load
- (SAWalletBillListView *)contentView {
    if (!_contentView) {
        _contentView = [[SAWalletBillListView alloc] initWithViewModel:self.viewModel];
    }

    return _contentView;
}

- (SAWalletBillListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SAWalletBillListViewModel.new;
    }
    return _viewModel;
}

@end
