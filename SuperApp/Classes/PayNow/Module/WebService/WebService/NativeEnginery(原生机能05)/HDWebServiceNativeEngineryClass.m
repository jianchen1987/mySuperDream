//
//  HDWebServiceNativeEngineryClass.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceNativeEngineryClass.h"

@implementation HDWebServiceNativeEngineryClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebFeatureShowLoading:
            return @"HDWebFeatureShowLoading";
        case HDWebFeatureDismiss:
            return @"HDWebFeatureDismiss";
        case HDWebFeatureAlertSure:
            return @"HDWebFeatureAlertSure";
        case HDWebFeatureAlertSelectSure:
            return @"HDWebFeatureAlertSelectSure";
        case HDWebFeatureClearNavigation:
            return @"HDWebFeatureClearNavigation";
        case HDWebFeaturePageSkipping:
            return @"HDWebFeaturePageSkipping";
        case HDWebFeatureShare:
            return @"HDWebFeatureShare";
        case HDWebFeatureContacts:
            return @"HDWebFeatureContacts";
        default:
            return @"";
    }
}

@end
