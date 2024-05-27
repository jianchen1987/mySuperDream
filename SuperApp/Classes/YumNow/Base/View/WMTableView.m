//
//  WMTableView.m
//  SuperApp
//
//  Created by wmz on 2022/3/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMTableView.h"
#import "LKDataRecord.h"
#import "WMStoreModel.h"


@implementation WMTableView

- (void)hd_languageDidChanged {
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.mj_header;
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [head setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];

    MJRefreshAutoNormalFooter *foot = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_NORMAL", @"上拉或者点击加载更多") forState:MJRefreshStateIdle];
    [foot setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
    [foot setTitle:SALocalizedString(@"MJ_STATE_NO_MORE", @"没有更多数据了") forState:MJRefreshStateNoMoreData];
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_RELEASE_TO_LOAD_MORE", @"松开立即加载更多") forState:MJRefreshStatePulling];
}

- (void)setNeedRefreshFooter:(BOOL)needRefreshFooter {
    [super setNeedRefreshFooter:needRefreshFooter];
}

@end
