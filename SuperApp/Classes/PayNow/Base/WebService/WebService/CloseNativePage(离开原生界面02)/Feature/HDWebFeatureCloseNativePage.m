//
//  HDWebFeatureCloseNativePage.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/8/7.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureCloseNativePage.h"

@implementation HDWebFeatureCloseNativePage
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    [self.viewController.navigationController popViewControllerAnimated:YES];
    // 流程闭环，执行不一定有用
    webFeatureResponse(self, [self responseSuccess]);
}
@end
