//
//  HDWebFeatureBackToHomeAndRoute.m
//  ViPay
//
//  Created by seeu on 2019/6/21.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDWebFeatureBackToHomeAndRoute.h"

@implementation HDWebFeatureBackToHomeAndRoute

- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {

    NSDictionary *params = [self.parameter.param objectForKey:@"params"];
    if (params) {
        NSString *oriRouteStr = [params objectForKey:@"url"];
        NSString *routeUrl = [oriRouteStr stringByRemovingPercentEncoding];
        if (HDIsStringNotEmpty(routeUrl)) {
            dispatch_after(NSEC_PER_SEC * 1, dispatch_get_main_queue(), ^{
                [SAWindowManager openUrl:routeUrl withParameters:nil];
            });
        }
    }
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
    // 流程闭环，执行不一定有用
    webFeatureResponse(self, [self responseSuccess]);
}

@end
