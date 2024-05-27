//
//  WMModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"


@implementation WMModel
- (NSString *)mShowTime {
    if (!_mShowTime) {
        _mShowTime = @(NSDate.date.timeIntervalSince1970).stringValue;
    }
    return _mShowTime;
}
@end
