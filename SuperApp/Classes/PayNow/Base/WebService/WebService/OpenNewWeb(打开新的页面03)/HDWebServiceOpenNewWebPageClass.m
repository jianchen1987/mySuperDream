//
//  WebServiceOpenNewWebClass.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/8/7.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceOpenNewWebPageClass.h"

@implementation HDWebServiceOpenNewWebPageClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebFeatureOpenNewWeb:
            return @"HDWebFeatureOpenNewWeb";
        default:
            return @"";
    }
}

@end
