//
//  SALaboratoryViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SALaboratoryViewController.h"
#import "HDMediator+SuperApp.h"
//#import <StoreKit/StoreKit.h>


@interface SALaboratoryViewController ()
///< test apple pay
@property (nonatomic, strong) UIButton *testIAP;
///< 支付请求
//@property (nonatomic, strong) SKProductsRequest *request;
@end


@implementation SALaboratoryViewController

- (void)hd_setupViews {
    [self.view addSubview:self.testIAP];

    //    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)hd_setupNavigation {
}

- (void)updateViewConstraints {
    [self.testIAP sizeToFit];

    [self.testIAP mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - private methods
- (void)clickedIAPButton:(UIButton *)button {
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:@{@"orderNo": @"1508062447462600704", @"businessLine": @"YumNow"}];
}

#pragma mark - SKProductRequestDelegate
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    for (NSString *unavaliable in response.invalidProductIdentifiers) {
//        HDLog(@"不可用的商品:%@", unavaliable);
//    }
//
//    for (SKProduct *product in response.products) {
//        HDLog(@"可用的商品:%@", product.productIdentifier);
//    }
//
//    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:response.products.firstObject];
//    payment.applicationUsername = @"88127127";
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}

- (UIButton *)testIAP {
    if (!_testIAP) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"IAP" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedIAPButton:) forControlEvents:UIControlEventTouchUpInside];
        _testIAP = button;
    }
    return _testIAP;
}

@end
