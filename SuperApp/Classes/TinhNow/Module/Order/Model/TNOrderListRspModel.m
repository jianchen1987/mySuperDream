//
//  TNOrderListRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListRspModel.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNOrderProductItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productId": @"id"};
}
@end


@implementation TNOrderStoreInfo

@end


@implementation TNOrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderItems": [TNOrderProductItemModel class]};
}
- (void)setStatus:(TNOrderState)status {
    _status = status;
    if ([status isEqualToString:TNOrderStatePendingReview]) {
        self.statusColor = HDAppTheme.TinhNowColor.G1;
    } else if ([status isEqualToString:TNOrderStatePendingPayment]) {
        self.statusColor = HDAppTheme.TinhNowColor.C1;
    } else if ([status isEqualToString:TNOrderStatePendingShipment]) {
        self.statusColor = HDAppTheme.TinhNowColor.G1;
    } else if ([status isEqualToString:TNOrderStateShipped]) {
        self.statusColor = HDAppTheme.TinhNowColor.G1;
    } else if ([status isEqualToString:TNOrderStateCompleted]) {
        self.statusColor = HexColor(0x14B96D);
    } else if ([status isEqualToString:TNOrderStateCanceled]) {
        self.statusColor = HDAppTheme.TinhNowColor.G3;
    } else {
        self.statusColor = HDAppTheme.TinhNowColor.G1;
    }
}
@end


@implementation TNOrderListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNOrderModel class]};
}
@end
