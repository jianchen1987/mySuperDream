//
//  HDWebFeatureClass.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/20.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDBaseHtmlVC.h"
#import "HDWebResponseModel.h"
#import <Foundation/Foundation.h>

@class HDWebFeatureClass;

NS_ASSUME_NONNULL_BEGIN

typedef void (^WebFeatureResponse)(HDWebFeatureClass *_Nonnull webFeature, NSString *_Nullable responseString);


@interface HDWebFeatureClass : NSObject

/**
 web 事件响应唯一标识
 */
@property (nonatomic, copy, nullable) NSString *callBackId;
@property (nonatomic, weak, nullable) HDBaseHtmlVC *viewController;
@property (nonatomic, strong, nullable) HDWebResponseModel *parameter;
@property (nonatomic, copy, nullable) NSString *resFnName; //服务响应函数名

/**
 完全响应后是否销毁
 */
@property (nonatomic, assign) BOOL isCompleteResponseDestroyMonitor;

@property (nonatomic, copy) WebFeatureResponse _Nullable webFeatureResponse;

/** 开始执行 */
- (void)webFeatureResponseAction:(WebFeatureResponse _Nullable)webFeatureResponse;

/**
 响应JS方法字符串
 @param functionName 函数名
 @param callBackId callBackId
 @param data 数据
 */
- (NSString *_Nullable)responseWebFunctionName:(NSString *_Nullable)functionName callBackId:(NSString *_Nullable)callBackId data:(NSDictionary *_Nullable)data;
// 字典转json格式字符串：
- (NSString *_Nullable)dictionaryToJson:(NSDictionary *_Nullable)dic;

/**
 响应成功
 */
- (NSString *_Nullable)responseSuccess;

- (NSString *_Nullable)responseSuccessWithData:(NSDictionary *)rspData;

/**
 响应失败
 */
- (NSString *_Nullable)responseFailureWithReason:(NSString *__nonnull)reason;

@end

NS_ASSUME_NONNULL_END
