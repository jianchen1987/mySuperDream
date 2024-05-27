//
//  TNIncomeViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeViewController.h"
#import "TNIncomeRecordView.h"
#import "TNIncomeViewModel.h"
#import "TNMenuNavView.h"
#import "TNNewIncomeIndexView.h"
#import "TNNewIncomeViewModel.h"


@interface TNIncomeViewController ()
@property (strong, nonatomic) TNIncomeViewModel *viewModel;
/// 新版用新的Viewmoel
@property (strong, nonatomic) TNNewIncomeViewModel *indexNewViewModel;
/// 旧版收益列表 根据开关是否回滚到旧版
@property (nonatomic, strong) TNIncomeRecordView *recordView;
///
@property (strong, nonatomic) TNNewIncomeIndexView *indexView;
///  是否需要pop回去上个页面  默认订单列表是一级tab页面
@property (nonatomic, assign) BOOL isNeedPopLastVC;
@end


@implementation TNIncomeViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    NSNumber *isNeedPop = parameters[@"isNeedPop"];
    NSNumber *queryMode = parameters[@"queryMode"];
    if (!HDIsObjectNil(isNeedPop)) {
        self.isNeedPopLastVC = [isNeedPop boolValue];
    }
    if (![TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //用新版本
        if (!HDIsObjectNil(queryMode)) {
            self.indexNewViewModel.filterModel.queryMode = [queryMode integerValue];
        }
    }

    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"1dh32q2n", @"收益");
    if (!self.isNeedPopLastVC) {
        self.hd_navigationItem.leftBarButtonItem = nil;
    }

    if (![TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        HDUIButton *walletBtn = [[HDUIButton alloc] init];
        [walletBtn setTitle:TNLocalizedString(@"vNSWHRwA", @"钱包") forState:UIControlStateNormal];
        [walletBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [walletBtn setImage:[UIImage imageNamed:@"tn_micshop_wallet"] forState:UIControlStateNormal];
        walletBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        walletBtn.spacingBetweenImageAndTitle = 5;
        [walletBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [SAWindowManager openUrl:@"SuperApp://SuperApp/wallet" withParameters:@{}];
        }];
        self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:walletBtn];
    }
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}
- (void)hd_getNewData {
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        [self.viewModel getIncomeData];
    } else {
        //新版本
        [self.indexNewViewModel checkUserOpenedWallet];
    }
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 1;
    //
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        [self.view addSubview:self.recordView];
    } else {
        //新版本
        [self.view addSubview:self.indexView];
    }
}

- (void)updateViewConstraints {
    if ([TNGlobalData shared].isNeedGobackSupplierIncomePage) {
        //回退旧版本
        [self.recordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    } else {
        //新版本
        [self.indexView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    [super updateViewConstraints];
}

#pragma mark
- (TNIncomeRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[TNIncomeRecordView alloc] initWithViewModel:self.viewModel];
    }
    return _recordView;
}
/** @lazy viewModel */
- (TNIncomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNIncomeViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy indexView */
- (TNNewIncomeIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[TNNewIncomeIndexView alloc] initWithViewModel:self.indexNewViewModel];
    }
    return _indexView;
}
/** @lazy indexNewViewModel */
- (TNNewIncomeViewModel *)indexNewViewModel {
    if (!_indexNewViewModel) {
        _indexNewViewModel = [[TNNewIncomeViewModel alloc] init];
    }
    return _indexNewViewModel;
}
@end
