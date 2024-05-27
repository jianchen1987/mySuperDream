//
//  WMTopUpOederDetailViewController.m
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailViewController.h"
#import "HDCheckStandPresenter.h"
#import "HDTradeBuildOrderModel.h"
#import "SAQueryOrderDetailsRspModel.h"
#import "SATopUpOrderDetailRspModel.h"
#import "SATopUpOrderDetailView.h"
#import "SATopUpOrderDetailViewModel.h"


@interface SATopUpOrderDetailViewController ()

/// 充值详情
@property (nonatomic, strong) SATopUpOrderDetailView *detailView;
/// viewModel
@property (nonatomic, strong) SATopUpOrderDetailViewModel *viewModel;

@end


@implementation SATopUpOrderDetailViewController

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.detailView];
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_detail", @"订单详情");
}

- (void)hd_getNewData {
    [self.viewModel getTopUpOrderDetail];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.detailView.model = self.viewModel;
    }];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - private methods
- (void)toPay {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = self.viewModel.orderNo;
    //    buildModel.outPayOrderNo = self.viewModel.outPayOrderNo;
    buildModel.payableAmount = self.viewModel.model.payeeAmt;
    buildModel.businessLine = SAClientTypePhoneTopUp;
    buildModel.merchantNo = self.viewModel.orderInfo.merchantNo;
    buildModel.storeNo = self.viewModel.orderInfo.storeNo;

    buildModel.needCheckPaying = YES; //需要校验重新支付的时候改成YES

    buildModel.payType = self.viewModel.orderInfo.payType;
    [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self delegate:self.viewModel];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:HDWebViewHostViewController.class]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy load
- (SATopUpOrderDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[SATopUpOrderDetailView alloc] init];
        @HDWeakify(self);
        [_detailView setBlockOnToPay:^{
            @HDStrongify(self);
            [self toPay];
        }];
    }
    return _detailView;
}

- (SATopUpOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SATopUpOrderDetailViewModel alloc] init];
        _viewModel.orderNo = self.parameters[@"orderNo"];
        //        _viewModel.outPayOrderNo = self.parameters[@"outPayOrderNo"];
    }
    return _viewModel;
}

@end
