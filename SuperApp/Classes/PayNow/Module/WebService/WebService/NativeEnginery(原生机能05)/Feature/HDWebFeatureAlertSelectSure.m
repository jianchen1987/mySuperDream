//
//  HDWebFeatureAlertSelectSure.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/26.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureAlertSelectSure.h"
//#import "HDNewAlertView.h"
@implementation HDWebFeatureAlertSelectSure
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {

    self.webFeatureResponse = webFeatureResponse;

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:self.parameter.param[@"params"][@"title"] message:self.parameter.param[@"params"][@"content"] config:nil];

    HDAlertViewButton *confirmButton =
        [HDAlertViewButton buttonWithTitle:HDLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确定", @"")
                                      type:HDAlertViewButtonTypeCustom
                                   handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                       self.webFeatureResponse(self, [NSString stringWithFormat:@"window.%@('%@',{'flag':'1'})", self.parameter.resFnName, self.parameter.callBackId]);

                                       [alertView dismiss];
                                   }];
    HDAlertViewButton *cancelButton =
        [HDAlertViewButton buttonWithTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"")
                                      type:HDAlertViewButtonTypeCancel
                                   handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                       self.webFeatureResponse(self, [NSString stringWithFormat:@"window.%@('%@',{'flag':'0'})", self.parameter.resFnName, self.parameter.callBackId]);

                                       [alertView dismiss];
                                   }];
    [alertView addButtons:@[ cancelButton, confirmButton ]];

    [alertView show];
}
@end
