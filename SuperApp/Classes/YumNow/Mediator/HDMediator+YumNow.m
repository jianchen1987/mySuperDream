//
//  HDMediator+YumNow.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+YumNow.h"
#import "SAApolloManager.h"
#import "SAAppEnvManager.h"
#import "SACacheManager.h"


@implementation HDMediator (YumNow)

- (void)navigaveToStoreSearchViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToStoreSearchViewController" params:params];
}

- (void)navigaveToChooseAddressViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToChooseAddressViewController" params:params];
}

- (void)navigaveToStoreListViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"store_list" params:params];
}

- (void)navigaveToStoreDetailViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"storeDetail" params:params];
}

- (void)navigaveToShoppingCartViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToShoppingCartViewController" params:params];
}

- (void)navigaveToAddOrModifyAddressViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToAddOrModifyAddressViewController" params:params];
}

- (void)navigaveToModifyOrderAddressViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToModifyOrderAddressViewController" params:params];
}

- (void)navigaveToChooseAddressMapViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToChooseAddressMapViewController" params:params];
}

- (void)navigaveToOrderSubmitController:(NSDictionary *)params {
    // 已经长时间运行，可以直接切换
    //    NSString *switchKey = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyYumNowOrderSubmit];
    //    if ([switchKey isEqualToString:@"Enable"]) {
    [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitV2Controller" params:params];
    //    } else {
    //        [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitController" params:params];
    //    }
}

- (void)navigaveToOrderSubmitV2Controller:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitV2Controller" params:params];
}

- (void)navigaveToOrderSubmitChooseAddressController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitChooseAddressController" params:params];
}

- (void)navigaveToOrderSubmitChooseCouponController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitChooseCouponController" params:params];
}

- (void)navigaveToOrderDetailViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderDetailViewController" params:params];
}

- (void)navigaveToOrderRefundApplyViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderRefundApplyViewController" params:params];
}

- (void)navigaveToOrderEvaluationViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderEvaluationViewController" params:params];
}

- (void)navigaveToMessageDetailController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToMessageDetailController" params:params];
}

- (void)navigaveToStoreReviewsAndInfoController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToStoreReviewsAndInfoController" params:params];
}

- (void)navigaveToStoreProductDetailController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"storeProductDetail" params:params];
}

- (void)navigaveToStoreProductReviewListController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToStoreProductReviewListController" params:params];
}

- (void)navigaveToMyReviewsViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToMyReviewsViewController" params:params];
}

- (void)navigaveToOrderSubmitWriteNoteViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderSubmitWriteNoteViewController" params:params];
}

- (void)navigaveToProductPackingFeeViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToProductPackingFeeViewController" params:params];
}

- (void)navigaveToOrderRefundDetailViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderRefundDetailViewController" params:params];
}

- (void)navigaveToProductSearchViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToProductSearchViewController" params:params];
}

- (void)navigaveToOrderResultViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderResultViewController" params:params];
}

//- (void)navigationToPayResultViewController:(NSDictionary *)params {
//    [self performTarget:@"YumNow" action:@"navigationToPayResultViewController" params:params];
//}

- (void)navigaveToStoreSortViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"sortActivity" params:params];
}

- (void)navigaveToFeedBackViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToFeedBackViewController" params:params];
}

- (void)navigaveToFeedBackDetailViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToFeedBackDetailViewController" params:params];
}

- (void)navigaveToSubmitFeedBackViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToSubmitFeedBackViewController" params:params];
}

- (void)navigaveToFeedBackHistoryController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToFeedBackHistoryViewController" params:params];
}

- (void)navigaveToFAQViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToFAQViewController" params:params];
}

- (void)navigaveToOrderListViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToOrderListViewController" params:params];
}

- (void)navigaveToThemeViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToThemeViewController" params:params];
}

- (void)navigaveToModifyOrderAddressHistoryViewController:(NSDictionary *)params {
    [self performTarget:@"YumNow" action:@"navigaveToModifyOrderAddressHistoryViewController" params:params];
}

@end
