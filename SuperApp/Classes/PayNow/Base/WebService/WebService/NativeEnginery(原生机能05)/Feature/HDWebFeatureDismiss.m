//
//  HDWebFeatureDismiss.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/26.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureDismiss.h"

@implementation HDWebFeatureDismiss
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    [self.viewController dismissLoading];
    webFeatureResponse(self, [self responseSuccess]);
}
@end
