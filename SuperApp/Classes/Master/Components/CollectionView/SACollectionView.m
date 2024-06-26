//
//  SACollectionView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACollectionView.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UICollectionView+HDKitCore.h>


@implementation SACollectionView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = UIColor.whiteColor;

    // 以下三项是适配iOS 11刷新时会漂移的情况
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;

    // 默认
    self.needRefreshHeader = false;
    self.needRefreshFooter = false;
    self.needShowNoDataView = YES;
    self.needShowErrorView = YES;

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        self.automaticallyAdjustsScrollIndicatorInsets = false;
    }

    if (self.mj_footer) {
        self.mj_footer.hidden = YES;
    }

    [self hd_languageDidChanged];

    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)getNewData {
    if (_needRefreshHeader) {
        // 如果当前正在刷新，结束刷新
        BOOL isRefreshing = self.mj_header.state == MJRefreshStateRefreshing;
        if (isRefreshing) {
            [self.mj_header endRefreshing];
            [self.mj_header beginRefreshing];
        } else {
            [self.mj_header beginRefreshing];
        }
    }
}

#pragma mark - Network
- (void)requestNewData {
    if (_needRefreshFooter) {
        if (self.mj_footer.isRefreshing) {
            [self.mj_footer endRefreshing];
        }
    }

    if (_needRefreshFooter) {
        self.mj_footer.hidden = YES;
    }

    if (self.requestNewDataHandler) {
        self.requestNewDataHandler();
    }
}

- (void)loadMoreData {
    if (_needRefreshHeader) {
        if (self.mj_header.isRefreshing) {
            [self.mj_header endRefreshing];
        }
    }

    if (self.requestMoreDataHandler) {
        self.requestMoreDataHandler();
    }
}

- (void)successGetNewDataWithNoMoreData:(BOOL)isNoMore scrollToTop:(BOOL)isScrollToTop {
    [self reloadData];

    if (isScrollToTop) {
        [self setContentOffset:CGPointMake(0.0, -self.contentInset.top) animated:true];
    }

    if (_needRefreshFooter) {
        [self.mj_footer resetNoMoreData];

        if (isNoMore) {
            self.mj_footer.hidden = YES;
        } else {
            self.mj_footer.hidden = NO;
        }
    }

    if (_needRefreshHeader) {
        if (self.mj_header.isRefreshing) {
            [self.mj_header endRefreshing];
        }
    }

    [self showOrHideNoDataPlacholderView];
}

- (void)successGetNewDataWithNoMoreData:(BOOL)isNoMore {
    [self successGetNewDataWithNoMoreData:isNoMore scrollToTop:YES];
}

- (void)successLoadMoreDataWithNoMoreData:(BOOL)isNoMore {
    [self reloadData];

    if (_needRefreshFooter) {
        if (isNoMore) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer endRefreshing];
        }
    }

    [self showOrHideNoDataPlacholderView];
}

- (void)failGetNewData {
    [self setContentOffset:CGPointMake(0.0, -self.contentInset.top) animated:true];

    if (_needRefreshHeader) {
        [self.mj_header endRefreshing];
    }
    [self reloadData];

    [self showOrHideNetworkErrorPlacholderView];
}

- (void)failLoadMoreData {
    if (_needRefreshFooter) {
        [self.mj_footer endRefreshing];
    }

    [self showOrHideNetworkErrorPlacholderView];
}

#pragma mark - private methods
- (void)showOrHideNoDataPlacholderView {
    if (self.needShowNoDataView && !self.hd_hasData) {
        UIViewPlaceholderViewModel *model = self.placeholderViewModel ?: [[UIViewPlaceholderViewModel alloc] init];
        if (!self.placeholderViewModel) {
            model.title = SALocalizedString(@"no_data", @"暂无数据");
            model.image = @"no_data_placeholder";
            model.needRefreshBtn = self.needRefreshHeader;
            model.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
        }
        [self hd_showPlaceholderViewWithModel:model];
        __weak __typeof(self) weakSelf = self;
        self.hd_tappedRefreshBtnHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.needRefreshHeader) {
                [strongSelf getNewData];
            }
            !strongSelf.tappedRefreshBtnHandler ?: strongSelf.tappedRefreshBtnHandler();
        };
        [self hd_showPlaceholderViewWithModel:model];
    } else {
        [self hd_removePlaceholderView];
    }
}

- (void)showOrHideNetworkErrorPlacholderView {
    HDLog(@"hd_hasData==%d", self.hd_hasData);
    HDLog(@"needShowErrorView==%d", self.needShowErrorView);
    HDLog(@"CGRectIsValidated==%d", CGRectIsValidated(self.frame));
    HDLog(@"CGRectIsEmpty==%d", CGRectIsEmpty(self.frame));
    if (self.needShowErrorView && !self.hd_hasData && CGRectIsValidated(self.frame) && !CGRectIsEmpty(self.frame)) {
        UIViewPlaceholderViewModel *model = self.placeholderViewModel ?: [[UIViewPlaceholderViewModel alloc] init];
        if (!self.placeholderViewModel) {
            model.image = @"placeholder_network_error";
            model.title = SALocalizedString(@"network_error", @"网络开小差啦");
            model.needRefreshBtn = self.needRefreshHeader;
        }
        [self hd_showPlaceholderViewWithModel:model];
        __weak __typeof(self) weakSelf = self;
        self.hd_tappedRefreshBtnHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.needRefreshHeader) {
                [strongSelf getNewData];
            }
            !strongSelf.tappedRefreshBtnHandler ?: strongSelf.tappedRefreshBtnHandler();
        };
    } else {
        [self hd_removePlaceholderView];
    }
}

/**
 同时识别多个手势

 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.mj_header;
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [head setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];

    MJRefreshAutoNormalFooter *foot = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_NORMAL", @"上拉或者点击加载更多") forState:MJRefreshStateIdle];
    [foot setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
    [foot setTitle:SALocalizedString(@"MJ_STATE_NO_MORE", @"没有更多数据了") forState:MJRefreshStateNoMoreData];
    [foot setTitle:SALocalizedString(@"MJ_STATE_UP_RELEASE_TO_LOAD_MORE", @"松开立即加载更多") forState:MJRefreshStatePulling];
}

#pragma mark - getters and setters
- (void)setNeedRefreshHeader:(BOOL)needRefreshHeader {
    _needRefreshHeader = needRefreshHeader;

    if (!needRefreshHeader) {
        [self.mj_header removeFromSuperview];
    } else {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;

        [self hd_languageDidChanged];
    }
}

- (void)setNeedRefreshFooter:(BOOL)needRefreshFooter {
    _needRefreshFooter = needRefreshFooter;
    if (!needRefreshFooter) {
        [self.mj_footer removeFromSuperview];
    } else {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self hd_languageDidChanged];
    }
}
@end
