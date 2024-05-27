//
//  TNEventTracking.h
//  SuperApp
//
//  Created by 张杰 on 2023/3/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNProductsExposureTool.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define TNEventTrackingInstance [TNEventTracking instance]


@interface TNEventTracking : NSObject
/// 记录曝光量工具
@property (strong, nonatomic) TNProductsExposureTool *exposureTool;

+ (instancetype)instance;

/// 解析第三方唤起app的参数  获取source 来源字段
/// - Parameter router: 链接
- (void)parseOpenRouter:(NSString *)router;

/// 页面埋点
/// - Parameter pageName: 名字
/// - Parameter properties: 属性
- (void)trackPage:(NSString *)pageName properties:(nullable NSDictionary *)properties;

/// 埋点
/// - Parameters:
///   - eventName: 事件ID
///   - properties: 事件属性
- (void)trackEvent:(NSString *)eventName properties:(nullable NSDictionary *)properties;

///开始记录曝光下标
//- (void)startRecordingExposureByScrollIndexPath:(NSIndexPath *)indexPath;

/// 开始记录曝光商品商品ID
- (void)startRecordingExposureIndexWithProductId:(NSString *)productId;

/// 埋点浏览商品的事件
/// - Parameter properties: 属性  例如专题 需要specialId
- (void)trackExposureScollProductsEventWithProperties:(nullable NSDictionary *)properties;

/// 埋点浏览商品的事件
/// - Parameter productsListDict: 商品模型字典  key为商品数组所在的section  value为商品数组
/// - Parameter properties: 属性  例如专题 需要specialId
//- (void)trackExposureScollProductsEventWithProductsListDict:(NSDictionary *)productsListDict properties:(nullable NSDictionary *)properties;

@end

NS_ASSUME_NONNULL_END
