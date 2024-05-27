//
//  GNSortViewController.m
//  SuperApp
//
//  Created by wmz on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNSortViewController.h"
#import "GNHomeDTO.h"
#import "GNHomeStoreListView.h"
#import "GNNaviView.h"
#import "GNSortDiscountListView.h"
#import "GNSortFilterView.h"
#import "GNSortHeadView.h"
#import "GNSortStoreListView.h"
#import "WMZPageView.h"


@interface GNSortViewController () <GNSortHeadViewDelegate>
/// headView
@property (nonatomic, strong) GNSortHeadView *headView;
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;
/// homeDTO
@property (nonatomic, strong) GNHomeDTO *homeDTO;
///选中的分类
@property (nonatomic, strong) GNClassificationModel *selectModel;
/// 筛选
@property (nonatomic, strong) GNSortFilterView *filterView;
/// 筛选数据源
@property (nonatomic, strong) NSMutableArray<GNClassificationModel *> *_Nonnull dataSource;
/// 导航栏
@property (nonatomic, strong) GNNaviView *naviView;
/// 占位
@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel;

@end


@implementation GNSortViewController

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.classificationCode = [parameters objectForKey:@"category"];
    self.boldTitle = GNFillEmpty([parameters objectForKey:@"title"]);
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideFilter:YES];
}

///隐藏筛选
///@param reset 重置筛选
- (void)hideFilter:(BOOL)reset {
    if ([[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)] isKindOfClass:GNSortStoreListView.class]) {
        GNSortStoreListView *list = (GNSortStoreListView *)[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
        [list.filterBarView hideAllSlideDownView];
        if (reset)
            [list.filterBarView resetAll];
    }
}

- (void)hd_setupViews {
    self.naviView.titleLB.text = self.boldTitle;
    [self.view addSubview:self.naviView];
}

- (void)gn_getNewData {
    @HDWeakify(self)[self showloading];
    [self.homeDTO getClassificationListWithCode:self.classificationCode success:^(NSArray<GNClassificationModel *> *_Nonnull rspModel) {
        @HDStrongify(self)[self dismissLoading];
        if ([rspModel isKindOfClass:NSArray.class]) {
            [self.view hd_removePlaceholderView];
            self.dataSource = [NSMutableArray arrayWithArray:rspModel];
            if (rspModel.count) {
                ///添加全部
                GNClassificationModel *allModel = GNClassificationModel.new;
                allModel.photo = @"gn_coupon_all";
                allModel.classificationName = [SAInternationalizationModel modelWithCN:@"全部" en:@"All" kh:@"ទាំងអស់"];
                allModel.parentCode = self.classificationCode;
                [self.dataSource insertObject:allModel atIndex:0];
                ///默认第一个选中
                self.selectModel = self.dataSource.firstObject;
                self.selectModel.select = YES;
                self.filterView.cateDatasource = [NSMutableArray arrayWithArray:self.dataSource];
            } else {
                self.selectModel = GNClassificationModel.new;
                self.selectModel.classificationCode = self.classificationCode;
            }
            [self hd_loadUI];
        } else {
            self.placeholderViewModel.title = SALocalizedString(@"no_data", @"暂无数据");
            self.placeholderViewModel.image = @"no_data_placeholder";
            [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self dismissLoading];
        self.placeholderViewModel.image = @"placeholder_network_error";
        self.placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
        [self.view hd_showPlaceholderViewWithModel:self.placeholderViewModel];
    }];
}

- (void)hd_loadUI {
    @HDWeakify(self) BOOL hideHead = (self.dataSource.count == 0);
    if (!hideHead) {
        self.headView = [[GNSortHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(106))];
        self.headView.delegate = self;
        self.headView.dataSource = self.dataSource;
    }

    WMZPageParam *param = PageParam();
    if (!hideHead) {
        param.wMenuHeadView = ^UIView *_Nullable {
            @HDStrongify(self) return self.headView;
        };
        param.wCustomDataViewTopOffsetSet(kRealWidth(46));
        param.wTopSuspensionSet(YES);
    }
    param.wTitleArr = @[GNLocalizedString(@"gn_storeName", @"商家"), GNLocalizedString(@"gn_offers", @"优惠")];
    param.wMenuPosition = PageMenuPositionCenter;
    param.wScrollCanTransfer = NO;
    param.wMenuTitleWidth = kScreenWidth / 2.0;
    param.wEventClick = ^(id _Nullable anyID, NSInteger index) {
        @HDStrongify(self)[self hideFilter:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.selectModel) {
                [self updateData:self.selectModel clickHead:NO];
            }
        });
    };
    param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
        return 0;
    };
    param.wCustomTabbarY = ^CGFloat(CGFloat nowY) {
        return 0;
    };
    param.wEventChildVCDidSroll = ^(UIViewController *_Nullable pageVC, CGPoint oldPoint, CGPoint newPonit, UIScrollView *_Nullable currentScrollView) {
        @HDStrongify(self) self.headView.topOffset = newPonit.y;
        if ([NSStringFromClass(self.pageView.upSc.currentVC.class) isEqualToString:@"GNSortStoreListView"]) {
            GNSortStoreListView *currentList = (id)self.pageView.upSc.currentVC;
            currentList.startOffsetY = kNavigationBarH + (self.headView.hd_height - self.headView.topOffset) + kRealWidth(82);
        } else if ([NSStringFromClass(self.pageView.upSc.currentVC.class) isEqualToString:@"GNSortDiscountListView"]) {
            GNSortDiscountListView *currentList = (id)self.pageView.upSc.currentVC;
            currentList.startOffsetY = kNavigationBarH + (self.headView.hd_height - self.headView.topOffset) + kRealWidth(82);
        }
    };
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self) if (index == 0) {
            GNSortStoreListView *view = GNSortStoreListView.new;
            view.startOffsetY = kNavigationBarH + self.headView.hd_height + kRealWidth(82);
            view.updateMenuList = YES;
            return (id)view;
        }
        else {
            GNSortDiscountListView *view = GNSortDiscountListView.new;
            view.startOffsetY = kNavigationBarH + self.headView.hd_height + kRealWidth(82);
            view.updateMenuList = YES;
            return (id)view;
        }
    };
    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH) param:param parentReponder:self];
    [self.view addSubview:self.pageView];
    self.headView.maxOffset = self.headView.hd_height - param.wCustomDataViewTopOffset;
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///打开筛选
    if ([event.key isEqualToString:@"openAction"]) {
        [self hideFilter:NO];
        if ([self.filterView isShow]) {
            [self.filterView dissmiss];
        } else {
            [self.filterView show:self.view];
        }
        ///关闭筛选
    } else if ([event.key isEqualToString:@"closeAction"]) {
        if ([self.filterView isShow]) {
            [self.filterView dissmiss];
        }
    }
    /// 跳转搜索
    else if ([event.key isEqualToString:@"toSearch"]) {
        [HDMediator.sharedInstance navigaveToGNStoreSearchViewController:@{}];
    }
    ///返回
    else if ([event.key isEqualToString:@"dissmiss"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma - mark GNSortHeadViewDelegate
- (void)clickItem:(GNClassificationModel *)model {
    [self hideFilter:YES];
    [self updateData:model clickHead:YES];
}

///更新数据
- (void)updateData:(GNClassificationModel *)model clickHead:(BOOL)clickHead {
    ///门店
    if ([NSStringFromClass(self.pageView.upSc.currentVC.class) isEqualToString:@"GNSortStoreListView"]) {
        GNSortStoreListView *currentList = (id)self.pageView.upSc.currentVC;
        if (!clickHead && [currentList.classificationCode isEqualToString:model.classificationCode] && currentList.tableView.hd_hasData) {
            return;
        }
        currentList.parentCode = model.parentCode;
        currentList.classificationCode = model.classificationCode;
        currentList.tableView.pageNum = 1;
        if (clickHead) {
            currentList.tableView.delegate = currentList.tableView.provider;
            currentList.tableView.dataSource = currentList.tableView.provider;
            [currentList.tableView reloadData];
        }
        [currentList gn_getNewData];
    }
    ///优惠
    else if ([NSStringFromClass(self.pageView.upSc.currentVC.class) isEqualToString:@"GNSortDiscountListView"]) {
        GNSortDiscountListView *currentList = (id)self.pageView.upSc.currentVC;
        if (!clickHead && [currentList.classificationCode isEqualToString:model.classificationCode] && currentList.tableView.hd_hasData) {
            return;
        }
        currentList.parentCode = model.parentCode;
        currentList.classificationCode = model.classificationCode;
        currentList.tableView.pageNum = 1;
        if (clickHead) {
            currentList.tableView.delegate = currentList.tableView.provider;
            currentList.tableView.dataSource = currentList.tableView.provider;
            [currentList.tableView reloadData];
        }
        [currentList gn_getNewData];
    }
    self.selectModel = model;
}

- (GNSortFilterView *)filterView {
    if (!_filterView) {
        @HDWeakify(self) _filterView = [[GNSortFilterView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight - kNavigationBarH)];
        _filterView.viewWillAppear = ^(UIView *_Nonnull view) {
            @HDStrongify(self)[self.filterView.collectionView updateUI];
        };
        _filterView.viewWillDisappear = ^(UIView *_Nonnull view) {
            @HDStrongify(self)[self.headView.collectionView updateUI];
        };
        _filterView.viewSelectModel = ^(GNClassificationModel *_Nonnull model, NSIndexPath *_Nonnull indexPath) {
            @HDStrongify(self)[self.headView.collectionView layoutIfNeeded];
            if ([self.headView.collectionView numberOfItemsInSection:0] > indexPath.row) {
                [self.headView.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
            [self updateData:model clickHead:NO];
        };
    }
    return _filterView;
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (GNNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[GNNaviView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarH)];
        @HDWeakify(self)[_naviView.rightBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self respondEvent:[GNEvent eventKey:@"toSearch"]];
        }];
        [_naviView.rightBTN setImage:[UIImage imageNamed:@"gn_home_nav_search"] forState:UIControlStateNormal];
    }
    return _naviView;
}

- (UIViewPlaceholderViewModel *)placeholderViewModel {
    if (!_placeholderViewModel) {
        UIViewPlaceholderViewModel *placeholderViewModel = UIViewPlaceholderViewModel.new;
        placeholderViewModel.image = @"placeholder_network_error";
        placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
        placeholderViewModel.needRefreshBtn = NO;
        _placeholderViewModel = placeholderViewModel;
    }
    return _placeholderViewModel;
}

- (BOOL)needLogin {
    return NO;
}

@end
