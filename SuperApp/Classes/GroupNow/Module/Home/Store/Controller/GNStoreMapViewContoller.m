//
//  GNStoreMapViewContoller.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreMapViewContoller.h"
#import "GNAlertUntils.h"
#import "GNHomeDTO.h"
#import "GNStoreMapFootView.h"
#import "SACommonConst.h"
#import "SALocationUtil.h"
#import "SAMapView.h"


@interface GNStoreMapViewContoller () <UIGestureRecognizerDelegate>
/// 用户刷新位置
@property (nonatomic, assign) BOOL locationUser;
/// 地图
@property (nonatomic, strong) SAMapView *mapView;
/// footView
@property (nonatomic, strong) GNStoreMapFootView *footView;
/// 定位
@property (nonatomic, strong) HDUIButton *locationBtn;
/// 刷新
@property (nonatomic, strong) HDUIButton *refreshBtn;
/// 线
@property (nonatomic, strong) UIView *lineView;
/// 定位刷新的容器
@property (nonatomic, strong) UIView *rightView;
// 网络请求
@property (nonatomic, strong) GNHomeDTO *homeDTO;
/// 商家标记
@property (nonatomic, strong) SAAnnotation *storeAnnotation;
///用户标记
@property (nonatomic, strong) SAAnnotation *userAnnotation;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy, nullable) void (^locationManagerLocateSuccessHandler)(void);

@end


@implementation GNStoreMapViewContoller

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.storeModel = [parameters objectForKey:@"storeModel"];
        self.storeNo = [parameters objectForKey:@"storeNo"];
    }
    return self;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_navBarAlpha = 0.5;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.footView];
    [self.view addSubview:self.rightView];
    [self.rightView addSubview:self.refreshBtn];
    [self.rightView addSubview:self.locationBtn];
    [self.rightView addSubview:self.lineView];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];
}

- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined) {
        [self requestLocation];
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
        self.locationManagerLocateSuccessHandler = nil;
    }
}

- (void)requestLocation {
    if (HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusAuthed) {
        [HDLocationManager.shared startUpdatingLocation];
        @HDWeakify(self) self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self) self.userAnnotation.coordinate = HDLocationManager.shared.realCoordinate2D;
            if (self.locationUser) {
                [self.mapView.mapView setRegion:MKCoordinateRegionMake(self.userAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
                self.locationUser = NO;
            }
        };
    }
}

- (void)hd_bindViewModel {
    [self requestLocation];
    [self.footView setGNModel:self.storeModel];
    [self.mapView.mapView setRegion:MKCoordinateRegionMake(self.storeAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
    [self.mapView.mapView addAnnotations:@[self.userAnnotation, self.storeAnnotation]];
}

#pragma mark - GNEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    ///导航
    if ([event.key isEqualToString:@"navigationAction"]) {
        [GNAlertUntils navigation:self.storeModel.storeName.desc lat:self.storeModel.geoPointDTO.lat.doubleValue lon:self.storeModel.geoPointDTO.lon.doubleValue];
    }
    ///联系商家
    else if ([event.key isEqualToString:@"callAction"]) {
        [GNAlertUntils callString:self.storeModel.businessPhone];
    }
}

- (void)updateViewConstraints {
    [self.footView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];

    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.equalTo(self.footView.mas_top);
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.bottom.equalTo(self.footView.mas_top).offset(-kRealHeight(50));
    }];

    [self.refreshBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.size.mas_equalTo(kRealHeight(60), kRealHeight(60));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(0);
    }];

    [self.locationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.refreshBtn.mas_bottom);
        make.size.mas_equalTo(kRealHeight(60), kRealHeight(60));
    }];

    [super updateViewConstraints];
}

- (GNStoreMapFootView *)footView {
    if (!_footView) {
        _footView = GNStoreMapFootView.new;
    }
    return _footView;
}

- (SAMapView *)mapView {
    if (!_mapView) {
        _mapView = SAMapView.new;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (HDUIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"gn_store_map_location"] forState:UIControlStateNormal];
        _locationBtn.titleLabel.font = [HDAppTheme.font forSize:13.0];
        [_locationBtn setTitle:GNLocalizedString(@"gn_location_position", @"定位") forState:UIControlStateNormal];
        [_locationBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        _locationBtn.spacingBetweenImageAndTitle = kRealHeight(2);
        _locationBtn.imagePosition = HDUIButtonImagePositionTop;
        @HDWeakify(self)[_locationBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.locationUser = YES;
            if (HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusNotAuthed) {
                [SALocationUtil showUnAuthedTipConfirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                    [HDSystemCapabilityUtil openAppSystemSettingPage];
                } cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
                return;
            }
            if (HDLocationUtils.getCLAuthorizationStatus == HDCLAuthorizationStatusAuthed && HDLocationManager.shared.isCurrentCoordinate2DValid) {
                self.userAnnotation.coordinate = HDLocationManager.shared.coordinate2D;
                [self.mapView.mapView setRegion:MKCoordinateRegionMake(self.userAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
            } else {
                [self requestLocation];
            }
        }];
    }
    return _locationBtn;
}

- (HDUIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.titleLabel.font = [HDAppTheme.font forSize:13.0];
        [_refreshBtn setImage:[UIImage imageNamed:@"gn_store_map_refresh"] forState:UIControlStateNormal];
        [_refreshBtn setTitle:GNLocalizedString(@"gn_location_refresh", @"刷新") forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        _refreshBtn.imagePosition = HDUIButtonImagePositionLeft;
        _refreshBtn.spacingBetweenImageAndTitle = kRealHeight(2);
        _refreshBtn.imagePosition = HDUIButtonImagePositionTop;
        @HDWeakify(self)[_refreshBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self.mapView.mapView setRegion:MKCoordinateRegionMake(self.storeAnnotation.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
        }];
    }
    return _refreshBtn;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = UIView.new;
        _rightView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        _rightView.layer.cornerRadius = kRealHeight(8);
    }
    return _rightView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    }
    return _lineView;
}

- (SAAnnotation *)storeAnnotation {
    if (!_storeAnnotation) {
        _storeAnnotation = SAAnnotation.new;
        _storeAnnotation.type = SAAnnotationTypeMerchant;
        _storeAnnotation.logoImage = [UIImage imageNamed:@"gn_store_map_user"];
        _storeAnnotation.subTitle = self.storeModel.storeName.desc;
        _storeAnnotation.title = self.storeModel.storeName.desc;
        _storeAnnotation.tipTitle = self.storeModel.storeName.desc;
        _storeAnnotation.coordinate = CLLocationCoordinate2DMake(self.storeModel.geoPointDTO.lat.doubleValue, self.storeModel.geoPointDTO.lon.doubleValue);
    }
    return _storeAnnotation;
}

- (SAAnnotation *)userAnnotation {
    if (!_userAnnotation) {
        _userAnnotation = SAAnnotation.new;
        _userAnnotation.type = SAAnnotationTypeConsignee;
        _userAnnotation.logoImage = [UIImage imageNamed:@"gn_store_map_position"];
        _userAnnotation.subTitle = GNLocalizedString(@"gn_location_current", @"当前位置");
        _userAnnotation.title = GNLocalizedString(@"gn_location_current", @"当前位置");
        _userAnnotation.tipTitle = GNLocalizedString(@"gn_location_current", @"当前位置");
        HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
        if (status == HDCLAuthorizationStatusAuthed && HDLocationManager.shared.isCurrentCoordinate2DValid) {
            _userAnnotation.coordinate = HDLocationManager.shared.coordinate2D;
        }
    }
    return _userAnnotation;
}

- (void)setStoreNo:(NSString *)storeNo {
    _storeNo = storeNo;
    if (!self.storeModel && storeNo) {
        @HDWeakify(self)[self.homeDTO merchantDetailStoreNo:storeNo productCode:nil success:^(GNStoreDetailModel *_Nonnull detailModel) {
            @HDStrongify(self) self.storeModel = detailModel;
            self.storeAnnotation.coordinate = CLLocationCoordinate2DMake(self.storeModel.geoPointDTO.lat.doubleValue, self.storeModel.geoPointDTO.lon.doubleValue);
            [self hd_bindViewModel];
        } failure:nil];
    }
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (BOOL)needLogin {
    return NO;
}

- (BOOL)needClose {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

@end
