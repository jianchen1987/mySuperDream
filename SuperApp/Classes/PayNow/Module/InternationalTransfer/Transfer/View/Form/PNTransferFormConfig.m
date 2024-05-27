//
//  PNTransferFormConfig.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransferFormConfig.h"
#import "HDAppTheme+PayNow.h"


@implementation PNTransferFormConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineHeight = 0.5;
        self.valueContainerHeight = kRealWidth(40);
        self.keyboardType = UIKeyboardTypeDefault;
        self.maxInputLength = 100;
        self.keyFont = [HDAppTheme.PayNowFont fontBold:14];
        self.leftLabelString = @"";
        self.valuePlaceHold = @"";
        self.subKeyFont = HDAppTheme.PayNowFont.standard14;
        self.subKeyColor = HDAppTheme.PayNowColor.mainThemeColor;
    }
    return self;
}

- (HDUITextFieldConfig *)textfeildConfig {
    HDUITextFieldConfig *config = [HDUITextFieldConfig defaultConfig];
    config.font = HDAppTheme.PayNowFont.standard14;
    config.textColor = HDAppTheme.PayNowColor.c333333;
    config.keyboardType = self.keyboardType;
    config.maxInputLength = self.maxInputLength;
    config.marginFloatingLabelToTextField = 0;
    config.floatingText = @"";
    config.floatingLabelFont = [UIFont systemFontOfSize:0];
    config.clearButtonMode = UITextFieldViewModeNever;
    config.placeholder = self.valuePlaceHold;
    config.placeholderColor = HDAppTheme.PayNowColor.cCCCCCC;
    config.placeholderFont = HDAppTheme.PayNowFont.standard14;
    config.bottomLineNormalHeight = 0;
    config.bottomLineSelectedHeight = 0;
    if (self.editType == PNSTransferFormValueEditTypeDrop) {
        config.rightIconImage = [UIImage imageNamed:@"pn_drop_more"];
        config.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    } else if (self.editType == PNSTransferFormValueEditTypeJump) {
        config.rightIconImage = [UIImage imageNamed:@"arrow_gray_small"];
        config.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return config;
}

@end
