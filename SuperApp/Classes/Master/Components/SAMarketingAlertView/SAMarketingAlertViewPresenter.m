//
//  SAMarketingAlertViewPresenter.m
//  SuperApp
//
//  Created by seeu on 2021/11/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMarketingAlertViewPresenter.h"
#import "SAAddressModel.h"
#import "SAAppConfigDTO.h"
#import "SALocationUtil.h"
#import "SATalkingData.h"
#import "SAUser.h"
#import <HDServiceKit/HDLocationManager.h>


@interface SAMarketingAlertViewPresenter ()

@property (nonatomic, strong) SAAppConfigDTO *configDto; ///<
////// 保存定位成功后需要做的操作
@property (nonatomic, copy) void (^locationManagerLocateSuccessHandler)(void);

@end


@implementation SAMarketingAlertViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        // 监听位置权限变化
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationPermissionChanged:) name:kNotificationNameLocationPermissionChanged object:nil];
        // 监听位置管理器位置变化
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(locationManagerMonitoredLocationChanged:) name:kNotificationNameLocationChanged object:nil];
    }

    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationPermissionChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
}

+ (void)showMarketingAlertAboutUserLoginActivity {
    if (![SAUser hasSignedIn]) {
        return;
    }
    SAMarketingAlertViewPresenter *present = SAMarketingAlertViewPresenter.new;
    [present setAddressWithCurrentLocation];
}

#pragma mark - private methods
- (void)setAddressWithCurrentLocation {
    self.locationManagerLocateSuccessHandler = nil;
//TODO: 需要处理手填地址的逻辑
    HDCLAuthorizationStatus status = HDLocationUtils.getCLAuthorizationStatus;

    if (status == HDCLAuthorizationStatusAuthed) { // 有授权，拿到定位在查
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;

            [SALocationUtil transferCoordinateToAddress:coordinate2D completion:^(NSString *_Nullable address, NSString *_Nullable consigneeAddress, NSDictionary *_Nullable addressDictionary) {
                SAAddressModel *addressModel = [SAAddressModel addressModelWithAddressDictionary:addressDictionary];
                addressModel.lat = @(coordinate2D.latitude);
                addressModel.lon = @(coordinate2D.longitude);
                addressModel.address = address;
                addressModel.consigneeAddress = consigneeAddress;
                addressModel.fromType = SAAddressModelFromTypeLocate;

                [self queryLoginMarketingAlert:addressModel];
            }];
        } else {
            [HDLocationManager.shared startUpdatingLocation];
            @HDWeakify(self);
            self.locationManagerLocateSuccessHandler = ^{
                @HDStrongify(self);
                [self setAddressWithCurrentLocation];
            };
        }
    } else if (status == HDCLAuthorizationStatusNotAuthed) { //拒绝授权，直接查
        [self queryLoginMarketingAlert:nil];
    } else if (status == HDCLAuthorizationStatusNotDetermined) { // 没授权，授权后查
        [HDLocationManager.shared requestWhenInUseAuthorization];
        @HDWeakify(self);
        self.locationManagerLocateSuccessHandler = ^{
            @HDStrongify(self);
            [self setAddressWithCurrentLocation];
        };
    }
}

- (void)queryLoginMarketingAlert:(SAAddressModel *_Nullable)address {
    [self.configDto queryLoginMarketingAlertWithType:SAClientTypeMaster
                                            province:address ? address.city : nil
                                            district:address ? address.subLocality : nil
                                            latitude:address.lat
                                           longitude:address.lon
                                          operatorNo:SAUser.shared.operatorNo success:^(NSArray<SAMarketingAlertViewConfig *> *_Nonnull list) {
                                              [self activityAlertShow:list];
                                          } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

                                          }];
}

- (void)activityAlertShow:(NSArray<SAMarketingAlertViewConfig *> *)list {
    NSMutableArray<SAMarketingAlertViewConfig *> *shouldShow = [[NSMutableArray alloc] initWithCapacity:1];
    for (SAMarketingAlertViewConfig *config in list) {
        if ([config isValidWithLocation:@"10"]) {
            [shouldShow addObject:config];
        }
    }
    
    if(shouldShow.count) {
        SAMarketingAlertView *alertView = [SAMarketingAlertView alertViewWithConfigs:shouldShow];
        alertView.willJumpTo = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"登陆弹窗" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": @(99),
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"enter",
                @"businessLine": SAClientTypeMaster
            }];
        };
        alertView.willClose = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"登陆弹窗" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": @(99),
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"close",
                @"businessLine": SAClientTypeMaster
            }];
        };
        [alertView show];
    }
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

#pragma mark - lazy load
- (SAAppConfigDTO *)configDto {
    if (!_configDto) {
        _configDto = SAAppConfigDTO.new;
    }
    return _configDto;
}

@end
