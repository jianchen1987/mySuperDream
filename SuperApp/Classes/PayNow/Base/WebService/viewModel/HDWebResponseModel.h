//
//  Web 响应数据 HDWebResponseModel.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/24.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HDWebResponseModel : NSObject

/**
 参数
 */
@property (nonatomic, copy) NSDictionary *param;

/**
 回调id
 */
@property (nonatomic, copy) NSString *callBackId;

/**
 服务响应名
 */
@property (nonatomic, copy) NSString *resFnName;

/**
 服务类型
 */
@property (nonatomic, copy) NSString *ServiceCode;
@end
