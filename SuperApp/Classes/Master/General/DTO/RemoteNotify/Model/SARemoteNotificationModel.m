//
//  SARemoteNotificationModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARemoteNotificationModel.h"


@implementation SARemoteNotificationAPSAlertModel

@end


@implementation SARemoteNotificationAPSModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"contentAvailable": @"content-available", @"mutableContent": @"mutable-content"};
}
@end


@implementation SARemoteNotificationModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"googleCAE": @"google.c.a.e", @"messageID": @"gcm.message_id"};
}
@end
