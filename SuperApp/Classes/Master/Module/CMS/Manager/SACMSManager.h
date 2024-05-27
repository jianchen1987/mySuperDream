//
//  SACMSManager.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMNetworkRequest.h"
#import "SAAddressModel.h"
#import "SACMSDefine.h"
#import "SACMSPageView.h"
#import "SACMSPageViewConfig.h"
#import "SAMultiLanguageManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SACMSManager : NSObject

/// 获取页面
/// @param addressModel 地址模型，为空标识该页面无区域概念
/// @param identify 页面标识
/// @param pageWidth 页面宽度
/// @param operatorNo 操作员编号
/// @param success 成功回调
/// @param failure 失败回调
+ (void)getPageWithAddress:(SAAddressModel *_Nullable)addressModel
                  identify:(CMSPageIdentify)identify
                 pageWidth:(CGFloat)pageWidth
                operatorNo:(NSString *_Nullable)operatorNo
                   success:(void (^)(SACMSPageView *page, SACMSPageViewConfig *config))success
                   failure:(CMNetworkFailureBlock _Nullable)failure;

/// 注册卡片模型
/// @param cardClass 类名
/// @param identify 模型标识
+ (void)registerCMSCardTemplateWithClass:(Class)cardClass identify:(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
