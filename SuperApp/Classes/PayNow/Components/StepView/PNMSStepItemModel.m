//
//  PNMSStepItemModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStepItemModel.h"
#import "HDAppTheme+PayNow.h"


@implementation PNMSStepItemModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleFont = HDAppTheme.PayNowFont.standard20B;
        self.titleColor = HDAppTheme.PayNowColor.cCCCCCC;
        self.titleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);

        self.subTitleFont = HDAppTheme.PayNowFont.standard11;
        self.subTitleColor = HDAppTheme.PayNowColor.cCCCCCC;
        self.subTitleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    }
    return self;
}

@end
