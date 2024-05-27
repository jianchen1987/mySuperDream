//
//  SAMessageDetailRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessageDetailRspModel.h"


@implementation SAMessageDetailRspModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *messageName = dic[@"messageName"];
    if ([messageName isKindOfClass:NSString.class]) {
        NSDictionary *messageNameDict = messageName.hd_dictionary;
        _messageName = [SAInternationalizationModel yy_modelWithJSON:messageNameDict];
    };
    NSString *messageContent = dic[@"messageContent"];
    if ([messageContent isKindOfClass:NSString.class]) {
        NSDictionary *messageContentDict = messageContent.hd_dictionary;
        _messageContent = [SAInternationalizationModel yy_modelWithJSON:messageContentDict];
    };
    return YES;
}
@end
