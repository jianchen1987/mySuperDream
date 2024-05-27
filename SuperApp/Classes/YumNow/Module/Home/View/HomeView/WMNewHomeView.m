//
//  WMNewHomeView.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewHomeView.h"
#import "LKDataRecord.h"
#import "SACacheManager.h"
#import "SANoDataCell.h"
#import "SATabBar.h"
#import "SATabBarController.h"
#import "SATableViewViewMoreView.h"
#import "UITableView+RecordData.h"
#import "WMCardTableViewCell.h"
#import "WMNewFreeDeleviryStoreListView.h"
#import "WMHomeCustomViewModel.h"
#import "WMHomeGuideView.h"
#import "WMNewHomeMenuGroundView.h"
#import "WMHomeTipView.h"
#import "WMNewHomeViewModel.h"
#import "WMLocationTipView.h"
#import "WMStoreCell.h"
#import "WMStoreSkeletonCell.h"
#import "WMTabBarController.h"
#import "WMZPageView.h"
#import "WMNewHomeSearchView.h"
#import "WMNewHomeStoreListView.h"
#import "WMLocationChangeTipView.h"


@interface WMNewHomeView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) WMNewHomeViewModel *viewModel;
/// VM
@property (nonatomic, strong) WMHomeCustomViewModel *customViewModel;
/// 头部菜单
@property (nonatomic, strong) WMNewHomeMenuGroundView *menuGroundView;
/// 默认数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 提示
@property (nonatomic, strong) WMHomeTipView *tipView;

@property (strong, nonatomic) WMNewHomeSearchView *headView;
///指示视图
@property (strong, nonatomic) WMHomeGuideView *guideView;
/// 定位失败提示
@property (strong, nonatomic) WMLocationTipView *locationTip;
///指示视图
@property (strong, nonatomic) WMZPageView *pageView;
/// 定位改变提示
@property (strong, nonatomic) WMLocationChangeTipView *locationChangeTip;

@end


@implementation WMNewHomeView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.menuGroundView];
    [self addSubview:self.tipView];
    [self addSubview:self.guideView];
    [self addSubview:self.locationTip];
    [self addSubview:self.locationChangeTip];
    self.menuGroundView.scrollViewDelegate = self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self layoutIfNeeded];
        [self insertSubview:self.pageView belowSubview:self.menuGroundView];
        self.pageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kiPhoneXSeriesSafeBottomHeight + [HDHelper hd_tabBarHeight]));
    }
}

- (void)hd_bindViewModel {
    self.dataSource = self.viewModel.dataSource;
    [self.tableView reloadData];
    self.customViewModel.view = self;

    @HDWeakify(self);
    [self.KVOController hd_observe:self.customViewModel keyPath:@"noticeModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.customViewModel.noticeModel) {
            [self.noticeView removeFromSuperview];
            self.noticeView = WMHomeNoticeTipView.new;
            [self addSubview:self.noticeView];
            [self.noticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-kRealWidth(15));
                make.left.mas_equalTo(kRealWidth(15));
                //                                         make.top.mas_equalTo(kRealWidth(44));
                make.top.mas_equalTo(kStatusBarH);
            }];
            self.noticeView.model = self.customViewModel.noticeModel;
            @HDWeakify(self) self.noticeView.eventHandClose = ^(BOOL handClose) {
                @HDStrongify(self)[self.customViewModel reSaveNoticeArray];
            };
            [self.noticeView show];
            NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
            if (self.customViewModel.noticeModel.showTime) {
                if (currentTime - self.customViewModel.noticeModel.showTime < 10) {
                    [self.noticeView performSelector:NSSelectorFromString(@"dissmiss") withObject:nil afterDelay:MAX(2, currentTime - self.customViewModel.noticeModel.showTime)];
                } else {
                    [self.noticeView performSelector:NSSelectorFromString(@"dissmiss") withObject:nil afterDelay:10];
                }
            } else {
                [self.noticeView performSelector:NSSelectorFromString(@"dissmiss") withObject:nil afterDelay:10];
            }
        }
    }];

    //    [self.KVOController hd_observe:self.tableView.mj_footer
    //                           keyPath:@"state"
    //                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
    //                                 @HDStrongify(self);
    //                                 if (self.tableView.mj_footer.state != MJRefreshStateRefreshing) {
    //                                     [self.guideView performSelector:@selector(show) withObject:nil afterDelay:1];
    //                                 }
    //                             }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView.mj_header endRefreshing];
        self.dataSource = self.viewModel.dataSource;
        [self.tableView reloadData];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"tipViewStyle" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMHomeTipViewStyle tipViewStyle = [change[NSKeyValueChangeNewKey] integerValue];
        self.tipView.hidden = tipViewStyle == WMHomeTipViewStyleDisapper;
        if (!self.tipView.isHidden) {
            [self.tipView updateUIForStyle:tipViewStyle];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"locationFailFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL locationFailFlag = [change[NSKeyValueChangeNewKey] boolValue];
        if (locationFailFlag) {
            [self.locationTip show];
        } else {
            [self.locationTip dissmiss];
        }
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"columnFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.pageView.param.wTitleArr = self.viewModel.columnArray;
        [self.pageView updateMenuData];
        self.pageView.downSc.dataSource = self;
        self.pageView.downSc.delegate = self;
        self.pageView.downSc.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
        self.pageView.downSc.scrollEnabled = YES;
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"locationChangeFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        [self.locationChangeTip show];
        //五秒过后自动隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationChangeTip dissmiss];
        });
    }];
}

- (void)hd_languageDidChanged {
    [self setNeedsUpdateConstraints];
    self.viewModel.isChangeLanguage = YES;
}

- (void)updateConstraints {
    [self.menuGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.top.equalTo(self.menuGroundView.mas_bottom);
    }];

    //    [self.searchBtn sizeToFit];
    //    [self.searchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(-kRealWidth(15));
    //        make.centerY.equalTo(self.searchBar);
    //        make.size.mas_equalTo(self.searchBtn.bounds.size);
    //    }];
    //
    //    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(0);
    //        make.bottom.mas_equalTo(-kRealWidth(15));
    //        make.top.mas_equalTo(kRealWidth(10));
    //        make.height.mas_equalTo(kRealWidth(40));
    //        make.right.equalTo(self.searchBtn.mas_left);
    //    }];

    [self.guideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(3));
        make.bottom.mas_equalTo(-kRealWidth(99));
    }];

    [self.locationTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(15));
        make.left.mas_equalTo(kRealWidth(15));
        make.top.equalTo(self.menuGroundView.mas_bottom).offset(-kRealWidth(10));
    }];

    [self.locationChangeTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.menuGroundView.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageView performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    ///新手指引
    if (self.guideView.isShow && scrollView.contentOffset.y >= 0)
        [self.guideView dissmiss];
    [self.menuGroundView refreshUIWithOffsetY:scrollView.contentOffset.y completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return 0;
    return self.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:WMHomeLayoutModel.class]) {
        ///阿波罗配置布局
        WMHomeLayoutModel *itemModel = (WMHomeLayoutModel *)model;
        WMCardTableViewCell *cell = [itemModel.cellClass cellWithTableView:tableView];
        ///对应的数据源
        [cell setGNModel:itemModel.dataSource];
        ///配置
        cell.layoutModel = itemModel;
        @HDWeakify(tableView);
        cell.refreshCell = ^{
            @HDStrongify(tableView);
            [tableView reloadData];
        };
        @HDWeakify(self);
        @HDWeakify(cell);
        cell.changeDataCell = ^(WMHomeLayoutModel *_Nonnull layoutModel) {
            @HDStrongify(self);
            @HDStrongify(cell);
            @HDWeakify(self);
            @HDWeakify(cell);
            if ([layoutModel.identity isEqualToString:WMHomeLayoutTypeKingKong]) {
                [self.tableView beginUpdates];
                [cell setNeedsUpdateConstraints];
                [self.tableView endUpdates];
            } else {
                [self.viewModel reloadDataWithLayoutModel:model completion:^(id _Nonnull rspModel, BOOL result) {
                    if (result) {
                        @HDStrongify(self);
                        @HDStrongify(cell);
                        if ([cell.collectionView isKindOfClass:WMHomeCollectionView.class]) {
                            WMHomeCollectionView *view = (WMHomeCollectionView *)cell.collectionView;
                            [view scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                        }
                        [self.tableView reloadData];
                    }
                }];
            }
        };
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tableView.mj_footer.state != MJRefreshStateRefreshing && !self.guideView.isShow) {
        [self.guideView performSelector:@selector(show) withObject:nil afterDelay:1];
    }
}

#pragma mark - event response
- (void)clickedSearchViewHandler {
    [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"SEARCH"} SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];

    [HDMediator.sharedInstance navigaveToStoreSearchViewController:@{}];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    if ([event.key isEqualToString:@"clickSearchAction"]) {
        [self clickedSearchViewHandler];
    }
}

#pragma mark - lazy load
- (WMNewHomeMenuGroundView *)menuGroundView {
    if (!_menuGroundView) {
        _menuGroundView = [[WMNewHomeMenuGroundView alloc] initWithViewModel:self.viewModel];
        _menuGroundView.scrollViewMaxOffsetY = 44;
    }
    return _menuGroundView;
}


- (WMHomeTipView *)tipView {
    if (!_tipView) {
        _tipView = WMHomeTipView.new;
        _tipView.hidden = true;
    }
    return _tipView;
}

- (WMNewHomeSearchView *)headView {
    if (!_headView) {
        _headView = [[WMNewHomeSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        @HDWeakify(self);
        _headView.searchClick = ^{
            @HDStrongify(self);
            [self clickedSearchViewHandler];
        };
    }
    return _headView;
}

- (WMHomeGuideView *)guideView {
    if (!_guideView) {
        _guideView = WMHomeGuideView.new;
    }
    return _guideView;
}

- (WMLocationTipView *)locationTip {
    if (!_locationTip) {
        _locationTip = WMLocationTipView.new;
        _locationTip.hidden = YES;
    }
    return _locationTip;
}

- (WMHomeCustomViewModel *)customViewModel {
    if (!_customViewModel) {
        _customViewModel = WMHomeCustomViewModel.new;
    }
    return _customViewModel;
}

- (WMLocationChangeTipView *)locationChangeTip {
    if (!_locationChangeTip) {
        _locationChangeTip = WMLocationChangeTipView.new;
        _locationChangeTip.hidden = YES;
        @HDWeakify(self);
        _locationChangeTip.relocationBlock = ^{
            @HDStrongify(self);
            [self.locationChangeTip dissmiss];
            !self.relocationBlock ?: self.relocationBlock();
        };
    }
    return _locationChangeTip;
}

- (WMZPageView *)pageView {
    if (!_pageView) {
        @HDWeakify(self);
        WMZPageParam *param = WMZPageParam.new;
        param.wLazyLoading = YES;
        param.wMenuIndicatorWidth = kRealWidth(28);
        param.wMenuIndicatorHeight = kRealWidth(3);
        param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
            @HDStrongify(self);
            [self.menuGroundView layoutIfNeeded];
            return kNavigationBarH;
        };
        param.wCustomTabbarY = ^CGFloat(CGFloat nowY) {
            return 0;
        };
        param.wMenuIndicatorYSet(kRealWidth(10));
        param.wMenuHeadView = ^UIView *_Nullable {
            @HDStrongify(self);
            return self.headView;
        };
        param.wCustomMenuTitle = ^(NSArray<WMZPageNaviBtn *> *_Nullable titleArr) {
            [titleArr enumerateObjectsUsingBlock:^(WMZPageNaviBtn *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                obj.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), 0, 0, 0);
            }];
        };
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            param.wMenuTitleWidth = kScreenWidth / 4.0;
        }
        param.wMenuHeightSet(kRealWidth(51));
        param.wTopChangeHeightSet(0.1);
        param.wMenuTitleUIFontSet([HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightRegular]);
        param.wMenuTitleSelectUIFontSet([HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightBold]);
        param.wMenuTitleColorSet(HDAppTheme.WMColor.B9);
        param.wMenuTitleSelectColorSet(HDAppTheme.WMColor.B3);
        param.wMenuBgColorSet([UIColor hd_colorWithHexString:@"#f7f7f7"]);
        param.wBouncesSet(YES);
        param.wTopSuspensionSet(YES);
        param.wCustomTitleContent = ^NSString *_Nullable(id _Nullable model, NSInteger index) {
            if ([model isKindOfClass:WMHomeColumnModel.class]) {
                WMHomeColumnModel *mo = (WMHomeColumnModel *)model;
                return mo.name;
            }
            return @"";
        };
        param.wTitleArrSet(self.viewModel.columnArray);
        param.wEventClick = ^(id _Nullable anyID, NSInteger index) {
            @HDStrongify(self);
            id obj = [self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
            if ([NSStringFromClass([obj class]) isEqualToString:@"WMNewHomeStoreListView"]) {
                WMNewHomeStoreListView *list = (WMNewHomeStoreListView *)obj;
                [list.filterBarView hideAllSlideDownView];
            }
            if (index == 1) {
                [LKDataRecord.shared traceEvent:@"freeDeliveryIocn" name:@"freeDeliveryIocn"
                                     parameters:@{@"type": @"freeDeliveryIocn", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                            SPM:nil];
            }
        };
        @HDWeakify(param);
        param.wEventMenuNormalHeight = ^(NSArray<WMZPageNaviBtn *> *_Nullable titleArr) {
            @HDStrongify(param);
            @HDStrongify(self);
            self.pageView.upSc.mainView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
            param.wMenuBgColorSet([UIColor hd_colorWithHexString:@"#f7f7f7"]);
            id obj = [self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
            if ([NSStringFromClass([obj class]) isEqualToString:@"WMNewHomeStoreListView"]) {
                WMNewHomeStoreListView *list = (WMNewHomeStoreListView *)obj;
                list.filterBarView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
            }
        };

        param.wEventMenuChangeHeight = ^(NSArray<WMZPageNaviBtn *> *_Nullable titleArr, CGFloat offset) {
            @HDStrongify(param);
            @HDStrongify(self);
            self.pageView.upSc.mainView.backgroundColor = UIColor.whiteColor;
            param.wMenuBgColorSet([UIColor whiteColor]);
            id obj = [self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
            if ([NSStringFromClass([obj class]) isEqualToString:@"WMNewHomeStoreListView"]) {
                WMNewHomeStoreListView *list = (WMNewHomeStoreListView *)obj;
                list.filterBarView.backgroundColor = [UIColor whiteColor];
            }
        };

        param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
            @HDStrongify(self);
            if (index == 0) {
                WMNewHomeStoreListView *listView = nil;
                if (self.viewModel.columnArray.count > index) {
                    listView = [[WMNewHomeStoreListView alloc] initWithViewModel:self.viewModel columnModel:self.viewModel.columnArray[index]];
                } else {
                    listView = [[WMNewHomeStoreListView alloc] initWithViewModel:self.viewModel];
                }
                listView.iocntype = @"nearbyMerchant";
                listView.filterBarView.viewWillAppear = ^(UIView *_Nonnull view) {
                    @HDStrongify(self)[self.pageView downScrollViewSetOffset:CGPointZero animated:NO];
                };
                listView.filterBarView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
                return (id)listView;
            }
            WMNewFreeDeleviryStoreListView *listView = nil;
            if (self.viewModel.columnArray.count > index) {
                listView = [[WMNewFreeDeleviryStoreListView alloc] initWithViewModel:self.viewModel columnModel:self.viewModel.columnArray[index]];
            } else {
                listView = [[WMNewFreeDeleviryStoreListView alloc] initWithViewModel:self.viewModel];
            }
            listView.iocntype = @"freeDelivery";
            return (id)listView;
        };
        _pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kiPhoneXSeriesSafeBottomHeight + [HDHelper hd_tabBarHeight])) autoFix:NO param:param
                                        parentReponder:self.viewController];
        _pageView.downSc.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pageView.downSc.dataSource = self;
        _pageView.downSc.delegate = self;
        _pageView.downSc.backgroundColor = UIColor.whiteColor;
        _pageView.downSc.scrollEnabled = YES;
        self.tableView = _pageView.downSc;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @HDStrongify(self);
            [self wm_getNewData:NO];
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
        header.automaticallyChangeAlpha = YES;
    }
    return _pageView;
}

/// 获取新数据
- (void)wm_getNewData:(BOOL)scrollTop {
    if (scrollTop) {
        [self.pageView.downSc setContentOffset:CGPointZero animated:NO];
    }
    [self.pageView selectMenuWithIndex:0];
    [self.viewModel hd_getNewData];
    [self.pageView.cache enumerateKeysAndObjectsUsingBlock:^(NSNumber *_Nonnull key, UIResponder *_Nonnull obj, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:WMNewHomeStoreListView.class]) {
            WMNewHomeStoreListView *list = (WMNewHomeStoreListView *)obj;
            if (scrollTop) {
                [list.tableView setContentOffset:CGPointZero animated:NO];
            }
            [list wm_getNewData];
        }
    }];
    if (scrollTop) {
        [self.pageView.downSc setContentOffset:CGPointZero animated:NO];
    }
    [self.customViewModel requestNotice];
}

- (void)setIsShowingInWindow:(BOOL)isShowingInWindow {
    _isShowingInWindow = isShowingInWindow;
    if (isShowingInWindow) {
        [self.customViewModel requestNotice];
    }
    if (!isShowingInWindow) {
        ///隐藏筛选
        id obj = [self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
        if ([NSStringFromClass([obj class]) isEqualToString:@"WMNewHomeStoreListView"]) {
            WMNewHomeStoreListView *list = (WMNewHomeStoreListView *)obj;
            [list.filterBarView hideAllSlideDownView];
        }
    }
}
@end
