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
typedef void (^WebFeatureResponse)(HDWebFeatureClass *webFeature, NSString *responseString);


@interface HDWebFeatureClass : NSObject

/**
 web 事件响应唯一标识
 */
@property (nonatomic, copy) NSString *callBackId;
@property (nonatomic, weak) HDBaseHtmlVC *viewController;
@property (nonatomic, strong) HDWebResponseModel *parameter;
@property (nonatomic, copy) NSString *resFnName; //服务响应函数名

/**
 完全响应后是否销毁
 */
@property (nonatomic, assign) BOOL isCompleteResponseDestroyMonitor;

@property (nonatomic, copy) WebFeatureResponse webFeatureResponse;

/** 开始执行 */
- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse;

/**
 响应JS方法字符串
 @param functionName 函数名
 @param callBackId callBackId
 @param data 数据
 */
- (NSString *)responseWebFunctionName:(NSString *)functionName callBackId:(NSString *)callBackId data:(NSDictionary *)data;
// 字典转json格式字符串：
- (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 响应成功
 */
- (NSString *)responseSuccess;

- (NSString *)responseSuccessWithData:(NSDictionary *)rspData;

/**
 响应失败
 */
- (NSString *)responseFailureWithReason:(NSString *__nonnull)reason;

@end
