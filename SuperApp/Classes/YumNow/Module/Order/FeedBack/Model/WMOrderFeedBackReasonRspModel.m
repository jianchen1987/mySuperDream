//
//  WMOrderFeedBackReasonRspModel.m
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackReasonRspModel.h"


@implementation WMOrderFeedBackReasonRspModel
- (NSString *)showName {
    return self.reason.desc;
}
@end
