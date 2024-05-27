//
//  WMHomeViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMHomeViewController.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAddressModel.h"
#import "SALocationUtil.h"
#import "WMChooseAddressViewModel.h"
#import "WMHomeCustomViewModel.h"
#import "WMHomeView.h"
#import "WMHomeViewModel.h"
#import "WMStoreListViewModel.h"


@interface WMHomeViewController ()
/// 内容
@property (nonatomic, strong) WMHomeView *contentView;
/// VM
@property (nonatomic, strong) WMHomeViewModel *viewModel;
/// VM
@property (nonatomic, strong) WMHomeCustomViewModel *customViewModel;
/// AdressVM
@property (nonatomic, strong) WMChooseAddressViewModel *addressViewModel;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);
/// 语言切换是否需要刷新附近门店(首次进入默认调用hd_languageDidChanged函数，不需要刷新)
@property (nonatomic, assign) BOOL languageChangedNeedRefreshNearBy;
/// 刷新时间标记
@property (nonatomic, assign) long timeFlag;
/// 刷新时间
@property (nonatomic, assign) long associateTimeout;

@end


@implementation WMHomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self dealingWithShouldShowTipView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.customViewModel versionUpdate];
    self.contentView.isShowingInWindow = true;
    WMManage.shareInstance.plateId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    ///埋点 进入外卖页面
    [LKDataRecord.shared traceEvent:@"takeawayPageEnter" name:@"takeawayPageEnter" parameters:@{@"type": @"homePage"} SPM:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.contentView.isShowingInWindow = false;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
    NSTimeInterval oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeStillTime"] doubleValue];
    if (currentTime > oldTime) {
        [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"STAY", @"time": @(currentTime - oldTime).stringValue}
                                    SPM:[LKSPM SPMWithPage:@"WMHomeViewController" area:@"" node:@""]];
    }
}

- (void)hd_setupViews {
    ///计算页面停留时长
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", NSDate.date.timeIntervalSince1970] forKey:@"homeStillTime"];

    [self.view addSubview:self.contentView];
    //    self.clientType = SAClientTypeYumNow;
    self.miniumGetNewDataDuration = 2;

    [self.viewModel loadOfflineData];
    [self.viewModel hd_getNewData];

    // 监听用户选择位置
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userChangedLocationHandler:) name:kNotificationNameUserChangedLocation object:nil];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];

    // 监听位置管理器位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    // 监听从后台进入前台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 监听从前台进入后台
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [self setAddressWithCurrentLocation];

    [self getShareBgAction];
    
    self.hd_fullScreenPopDisabled = NO;
}

- (void)getShareBgAction {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/getImagePath";
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        if (info[@"appImagePath"]) {
            [NSUserDefaults.standardUserDefaults setObject:info[@"appImagePath"] forKey:@"wm_imagePath"];
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[[NSURL URLWithString:info[@"appImagePath"]]]];
        }
    } failure:nil];
}

- (void)hd_getNewData {
    // 触发消息更新
    [super hd_getNewData];
}

- (void)hd_bindViewModel {
    [self.customViewModel hd_bindView:self.view];
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_languageDidChanged {
    [WMManage.shareInstance changeLanguage];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - Notification
- (void)userChangedLocationHandler:(NSNotification *)notification {
    SAClientType clientType = notification.userInfo[@"clientType"];
    if (!notification || [clientType isEqualToString:SAClientTypeMaster]) {
        if (!self.viewModel.finishRequestType || self.viewModel.finishRequestType == 2) {
            if (self.viewModel.finishRequestType == 2) {
                [self.contentView showloading];
            }
            [self.contentView wm_getNewData:YES];
        }

        ///还没有展示过通知
        if ([NSUserDefaults.standardUserDefaults objectForKey:@"noneNoticeKey"]) {
            ///重现调用一遍
            self.contentView.isShowingInWindow = true;
        }

        [self dealingWithShouldShowTipView];

        if ([self.viewModel isKindOfClass:WMHomeViewModel.class]) {
            //            SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
            SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
            WMHomeViewModel *viewModel = (WMHomeViewModel *)self.viewModel;
            viewModel.locationFailFlag = !addressModel;
        }
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

    if (HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusAuthed && HDLocationManager.shared.isCurrentCoordinate2DValid) {
        CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
        // 上次定位的地址，未超过100米，使用上次缓存的地址
        SAAddressModel *lastLocateAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];

        if (!HDIsObjectNil(lastLocateAddressModel)) {
            CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
            CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:lastLocateAddressModel.lat.doubleValue longitude:lastLocateAddressModel.lon.doubleValue];
            CLLocationDistance distance = [HDLocationUtils distanceFromLocation:currentLocation toLocation:lastLocation];
            if (distance <= 100) {
                //                [self setAddressModel:lastLocateAddressModel];
                //                [self.addressViewModel localSaveHistoryAddress:lastLocateAddressModel];
                //                if ([self.viewModel isKindOfClass:WMNewHomeViewModel.class]) {
                //                    WMNewHomeViewModel *viewModel = (WMNewHomeViewModel *)self.viewModel;
                //                    viewModel.locationFailFlag = NO;
                //                }
                HDLog(@"当前变化小于100米");

            } else {
                //仅提示一次，再位置改变不提示，除非重新进入页面
                if (!self.viewModel.locationChangeFlag) {
                    self.viewModel.locationChangeFlag = YES;
                }
                HDLog(@"当前变化大于100米");
            }
        }
    }
}

#pragma mark - noti
- (void)applicationBecomeActive {
    [self dealingWithShouldShowTipView];

    //处理页面刷新判断
    if (self.timeFlag > 0 && time(0) - self.timeFlag > self.associateTimeout) {
        [self.contentView wm_getNewData:YES];
    }

    self.timeFlag = 0;
}

- (void)applicationEnterBackground {
    self.timeFlag = time(0);
    @HDWeakify(self);
    [WMStoreListViewModel getSystemConfigWithKey:@"userapp_refresh_interval" success:^(NSString *_Nonnull value) {
        @HDStrongify(self);
        long time = value.integerValue;
        if (time > 0) {
            self.associateTimeout = time;
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

#pragma mark - private methods
- (void)dealingWithShouldShowTipView {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (status == HDCLAuthorizationStatusNotAuthed && addressModel.fromType != SAAddressModelFromTypeOnceTime) {
        self.viewModel.tipViewStyle = WMHomeTipViewStyleLackingLocationPermission;
        return;
    }

    BOOL hasUserChoosenValidAddress = NO;
    if (addressModel) {
        hasUserChoosenValidAddress = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(addressModel.lat.doubleValue, addressModel.lon.doubleValue)];
    }

    if (hasUserChoosenValidAddress && addressModel.fromType != SAAddressModelFromTypeUnknown) {
        // 不要更改不在配送范围内的情况
        if (self.viewModel.tipViewStyle == WMHomeTipViewStyleLackingLocationPermission) {
            self.viewModel.tipViewStyle = WMHomeTipViewStyleDisapper;
        }
        return;
    }

    if (status == HDCLAuthorizationStatusNotAuthed) {
        self.viewModel.tipViewStyle = WMHomeTipViewStyleLackingLocationPermission;
    } else {
        // 不要更改不在配送范围内的情况
        if (self.viewModel.tipViewStyle == WMHomeTipViewStyleLackingLocationPermission) {
            self.viewModel.tipViewStyle = WMHomeTipViewStyleDisapper;
        }
    }
}

- (void)setAddressWithCurrentLocation {
    @HDWeakify(self);
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusNotAuthed) {
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self);
            [self setAddressWithCurrentLocation];
        };
        return;
    }


    //获取缓存地址
    SAAddressModel *lastLocateAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    if (!HDIsObjectNil(lastLocateAddressModel)) {
        [self.addressViewModel localSaveHistoryAddress:lastLocateAddressModel];
        if ([self.viewModel isKindOfClass:WMHomeViewModel.class]) {
            WMHomeViewModel *viewModel = (WMHomeViewModel *)self.viewModel;
            viewModel.locationFailFlag = NO;
        }
        return;
    }

    // 来到这里说明原地址无效或者页面还未首次使用定位地址，都使用定位地址
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
            // 重新解析当前地址
            [SALocationUtil transferCoordinateToAddress:coordinate2D
                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                 if (HDIsStringNotEmpty(address)) {
                                                     SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                     addressModel.lat = @(coordinate2D.latitude);
                                                     addressModel.lon = @(coordinate2D.longitude);
                                                     addressModel.address = address;
                                                     addressModel.consigneeAddress = consigneeAddress;
                                                     addressModel.fromType = SAAddressModelFromTypeLocate;
                                                     [self setAddressModel:addressModel];
                                                     [self.addressViewModel localSaveHistoryAddress:addressModel];
                                                 } else {
                                                     SAAddressModel *addressModel = SAAddressModel.new;
                                                     addressModel.lat = @(coordinate2D.latitude);
                                                     addressModel.lon = @(coordinate2D.longitude);
                                                     addressModel.address = WMLocalizedString(@"wm_unkown_oad", @"Unkown Road");
                                                     [self setAddressModel:addressModel];
                                                 }
                                                 if ([self.viewModel isKindOfClass:WMHomeViewModel.class]) {
                                                     WMHomeViewModel *viewModel = (WMHomeViewModel *)self.viewModel;
                                                     viewModel.locationFailFlag = HDIsStringEmpty(address);
                                                 }
                                             }];
        } else {
            //            SAAddressModel *lastLocateAddressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
            SAAddressModel *lastLocateAddressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
            if (lastLocateAddressModel) {
                [self setAddressModel:lastLocateAddressModel];
            } else {
                SAAddressModel *addressModel = SAAddressModel.new;
                addressModel.address = SALocalizedString(@"wm_location_fail", @"定位失败");
                [self setAddressModel:addressModel];
            }
            if ([self.viewModel isKindOfClass:WMHomeViewModel.class]) {
                WMHomeViewModel *viewModel = (WMHomeViewModel *)self.viewModel;
                viewModel.locationFailFlag = YES;
            }

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
}

#pragma mark - lazy load

- (WMHomeView *)contentView {
    if (!_contentView) {
        _contentView = [[WMHomeView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _contentView.relocationBlock = ^{
            @HDStrongify(self);
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
            // 重新解析当前地址
            @HDWeakify(self);
            [SALocationUtil transferCoordinateToAddress:coordinate2D
                                             completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary<SAAddressKey, id> *_Nullable addressDictionary) {
                                                 @HDStrongify(self);
                                                 if (HDIsStringNotEmpty(address)) {
                                                     SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                                                     addressModel.lat = @(coordinate2D.latitude);
                                                     addressModel.lon = @(coordinate2D.longitude);
                                                     addressModel.address = address;
                                                     addressModel.consigneeAddress = consigneeAddress;
                                                     addressModel.fromType = SAAddressModelFromTypeLocate;
                                                     [self setAddressModel:addressModel];
                                                     [self.addressViewModel localSaveHistoryAddress:addressModel];
                                                 } else {
                                                     SAAddressModel *addressModel = SAAddressModel.new;
                                                     addressModel.lat = @(coordinate2D.latitude);
                                                     addressModel.lon = @(coordinate2D.longitude);
                                                     addressModel.address = WMLocalizedString(@"wm_unkown_oad", @"Unkown Road");
                                                     [self setAddressModel:addressModel];
                                                 }
                                                 if ([self.viewModel isKindOfClass:WMHomeViewModel.class]) {
                                                     WMHomeViewModel *viewModel = (WMHomeViewModel *)self.viewModel;
                                                     viewModel.locationFailFlag = HDIsStringEmpty(address);
                                                 }
                                             }];
        };
    }
    return _contentView;
}

- (WMHomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMHomeViewModel alloc] init];
        _viewModel.hideBackButton = [self.parameters[@"hideBackButton"] boolValue];
        HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
        if (status == HDCLAuthorizationStatusNotAuthed) {
            _viewModel.tipViewStyle = WMHomeTipViewStyleLackingLocationPermission;
        }
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}
- (WMChooseAddressViewModel *)addressViewModel {
    if (!_addressViewModel) {
        _addressViewModel = [WMChooseAddressViewModel new];
    }
    return _addressViewModel;
}

- (WMHomeCustomViewModel *)customViewModel {
    if (!_customViewModel) {
        _customViewModel = [WMHomeCustomViewModel new];
    }
    return _customViewModel;
}

- (long)associateTimeout {
    if (!_associateTimeout) {
        _associateTimeout = 15 * 60;
    }
    return _associateTimeout;
}

- (void)dealloc {
    WMManage.shareInstance.plateId = nil;
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserChangedLocation object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeHome;
}

@end
