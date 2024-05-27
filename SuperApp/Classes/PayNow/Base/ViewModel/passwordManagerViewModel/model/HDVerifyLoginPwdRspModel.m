//
//  HDVerifyLoginPwdRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/13.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDVerifyLoginPwdRspModel.h"
#import "PNUtilMacro.h"


@implementation HDVerifyLoginPwdRspModel

- (BOOL)parse {
    if ([super parse]) {
        if ([self.rspCd isEqualToString:RSP_SUCCESS_CODE]) {
            NSDictionary *datas = self.data;
            self.accessToken = [datas valueForKey:@"accessToken"];
        }

        return YES;
    }
    return NO;
}
@end
