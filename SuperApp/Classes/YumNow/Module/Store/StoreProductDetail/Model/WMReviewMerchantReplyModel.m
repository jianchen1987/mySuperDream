//
//  WMReviewMerchantReplyModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMReviewMerchantReplyModel.h"


@implementation WMReviewMerchantReplyModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"reviewId": @"id"};
}

- (void)setStatus:(SABoolValue)status {
    if ([@[@"1", @"true", @"yes", @"enable"] containsObject:status.lowercaseString]) {
        _status = SABoolValueTrue;
    } else {
        _status = SABoolValueFalse;
    }
}
@end
