//
//  Target_HTTP.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "Target_HTTP.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDLog.h>
#import <HDServiceKit/HDWebViewHostViewController.h>


@implementation Target_HTTP
- (void)action_openURL:(NSDictionary *)params {
    NSURL *url = [params valueForKey:@"url"];
    HDLog(@"打开地址：%@", url.absoluteString);

    HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
    vc.url = url.absoluteString;
    //    [SAWindowManager navigateToViewController:vc removeSpecClass:@"SAPayResultViewController"];

    [SAWindowManager navigateToViewController:vc parameters:@{@"specClassNames": @[@"SAPayResultViewController", @"WMOrderSubmitV2ViewController", @"TNOrderSubmitViewController"]}];
}
@end
