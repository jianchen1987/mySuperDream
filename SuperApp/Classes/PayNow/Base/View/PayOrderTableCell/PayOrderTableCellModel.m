//
//  PayOrderTableCellModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayOrderTableCellModel.h"
#import "HDAppTheme+PayNow.h"


@implementation PayOrderTableCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.nameTextColor = HDAppTheme.PayNowColor.c9599A2;
        self.nameTextFont = [HDAppTheme.font forSize:15];
        self.valueTextColor = HDAppTheme.PayNowColor.c343B4D;
        self.valueTextFont = [HDAppTheme.font forSize:15];
    }
    return self;
}
@end
