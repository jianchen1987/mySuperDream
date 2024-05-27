//
//  SASearchThematicModel.m
//  SuperApp
//
//  Created by Tia on 2022/12/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchThematicModel.h"


@implementation SASearchThematicListModel

@end


@implementation SASearchThematicModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"thematicContentList": SASearchThematicListModel.class};
}

@end
