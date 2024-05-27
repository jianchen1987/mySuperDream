//
//  SAInfoViewModel.m
//
//
//  Created by VanJay on 2020/3/31.
//

#import "SAInfoViewModel.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDAppTheme.h>


@implementation SAInfoViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        self.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
        self.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
        self.leftImageSize = CGSizeMake(kRealWidth(22), kRealWidth(22));
        self.keyFont = HDAppTheme.font.standard3;
        self.keyColor = HDAppTheme.color.G1;
        self.keyTextAlignment = NSTextAlignmentLeft;
        self.keyContentEdgeInsets = UIEdgeInsetsZero;
        self.keyImageEdgeInsets = UIEdgeInsetsZero;
        self.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(5));
        self.keyImagePosition = HDUIButtonImagePositionRight;
        self.keyNumbersOfLines = 0;
        self.keyWidth = 0;

        self.valueFont = HDAppTheme.font.standard3;
        self.valueColor = HDAppTheme.color.G3;
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
        self.lineColor = HDAppTheme.color.G4;
        self.lineWidth = PixelOne;
        self.lineEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), 0, kRealWidth(15));
        self.backgroundColor = UIColor.clearColor;
        self.cornerRadius = 0;

        self.valueAlignmentToOther = NSTextAlignmentRight;
        self.keyToValueWidthRate = 0.8;

        self.subValueFont = HDAppTheme.font.standard3;
        self.subValueColor = HDAppTheme.color.G3;
        self.subToValueButtonTopSpace = 5;
        self.rectCorner = UIRectCornerAllCorners;
    }
    return self;
}
@end
