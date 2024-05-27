//
//  PNGrideItemModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGrideItemModel.h"
#import "HDAppTheme+PayNow.h"


@implementation PNGrideItemModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.valueColor = HDAppTheme.PayNowColor.c333333;
        self.valueFont = HDAppTheme.PayNowFont.standard14;
        self.cellBackgroudColor = HDAppTheme.PayNowColor.cFFFFFF;
    }
    return self;
}
@end


@implementation PNGrideModel

@end
