//
//  PNPacketFriendsUserModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsUserModel.h"
#import "VipayUser.h"


@implementation PNPacketFriendsUserModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"otherUser": PNPacketFriendsUserModel.class,
    };
}

- (BOOL)isMe {
    if ([VipayUser.shareInstance.loginName isEqualToString:self.userPhone]) {
        return YES;
    } else {
        return NO;
    }
}
@end
