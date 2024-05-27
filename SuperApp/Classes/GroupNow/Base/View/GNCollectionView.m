//
//  GNCollectionView.m
//  SuperApp
//
//  Created by wmz on 2021/6/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCollectionView.h"


@implementation GNCollectionView

- (void)updateUI {
    UICollectionView *collectionView = self;
    [collectionView reloadData];
}

- (void)reloadNewData:(BOOL)isNoMore {
    [self updateUI];
    if (self.needShowErrorView || self.needShowNoDataView)
        [self hd_removePlaceholderView];
    [self hd_removePlaceholderView];
    if (self.needRefreshFooter) {
        [self.mj_footer resetNoMoreData];
        if (isNoMore) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer endRefreshing];
        }
    }
    if (isNoMore && !self.hd_hasData) {
        self.mj_footer.hidden = YES;
    } else {
        self.mj_footer.hidden = NO;
    }
    if (self.needRefreshHeader && self.mj_header.isRefreshing)
        [self.mj_header endRefreshing];
    [self gnShowOrHideNoDataPlacholderView];
}

- (void)reloadMoreData:(BOOL)isNoMore {
    [self updateUI];
    self.mj_footer.hidden = NO;
    if (self.needShowErrorView || self.needShowNoDataView)
        [self hd_removePlaceholderView];
    [self hd_removePlaceholderView];
    if (self.needRefreshFooter) {
        if (isNoMore && self.mj_footer.isRefreshing) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer endRefreshing];
        }
    }
    [self gnShowOrHideNoDataPlacholderView];
}

- (void)gnFailGetNewData {
    [self updateUI];
    [self gnShowOrHideNetworkErrorPlacholderView];
}

- (void)gnFailLoadMoreData {
    [self updateUI];
    [self gnShowOrHideNetworkErrorPlacholderView];
}

- (void)gnShowOrHideNoDataPlacholderView {
    if (self.needShowNoDataView && !self.hd_hasData) {
        self.mj_header.hidden = self.needRefreshBtn;
        self.mj_footer.hidden = YES;
        self.gnPlaceholderViewModel.title = SALocalizedString(@"no_data", @"暂无数据");
        self.gnPlaceholderViewModel.image = @"no_data_placeholder";
        if (self.customPlaceHolder)
            self.customPlaceHolder(self.gnPlaceholderViewModel, NO);
        [self hd_showPlaceholderViewWithModel:self.gnPlaceholderViewModel];
    } else {
        self.mj_header.hidden = NO;
        self.mj_footer.hidden = NO;
        [self hd_removePlaceholderView];
    }
}

- (void)gnShowOrHideNetworkErrorPlacholderView {
    if (self.needShowErrorView && !self.hd_hasData) {
        self.mj_header.hidden = self.needRefreshBtn;
        self.mj_footer.hidden = YES;
        self.gnPlaceholderViewModel.image = @"placeholder_network_error";
        self.gnPlaceholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
        if (self.customPlaceHolder)
            self.customPlaceHolder(self.gnPlaceholderViewModel, YES);
        [self hd_showPlaceholderViewWithModel:self.gnPlaceholderViewModel];
    } else {
        [self hd_removePlaceholderView];
        self.mj_header.hidden = NO;
        self.mj_footer.hidden = NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.shouldRecognizeSimultaneousl;
}

- (UIViewPlaceholderViewModel *)gnPlaceholderViewModel {
    if (!_gnPlaceholderViewModel) {
        UIViewPlaceholderViewModel *placeholderViewModel = UIViewPlaceholderViewModel.new;
        placeholderViewModel.title = SALocalizedString(@"no_data", @"暂无数据");
        placeholderViewModel.image = @"no_data_placeholder";
        placeholderViewModel.needRefreshBtn = self.needRefreshBtn;
        placeholderViewModel.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
        @HDWeakify(self) placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self) if (self.tappedRefreshBtnHandler) self.tappedRefreshBtnHandler();
        };
        _gnPlaceholderViewModel = placeholderViewModel;
    }
    return _gnPlaceholderViewModel;
}

@end
