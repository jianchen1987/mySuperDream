//
//  WNHomeViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WNHomeViewController.h"
#import "SAAddressModel.h"
#import "SAAppConfigDTO.h"
#import "SAMarketingAlertView.h"
#import "SATalkingData.h"
#import <MJRefresh/MJRefresh.h>
#import "SAAddressCacheAdaptor.h"
#import "LKDataRecord.h"

@interface WNHomeViewController ()
/// 弹窗广告DTO
@property (nonatomic, strong) SAAppConfigDTO *appConfigDTO;
///< 当前地址
@property (nonatomic, strong) SAAddressModel *currentlyAddress;
/// 记录是否已出现过广告弹窗
@property (nonatomic, strong) NSMutableSet *adSet;

@end


@implementation WNHomeViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [dic setObject:@"WOWNOW_HOME3.0_O2O" forKey:@"pageLabel"];
    return [super initWithRouteParameters:dic];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessHandler:) name:kNotificationNameLoginSuccess object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameLoginSuccess object:nil];
}


#pragma mark - OverWrite
- (void)locationDidChanged:(SAAddressModel *)address {
    [self queryAppMarketingAlertWithAddress:address forceUpdate:NO];
}

- (void)firstLoadSuccessHandler {
    [self activityAlertShow];
}

#pragma mark - notification
- (void)loginSuccessHandler:(NSNotification *)notification {
    // 登录后重新请求一次广告，把未登录的广告逻辑刷新
    [self queryAppMarketingAlertWithAddress:self.currentlyAddress forceUpdate:YES];
}


#pragma mark - private methods
// 展示弹窗广告
- (void)activityAlertShow {
    // 当前展示页面不是本页面，不展示广告
    //    if (SAWindowManager.visibleViewController != self) return;
    NSMutableArray<SAMarketingAlertViewConfig *> *shouldShow = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray<SAMarketingAlertViewConfig *> *marketingAlertConfigs = [SACacheManager.shared objectForKey:kCacheKeyMarketingAlertConfigs
                                                                                                  type:SACacheTypeDocumentPublic
                                                                                          relyLanguage:NO];
    for (SAMarketingAlertViewConfig *config in marketingAlertConfigs) {
        if ([config isValidWithLocation:@"10"] && ![self.adSet containsObject:config.activityId]) {
            config.showInClass = [self class];
            [self.adSet addObject:config.activityId];
            [shouldShow addObject:config];
        }
    }
    
    if(shouldShow.count) {
        SAMarketingAlertView *alertView = [SAMarketingAlertView alertViewWithConfigs:shouldShow];
        // 跳转前拦截 埋点
        alertView.willJumpTo = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"WOWNOW" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationWOWNOWAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"enter",
                @"businessLine": SAClientTypeMaster
            }];
            
            NSMutableDictionary *parameters = @{}.mutableCopy;
            parameters[@"adNo"] = adId;
            parameters[@"jumpLink"] = link;
            [LKDataRecord.shared traceEvent:@"click_pop_up_advertisement" name:@"wownow首页弹窗_点击" parameters:parameters];
        };
        // 关闭前拦截 埋点
        alertView.willClose = ^(NSString *_Nonnull adId, NSString *_Nonnull adTitle, NSString *_Nonnull imageUrl, NSString *_Nonnull link) {
            [SATalkingData SATrackEvent:@"弹窗广告" label:@"WOWNOW" parameters:@{
                @"userId": [SAUser hasSignedIn] ? SAUser.shared.loginName : @"",
                @"bannerId": adId,
                @"bannerLocation": [NSNumber numberWithUnsignedInteger:SAWindowLocationWOWNOWAlertWindow],
                @"bannerTitle": adTitle,
                @"clickTime": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                @"link": link,
                @"imageUrl": imageUrl,
                @"action": @"close",
                @"businessLine": SAClientTypeMaster
            }];
            [LKDataRecord.shared traceEvent:@"close_pop_up_advertisement" name:@"wownow首页弹窗_关闭" parameters:nil];
        };
        [alertView show];
    }
}

/// 获取弹窗广告
/// @param addressModel 当前位置
/// @param force 是否强制刷新
- (void)queryAppMarketingAlertWithAddress:(SAAddressModel *)addressModel forceUpdate:(BOOL)force {
    if (!HDIsObjectNil(self.currentlyAddress) &&
        [HDLocationUtils distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.currentlyAddress.lat.doubleValue longitude:self.currentlyAddress.lon.doubleValue]
                                   toLocation:[[CLLocation alloc] initWithLatitude:addressModel.lat.doubleValue longitude:addressModel.lon.doubleValue]]
            < 50.0
        && !force) {
        HDLog(@"位置变化不大，不需要重新拉取广告数据");
        return;
    }

    self.currentlyAddress = addressModel;
    [self.appConfigDTO queryAppMarketingAlertWithType:SAClientTypeMaster
                                             province:addressModel.city
                                             district:addressModel.subLocality
                                             latitude:addressModel.lat
                                            longitude:addressModel.lon
                                              success:^(NSArray<SAMarketingAlertViewConfig *> *_Nonnull list) {
                                                  [SACacheManager.shared setObject:list forKey:kCacheKeyMarketingAlertConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
//                                                  [self activityAlertShow];
                                              }
                                              failure:nil];
}

- (BOOL)allowContinuousBePushed {
    return NO;
}

#pragma mark - lazy load
- (SAAppConfigDTO *)appConfigDTO {
    return _appConfigDTO ?: ({ _appConfigDTO = SAAppConfigDTO.new; });
}

- (NSMutableSet *)adSet {
    if (!_adSet) {
        _adSet = [NSMutableSet set];
    }
    return _adSet;
}

@end
