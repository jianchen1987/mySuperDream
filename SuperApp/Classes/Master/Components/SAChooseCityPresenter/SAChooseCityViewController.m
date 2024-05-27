//
//  SAChooseCityViewController.m
//  SuperApp
//
//  Created by seeu on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChooseCityViewController.h"
#import "SAAddressZoneModel.h"
#import "SAApolloManager.h"
#import "SAChooseCityView.h"
#import "SAChooseCityViewModel.h"
#import "SALocationUtil.h"


@interface SAChooseCityViewController ()
/// 内容
@property (nonatomic, strong) SAChooseCityView *contentView;
/// VM
@property (nonatomic, strong) SAChooseCityViewModel *viewModel;
/// 保存定位成功后需要做的操作
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);
@end


@implementation SAChooseCityViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(SAAddressZoneModel *) = parameters[@"callback"];
    self.viewModel.callback = callback;

    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    [self.view setNeedsUpdateConstraints];

    // 监听位置权限变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];
    // 监听位置管理器位置变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];

    // 检查权限
    [self setAddressWithCurrentLocation];
    // 获取热门城市
    [self getHotCitys];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"choose_city_title", @"选择城市");
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
}

#pragma mark - HDLocationManagerProtocol
- (void)locationManagerMonitoredLocationPermissionChanged:(NSNotification *)notification {
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status != HDCLAuthorizationStatusNotDetermined && self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
    }
}

- (void)locationManagerMonitoredLocationChanged:(NSNotification *)notification {
    if (self.locationManagerLocateSuccessHandler) {
        self.locationManagerLocateSuccessHandler();
    }
}

#pragma mark - private methods
- (void)setAddressWithCurrentLocation {
    self.locationManagerLocateSuccessHandler = nil;

    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;
    if (status == HDCLAuthorizationStatusAuthed) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;

            [SALocationUtil transferCoordinateToAddress:coordinate2D completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary *_Nullable addressDictionary) {
                SAAddressZoneModel *model = SAAddressZoneModel.new;
                model.radius = 20000;
                model.latitude = [NSNumber numberWithDouble:coordinate2D.latitude];
                model.longitude = [NSNumber numberWithDouble:coordinate2D.longitude];
                model.zlevel = SAAddressZoneLevelProvince;
                NSString *subLocality = addressDictionary[SAAddressKeyCity];
                if (HDIsStringEmpty(subLocality)) {
                    subLocality = addressDictionary[SAAddressKeyState];
                }
                model.message = [SAInternationalizationModel modelWithCN:subLocality en:subLocality kh:subLocality];
                [self.contentView setupLocation:model];
            }];
        } else {
            [HDLocationManager.shared startUpdatingLocation];
            @HDWeakify(self);
            self.locationManagerLocateSuccessHandler = ^{
                @HDStrongify(self);
                [self setAddressWithCurrentLocation];
            };
        }
    } else if (status == HDCLAuthorizationStatusNotDetermined) {
        [HDLocationManager.shared requestWhenInUseAuthorization];
        @HDWeakify(self);
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self);
            [self setAddressWithCurrentLocation];
        };
    }
}

- (void)getHotCitys {
    NSDictionary *map = [SAApolloManager getApolloConfigForKey:ApolloConfigKeyMap];
    NSArray<SAAddressZoneModel *> *hotCitys = [NSArray yy_modelArrayWithClass:SAAddressZoneModel.class json:map[ApolloConfigKeyMapHotCity]];
    [self.contentView setupHotCitys:hotCitys];
}

#pragma mark - lazy load
- (SAChooseCityView *)contentView {
    return _contentView ?: ({ _contentView = [[SAChooseCityView alloc] initWithViewModel:self.viewModel]; });
}

- (SAChooseCityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAChooseCityViewModel alloc] init];
    }
    return _viewModel;
}

@end
