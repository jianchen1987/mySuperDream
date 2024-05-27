//
//  PNInputItemModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNInputItemModel.h"
#import "HDAppTheme+PayNow.h"


@implementation PNInputItemModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.style = PNInputStypeRow_One;
        self.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
        self.backgroundColor = [UIColor whiteColor];
        self.enabled = YES;
        self.bottomLineHeight = PixelOne;
        self.bottomLineSpaceToLeft = kRealWidth(15);
        self.bottomLineSpaceToRight = kRealWidth(15);
        self.valueAlignment = NSTextAlignmentRight;
        self.useWOWNOWKeyboard = NO;
        self.fixWhenInputSpace = NO;
        self.coverUp = PNInputCoverUpNone;
        self.isUppercaseString = NO;
        self.isWhenEidtClearValue = NO;
        self.canInputMoreSpace = YES;
        self.firstDigitCanNotEnterZero = NO;
        self.leftLabelColor = HDAppTheme.PayNowColor.c333333;
        self.leftLabelFont = HDAppTheme.PayNowFont.standard14;
    }
    return self;
}

@end
