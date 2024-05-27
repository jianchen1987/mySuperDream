//
//  SAMessageCenterListCellModel.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterListModel.h"


@implementation SAMessageCenterListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"messageRespList": SASystemMessageModel.class,
    };
}

@end
