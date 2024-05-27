//
//  PNWalletListConfigModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletListConfigModel.h"


@implementation PNWalletListConfigModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": [PNWalletListConfigModel class]};
}

@end
