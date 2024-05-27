//
//  SASystemMessageModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageModel.h"
#import "NSDate+SAExtension.h"
#import "SAGeneralUtil.h"


@implementation SAMessageAction

@end


@implementation SASystemMessageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buttonList": SAMessageAction.class};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *messageName = dic[@"messageName"];
    if ([messageName isKindOfClass:NSString.class]) {
        NSDictionary *messageNameDict = messageName.hd_dictionary;
        _messageName = [SAInternationalizationModel yy_modelWithJSON:messageNameDict];
    }
    NSString *messageContent = dic[@"messageContent"];
    if ([messageContent isKindOfClass:NSString.class]) {
        NSDictionary *messageContentDict = messageContent.hd_dictionary;
        _messageContent = [SAInternationalizationModel yy_modelWithJSON:messageContentDict];
    };

    NSString *prefix = @"${", *suffix = @"}";
    NSArray<NSString *> *messageContents = @[_messageContent.zh_CN, _messageContent.en_US, _messageContent.km_KH];
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
            NSString *dateStr = [SAGeneralUtil getDateStrWithTimeInterval:timeStampStr.integerValue / 1000.0 dateFormat:@"dd/MM/yyyy HH:mm" dateInTodayFormat:@"HH:mm"];
            NSString *needReplaceStr = [NSString stringWithFormat:@"%@%@%@", prefix, timeStampStr, suffix];
            NSString *str = [destStr stringByReplacingOccurrencesOfString:needReplaceStr withString:dateStr];

            if (i == 0) {
                _messageContent.zh_CN = str;
            } else if (i == 1) {
                _messageContent.en_US = str;
            } else if (i == 2) {
                _messageContent.km_KH = str;
            }
        }
    }
    return YES;
}
@end
