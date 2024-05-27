//
//  WebServiceLanguage.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/20.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//
#import "HDWebServiceLanguageClass.h"

@implementation HDWebServiceLanguageClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebFeatureLanguage:
            return @"HDWebFeatureLanguage";
        default:
            return @"";
    }
}

@end
