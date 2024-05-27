//
//  HDWebServicetitleView.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServicetitleView.h"

@implementation HDWebServicetitleView
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    HDLog(@"h5 设置标题  %@", self.parameter.param[@"params"][@"label"]);
    self.viewController.boldTitle = self.parameter.param[@"params"][@"label"];
    webFeatureResponse(self, [self responseSuccess]);
}
@end
