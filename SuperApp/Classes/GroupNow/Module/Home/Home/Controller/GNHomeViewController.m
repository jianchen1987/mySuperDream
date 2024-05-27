//
//  GNHomeViewController.m
//  SuperApp
//
//  Created by wmz on 2021/5/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//
#import "GNHomeViewController.h"
#import "GNFilterView.h"
#import "GNHomeArticleListView.h"
#import "GNHomeStoreListView.h"
#import "GNHomeViewModel.h"
#import "GNNaviView.h"
#import "SAAddressModel.h"
#import "SALocationUtil.h"
#import "SATabBar.h"
#import "SATabBarButton.h"
#import "WMCardTableViewCell.h"
#import "WMZPageView.h"


@interface GNHomeViewController () <UITableViewDataSource, UITableViewDelegate>
/// locationShow
@property (nonatomic, assign) BOOL locationShow;
/// 可以更新列表数据了
@property (nonatomic, assign) BOOL updateMenuList;
/// 导航栏
@property (nonatomic, strong) GNNaviView *naviView;
/// viewModel
@property (nonatomic, strong) GNHomeViewModel *viewModel;
/// 筛选
@property (nonatomic, strong) GNFilterView *filterBarView;
/// sectionHeadView
@property (nonatomic, strong) UIView *sectionHeadView;
/// sectionHeadHeight
@property (nonatomic, assign) CGFloat sectionHeadHeight;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy, nullable) void (^locationManagerLocateSuccessHandler)(void);
/// pageView
@property (nonatomic, strong) WMZPageView *pageView;

@end


@implementation GNHomeViewController

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///隐藏筛选
    if ([[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)] isKindOfClass:GNHomeStoreListView.class]) {
        GNHomeStoreListView *list = (GNHomeStoreListView *)[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
        [list.filterBarView hideAllSlideDownView];
    }
}

- (void)hd_setupViews {
    @HDWeakify(self);
    HDLocationManager.shared.hd_delegatesSelf = self;

    WMZPageParam *param = PageParam();
    param.wCustomNaviBarY = ^CGFloat(CGFloat nowY) {
        return kNavigationBarH;
    };
    param.wCustomTabbarY = ^CGFloat(CGFloat nowY) {
        return 0;
    };
    param.wAvoidQuickScrollSet(YES);
    param.wLazyLoadingSet(NO);
    param.wDelegateWithResponserSet(YES);
    param.wCustomTitleContentSet(^NSString *_Nullable(id _Nullable model, NSInteger index) {
        if ([model isKindOfClass:GNColumnModel.class]) {
            GNColumnModel *tmpModel = (GNColumnModel *)model;
            return tmpModel.columnName;
        }
        return nil;
    });
    param.wEventChildVCDidSroll = ^(UIViewController *_Nullable pageVC, CGPoint oldPoint, CGPoint newPonit, UIScrollView *_Nonnull currentScrollView) {
        @HDStrongify(self);
        self.down = (newPonit.y > (self.pageView.downSc.contentSize.height - self.pageView.downSc.frame.size.height - 1));
    };
    param.wBounces = YES;
    //    param.wTitleArr = [SACacheManager.shared objectForKey:kCacheKeyGroupBuyLivingList type:SACacheTypeDocumentPublic];
    param.wTopSuspension = YES;
    param.wEventClick = ^(id _Nullable anyID, NSInteger index) {
        @HDStrongify(self);
        if ([[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)] isKindOfClass:GNHomeStoreListView.class]) {
            GNHomeStoreListView *list = (GNHomeStoreListView *)[self.pageView.upSc.cache objectForKey:@(self.pageView.upSc.currentTitleIndex)];
            [list.filterBarView hideAllSlideDownView];
        }
    };
    param.wViewController = ^UIViewController *_Nullable(NSInteger index) {
        @HDStrongify(self);
        NSArray *titleArr = self.pageView.param.wTitleArr;
        GNView *storeView = nil;
        if (titleArr.count > index) {
            GNColumnModel *column = titleArr[index];
            if ([column isKindOfClass:GNColumnModel.class]) {
                if ([column.columnType.codeId isEqualToString:GNHomeColumnAricle]) {
                    storeView = GNHomeArticleListView.new;
                    GNHomeArticleListView *tmp = (GNHomeArticleListView *)storeView;
                    tmp.updateMenuList = self.updateMenuList;
                    tmp.columnCode = column.columnCode;
                    tmp.columnType = column.columnType.codeId;
                } else {
                    storeView = GNHomeStoreListView.new;
                    GNHomeStoreListView *tmp = (GNHomeStoreListView *)storeView;
                    tmp.updateMenuList = self.updateMenuList;
                    @HDWeakify(self) tmp.filterBarView.viewWillAppear = ^(UIView *_Nonnull view) {
                        @HDStrongify(self)[self.pageView downScrollViewSetOffset:CGPointZero animated:NO];
                    };
                    tmp.columnCode = column.columnCode;
                    tmp.columnType = column.columnType.codeId;
                }
            }
        }
        return (id)storeView;
    };
    self.pageView = [[WMZPageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - (kiPhoneXSeriesSafeBottomHeight + [HDHelper hd_tabBarHeight])) param:param parentReponder:self];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.naviView];

    self.pageView.downSc.dataSource = self;
    self.pageView.downSc.backgroundColor = HDAppTheme.color.gn_whiteColor;
    self.pageView.downSc.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pageView.downSc.scrollEnabled = YES;
    self.pageView.downSc.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @HDStrongify(self);
        [self clickLocation:NO requestInfo:YES];
    }];
    [self hd_languageDidChanged];

    if (![SACacheManager.shared objectForKey:kCacheKeyGroupBuyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic]) {
        [self clickLocation:NO requestInfo:YES];
    } else {
        [self.viewModel getInfoData];
    }
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];
    
    self.hd_fullScreenPopDisabled = NO;
}

- (void)hd_languageDidChanged {
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.pageView.downSc.mj_header;
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_NORMAL", @"下拉刷新") forState:MJRefreshStateIdle];
    [head setTitle:SALocalizedString(@"MJ_STATE_DOWN_PULLING", @"放开刷新") forState:MJRefreshStatePulling];
    [head setTitle:SALocalizedString(@"MJ_STATE_LOADING", @"加载中") forState:MJRefreshStateRefreshing];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.viewModel hd_bindView:self.view];
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (self.viewModel.refreshFlag) {
            self.sectionHeadHeight = kRealWidth(8);
        }
        [self.pageView.downSc.mj_header endRefreshing];
        [self.pageView.downSc reloadData];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"columnDataSource" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.updateMenuList = YES;
        self.pageView.param.wTitleArr = self.viewModel.columnDataSource;
        [self.pageView updateMenuData];
        self.pageView.downSc.scrollEnabled = YES;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNCellModel *model = self.viewModel.dataSource[indexPath.row];
    GNTableViewCell *cell = [GNTableViewCell cellWithTableView:tableView];
    if ([model isKindOfClass:WMHomeLayoutModel.class]) {
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
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sectionHeadHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.sectionHeadView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageView performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
}

#pragma mark respondEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    /// 跳转搜索
    if ([event.key isEqualToString:@"toSearch"]) {
        [HDMediator.sharedInstance navigaveToGNStoreSearchViewController:@{}];
    }
    /// 关闭视图
    else if ([event.key isEqualToString:@"dissmiss"]) {
        [self dismissAnimated:YES completion:nil];
    }
    /// 重新定位
    else if ([event.key isEqualToString:@"showLocation"]) {
        [self reLocationAction];
    }
}

#pragma mark 点击定位
- (void)clickLocation:(BOOL)showloading requestInfo:(BOOL)requestInfo {
    @HDWeakify(self);
    SAAddressModel *addressModel = SAAddressModel.new;
    if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
        addressModel.lat = @(HDLocationManager.shared.coordinate2D.latitude);
        addressModel.lon = @(HDLocationManager.shared.coordinate2D.longitude);
    } else {
        addressModel.lat = @(kDefaultLocationPhn.latitude);
        addressModel.lon = @(kDefaultLocationPhn.longitude);
    }
    if (requestInfo) {
        [SALocationUtil transferCoordinateToAddress:HDLocationManager.shared.isCurrentCoordinate2DValid ? HDLocationManager.shared.coordinate2D : kDefaultLocationPhn
                                         completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                             @HDStrongify(self);
                                             addressModel.city = addressDictionary[SAAddressKeyCity];
                                             addressModel.subLocality = addressDictionary[SAAddressKeySubLocality];
                                             [SACacheManager.shared setObject:addressModel forKey:kCacheKeyGroupBuyUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
                                             if (showloading) {
                                                 [self.pageView.downSc.mj_header beginRefreshing];
                                             } else {
                                                 [self.viewModel getInfoData];
                                             }
                                         }];
    }

    if (showloading)
        [self showloading];
    [self.viewModel.homeDTO fuzzyQueryZoneListWithProvince:nil district:nil commune:nil defaultNum:0 latitude:addressModel.lat.stringValue longitude:addressModel.lon.stringValue
        success:^(NSArray<SAAddressZoneModel *> *_Nonnull list) {
            @HDStrongify(self);
            if (list.count) {
                if (list.firstObject.children.count) {
                    if ([list.firstObject isKindOfClass:SAAddressZoneModel.class] && [list.firstObject.children.firstObject isKindOfClass:SAAddressZoneModel.class]) {
                        [self checkCityCode:list.firstObject.children.firstObject];
                    }
                } else {
                    if ([list.firstObject isKindOfClass:SAAddressZoneModel.class])
                        [self checkCityCode:list.firstObject];
                }
            } else {
                [self dismissLoading];
                [HDTips showInfo:GNLocalizedString(@"gn_home_noStore", @"定位附近暂无商家，将自动为您推荐金边商家") hideAfterDelay:1.5];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
}

#pragma mark 检测当前城市有无门店
- (void)checkCityCode:(nullable SAAddressZoneModel *)model {
    @HDWeakify(self)[self.viewModel.homeDTO merchantCheckCityWithCityCode:model.code success:^(BOOL result) {
        @HDStrongify(self)[self dismissLoading];
        if (!result) {
            [HDTips showInfo:GNLocalizedString(@"gn_home_noStore", @"定位附近暂无商家，将自动为您推荐金边商家") hideAfterDelay:1.5];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self dismissLoading];
    }];
}

///手动置顶
- (void)scrollToTop {
    [self.pageView downScrollViewSetOffset:CGPointMake(0, CGFLOAT_MIN) animated:YES];
}

/// 重新定位事件
- (void)reLocationAction {
    @HDWeakify(self) HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        [HDLocationManager.shared setValue:@(YES) forKey:@"mustCallDelegateFlag"];
        [HDLocationManager.shared startUpdatingLocation];
        [self showloadingText:[GNLocalizedString(@"gn_home_reLocation", @"重新定位") stringByAppendingString:@"..."]];
        __block BOOL change = NO;
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self)[self dismissLoading];
            [self clickLocation:YES requestInfo:YES];
            change = YES;
        };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!change) {
                [self dismissLoading];
                self.locationManagerLocateSuccessHandler = nil;
                [self clickLocation:YES requestInfo:YES];
            }
        });
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        [HDLocationManager.shared requestWhenInUseAuthorization];
    } else if (status == HDCLAuthorizationStatusNotAuthed) {
        [SALocationUtil showUnAuthedTipConfirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            [HDSystemCapabilityUtil openAppSystemSettingPage];
        } cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];
    }
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined)
        [self reLocationAction];
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
        self.locationManagerLocateSuccessHandler = nil;
    }
}

- (GNHomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNHomeViewModel.new;
    }
    return _viewModel;
}

- (SATabBarButton *)getCurrentTabBarButton {
    SATabBar *tabbar = (SATabBar *)self.tabBarController.tabBar;
    if ([tabbar isKindOfClass:SATabBar.class]) {
        return tabbar.buttons.firstObject;
    }
    return nil;
}

- (GNNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[GNNaviView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarH)];
        @HDWeakify(self)[_naviView.rightBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self respondEvent:[GNEvent eventKey:@"toSearch"]];
        }];
        [_naviView.rightBTN setImage:[UIImage imageNamed:@"gn_home_nav_search"] forState:UIControlStateNormal];
        _naviView.titleLB.text = GNLocalizedString(@"gn_local_sevice", @"本地生活");
    }
    return _naviView;
}

- (UIView *)sectionHeadView {
    if (!_sectionHeadView) {
        _sectionHeadView = UIView.new;
        _sectionHeadView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _sectionHeadView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

@end
