//
//  HDWebFeatureMonitorRight.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureMonitorRight.h"

@implementation HDWebFeatureMonitorRight
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    //监听返回事件
    self.viewController.rightButtonfunctionName = self.parameter.param[@"params"][@"callBackFuncName"];
    webFeatureResponse(self, [self responseSuccess]);
}
@end
