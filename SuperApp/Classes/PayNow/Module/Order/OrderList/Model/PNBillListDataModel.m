//
//  PayHDBillListDataModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBillListDataModel.h"


@implementation PNBillListDataModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.datas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
@end
