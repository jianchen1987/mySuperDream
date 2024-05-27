//
//  Target_YumNow.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "Target_YumNow.h"
#import "SAAddOrModifyAddressViewController.h"
#import "SAAddressListViewController.h"
#import "SAChooseAddressMapViewController.h"
#import "SAChooseAddressViewController.h"
#import "SAMessageDetailViewController.h"
#import "SAMineViewController.h"
#import "SAWindowManager.h"
#import "WMFAQViewController.h"
#import "WMFeedBackContentViewController.h"
#import "WMFeedBackHistoryViewController.h"
#import "WMFeedBackMainViewController.h"
#import "WMHomeViewController.h"
#import "WMMyReviewsViewController.h"
#import "WMOrderDetailViewController.h"
#import "WMOrderEvaluationViewController.h"
#import "WMOrderModifyAddressHistoryViewController.h"
#import "WMOrderModifyAddressViewController.h"
#import "WMOrderRefundApplyViewController.h"
#import "WMOrderResultController.h"
#import "WMOrderSubmitChooseAddressViewController.h"
#import "WMOrderSubmitChooseCouponViewController.h"
#import "WMOrderSubmitV2ViewController.h"
#import "WMOrderSubmitWriteNoteViewController.h"
#import "WMOrderViewController.h"
#import "WMProductPackingFeeViewController.h"
#import "WMProductSearchViewController.h"
#import "WMRefundDetailViewController.h"
#import "WMSelectCouponsViewController.h"
#import "WMShoppingCartViewController.h"
#import "WMSpecialActivesViewController.h"
#import "WMStoreDetailViewController.h"
#import "WMStoreListViewController.h"
#import "WMStoreProductDetailViewController.h"
#import "WMStoreProductReviewListViewController.h"
#import "WMStoreReviewAndInfoViewController.h"
#import "WMStoreSearchViewController.h"
#import "WMStoreSortViewController.h"
#import "WMTabBarController.h"
#import "WMNewHomeViewController.h"
#import "SAAppSwitchManager.h"


@implementation _Target (YumNow)

- (void)_Action(navigaveToStoreSearchViewController):(NSDictionary *)params {
    WMStoreSearchViewController *vc = [[WMStoreSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToChooseAddressViewController):(NSDictionary *)params {
    SAChooseAddressViewController *vc = [[SAChooseAddressViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(store_list):(NSDictionary *)params {
    if (params[@"tag"] && [params[@"tag"] caseInsensitiveCompare:@"All"] == NSOrderedSame) {
        WMStoreSortViewController *vc = [[WMStoreSortViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeYumNow];
    } else {
        WMStoreListViewController *vc = [[WMStoreListViewController alloc] initWithRouteParameters:params];
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeYumNow];
    }
}

- (void)_Action(storeDetail):(NSDictionary *)params {
    WMStoreDetailViewController *vc = [[WMStoreDetailViewController alloc] initWithRouteParameters:params];
    BOOL notAddBusinessHomePage = [params[@"notAddBusinessHomePage"] boolValue];
    if (notAddBusinessHomePage) {
        [SAWindowManager navigateToViewController:vc parameters:params];
    } else {
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeYumNow];
    }
}

- (void)_Action(navigaveToShoppingCartViewController):(NSDictionary *)params {
    WMShoppingCartViewController *vc = [[WMShoppingCartViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToAddOrModifyAddressViewController):(NSDictionary *)params {
    SAAddOrModifyAddressViewController *vc = [[SAAddOrModifyAddressViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToChooseAddressMapViewController):(NSDictionary *)params {
    SAChooseAddressMapViewController *vc = [[SAChooseAddressMapViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderSubmitV2Controller):(NSDictionary *)params {
    WMOrderSubmitV2ViewController *vc = [[WMOrderSubmitV2ViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderSubmitChooseCouponController):(NSDictionary *)params {
    WMSelectCouponsViewController *vc = [[WMSelectCouponsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderSubmitChooseAddressController):(NSDictionary *)params {
    WMOrderSubmitChooseAddressViewController *vc = [[WMOrderSubmitChooseAddressViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderDetailViewController):(NSDictionary *)params {
    WMOrderDetailViewController *vc = [[WMOrderDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderRefundApplyViewController):(NSDictionary *)params {
    WMOrderRefundApplyViewController *vc = [[WMOrderRefundApplyViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderEvaluationViewController):(NSDictionary *)params {
    WMOrderEvaluationViewController *vc = [[WMOrderEvaluationViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToMessageDetailController):(NSDictionary *)params {
    SAMessageDetailViewController *vc = [[SAMessageDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToStoreReviewsAndInfoController):(NSDictionary *)params {
    WMStoreReviewAndInfoViewController *vc = [[WMStoreReviewAndInfoViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToStoreProductReviewListController):(NSDictionary *)params {
    WMStoreProductReviewListViewController *vc = [[WMStoreProductReviewListViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToMyReviewsViewController):(NSDictionary *)params {
    WMMyReviewsViewController *vc = [[WMMyReviewsViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderSubmitWriteNoteViewController):(NSDictionary *)params {
    WMOrderSubmitWriteNoteViewController *vc = [[WMOrderSubmitWriteNoteViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(storeProductDetail):(NSDictionary *)params {
    WMStoreProductDetailViewController *vc = [[WMStoreProductDetailViewController alloc] initWithRouteParameters:params];
    BOOL isPresent = [[params valueForKey:@"isPresent"] boolValue];
    if (isPresent) {
        [SAWindowManager presentViewController:vc parameters:params];
    } else {
        [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeYumNow];
    }
}

- (void)_Action(navigaveToProductPackingFeeViewController):(NSDictionary *)params {
    WMProductPackingFeeViewController *vc = [[WMProductPackingFeeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderRefundDetailViewController):(NSDictionary *)params {
    WMRefundDetailViewController *vc = [[WMRefundDetailViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(specialActivity):(NSDictionary *)params {
    WMSpecialActivesViewController *vc = [[WMSpecialActivesViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params addBusinessHomePage:SAClientTypeYumNow];
}

- (void)_Action(navigaveToProductSearchViewController):(NSDictionary *)params {
    WMProductSearchViewController *vc = [[WMProductSearchViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderResultViewController):(NSDictionary *)params {
    WMOrderResultController *vc = [[WMOrderResultController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(home):(NSDictionary *)params {
    //    NSString *cryptModel = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewWMPage];
    //    if(HDIsStringNotEmpty(cryptModel) && [cryptModel.lowercaseString isEqualToString:@"on"]) {
    //        WMNewHomeViewController *vc = [[WMNewHomeViewController alloc] initWithRouteParameters:params];
    //        [SAWindowManager navigateToViewController:vc parameters:params];
    //    }else{
    WMHomeViewController *vc = [[WMHomeViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
    //    }
}

- (void)_Action(navigaveToFeedBackViewController):(NSDictionary *)params {
    WMFeedBackMainViewController *vc = [[WMFeedBackMainViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToFeedBackDetailViewController):(NSDictionary *)params {
    WMFeedBackContentViewController *vc = [[WMFeedBackContentViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToSubmitFeedBackViewController):(NSDictionary *)params {
    WMFeedBackContentViewController *vc = [[WMFeedBackContentViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToFeedBackHistoryViewController):(NSDictionary *)params {
    WMFeedBackHistoryViewController *vc = [[WMFeedBackHistoryViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToFAQViewController):(NSDictionary *)params {
    WMFAQViewController *vc = [[WMFAQViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToOrderListViewController):(NSDictionary *)params {
    WMOrderViewController *vc = [[WMOrderViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToModifyOrderAddressViewController):(NSDictionary *)params {
    WMOrderModifyAddressViewController *vc = [[WMOrderModifyAddressViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(navigaveToModifyOrderAddressHistoryViewController):(NSDictionary *)params {
    WMOrderModifyAddressHistoryViewController *vc = [[WMOrderModifyAddressHistoryViewController alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

@end
