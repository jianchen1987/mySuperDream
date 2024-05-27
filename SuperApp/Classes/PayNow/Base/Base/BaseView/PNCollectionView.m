//
//  PNCollectionView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNCollectionView.h"
#import "PNMultiLanguageManager.h"


@implementation PNCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.needRecognizeSimultaneously;
}

- (void)hd_languageDidChanged {
    NSLog(@"hd_languageDidChanged");
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.mj_header;
    [head setTitle:PNLocalizedString(@"PN_MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [head setTitle:PNLocalizedString(@"PN_MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [head setTitle:PNLocalizedString(@"PN_MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];

    MJRefreshAutoNormalFooter *foot = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [foot setTitle:PNLocalizedString(@"PN_MJ_STATE_UP_NORMAL", @"上拉或者点击加载更多") forState:MJRefreshStateIdle];
    [foot setTitle:PNLocalizedString(@"PN_MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
    [foot setTitle:PNLocalizedString(@"PN_MJ_STATE_NO_MORE", @"没有更多数据了") forState:MJRefreshStateNoMoreData];
    [foot setTitle:PNLocalizedString(@"PN_MJ_STATE_UP_RELEASE_TO_LOAD_MORE", @"松开立即加载更多") forState:MJRefreshStatePulling];
}

@end
