//
//  HDWebServiceNativeEngineryClass.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/25.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDWebServiceClass.h"

typedef NS_ENUM(NSInteger, WebServiceNativeEngineryType) {
    HDWebFeatureShowLoading = 1,      // 呼叫loading显示
    HDWebFeatureDismiss = 2,          // 呼叫loading隐藏
    HDWebFeatureAlertSure = 3,        // 呼叫确认框  确认
    HDWebFeatureAlertSelectSure = 4,  // 呼叫确认框  确认/取消
    HDWebFeatureClearNavigation = 5,  // 清空头部内容
    HDWebFeaturePageSkipping = 6,     //页面跳转
    HDWebFeatureShare = 7,            // 分享
    HDWebFeatureContacts = 8          // 呼起通讯录
};

@interface HDWebServiceNativeEngineryClass : HDWebServiceClass

@end
