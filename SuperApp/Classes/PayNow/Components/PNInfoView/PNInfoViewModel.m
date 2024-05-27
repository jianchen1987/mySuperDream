//
//  PNInfoViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoViewModel.h"
#import "HDAppTheme+PayNow.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation PNInfoViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        self.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
        self.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
        self.leftImageSize = CGSizeMake(kRealWidth(22), kRealWidth(22));
        self.keyFont = HDAppTheme.PayNowFont.standard15;
        self.keyColor = HDAppTheme.color.G1;
        self.keyTextAlignment = NSTextAlignmentLeft;
        self.keyContentEdgeInsets = UIEdgeInsetsZero;
        self.keyImageEdgeInsets = UIEdgeInsetsZero;
        self.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
        self.keyImagePosition = HDUIButtonImagePositionRight;
        self.keyNumbersOfLines = 0;
        self.keyWidth = 0;

        self.valueFont = HDAppTheme.PayNowFont.standard15;
        self.valueColor = HDAppTheme.PayNowColor.c343B4D;
        self.valueTextAlignment = NSTextAlignmentRight;
        self.valueContentEdgeInsets = UIEdgeInsetsZero;
        self.valueImageEdgeInsets = UIEdgeInsetsZero;
        self.valueTitleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, 0);
        self.valueImagePosition = HDUIButtonImagePositionLeft;

        self.rightButtonFont = HDAppTheme.font.standard4;
        self.rightButtonColor = HDAppTheme.color.C1;
        self.rightButtonTextAlignment = NSTextAlignmentRight;
        self.rightButtonContentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, 0);
        self.rightButtonImageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, 0);
        self.rightButtonTitletEdgeInsets = UIEdgeInsetsZero;
        self.rightButtonImagePosition = HDUIButtonImagePositionRight;

        self.valueNumbersOfLines = 0;
        self.lineColor = HDAppTheme.PayNowColor.lineColor;
        self.lineWidth = PixelOne;
        self.lineEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        self.backgroundColor = UIColor.clearColor;
        self.cornerRadius = 0;

        self.valueAlignmentToOther = NSTextAlignmentRight;
        self.keyToValueWidthRate = 0.8;

        self.rectCorner = UIRectCornerAllCorners;

        self.bottomTipsFont = HDAppTheme.PayNowFont.standard13;
        self.bottomTipsColor = HDAppTheme.PayNowColor.mainThemeColor;
    }
    return self;
}
@end
