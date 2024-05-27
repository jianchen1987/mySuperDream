//
//  PNOperationButton.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNOperationButton.h"
#import "HDAppTheme+PayNow.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIImage+HDKitCore.h>


@implementation PNOperationButton

+ (instancetype)buttonWithStyle:(SAOperationButtonStyle)style {
    PNOperationButton *button = [PNOperationButton buttonWithType:UIButtonTypeCustom];
    [button applyPropertiesWithStyle:style];
    button.cornerRadius = 4;
    button.titleLabel.font = [HDAppTheme.PayNowFont fontBold:16];

    if (style == SAOperationButtonStyleHollow) {
        button.borderWidth = 1;
        button.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
    }
    return button;
}

- (void)op_commonInit {
    self.titleLabel.font = [HDAppTheme.PayNowFont fontBold:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    // 默认 solid
    [self applyPropertiesWithStyle:SAOperationButtonStyleSolid];
}

- (void)applyPropertiesWithStyle:(SAOperationButtonStyle)style {
    UIColor *backgroundColor = style == SAOperationButtonStyleSolid ? HDAppTheme.PayNowColor.mainThemeColor : UIColor.whiteColor;
    UIColor *titleColor = style == SAOperationButtonStyleSolid ? UIColor.whiteColor : HDAppTheme.PayNowColor.mainThemeColor;
    [self applyPropertiesWithBackgroundColor:backgroundColor];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    if (style == SAOperationButtonStyleHollow) {
        self.borderWidth = 1;
        self.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
    }
}
@end
