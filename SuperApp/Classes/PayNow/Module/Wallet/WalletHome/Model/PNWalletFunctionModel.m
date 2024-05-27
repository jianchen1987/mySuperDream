//
//  PNWalletFunctionModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/15.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletFunctionModel.h"


@implementation PNWalletFunctionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"SETTING": [PNWalletListConfigModel class],
        @"RIBBON": [PNWalletListConfigModel class],
        @"ENTRANCE": [PNWalletListConfigModel class],
    };
}
@end
