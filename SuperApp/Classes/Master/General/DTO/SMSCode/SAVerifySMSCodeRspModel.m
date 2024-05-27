//
//  SAVerifySMSCodeRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAVerifySMSCodeRspModel.h"


@implementation SAVerifySMSCodeRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"apiTicket": @[@"accessToken", @"apiTicket"]};
}
@end
