//
//  PNWalletListRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletListRspModel.h"


@implementation PNWalletListRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNWalletListModel.class,
    };
}

@end


@implementation PNWalletListItemModel

@end


@implementation PNWalletListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNWalletListItemModel.class,
    };
}
@end
