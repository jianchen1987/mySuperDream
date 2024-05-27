//
//  SAViewModelProtocol.h
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMNetworkRequest;

@protocol SAViewModelProtocol <NSObject>

@optional

- (_Nonnull instancetype)initWithModel:(id _Nonnull)model;
- (void)hd_bindView:(UIView *_Nonnull)view;

@property (strong, nonatomic, nullable) CMNetworkRequest *request;

/// 关联的 View
@property (weak, nonatomic, nullable) UIView *view;

/// 是否请求失败，网络错误或者业务数据失败都应该认定为失败
@property (nonatomic, assign) BOOL isRequestFailed;

/// 是否网络错误
@property (nonatomic, assign) BOOL isNetworkError;

/// 是否业务数据失败
@property (nonatomic, assign) BOOL isBusinessDataError;

/**
 *  初始化
 */
- (void)hd_initialize;

@end
