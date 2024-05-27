//
//  SACommonrefundInfoModel.m
//  SuperApp
//
//  Created by Tia on 2022/5/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundInfoModel.h"


@implementation SACommonRefundOperateListModel

@end


@implementation SACommonRefundOfflineRefundOrderDetailModel

@end


@implementation SACommonRefundInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"refundOrderOperateList": SACommonRefundOperateListModel.class,
    };
}

@end
