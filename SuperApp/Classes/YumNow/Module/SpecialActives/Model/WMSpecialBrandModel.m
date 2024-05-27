//
//  WMSpecialBrandModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSpecialBrandModel.h"


@implementation WMSpecialBrandModel
- (NSString *)showTime {
    if (!_showTime) {
        _showTime = @(NSDate.date.timeIntervalSince1970).stringValue;
    }
    return _showTime;
}
@end
