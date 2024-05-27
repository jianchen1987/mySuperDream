//
//  Target_GroupOn.m
//  SuperApp
//
//  Created by wmz on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "Target_GroupOn.h"
#import "GNViewController.h"
#import "SAWindowManager.h"


@implementation _Target (GroupOn)

- (void)_Action(store_list):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNSortViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(store_detail):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNStoreDetailViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(store_search):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNSearchViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_take):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNSubmitOrderViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(store_map):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNStoreMapViewContoller") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(product_detail):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNStoreProductHomeController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_result):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNOrderResultViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_detail):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNOrderDetailViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(specialActivity):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNTopicViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_refund):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNRefundDeailController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(article_detail):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNArticleDetailViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(review_list):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNReviewsViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_cancel):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNOrderCancelViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(order_reserve):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNReserveViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

- (void)_Action(reserve_detail):(NSDictionary *)params {
    GNViewController *vc = [[NSClassFromString(@"GNReserveDetailViewController") alloc] initWithRouteParameters:params];
    [SAWindowManager navigateToViewController:vc parameters:params];
}

@end
