//
//  PNApartmentComfirmViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentComfirmViewController.h"
#import "PNApartmentComfirmMoreView.h"
#import "PNApartmentComfirmSingleView.h"
#import "PNApartmentComfrimSubmitAlertView.h"
#import "PNApartmentDTO.h"
#import "SAQueryOrderInfoRspModel.h"
#import "UIViewController+NavigationController.h"
#import "SAOrderDTO.h"
#import "HDCheckStandViewController.h"
#import "SAPayResultViewController.h"


@interface PNApartmentComfirmViewController () <HDCheckStandViewControllerDelegate>
@property (nonatomic, strong) PNApartmentComfirmMoreView *moreView;
@property (nonatomic, strong) PNApartmentComfirmSingleView *singleView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, strong) SAOrderDTO *orderDTO;
@property (nonatomic, copy) NSString *aggregateOrderNo;
@end


@implementation PNApartmentComfirmViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithArray:[parameters objectForKey:@"dataSource"]];
        if (!WJIsArrayEmpty(self.dataSource)) {
        } else {
            NSAssert(YES, @"需要有数据源才行啊");
        }
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Rent_bill", @"公寓缴费");
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    if (self.dataSource.count == 1) {
        [self.view addSubview:self.singleView];
        self.moreView.hidden = YES;
    } else {
        [self.view addSubview:self.moreView];
        self.singleView.hidden = YES;
    }
}

- (void)updateViewConstraints {
    if (!self.moreView.hidden) {
        [self.moreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    if (!self.singleView.hidden) {
        [self.singleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    [super updateViewConstraints];
}

- (void)preCheckSubimi:(NSArray<PNApartmentListItemModel *> *)arr {
    if (!WJIsArrayEmpty(arr)) {
        [self showloading];

        NSMutableArray *feesNoArray = [NSMutableArray arrayWithCapacity:arr.count];
        for (PNApartmentListItemModel *item in arr) {
            [feesNoArray addObject:item.paymentSlipNo];
        }

        @HDWeakify(self);
        [self.apartmentDTO preCheckThePayment:feesNoArray success:^(PNApartmentComfirmRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self dismissLoading];

            PNApartmentComfrimSubmitAlertView *alertView = [[PNApartmentComfrimSubmitAlertView alloc] initWithBalanceModel:rspModel];

            @HDWeakify(self);
            alertView.comfrimBlock = ^{
                @HDStrongify(self);
                [self comfirmToPay:feesNoArray];
            };
            [alertView show];
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

- (void)comfirmToPay:(NSArray *)arr {
    [self showloading];

    @HDWeakify(self);
    [self.apartmentDTO comfirmThePayment:arr success:^(PNApartmentComfirmRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self openCashRegisterWithModel:rspModel.aggregateOrderNo outPayOrderNo:rspModel.outPayOrderNo totalAmount:rspModel.actualPayAmount];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
#pragma mark 打开收银台
///打开收银台
- (void)openCashRegisterWithModel:(NSString *)aggregateOrderNo outPayOrderNo:(NSString *)outPayOrderNo totalAmount:(SAMoneyModel *)totalAmount {
    @HDWeakify(self);
    [self.orderDTO queryOrderInfoWithOrderNo:aggregateOrderNo outPayOrderNo:outPayOrderNo success:^(SAQueryOrderInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        if (rspModel) {
            self.aggregateOrderNo = aggregateOrderNo;

            HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
            buildModel.orderNo = aggregateOrderNo;
            buildModel.storeNo = rspModel.storeId;
            buildModel.merchantNo = rspModel.merchantNo;
            buildModel.payableAmount = totalAmount;
            buildModel.businessLine = SAClientTypeBillPayment;
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
            checkStandVC.resultDelegate = self;
            [self presentViewController:checkStandVC animated:YES completion:nil];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

// 线上支付结果页
- (void)navigationToOnlineResultPageWithParams {
    NSMutableDictionary *resultPageParams = [NSMutableDictionary dictionary];
    resultPageParams[@"businessLine"] = SAClientTypeBillPayment;
    resultPageParams[@"orderNo"] = self.aggregateOrderNo;
    resultPageParams[@"pageLabel"] = @"online_payment_result";

    @HDWeakify(self);
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        BOOL result = NO;
        UIViewController *viewContr;
        for (UIViewController *itemVC in vc.navigationController.viewControllers) {
            if ([itemVC isKindOfClass:NSClassFromString(@"PNApartmentListViewController")]) {
                result = YES;
                viewContr = itemVC;
                break;
            }
        }
        if (result && viewContr) {
            [vc.navigationController popToViewController:viewContr animated:YES];
            [HDMediator.sharedInstance navigaveToPayNowApartmentRecordListVC:@{}];
        } else {
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    };

    void (^doneClickBlock)(UIViewController *) = ^(UIViewController *vc) {
        BOOL result = NO;
        UIViewController *viewContr;
        for (UIViewController *itemVC in vc.navigationController.viewControllers) {
            if ([itemVC isKindOfClass:NSClassFromString(@"PNApartmentListViewController")]) {
                result = YES;
                viewContr = itemVC;
                break;
            }
        }
        if (result && viewContr) {
            [vc.navigationController popToViewController:viewContr animated:NO];
        } else {
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }
    };

    resultPageParams[@"orderClickBlock"] = orderDetailBlock;
    resultPageParams[@"doneClickBlock"] = doneClickBlock;

    SAPayResultViewController *vc = [[SAPayResultViewController alloc] initWithRouteParameters:resultPageParams];
    [self.navigationController pushViewController:vc animated:YES removeSpecClass:self.class onlyOnce:YES];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self navigationToOnlineResultPageWithParams];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToOnlineResultPageWithParams];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:^{
    }];
}
#pragma mark
- (PNApartmentComfirmMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[PNApartmentComfirmMoreView alloc] init];
        _moreView.dataSource = self.dataSource;

        @HDWeakify(self);
        _moreView.payNowBlock = ^(NSArray<PNApartmentListItemModel *> *_Nonnull array) {
            @HDStrongify(self);
            [self preCheckSubimi:array];
        };
    }
    return _moreView;
}

- (PNApartmentComfirmSingleView *)singleView {
    if (!_singleView) {
        _singleView = [[PNApartmentComfirmSingleView alloc] init];
        _singleView.model = [self.dataSource firstObject];

        @HDWeakify(self);
        _singleView.payNowBlock = ^(NSArray<PNApartmentListItemModel *> *_Nonnull array) {
            @HDStrongify(self);
            [self preCheckSubimi:array];
        };
    }
    return _singleView;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

- (SAOrderDTO *)orderDTO {
    return _orderDTO ?: ({ _orderDTO = [[SAOrderDTO alloc] init]; });
}

@end
