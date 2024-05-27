//
//  HDWebFeatureClass.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/20.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureClass.h"


@implementation HDWebFeatureClass

// 字典转json格式字符串：
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)responseWebFunctionName:(NSString *)functionName callBackId:(NSString *)callBackId data:(NSDictionary *)data {
    if (data != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *param = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *JSString = [NSString stringWithFormat:@"window.%@('%@',%@)", functionName, callBackId, param];
        return JSString;
    } else {
        return @"";
    }
}

- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    self.webFeatureResponse = webFeatureResponse;
    self.webFeatureResponse(self, nil);
}

- (NSString *)responseSuccess {
    return [NSString stringWithFormat:@"window.%@('%@',{'status':'1','msg':'','data':''})", self.parameter.resFnName, self.parameter.callBackId];
}

- (NSString *)responseSuccessWithData:(NSDictionary *)rspData {
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rspData options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {
        return [NSString stringWithFormat:@"window.%@('%@',{'status':'1','msg':'','data':'%@'})", self.parameter.resFnName, self.parameter.callBackId, @""];
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"window.%@('%@',{'status':'1','msg':'','data': %@})", self.parameter.resFnName, self.parameter.callBackId, jsonString];
    }
}

- (NSString *)responseFailureWithReason:(NSString *__nonnull)reason {
    return [NSString stringWithFormat:@"window.%@('%@',{'status':'0','msg':'%@'})", self.parameter.resFnName, self.parameter.callBackId, reason];
}

@end
