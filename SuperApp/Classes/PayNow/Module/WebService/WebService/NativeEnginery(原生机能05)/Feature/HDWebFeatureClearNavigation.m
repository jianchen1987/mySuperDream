//
//  HDWebFeatureClearNavigation.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/26.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureClearNavigation.h"

@implementation HDWebFeatureClearNavigation
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {

    //    [self.viewController setNavCustomLeftView:nil];
    self.viewController.hd_navLeftBarButtonItems = nil;
    self.viewController.backfunctionName = nil;
    self.viewController.closefunctionName = nil;

    //    [self.viewController setNavCustomRightView:nil];
    self.viewController.hd_navRightBarButtonItems = nil;
    [self.viewController.rightView removeFromSuperview];
    self.viewController.rightView = nil;
    self.viewController.rightButtonfunctionName = nil;

    self.viewController.title = @"";
    //    [self.viewController setNavCustomTitleView:nil];
    self.viewController.hd_navTitleView = nil;
    self.viewController.titleClickedFuncName = nil;

    webFeatureResponse(self, [self responseSuccess]);
}
@end
