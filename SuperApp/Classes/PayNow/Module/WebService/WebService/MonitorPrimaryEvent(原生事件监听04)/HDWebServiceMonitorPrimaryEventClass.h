//
//  HDWebServiceMonitorPrimaryEventClass.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceClass.h"
typedef NS_ENUM(NSInteger, WebServiceMonitorPrimaryEventType) {
    HDWebFeatureMonitorBack = 1,             // 左上按钮点击
    HDWebFeatureMonitorRight = 2,            // 右上按钮点击
    HDWebFeatureMonitorTitleView = 3,        // 标题点击
    HDWebFeatureMonitorEnterNativePage = 4,  // 进入当前原生页面
    HDWebFeatureMonitorLeaveNativePage = 5,  // 离开当前原生页面
};

@interface HDWebServiceMonitorPrimaryEventClass : HDWebServiceClass

@end
