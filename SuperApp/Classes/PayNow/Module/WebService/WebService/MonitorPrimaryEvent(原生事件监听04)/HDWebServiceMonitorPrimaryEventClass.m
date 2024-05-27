//
//  HDWebServiceMonitorPrimaryEventClass.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceMonitorPrimaryEventClass.h"

@implementation HDWebServiceMonitorPrimaryEventClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebFeatureMonitorBack:
            return @"HDWebFeatureMonitorBack";
        case HDWebFeatureMonitorRight:
            return @"HDWebFeatureMonitorRight";
        case HDWebFeatureMonitorTitleView:
            return @"HDWebFeatureMonitorTitleView";
        case HDWebFeatureMonitorEnterNativePage:
            return @"HDWebFeatureMonitorEnterNativePage";
        case HDWebFeatureMonitorLeaveNativePage:
            return @"HDWebFeatureMonitorLeaveNativePage";
        default:
            return @"";
    }
}

@end
