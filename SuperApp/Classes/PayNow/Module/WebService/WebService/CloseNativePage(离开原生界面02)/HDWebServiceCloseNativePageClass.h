//
//  HDWebServiceCloseNativePageClass.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/8/7.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceClass.h"

typedef NS_ENUM(NSInteger, WebServiceCloseNativePageType) {
    HDWebFeatureCloseNativePage = 0,     // 关闭原生界面
    HDWebFeatureBackToHomeAndRoute = 1,  //回到首页，并跳转路由
};

@interface HDWebServiceCloseNativePageClass : HDWebServiceClass

@end
