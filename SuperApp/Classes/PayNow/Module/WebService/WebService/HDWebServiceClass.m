//
//  HDWebServiceClass.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/20.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceClass.h"
#import "HDWebFeatureClass.h"

//@interface HDWebServiceClass ()
//
////@property (nonatomic, assign) WebServiceType webServiceType;
//
//@end

/** 一级指令对应的处理类 */
NSString *NSStringFromWebServiceType(WebServiceType state) {
    switch (state) {
        case WebServiceLanguage:
            return @"HDWebServiceLanguage";
        case WebServiceRequestData:
            return @"HDWebServiceRequestData";
        case WebServiceCloseNativePage:
            return @"HDWebServiceCloseNativePage";
        case WebServiceOpenNewWebPage:
            return @"HDWebServiceOpenNewWebPage";
        case WebServiceMonitorPrimaryEvent:
            return @"HDWebServiceMonitorPrimaryEvent";
        case WebServiceNativeEnginery:
            return @"HDWebServiceNativeEnginery";
        case WebServiceNativeElement:
            return @"HDWebServiceNativeElement";
        case WebServiceShare:
            return @"HDWebServiceShare";
        default:
            return @"";
    }
}


@implementation HDWebServiceClass

+ (instancetype)webServiceParameter:(HDWebResponseModel *)model viewController:(HDBaseHtmlVC *)viewController {
    NSString *serviceClassStr = NSStringFromWebServiceType([model.ServiceCode intValue]);
    // 不存在的指令
    if (HDIsStringEmpty(serviceClassStr)) {
        return nil;
    }
    HDWebServiceClass *webService = [[NSClassFromString([NSString stringWithFormat:@"%@Class", serviceClassStr]) alloc] init];

    // 服务创建失败
    if (!webService) {
        return nil;
    }

    webService.parameter = model;

    // 创建业务处理类失败
    if (!webService.webFeatureClass) {
        return nil;
    }
    webService.webFeatureClass.viewController = viewController;

    if ([model.ServiceCode integerValue] == WebServiceMonitorPrimaryEvent) { //只有监听事件才不销毁
        webService.webFeatureClass.isCompleteResponseDestroyMonitor = NO;
    } else {
        webService.webFeatureClass.isCompleteResponseDestroyMonitor = YES;
    }
    return webService;
}

// 根据类型获取对应的处理类
- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type {
    return @"";
}

- (void)setParameter:(HDWebResponseModel *)parameter {
    NSString *webFeatureClassStr = [self getWebFeatureClassStringByTypeCode:[parameter.param[@"typeCode"] integerValue]];
    if (HDIsStringNotEmpty(webFeatureClassStr)) {
        HDWebFeatureClass *webFeatureClass = [[NSClassFromString(webFeatureClassStr) alloc] init];
        if (webFeatureClass) {
            self.webFeatureClass = webFeatureClass;
            self.webFeatureClass.parameter = parameter;
        }
    }
}

@end
