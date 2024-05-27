//
//  HDWebFeatureLanguage.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/23.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//
typedef enum {
    LanguageEnglishType,   //英语0
    LanguageCambodiaType,  //柬埔寨1
    LanguageChineseType,   //中文2
} LanguageType;

#import "HDWebFeatureLanguage.h"
#import "PNMultiLanguageManager.h"  //语言
#import "PNUtilMacro.h"
#import "UIDevice+Extension.h"
#import "VipayUser.h"

@implementation HDWebFeatureLanguage

- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    NSArray<NSString *> *data = @[ LANGUAGE_ENGLISH, LANGUAGE_KHR, LANGUAGE_CHINESE ];

    NSDictionary *Dic;
    for (int i = 0; i < 3; i++) {
        if ([PNLocalizedString(@"languageName", @"") isEqualToString:data[i]]) {
            Dic = @{
                @"lang" : [NSString stringWithFormat:@"%d", i],
                @"loginName" : [VipayUser isLogin] ? [VipayUser shareInstance].loginName : @"",
                @"deviceId" : [HDDeviceInfo getUniqueId],
                @"ver" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                @"termType" : @"IOS"
            };
            break;
        }
    }

    //    HDLog(@"语言类型回调");
    webFeatureResponse(self, [self responseWebFunctionName:self.parameter.resFnName callBackId:self.parameter.callBackId data:Dic]);
}
@end
