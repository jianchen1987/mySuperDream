//
//  HDOnlinePaymentToolsModel.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDOnlinePaymentToolsModel.h"


@implementation HDOnlinePaymentToolsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"method": @"code"};
}
+ (instancetype)modelWithToolsCode:(HDCheckStandPaymentTools)tool {
    HDOnlinePaymentToolsModel *model = HDOnlinePaymentToolsModel.new;
    model.method = tool;
    return model;
}

@end
