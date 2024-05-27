//
//  WebServiceNativeElement.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceNativeElementClass.h"

@implementation HDWebServiceNativeElementClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebServiceLeftButtonView:
            return @"HDWebServiceLeftButtonView";
        case HDWebServiceRightButtonView:
            return @"HDWebServiceRightButtonView";
        case HDWebServicetitleView:
            return @"HDWebServicetitleView";
        default:
            return @"";
    }
}

@end
