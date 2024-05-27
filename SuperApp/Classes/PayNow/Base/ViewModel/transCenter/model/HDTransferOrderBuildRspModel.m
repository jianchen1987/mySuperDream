//
//  HDTransferOrderBuildRspModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/8.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDTransferOrderBuildRspModel.h"
#import "PNCommonUtils.h"
#import "PNUtilMacro.h"


@implementation HDTransferOrderBuildRspModel

- (BOOL)parse {
    if ([super parse]) {
        if ([self.rspCd isEqualToString:RSP_SUCCESS_CODE]) {
            //            [self parseAllObject];
            NSDictionary *data = self.data;
            if (![data isEqual:[NSNull null]]) {
                self.tradeType = (PNTransType)[data valueForKey:@"tradeType"];
                self.tradeNo = [data valueForKey:@"tradeNo"];
                self.payeeNo = [data valueForKey:@"payeeNo"];
                self.payeeName = [data valueForKey:@"payeeName"];
                self.headUrl = [data valueForKey:@"headUrl"];
                NSString *temp = [data valueForKey:@"amt"];
                if (temp && [temp isEqual:[NSNull null]]) {
                    self.amt = @"";
                    self.cy = @"";
                } else {
                    //                    self.amt = [NSString stringWithFormat:@"%0.2f", [[data valueForKey:@"amt"] integerValue] / 100.0];
                    self.amt = [PNCommonUtils fenToyuan:temp];
                    self.cy = [data valueForKey:@"cy"];
                }

                NSString *tmp = [data valueForKey:@"payeeAmt"];
                if (tmp && [tmp isEqual:[NSNull null]]) {
                    self.payeeAmt = @"";
                    self.payeeCy = @"";
                } else {
                    //                    self.payeeAmt = [NSString stringWithFormat:@"%0.2f", [[data valueForKey:@"payeeAmt"] integerValue] / 100.0];
                    self.payeeAmt = [PNCommonUtils fenToyuan:tmp];
                    self.payeeCy = [data valueForKey:@"payeeCy"];
                }
            }
        }

        return YES;
    }
    return NO;
}
@end
