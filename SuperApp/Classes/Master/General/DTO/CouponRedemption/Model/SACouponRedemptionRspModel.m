//
//  SACouponRedemptionRspModel.m
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionRspModel.h"


@interface SACouponRedemptionRspModel ()

@property (nonatomic, copy) NSString *activityNameZh;
@property (nonatomic, copy) NSString *activityNameEn;
@property (nonatomic, copy) NSString *activityNameKh;

@end


@implementation SACouponRedemptionRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SACouponTicketModel.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list": @"receivedCouponList"};
}

#pragma mark - setter
- (void)setActivityNameEn:(NSString *)activityNameEn {
    _activityNameEn = activityNameEn;
    self.activityName.en_US = activityNameEn;
}

- (void)setActivityNameKh:(NSString *)activityNameKh {
    _activityNameKh = activityNameKh;
    self.activityName.km_KH = activityNameKh;
}

- (void)setActivityNameZh:(NSString *)activityNameZh {
    _activityNameZh = activityNameZh;
    self.activityName.zh_CN = activityNameZh;
}

#pragma mark - lazy load
- (SAInternationalizationModel *)activityName {
    if (!_activityName) {
        _activityName = SAInternationalizationModel.new;
    }
    return _activityName;
}

@end
