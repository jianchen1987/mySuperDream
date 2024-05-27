//
//  HDWebFeatureAlertSure.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/26.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureAlertSure.h"
#import "HDAlertView.h"

@implementation HDWebFeatureAlertSure
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {

    self.webFeatureResponse = webFeatureResponse;

    HDAlertView *alertView = [HDAlertView alertViewWithTitle:self.parameter.param[@"params"][@"title"] message:self.parameter.param[@"params"][@"content"] config:nil];

    HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:HDLocalizedString(@"BUTTON_TITLE_DONE", @"确定", @"")
                                                              type:HDAlertViewButtonTypeCustom
                                                           handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                                               [alertView dismiss];
                                                           }];
    [alertView addButtons:@[ button ]];

    [alertView show];

    webFeatureResponse(self, [self responseSuccess]);
}
@end
