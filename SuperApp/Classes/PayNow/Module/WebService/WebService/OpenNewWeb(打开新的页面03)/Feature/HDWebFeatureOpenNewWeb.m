//
//  HDWebFeatureOpenNewWeb.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/8/7.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureOpenNewWeb.h"
#import "HDBaseHtmlVC.h"

@implementation HDWebFeatureOpenNewWeb
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    //    HDBaseHtmlVC *html = [[HDBaseHtmlVC alloc] init];
    //    HDLog(@"%@", self.parameter.param);
    //    html.InterfaceString = self.parameter.param[@"url"];
    //    [self.viewController.navigationController pushViewController:html animated:YES];
    [SAWindowManager openUrl:self.parameter.param[@"url"] withParameters:nil];
    //    [SAWindowManager openUrlNoCheck:[NSURL URLWithString:self.parameter.param[@"url"]] withParameters:nil];
    webFeatureResponse(self, [self responseSuccess]);
}
@end
