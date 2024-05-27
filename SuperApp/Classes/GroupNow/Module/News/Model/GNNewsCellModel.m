//
//  GNNewsCellModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsCellModel.h"
#import "SAGeneralUtil.h"
#import "SAInternationalizationModel.h"


@implementation GNNewsCellModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *messageName = dic[@"messageName"];
    if ([messageName isKindOfClass:NSString.class]) {
        NSDictionary *messageNameDict = messageName.hd_dictionary;
        self.messageName = [SAInternationalizationModel yy_modelWithJSON:messageNameDict];
    }
    NSString *messageContent = dic[@"messageContent"];
    if ([messageContent isKindOfClass:NSString.class]) {
        NSDictionary *messageContentDict = messageContent.hd_dictionary;
        self.messageContent = [SAInternationalizationModel yy_modelWithJSON:messageContentDict];
    };

    NSString *prefix = @"${", *suffix = @"}";
    NSArray<NSString *> *messageContents = @[self.messageContent.zh_CN, self.messageContent.en_US, self.messageContent.km_KH];
    // 替换时间戳
    for (NSUInteger i = 0; i < messageContents.count; i++) {
        NSString *destStr = messageContents[i];

        NSRange prefixRange = [destStr rangeOfString:prefix];
        NSRange suffixRange = [destStr rangeOfString:suffix];

        NSRange timeStampStrRange = NSMakeRange(prefixRange.location + prefixRange.length, suffixRange.location - prefixRange.length - prefixRange.location);
        NSString *timeStampStr = [destStr substringWithRange:timeStampStrRange];
        // 替换
        if (HDIsStringNotEmpty(timeStampStr)) {
            // 计算时间
            NSString *dateStr = [SAGeneralUtil getDateStrWithTimeInterval:timeStampStr.integerValue / 1000.0 dateFormat:@"dd/MM/yyyy HH:mm" dateInTodayFormat:@"dd/MM/yyyy HH:mm"];
            NSString *needReplaceStr = [NSString stringWithFormat:@"%@%@%@", prefix, timeStampStr, suffix];
            NSString *str = [destStr stringByReplacingOccurrencesOfString:needReplaceStr withString:dateStr];
            if (i == 0) {
                self.messageContent.zh_CN = str;
            } else if (i == 1) {
                self.messageContent.en_US = str;
            } else if (i == 2) {
                self.messageContent.km_KH = str;
            }
        }
    }
    return YES;
}

@end
