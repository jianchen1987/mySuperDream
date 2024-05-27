//
//  PNInfoSwitchModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoSwitchModel.h"
#import "HDAppTheme+PayNow.h"


@implementation PNInfoSwitchModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        self.titleColor = HDAppTheme.PayNowColor.c333333;
        self.titleFont = HDAppTheme.PayNowFont.standard14B;
        self.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(12), kRealWidth(12));

        self.subTitleColor = HDAppTheme.PayNowColor.cCCCCCC;
        self.subTitleFont = HDAppTheme.PayNowFont.standard14;
        self.subTitleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(12), kRealWidth(12));

        self.bottomLineHeight = PixelOne;
        self.bottomLineColor = HDAppTheme.PayNowColor.lineColor;
        self.bottomLineSpaceToLeft = kRealWidth(12);
        self.bottomLineSpaceToRight = kRealWidth(12);

        self.switchEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(12));
        self.onTintColor = [UIColor hd_colorWithHexString:@"#2552eb"];
        self.switchValue = NO;

        self.isCenterToView = NO;
        self.enable = YES;
    }
    return self;
}
@end
