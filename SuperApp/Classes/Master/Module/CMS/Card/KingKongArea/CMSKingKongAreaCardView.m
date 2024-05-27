//
//  CMSKingKongAreaCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaCardView.h"
#import "CMSKingKongAreaAppGroupView.h"
#import "CMSKingKongAreaItemConfig.h"
#import "HDPopTip.h"
#import "SACMSCacheKeyConst.h"
#import "SACacheManager.h"
#import "SAMultiLanguageManager.h"
#import <HDServiceKit/HDLocationManager.h>

static CGFloat const kPageControlDotSize = 5;
static NSString *const kCMSThrottleWillMoveToWindow = @"cms.home.newFuntionGuide.willMoveToWindow";
static NSString *const kCMSPopViewCallbackKey = @"cms.showKingKongAreaGuideEventKey";


@interface CMSKingKongAreaCardView () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>

@property (nonatomic, strong) HDCyclePagerView *bannerView;   ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;     ///< pageControl
@property (nonatomic, copy) NSArray *dataSource;              ///< 数据源
@property (nonatomic, assign) BOOL isNewFunctionGuideShowing; ///< 新功能提示是否正在显示
@property (nonatomic, assign) NSInteger totalCount;           ///< 只是用来记录总数，防止重复计算
@property (nonatomic, assign) BOOL showTwoRow;                ///< 是否展示两行
@property (nonatomic, assign) BOOL hasTwoIcon;                ///< 是否有两个icon的
@property (nonatomic, copy) void (^showPopTipBlock)(void);    ///< 保留显示蒙层事件，等待用户选择位置权限再显示

@end


@implementation CMSKingKongAreaCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.bannerView];
    [self.containerView addSubview:self.pageControl];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.containerView);
        if (self.showTwoRow) {
            if (self.hasTwoIcon) {
                make.height.mas_equalTo(kCMSCollectionTopCellH + kCMSCollectionCellH + UIEdgeInsetsGetVerticalValue(KCMSCollectionEdgeInsets) + 1 * kCMSCollectionViewLineSpacing);
            } else {
                make.height.mas_equalTo((2 * kCMSCollectionCellH + UIEdgeInsetsGetVerticalValue(KCMSCollectionEdgeInsets) + 1 * kCMSCollectionViewLineSpacing));
            }
        } else {
            make.height.mas_equalTo(kCMSCollectionCellH + UIEdgeInsetsGetVerticalValue(KCMSCollectionEdgeInsets));
        }
        if (self.pageControl.isHidden) {
            make.bottom.equalTo(self.containerView);
        }
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pageControl.isHidden) {
            make.width.centerX.equalTo(self.bannerView);
            make.top.equalTo(self.bannerView.mas_bottom);
            make.height.mas_equalTo(kPageControlDotSize);
            make.bottom.equalTo(self.containerView).offset(-kRealWidth(5));
        }
    }];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.bannerView setNeedClearLayout];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];

    if (newWindow) {
        dispatch_throttle(0.5, kCMSThrottleWillMoveToWindow, ^{
            [self showNewFunctionGuideIsFromDisplayCell:false];
        });
    } else {
        // 非活动，取消事件
        dispatch_throttle_cancel(kCMSThrottleWillMoveToWindow);
        dispatch_throttle_cancel(kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide);
    }
}

#pragma mark - private methods
- (void)reloadData {
    self.bannerView.isInfiniteLoop = self.dataSource.count > 1;
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.bannerView reloadData];

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

/// 展示新功能提示，内部会处理是否该展示的逻辑
/// @param isFromDisplayCell 是否来自展示 cell
- (void)showNewFunctionGuideIsFromDisplayCell:(BOOL)isFromDisplayCell {
    @HDWeakify(self);
    self.showPopTipBlock = ^(void) {
        @HDStrongify(self);

        if (self.isNewFunctionGuideShowing)
            return;

        NSArray<CMSKingKongAreaAppGroupView *> *visibleCells = self.bannerView.collectionView.visibleCells;
        CMSKingKongAreaAppGroupView *cell;
        if (visibleCells.count > 0) {
            cell = visibleCells.firstObject;
        }
        // 换页、正在滚动、所在控制器未显示不处理
        BOOL isCurrentVCDisplaying = self.viewController.hd_isViewLoadedAndVisible;

        if (!cell || self.bannerView.collectionView.isDragging || !isCurrentVCDisplaying)
            return;

        // 判断父 View 是否在滚动
        if ([self.superview isKindOfClass:UIScrollView.class]) {
            UIScrollView *superView = (UIScrollView *)self.superview;
            if (superView.isScrolling) {
                return;
            }

            @HDWeakify(self);
            [superView registerEndScrollinghandler:^{
                @HDStrongify(self);
                [self showNewFunctionGuideIsFromDisplayCell:false];
                return;
            } withKey:@"home_scrollView_endScrolling_key"];
        }

        NSArray<CMSKingKongAreaAppView *> *array = cell.shouldShowGuideViewArray;
        if (!array || array.count <= 0)
            return;

        NSArray<HDPopTipConfig *> *configs = [array mapObjectsUsingBlock:^HDPopTipConfig *_Nonnull(CMSKingKongAreaAppView *_Nonnull obj, NSUInteger idx) {
            HDPopTipConfig *config = [[HDPopTipConfig alloc] init];
            config.text = obj.config.funcGuideDesc;
            config.sourceView = obj.logoImageView;
            config.needDrawMaskImageBackground = true;
            config.autoDismiss = false;
            config.maskImageHeightScale = 0.9;
            config.imageURL = obj.config.imageUrl;
            config.identifier = [NSString stringWithFormat:@"kkarea_%@", obj.config.identifier];
            return config;
        }];
        [HDPopTip showPopTipInView:nil configs:configs onlyInControllerClass:[self.viewController class]];
        self.isNewFunctionGuideShowing = true;
        [HDPopTip setDissmissHandler:^{
            self.isNewFunctionGuideShowing = false;
            @autoreleasepool {
                // 新功能指引消失
                NSArray<CMSKingKongAreaItemConfig *> *oldList = [SACacheManager.shared objectForKey:kCMSCacheKeyKingKongShownGuideNode type:SACacheTypeCachePublic relyLanguage:YES];
                NSArray<CMSKingKongAreaItemConfig *> *showndList = [array mapObjectsUsingBlock:^CMSKingKongAreaItemConfig *_Nonnull(CMSKingKongAreaAppView *_Nonnull obj, NSUInteger idx) {
                    return obj.config;
                }];

                [showndList enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger oldIdx, BOOL *_Nonnull oldStop) {
                    obj.hasDisplayedNewFunctionGuide = true;
                    [oldList enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull oldObj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([oldObj.identifier isEqualToString:obj.identifier]) {
                            oldObj.hasDisplayedNewFunctionGuide = true;
                        }
                    }];
                }];
                // 更新缓存
                [SACacheManager.shared setObject:oldList forKey:kCMSCacheKeyKingKongShownGuideNode type:SACacheTypeDocumentPublic relyLanguage:YES];

                [self reloadData];
            }
        } withKey:kCMSPopViewCallbackKey];
    };

    if (isFromDisplayCell) {
        // 节流的同时做到延时
        dispatch_throttle(1, kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide, self.showPopTipBlock);
    } else {
        dispatch_throttle(0.5, kCMSFunctionThrottleKeyShowKingKongAreaNewFunctionGuide, self.showPopTipBlock);
    }
}

#pragma mark - getters and setters
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    NSString *tintColor = config.getCardContent[@"tintColor"];
    if (HDIsStringNotEmpty(tintColor)) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor hd_colorWithHexString:tintColor];
    }

    self.isNewFunctionGuideShowing = false;
    [self dealWithDataSource];
    [self reloadData];
}
// 处理数据源
- (void)dealWithDataSource {
    NSArray<CMSKingKongAreaItemConfig *> *list = [NSArray yy_modelArrayWithClass:CMSKingKongAreaItemConfig.class json:self.config.getAllNodeContents];
    [list enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        SACMSNode *node = self.config.nodes[idx];
        obj.node = node;
    }];
    // 过滤不能打开的入口
    //    list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CMSKingKongAreaItemConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
    //        return [SAWindowManager canOpenURL:obj.link];
    //    }]];
    if (list && list.count > 0) {
        self.totalCount = list.count;
        NSMutableArray *firstArr = [NSMutableArray array];
        NSMutableArray *secArr = [NSMutableArray array];
        @HDWeakify(self);
        [list enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            @HDStrongify(self);
            if (obj.type == CMSHomeDynamicShowTypeOne) {
                self.hasTwoIcon = true;
                [firstArr addObject:obj];
            } else {
                [secArr addObject:obj];
            }
        }];

        firstArr = [NSMutableArray arrayWithArray:[firstArr hd_splitArrayWithEachCount:2]];
        NSArray *temp4Arr = [secArr hd_splitArrayWithEachCount:kCMSCollectionViewColumn];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (!HDIsArrayEmpty(firstArr)) {
            for (int i = 0; i < firstArr.count; i++) {
                NSMutableArray *kingArr = [NSMutableArray array];
                [kingArr addObject:firstArr[i]];
                if (temp4Arr.count > i) {
                    self.showTwoRow = YES;
                    [kingArr addObjectsFromArray:temp4Arr[i]];
                }
                [dataArray addObjectsFromArray:@[kingArr]];
            }
            if (firstArr.count < temp4Arr.count) {
                NSMutableArray *filArr = [NSMutableArray array];
                for (NSInteger i = firstArr.count; i < temp4Arr.count; i++) {
                    [filArr addObjectsFromArray:temp4Arr[i]];
                }
                NSArray *filSecArr = [filArr hd_splitArrayWithEachCount:kCMSCollectionViewColumn * 2];
                [dataArray addObjectsFromArray:filSecArr];
            }
            _dataSource = dataArray;
        } else {
            self.showTwoRow = self.totalCount > kCMSCollectionViewColumn;
            _dataSource = [list hd_splitArrayWithEachCount:kCMSCollectionViewColumn * 2];
        }
    } else {
        _dataSource = nil;
    }
    [self updateFuncGuideStateWithList:list];
}
// 更新功能引导标识
- (void)updateFuncGuideStateWithList:(NSArray<CMSKingKongAreaItemConfig *> *)list {
    // 已经展示过功能引导的节点
    NSArray<CMSKingKongAreaItemConfig *> *shownGuideConfigs = [SACacheManager.shared objectForKey:kCMSCacheKeyKingKongShownGuideNode type:SACacheTypeDocumentPublic relyLanguage:YES];
    if (!shownGuideConfigs || shownGuideConfigs.count <= 0) {
        [list enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            // 没配文字不显示
            obj.hasUpdated = HDIsStringNotEmpty(obj.funcGuideDesc);
        }];
    } else {
        NSArray<NSString *> *identifiers = [list mapObjectsUsingBlock:^id _Nonnull(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx) {
            return obj.identifier;
        }];
        [list enumerateObjectsUsingBlock:^(CMSKingKongAreaItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (![identifiers containsObject:obj.identifier]) {
                obj.hasUpdated = HDIsStringNotEmpty(obj.funcGuideDesc);
            } else {
                NSArray<CMSKingKongAreaItemConfig *> *filtered = [shownGuideConfigs hd_filterWithBlock:^BOOL(CMSKingKongAreaItemConfig *_Nonnull item) {
                    return [item.identifier isEqualToString:obj.identifier];
                }];
                CMSKingKongAreaItemConfig *lastShownConfig = filtered.lastObject;
                if (lastShownConfig) {
                    if (lastShownConfig.hasDisplayedNewFunctionGuide) {
                        BOOL hasUpdated = HDIsStringNotEmpty(obj.funcGuideDesc) && obj.funcGuideVersion > lastShownConfig.funcGuideVersion;
                        obj.hasUpdated = hasUpdated;
                        obj.hasDisplayedNewFunctionGuide = !hasUpdated;
                    } else {
                        // 没显示过
                        obj.hasUpdated = HDIsStringNotEmpty(obj.funcGuideDesc);
                    }
                }
            }
        }];
    }
    [SACacheManager.shared setObject:list forKey:kCMSCacheKeyKingKongShownGuideNode type:SACacheTypeDocumentPublic relyLanguage:YES];
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CMSKingKongAreaAppGroupView *cell = [CMSKingKongAreaAppGroupView cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    NSArray *singlePageDataSource = self.dataSource[index];
    cell.dataSource = singlePageDataSource;
    @HDWeakify(self);
    cell.clickKingKongArea = ^(SACMSNode *_Nonnull node, NSString *_Nonnull link, NSUInteger idx) {
        @HDStrongify(self);
        !self.clickNode ?: self.clickNode(self, node, link, [NSString stringWithFormat:@"node@%zd", index * 8 + idx]);
    };
    return cell;
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = CGRectGetWidth(pageView.frame);
    const CGFloat height = CGRectGetHeight(pageView.frame);
    layout.itemSize = CGSizeMake(width, height);
    return layout;
}

#pragma mark - HDCyclePagerViewDelegate
- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

- (void)pagerView:(HDCyclePagerView *)pageView willDisplayCell:(__kindof CMSKingKongAreaAppGroupView *)cell atIndexSection:(HDIndexSection)indexSection {
    if (indexSection.index == 0) {
        [self showNewFunctionGuideIsFromDisplayCell:true];
    }
}

- (void)pagerViewDidScroll:(HDCyclePagerView *)pageView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(pagerViewDidEndScrollingAnimation:) withObject:pageView afterDelay:0.1];
}

// 滚动结束
- (void)pagerViewDidEndScrollingAnimation:(HDCyclePagerView *)pageView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self showNewFunctionGuideIsFromDisplayCell:false];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    if (self.showTwoRow) {
        height += (2 * kCMSCollectionCellH + UIEdgeInsetsGetVerticalValue(KCMSCollectionEdgeInsets) + 1 * kCMSCollectionViewLineSpacing);
    } else {
        height += kCMSCollectionCellH + UIEdgeInsetsGetVerticalValue(KCMSCollectionEdgeInsets);
    }

    if (!self.pageControl.isHidden) {
        height += kRealWidth(5) + kPageControlDotSize;
    }
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kPageControlDotSize * 3, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize * 2, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.color.C1;
        _pageControl.pageIndicatorTintColor = HDAppTheme.color.G4;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end
