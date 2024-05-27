//
//  ApplePayManager.m
//  SuperApp
//
//  Created by seeu on 2022/1/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "ApplePayManager.h"
#import "CMNetworkRequest.h"
#import "SAApplePayRequest.h"
#import <HDKitCore/HDKitCore.h>
#import <StoreKit/StoreKit.h>


@interface ApplePayManager () <SKProductsRequestDelegate>
///< 支付队列
@property (nonatomic, strong) NSMutableArray<SAApplePayRequest *> *payments;
///< 支持的商品列表
@property (nonatomic, strong) NSMutableArray<NSString *> *availableProducts;
///< 处理队列
@property (nonatomic, strong, nullable) dispatch_queue_t processQueue;
///< 查询商品列表请求
@property (nonatomic, strong) SKProductsRequest *productReq;
///< 当前请求
@property (nonatomic, strong) SAApplePayRequest *currentPaymentReq;
@end


@implementation ApplePayManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ApplePayManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

#pragma mark - public methods
- (void)requestPaymentWithOrderNo:(NSString *)orderNo
                        productId:(NSString *)productId
                         quantity:(NSInteger)quantity
                         userInfo:(NSDictionary *_Nullable)userInfo
                       completion:(void (^)(NSInteger rspCode, NSDictionary *userInfo))completion {
    SAApplePayRequest *request = [[SAApplePayRequest alloc] init];
    request.orderNo = orderNo;
    request.productId = productId;
    request.quantity = quantity;
    if (!HDIsObjectNil(userInfo) && userInfo.allKeys.count) {
        request.userInfo = [userInfo copy];
    }
    request.paymentCompletionBlock = completion;
    dispatch_async(self.processQueue ? self.processQueue : dispatch_queue_create("com.superapp.queue.applepay", DISPATCH_QUEUE_SERIAL), ^{
        [self.payments addObject:request];
        HDLog(@"有新的支付请求进来啦,当前队列数:%zd", self.payments.count);
        //        [self checkProductAvailableWithPaymentRequest:request];
        if ([request isEqual:self.payments.firstObject]) {
            [self checkProductAvailableWithPaymentRequest:request];
        }
    });
}

- (void)handleTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                break;
            }
            case SKPaymentTransactionStateDeferred: {
                break;
            }
            case SKPaymentTransactionStateRestored: {
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                [self IAPSuccessActionWithTransaction:transaction];
                break;
            }
            default: { // fail
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                SAApplePayRequest *request = [self findRequestWithOrderNo:transaction.payment.applicationUsername];
                if (!HDIsObjectNil(request)) {
                    [self failResponseWithPaymentRequest:request reason:transaction.error.code];
                }
                break;
            }
        }
    }
}

#pragma mark - private methods
- (void)checkProductAvailableWithPaymentRequest:(SAApplePayRequest *)request {
    self.currentPaymentReq = request;
    self.productReq = nil;
    self.productReq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[request.productId]]];
    self.productReq.delegate = self;
    [self.productReq start];
}

- (void)IAPSuccessActionWithTransaction:(SKPaymentTransaction *)transaction {
    SAApplePayRequest *paymentRequest = [self findRequestWithOrderNo:transaction.payment.applicationUsername];

    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/pay/iap/checkReceipt";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"payOrderNo"] = transaction.payment.applicationUsername;
    params[@"receipt"] = [receipt base64EncodedStringWithOptions:0];

    HDLog(@"params:%@", params);

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if (!HDIsObjectNil(paymentRequest)) {
            [self successResponseWithPaymentRequest:paymentRequest];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        if (!HDIsObjectNil(paymentRequest)) {
            [self failResponseWithPaymentRequest:paymentRequest reason:-1];
        }
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }];
}

- (void)failResponseWithPaymentRequest:(SAApplePayRequest *)request reason:(NSInteger)reason {
    !request.paymentCompletionBlock ?: request.paymentCompletionBlock(reason, request.userInfo);
    [self finishResponseWithRequest:request];
}

- (void)successResponseWithPaymentRequest:(SAApplePayRequest *)request {
    !request.paymentCompletionBlock ?: request.paymentCompletionBlock(0, request.userInfo);
    [self finishResponseWithRequest:request];
}

- (void)finishResponseWithRequest:(SAApplePayRequest *)request {
    self.currentPaymentReq = nil;
    [self.payments removeObject:request];
    // 开始处理下一个
    if (self.payments.count) {
        [self checkProductAvailableWithPaymentRequest:self.payments.firstObject];
    }
}

- (SAApplePayRequest *_Nullable)findRequestWithOrderNo:(NSString *_Nonnull)orderNo {
    NSArray<SAApplePayRequest *> *bingo = [self.payments hd_filterWithBlock:^BOOL(SAApplePayRequest *_Nonnull item) {
        return [item.orderNo isEqualToString:orderNo];
    }];

    if (bingo.count) {
        return bingo.firstObject;
    } else {
        return nil;
    }
}

#pragma mark - SKProductRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for (NSString *unavaliable in response.invalidProductIdentifiers) {
        HDLog(@"不可用的商品:%@", unavaliable);
    }

    for (SKProduct *product in response.products) {
        HDLog(@"可用的商品:%@", product.productIdentifier);
    }

    NSArray<SKProduct *> *bingo = [response.products hd_filterWithBlock:^BOOL(SKProduct *_Nonnull item) {
        return [item.productIdentifier isEqualToString:self.currentPaymentReq.productId];
    }];

    if (bingo.count) {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:response.products.firstObject];
        payment.applicationUsername = self.currentPaymentReq.orderNo;
        payment.quantity = self.currentPaymentReq.quantity;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        [self failResponseWithPaymentRequest:self.currentPaymentReq reason:-5];
    }
}

#pragma mark - lazy load
- (NSMutableArray<SAApplePayRequest *> *)payments {
    if (!_payments) {
        _payments = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _payments;
}

- (NSMutableArray<NSString *> *)availableProducts {
    if (!_availableProducts) {
        _availableProducts = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _availableProducts;
}

@end
