//
//  HDWebFeatureNetworkRequestData.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/24.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureNetworkRequestData.h"
#import "HDWebViewModel.h"
#import "PNRspModel.h"

@interface HDWebFeatureNetworkRequestData ()
@end

@implementation HDWebFeatureNetworkRequestData
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    self.webFeatureResponse = webFeatureResponse;

    HDLog(@"Web 网络请求，url：%@", self.parameter.param[@"url"]);
    HDLog(@"Web 网络请求，参数：%@", self.parameter.param);

    __weak __typeof(self) weakSelf = self;

    [HDWebViewModel.share postWebIntferface:self.parameter.param[@"url"]
        parameter:self.parameter.param[@"params"]
        success:^(PNRspModel *rspModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rspModel.data options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *name = [NSString stringWithFormat:@"window.%@('%@',%@)", strongSelf.parameter.resFnName, strongSelf.parameter.callBackId, str];
            if (strongSelf) {
                strongSelf.webFeatureResponse(strongSelf, name);
            } else {
                HDLog(@"webView 已销毁");
            }
        }
        failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSString *name =
                [NSString stringWithFormat:@"window.%@('%@',%@)", strongSelf.parameter.resFnName, strongSelf.parameter.callBackId, [strongSelf responseWithReason:rspModel.msg code:rspModel.code]];
            if (strongSelf) {
                strongSelf.webFeatureResponse(strongSelf, name);
            } else {
                HDLog(@"webView 已销毁");
            }
        }];
}

- (NSString *)responseWithReason:(NSString *)reason code:(NSString *)code {
    NSDictionary *rsp = @{@"responseTm" : @"00000000", @"data" : @{}, @"rspInf" : reason, @"rspType" : @0, @"rspCd" : code, @"v" : @"1"};

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rsp options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
