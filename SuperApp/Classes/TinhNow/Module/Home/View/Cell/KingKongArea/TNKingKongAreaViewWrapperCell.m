//
//  TNKingKongAreaViewWrapperCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNKingKongAreaViewWrapperCell.h"
#import "HDPopTip.h"
#import "SAAppFunctionModel.h"
#import "SACacheManager.h"
#import "SAKingKongAreaItemConfig.h"
#import "SANotificationConst.h"
#import "SAWindowManager.h"
#import "TNKingKongAreaAppGroupView.h"
#import <HDServiceKit/HDLocationManager.h>

static CGFloat const kPageControlDotSize = 4;
static NSString *const kTNhrottleWillMoveToWindow = @"tinhnow.home.newFuntionGuide.willMoveToWindow";
static NSString *const kTNPopViewCallbackKey = @"tinhnow.showKingKongAreaGuideEventKey";


@interface TNKingKongAreaViewWrapperCellModel ()
@property (nonatomic, copy) NSArray *dataSource;    ///< 数据源
@property (nonatomic, assign) NSInteger totalCount; ///< 只是用来记录总数，防止重复计算
@end


@implementation TNKingKongAreaViewWrapperCellModel
- (NSArray *)dataSource {
    if (!_dataSource) {
        NSArray<SAKingKongAreaItemConfig *> *list = [SACacheManager.shared objectForKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];

        // 过滤不能打开的入口
        list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SAKingKongAreaItemConfig *_Nullable obj, NSDictionary<NSString *, id> *_Nullable bindings) {
                         return [SAWindowManager canOpenURL:obj.url];
                     }]];
        if (list && list.count > 0) {
            // 排序
            list = [list sortedArrayUsingComparator:^NSComparisonResult(SAKingKongAreaItemConfig *_Nonnull obj1, SAKingKongAreaItemConfig *_Nonnull obj2) {
                return obj1.index > obj2.index;
            }];

            self.totalCount = list.count;

            _dataSource = [list hd_splitArrayWithEachCount:kCollectionViewColumn * 2];
        }
    }
    return _dataSource;
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    if (self.dataSource.count > 0) {
        if (self.totalCount > kCollectionViewColumn) {
            height = 2 * kCollectionCellH + UIEdgeInsetsGetVerticalValue(KCollectionEdgeInsets) + 1 * kCollectionViewLineSpacing;
        } else {
            height = kCollectionCellH + UIEdgeInsetsGetVerticalValue(KCollectionEdgeInsets);
        }
    }
    return height;
}
@end


@interface TNKingKongAreaViewWrapperCell () <HDCyclePagerViewDataSource, HDCyclePagerViewDelegate>
@property (nonatomic, strong) HDCyclePagerView *bannerView; ///< 轮播图
@property (nonatomic, strong) HDPageControl *pageControl;   ///< pageControl

@property (nonatomic, assign) BOOL isNewFunctionGuideShowing; ///< 新功能提示是否正在显示

@property (nonatomic, copy) void (^showPopTipBlock)(void); ///< 保留显示蒙层事件，等待用户选择位置权限再显示

@property (nonatomic, strong) TNKingKongAreaViewWrapperCellModel *oldModel; ///< 旧模型 限制relod次数
@end


@implementation TNKingKongAreaViewWrapperCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.pageControl];

    // 注册金刚区变化通知
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appSuccessGetAppHomeDynamicFunctionList) name:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSuccessGetTinhNowAppHomeDynamicFunctionList object:nil];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.height.mas_equalTo(self.model.cellHeight);
        make.bottom.equalTo(self.contentView);
    }];

    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.pageControl.isHidden) {
            make.width.centerX.equalTo(self.bannerView);
            make.height.mas_equalTo(kPageControlDotSize);
            make.bottom.equalTo(self.bannerView.mas_bottom).offset(-kRealWidth(5));
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
        dispatch_throttle(0.5, kTNhrottleWillMoveToWindow, ^{
            [self showNewFunctionGuideIsFromDisplayCell:false];
        });
    } else {
        // 非活动，取消事件
        dispatch_throttle_cancel(kTNhrottleWillMoveToWindow);
        dispatch_throttle_cancel(kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide);
    }
}

#pragma mark - Notification
- (void)appSuccessGetAppHomeDynamicFunctionList {
    HDLog(@"获取金刚区配置成功");
    [self reloadData];
}

#pragma mark - private methods
- (void)reloadData {
    // 生成轮播数据源
    self.model.dataSource = nil;
    [self.pageControl setHidden:!(self.model.totalCount > kCollectionViewColumn * 2)];
    self.bannerView.isInfiniteLoop = self.model.dataSource.count > 1;
    self.pageControl.numberOfPages = self.model.dataSource.count;
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

        BOOL isLocalFunction = true;
        if (self.model.dataSource.count > 0) {
            NSArray *subAray = self.model.dataSource.firstObject;
            if ([subAray isKindOfClass:NSArray.class] && subAray.count > 0) {
                isLocalFunction = [subAray.firstObject isKindOfClass:SAAppFunctionModel.class];
            }
        }
        if (isLocalFunction || self.isNewFunctionGuideShowing)
            return;

        NSArray<TNKingKongAreaAppGroupView *> *visibleCells = self.bannerView.collectionView.visibleCells;
        TNKingKongAreaAppGroupView *cell;
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

        NSArray<TNKingKongAreaAppView *> *array = cell.shouldShowGuideViewArray;
        if (!array || array.count <= 0)
            return;

        NSArray<HDPopTipConfig *> *configs = [array mapObjectsUsingBlock:^HDPopTipConfig *_Nonnull(TNKingKongAreaAppView *_Nonnull obj, NSUInteger idx) {
            HDPopTipConfig *config = [[HDPopTipConfig alloc] init];
            config.text = obj.config.guideDesc.desc;
            config.sourceView = obj.logoImageView;
            config.needDrawMaskImageBackground = true;
            config.autoDismiss = false;
            config.maskImageHeightScale = 0.9;
            config.imageURL = obj.config.iconURL;
            config.identifier = [NSString stringWithFormat:@"kkarea_%@", obj.config.identifier];
            return config;
        }];
        [HDPopTip showPopTipInView:nil configs:configs onlyInControllerClass:[self.viewController class]];
        self.isNewFunctionGuideShowing = true;
        [HDPopTip setDissmissHandler:^{
            self.isNewFunctionGuideShowing = false;
            @autoreleasepool {
                // 新功能指引消失
                NSArray<SAKingKongAreaItemConfig *> *oldList = [SACacheManager.shared objectForKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeCachePublic relyLanguage:YES];
                NSArray<SAKingKongAreaItemConfig *> *showndList = [array mapObjectsUsingBlock:^SAKingKongAreaItemConfig *_Nonnull(TNKingKongAreaAppView *_Nonnull obj, NSUInteger idx) {
                    return obj.config;
                }];

                [showndList enumerateObjectsUsingBlock:^(SAKingKongAreaItemConfig *_Nonnull obj, NSUInteger oldIdx, BOOL *_Nonnull oldStop) {
                    [oldList enumerateObjectsUsingBlock:^(SAKingKongAreaItemConfig *_Nonnull oldObj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([oldObj.identifier isEqualToString:obj.identifier]) {
                            oldObj.hasDisplayedNewFunctionGuide = true;
                        }
                    }];
                }];
                // 更新缓存
                [SACacheManager.shared setObject:oldList forKey:kCacheKeyTinhNowAppHomeDynamicFunctionList type:SACacheTypeDocumentPublic relyLanguage:YES];

                [self reloadData];
            }
        } withKey:kTNPopViewCallbackKey];
    };

    // 判断用户是否已经处理过位置权限获取
    BOOL hasUserGotLocationPermission = HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusAuthed;
    if (hasUserGotLocationPermission) {
        if (isFromDisplayCell) {
            // 节流的同时做到延时
            dispatch_throttle(1, kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide, self.showPopTipBlock);
        } else {
            dispatch_throttle(0.5, kTNFunctionThrottleKeyShowKingKongAreaNewFunctionGuide, self.showPopTipBlock);
        }
    } else {
        // 监听位置权限变化
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];
    }
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        !self.showPopTipBlock ?: self.showPopTipBlock();
    }
}

#pragma mark - getters and setters
- (void)setModel:(TNKingKongAreaViewWrapperCellModel *)model {
    _model = model;

    // 可能当前正在展示的时候被外部刷新数据，导致新功能引导的 superView (cell) 为 nil
    // 导致位置计算不正确，此时 isNewFunctionGuideShowing 未置否，这里手动置否
    self.isNewFunctionGuideShowing = false;
    if (HDIsObjectNil(self.oldModel) || ![self.oldModel.dataSource isEqualToArray:model.dataSource]) {
        [self reloadData];
        self.oldModel = model;
    }
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.model.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TNKingKongAreaAppGroupView *cell = [TNKingKongAreaAppGroupView cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    __weak __typeof(self) weakSelf = self;
    cell.canNotOpenRouteHandler = ^(NSString *_Nonnull urlString) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        !strongSelf.canNotOpenRouteHandler ?: strongSelf.canNotOpenRouteHandler(urlString);
    };
    NSArray *singlePageDataSource = self.model.dataSource[index];
    cell.dataSource = singlePageDataSource;
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

- (void)pagerView:(HDCyclePagerView *)pageView willDisplayCell:(__kindof TNKingKongAreaAppGroupView *)cell atIndexSection:(HDIndexSection)indexSection {
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

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bannerView;
}

- (HDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[HDPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(kPageControlDotSize * 3, kPageControlDotSize);
        _pageControl.pageIndicatorSize = CGSizeMake(kPageControlDotSize * 2, kPageControlDotSize);
        _pageControl.currentPageIndicatorTintColor = HDAppTheme.TinhNowColor.C1;
        _pageControl.pageIndicatorTintColor = HDAppTheme.color.G4;
        _pageControl.hidesForSinglePage = true;
    }
    return _pageControl;
}

@end
