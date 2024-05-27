//
//  TNIMManagerHander.m
//  SuperApp
//
//  Created by xixi on 2021/5/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIMManagerHander.h"
#import "SAWindowManager.h"


@implementation TNIMManagerHander

+ (instancetype)sharedInstance {
    static TNIMManagerHander *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:nil] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

#pragma mark 解析数据构造 路由
- (void)openViewController:(NSString *)card {
    NSDictionary *dict = [card hd_dictionary];
    NSString *typeStr = [dict objectForKey:@"type"];
    NSString *valueStr = [dict objectForKey:@"value"];
    NSDictionary *valueDict = [valueStr hd_dictionary];
    NSString *paramStr = [self splicingParameter:valueDict];
    NSString *routPath = @"";
    if ([typeStr isEqualToString:@"productDetails"]) {
        routPath = [NSString stringWithFormat:@"SuperApp://TinhNow/productDetails?%@", paramStr];
    } else if ([typeStr isEqualToString:@"orderDetail"]) {
        //        routPath = [NSString stringWithFormat:@"SuperApp://TinhNow/orderDetail?orderNo=%@", valueStr];
    }

    [SAWindowManager openUrl:routPath withParameters:nil];
}

#pragma mark Tool
- (NSString *)splicingParameter:(NSDictionary *)dict {
    __block NSString *str = @"";
    if (dict) {
        NSArray *keys = dict.allKeys;
        [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (idx == 0) {
                str = [str stringByAppendingFormat:@"%@=%@", obj, dict[obj]];
            } else {
                str = [str stringByAppendingFormat:@"&%@=%@", obj, dict[obj]];
            }
        }];
    }

    return str;
}

#pragma mark KSChatViewControllerDelegate
/// 点击卡片回调
- (void)didClickedOnInfoCard:(KSChatFloatCardViewModel *)card {
    /// 如果是商品的卡片类型
    if ([card isKindOfClass:KSChatGoodsFloatCardViewModel.class]) {
        NSLog(@"%@", card);
        NSString *extensionJson = card.extensionJson;
        if (HDIsStringNotEmpty(extensionJson)) {
            [self openViewController:card.extensionJson];
        }
    }
}

@end
