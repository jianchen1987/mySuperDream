//
//  TNWithdrawBindModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawBindModel.h"


@implementation TNWithdrawPayCompanyModel

@end


@implementation TNWithdrawBindModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"paymentCompanyRespDTOList": [TNWithdrawPayCompanyModel class]};
}
@end
