//
//  HDWebServiceClass.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/20.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebFeatureClass.h"
#import "HDWebResponseModel.h"
#import "SAViewController.h"
#import <Foundation/Foundation.h>

/** 一级指令 */
typedef enum {
    WebServiceLanguage = 0,        // 0  语言设置
    WebServiceRequestData,         // 1  h5发起请求数据
    WebServiceCloseNativePage,     // 2。关闭当前原生页面并且后退到上一个原生页面
    WebServiceOpenNewWebPage,      // 3 打开一个带有webview的原生页面
    WebServiceMonitorPrimaryEvent, // 4 监听原生页面中元素的事件,并在触发时执行h5的对应函数
    WebServiceNativeEnginery,      // 5 调用原生机能
    WebServiceNativeElement,       // 6 设置原生元素显示方式
    WebServiceShare,               // 7分享

} WebServiceType;

extern NSString *NSStringFromWebServiceType(WebServiceType state);


@interface HDWebServiceClass : NSObject

@property (nonatomic, strong) HDWebResponseModel *parameter;
@property (nonatomic, strong) HDWebFeatureClass *webFeatureClass;

+ (instancetype)webServiceParameter:(HDWebResponseModel *)model viewController:(HDBaseHtmlVC *)viewController;

// 根据类型获取对应的处理类
- (NSString *)getWebFeatureClassStringByTypeCode:(NSInteger)type;

@end
