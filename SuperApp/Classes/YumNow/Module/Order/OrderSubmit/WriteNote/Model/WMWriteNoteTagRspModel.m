//
//  WMWriteNoteTagRspModel.m
//  SuperApp
//
//  Created by wmz on 2023/2/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMWriteNoteTagRspModel.h"


@implementation WMWriteNoteTagRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"codeStr": @"code",
    };
}

- (NSString *)infactStr {
    if (!_infactStr) {
        _infactStr = self.name.desc;
    }
    return _infactStr;
}
@end
