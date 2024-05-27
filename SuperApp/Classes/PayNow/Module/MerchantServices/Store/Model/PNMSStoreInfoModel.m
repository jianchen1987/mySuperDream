//
//  PNMSStoreInfoModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreInfoModel.h"


@implementation PNMSStoreInfoModel

- (NSString *)statusStr {
    NSString *str = @"";
    if ([self.status isEqualToString:@"ENABLE"]) {
        str = PNLocalizedString(@"pn_Active", @"正常");
    } else if ([self.status isEqualToString:@"CLOSE"]) {
        str = PNLocalizedString(@"pn_Suspended", @"停用");
    }
    return str;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"role": @"role.code",
        @"roleStr": @"role.message",
    };
}
@end
