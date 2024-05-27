//
//  HDMediator+TinhNow.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+TinhNow.h"


@implementation HDMediator (TinhNow)
- (void)navigaveTinhNowProductDetailViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"productDetails" params:params];
}

- (void)navigaveToTinhNowStoreDetailsPage:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"storeDetails" params:params];
}

- (void)navigaveToTinhNowPostReviewlViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"uploadReview" params:params];
}

- (void)navigaveToTinhNowStoreInfoViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"StoreInfo" params:params];
}

- (void)navigaveToTinhNowOrderSubmitViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"OrderSubmit" params:params];
}

- (void)navigaveToTinhNowOrderDetailsViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"orderDetail" params:params];
}

- (void)navigaveToTinhNowProductReviewDetailsViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"prductReviewDetials" params:params];
}

- (void)navigaveToTinhNowMyReviewsPage:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"myReviews" params:params];
}

- (void)navigaveToTinhNowspecialActivityViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"specialActivity" params:params];
}

- (void)navigaveToTinhNowMyBargainRecordViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"myBargainRecord" params:params];
}

- (void)navigaveToExpressDetails:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"expressDetails" params:params];
}

- (void)navigaveToTinhNowChooseCouponViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"chooseCoupon" params:params];
}

- (void)navigaveToTinhNowApplyRefundViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"applyRefund" params:params];
}

- (void)navigaveToTinhNowRefundDetailViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"refundDetail" params:params];
}

- (void)navigaveToTinhNowTransferViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"transfer" params:params];
}

- (void)navigaveToTinhNowBargainDetailViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"bargainDetail" params:params];
}

- (void)navigaveToTinhNowBargainProductDetailViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"bargainProductDetail" params:params];
}

- (void)navigaveToTinhNowCouponListViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"myCoupon" params:params];
}

- (void)navigaveToTinhNowExpressTrackingViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"expressTracking" params:params];
}

- (void)navigaveToTinhNowDeliveryAreaMapViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"deliveryAreaMap" params:params];
}

- (void)navigaveToTinhNowSupplyAndMarketingShop:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"SupplyAndMarketingShop" params:params];
}

- (void)navigaveToTinhNowProductCenterViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"ProductCenter" params:params];
}

- (void)navigaveToTinhNowSellerSearchViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"SellerSearch" params:params];
}

- (void)navigaveToTinhNowPreIncomeRecordViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"PreIncomeRecord" params:params];
}

- (void)navigaveToTinhNowWithdrawBindViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"WithdrawBind" params:params];
}

- (void)navigaveToTinhNowPictureSearchViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"PictureSearch" params:params];
}
- (void)navigaveTinhNowBargainProductDetailViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"BargainProductDetail" params:params];
}

- (void)navigaveTinhNowContactCustomerServiceViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"contactCustomerService" params:params];
}
- (void)navigaveTinhNowTelegramGroupViewController:(NSDictionary *)params {
    [self performTarget:@"TinhNow" action:@"telegramGroup" params:params];
}
@end
