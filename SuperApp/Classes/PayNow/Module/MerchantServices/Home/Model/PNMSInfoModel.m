//
//  PNMSInfoModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSInfoModel.h"


@implementation PNMSInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"merchantList": [PNMSMerchantListModel class]};
}
@end


@implementation PNMSMerchantListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"balanceInfos": [PNMSBalanceInfoModel class]};
}
@end


@implementation PNMSBalanceInfoModel

@end
