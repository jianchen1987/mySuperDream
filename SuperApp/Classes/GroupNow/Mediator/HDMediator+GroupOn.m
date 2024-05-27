//
//  HDMediator+GroupOn.m
//  SuperApp
//
//  Created by wmz on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//
#import "HDMediator+GroupOn.h"


@implementation HDMediator (GroupOn)

- (void)navigaveToGNStoreListViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"store_list" params:params];
}

- (void)navigaveToGNStoreDetailViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"store_detail" params:params];
}

- (void)navigaveToGNStoreSearchViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"store_search" params:params];
}

- (void)navigaveToGNStoreMapViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"store_map" params:params];
}

- (void)navigaveToGNStoreProductViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"product_detail" params:params];
}

- (void)navigaveToGNOrderTakeViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_take" params:params];
}

- (void)navigaveToGNOrderResultViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_result" params:params];
}

- (void)navigaveToGNOrderDetailViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_detail" params:params];
}

- (void)navigaveToGNTopicViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"specialActivity" params:params];
}

- (void)navigaveToGNRefundDetailViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_refund" params:params];
}

- (void)navigaveToGNArticleDetailViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"article_detail" params:params];
}

- (void)navigaveToGNReViewListViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"review_list" params:params];
}

- (void)navigaveToGNOrderCancelViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_cancel" params:params];
}

- (void)navigaveToGNOrderReserveViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"order_reserve" params:params];
}

- (void)navigaveToGNReserveDetailViewController:(NSDictionary *)params {
    [self performTarget:@"GroupOn" action:@"reserve_detail" params:params];
}

@end
