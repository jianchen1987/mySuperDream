//
//  WebServiceRequestData.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/24.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceRequestDataClass.h"

@implementation HDWebServiceRequestDataClass

- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    switch (type) {
        case HDWebFeatureNetworkRequestData:
            return @"HDWebFeatureNetworkRequestData";  //网络请求数据
        default:
            return @"";
    }
}
@end
