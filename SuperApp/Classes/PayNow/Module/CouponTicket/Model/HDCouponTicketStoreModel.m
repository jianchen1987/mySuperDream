//
//  HDCouponTicketStoreModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketStoreModel.h"
#import "HDLocationUtils.h"


@implementation HDCouponTicketStoreModel

- (void)setStoreAddress:(NSString *)storeAddress {
    _storeAddress = storeAddress;

    if (storeAddress && storeAddress.length) {
        _shouldShowAddressInfo = YES;
    } else {
        _shouldShowAddressInfo = NO;
    }
}

- (NSString *)storeFullAddress {
    return [NSString stringWithFormat:@"%@,%@,%@,%@", self.storeAddress, self.city, self.province, self.area];
}

- (void)setStoreTel:(NSString *)storeTel {
    _storeTel = storeTel;

    if (storeTel && storeTel.length) {
        _shouldShowPhoneInfo = YES;
    } else {
        _shouldShowPhoneInfo = NO;
    }
}

- (BOOL)shouldShowOpenTimeInfo {
    // 两个字段都为空代表24小时营业，该字段必显示
    return YES;
}

- (double)distanceFromUserToStore {
    if (_storeLat.length <= 0 || _storeLot.length <= 0 || _userLocationLongitude == 0 || _userLocationLatitude == 0 || !_isGetUserLocationSuccess)
        return 0;

    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_userLocationLatitude longitude:_userLocationLongitude];
    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:_storeLat.doubleValue longitude:_storeLot.doubleValue];
    return [HDLocationUtils distanceFromLocation:userLocation toLocation:storeLocation];
}
@end
