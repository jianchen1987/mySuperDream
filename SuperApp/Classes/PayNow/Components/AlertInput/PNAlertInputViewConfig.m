//
//  PNAlertInputViewConfig.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAlertInputViewConfig.h"
#import "HDAppTheme+PayNow.h"


@implementation PNAlertInputViewConfig

+ (PNAlertInputViewConfig *)defulatConfig {
    PNAlertInputViewConfig *config = [[PNAlertInputViewConfig alloc] init];
    config.style = PNAlertInputStyle_textField;

    config.titleColor = HDAppTheme.PayNowColor.c333333;
    config.titleFont = HDAppTheme.PayNowFont.standard16B;

    config.subTitleColor = HDAppTheme.PayNowColor.c999999;
    config.subTitleFont = HDAppTheme.PayNowFont.standard14;

    config.cancelButtonColor = HDAppTheme.PayNowColor.c333333;
    config.cancelButtonFont = HDAppTheme.PayNowFont.standard14M;
    config.cancelButtonBackgroundColor = HDAppTheme.PayNowColor.lineColor;

    config.doneButtonColor = HDAppTheme.PayNowColor.cFFFFFF;
    config.doneButtonFont = HDAppTheme.PayNowFont.standard14M;
    config.doneButtonBackgroundColor = HDAppTheme.PayNowColor.mainThemeColor;

    config.maxInputLength = 0;
    return config;
}
@end
