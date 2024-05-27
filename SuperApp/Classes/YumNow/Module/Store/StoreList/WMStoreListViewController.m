//
//  WMStoreListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreListViewController.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "SAMessageButton.h"
#import "WNHomeViewController.h"
#import "SAWriteDateReadableModel.h"
#import "WMStoreListView.h"
#import "WMStoreListViewModel.h"


@interface WMStoreListViewController ()
/// 内容
@property (nonatomic, strong) WMStoreListView *contentView;
/// VM
@property (nonatomic, strong) WMStoreListViewModel *viewModel;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);
@end


@implementation WMStoreListViewController
- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!SAMultiLanguageManager.isCurrentLanguageCN)
        self.viewModel.shouldShowShoppingCartBTN = true;

    [self dealingWithShouldShowTipView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.contentView.isShowingInWindow = false;
    self.viewModel.shouldShowShoppingCartBTN = false;
}

- (void)hd_setupViews {
    self.viewModel.filterModel = self.contentView.filterModel;
    self.clientType = SAClientTypeYumNow;
    self.viewModel.isFromMasterHome = [self isFromMasterHome];
    [self.view addSubview:self.contentView];

    // 检查权限
    [self setAddressWithCurrentLocation];

    // 监听用户选择位置
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置管理器位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    // 判断获取时间间隔
    SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
    if (cacheModel && cacheModel.timeIntervalSinceCreateTime < 300)
        return;
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///跳转搜索
    if ([event.key isEqualToString:@"clickToSearch"]) {
        [HDMediator.sharedInstance navigaveToStoreSearchViewController:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingFormat:@"|外卖门店列表.分类%@.搜索", self.viewModel.filterModel.businessScope] : [NSString stringWithFormat:@"外卖门店列表.分类%@.搜索", self.viewModel.filterModel.businessScope],
            @"associatedId" : self.viewModel.associatedId
        }];
    }
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - override
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - Notification
- (void)userChangedLocationHandler:(NSNotification *)notification {
    SAClientType clientType = notification.userInfo[@"clientType"];
    if (!notification || [clientType isEqualToString:SAClientTypeMaster]) {
        [self.contentView hd_getNewData];
    }
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined) {
        [self dealingWithShouldShowTipView];
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
        // 清空
        self.locationManagerLocateSuccessHandler = nil;
    }
}

#pragma mark - private methods
- (void)dealingWithShouldShowTipView {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    // 如果入口为超A首页，未开启定位就展示TipView
    if ([self isFromMasterHome]) {
        if (status == HDCLAuthorizationStatusNotAuthed && addressModel.fromType != SAAddressModelFromTypeOnceTime) {
            self.viewModel.tipViewStyle = WMHomeTipViewStyleLackingLocationPermission;
            return;
        }
    }

    BOOL hasUserChoosenValidAddress = NO;
    if (addressModel) {
        hasUserChoosenValidAddress = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)];
    }

    if (hasUserChoosenValidAddress && addressModel.fromType != SAAddressModelFromTypeUnknown) {
        self.viewModel.tipViewStyle = WMHomeTipViewStyleDisapper;
        if (!SAMultiLanguageManager.isCurrentLanguageCN)
            self.viewModel.shouldShowShoppingCartBTN = true;
        return;
    }

    if (status == HDCLAuthorizationStatusNotAuthed) {
        self.viewModel.tipViewStyle = WMHomeTipViewStyleLackingLocationPermission;
        self.viewModel.shouldShowShoppingCartBTN = false;
    } else {
        self.viewModel.tipViewStyle = WMHomeTipViewStyleDisapper;
        if (!SAMultiLanguageManager.isCurrentLanguageCN)
            self.viewModel.shouldShowShoppingCartBTN = true;
    }
}

- (void)setAddressWithCurrentLocation {
    @HDWeakify(self);
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if ([self isFromMasterHome]) {
        if (status == HDCLAuthorizationStatusNotAuthed) {
            self.locationManagerLocateSuccessHandler = ^{
                @HDStrongify(self);
                [self setAddressWithCurrentLocation];
            };
            return;
        }
    } else {
        //        SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
        BOOL hasUserChoosenValidAddress = NO;
        if (addressModel) {
            hasUserChoosenValidAddress = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)];
        }

        // 前提条件是当前的位置无效，说明用户还没主动变更过地址，或者进入页面还未首次使用定位地址
        if (hasUserChoosenValidAddress) {
            return;
        }
    }

    // 来到这里说明原地址无效或者页面还未首次使用定位地址，都使用定位地址
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
//            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
//
//            [SALocationUtil transferCoordinateToAddress:coordinate2D
//                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
//                                                 if (HDIsStringNotEmpty(address)) {
//                                                     // 更新标志
//                                                     SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
//                                                     addressModel.lat = @(coordinate2D.latitude);
//                                                     addressModel.lon = @(coordinate2D.longitude);
//                                                     addressModel.address = address;
//                                                     addressModel.consigneeAddress = consigneeAddress;
//                                                     addressModel.fromType = SAAddressModelFromTypeLocate;
//                                                     [self setAddressModel:addressModel];
//                                                 } else {
//                                                     [NAT showToastWithTitle:nil content:@"未知位置" type:HDTopToastTypeError];
//                                                 }
//                                             }];
        } else {
            [HDLocationManager.shared startUpdatingLocation];
            self.locationManagerLocateSuccessHandler = ^{
                @HDStrongify(self);
                [self setAddressWithCurrentLocation];
            };
        }
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        [HDLocationManager.shared requestWhenInUseAuthorization];
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self);
            [self setAddressWithCurrentLocation];
        };
    }
}

- (void)setAddressModel:(SAAddressModel *)addressModel {
    // 这里缓存的是 kCacheKeyYumNowUserChoosedCurrentAddress
    [SAAddressCacheAdaptor cacheAddressForClientType:SAClientTypeYumNow addressModel:addressModel];

    [self.contentView hd_getNewData];
}

// 是否是从超A首页进来的
- (BOOL)isFromMasterHome {
    NSUInteger selfIndex = [self.navigationController.viewControllers indexOfObject:self];
    NSInteger lastIndex = selfIndex - 1;
    UIViewController *fromViewController;
    if (lastIndex >= 0 && self.navigationController.viewControllers.count > lastIndex) {
        fromViewController = self.navigationController.viewControllers[lastIndex];
    }
    if (fromViewController && [fromViewController isKindOfClass:WNHomeViewController.class]) {
        return true;
    }
    return false;
}

#pragma mark - lazy load

- (WMStoreListView *)contentView {
    return _contentView ?: ({ _contentView = [[WMStoreListView alloc] initWithViewModel:self.viewModel]; });
}

- (WMStoreListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMStoreListViewModel alloc] init];
        _viewModel.businessScope = [self.parameters objectForKey:@"category"];
        _viewModel.plateId = self.parameters[@"plateId"];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeCategory;
}

@end
