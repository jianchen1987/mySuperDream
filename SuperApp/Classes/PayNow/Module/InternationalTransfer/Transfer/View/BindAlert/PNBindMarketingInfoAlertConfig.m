//
//  PNBindMarketingInfoAlertConfig.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNBindMarketingInfoAlertConfig.h"
#import "HDAppTheme+PayNow.h"


@implementation PNBindMarketingInfoAlertConfig

+ (PNBindMarketingInfoAlertConfig *)defulatConfig {
    PNBindMarketingInfoAlertConfig *config = [[PNBindMarketingInfoAlertConfig alloc] init];

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

    return config;
}

@end
