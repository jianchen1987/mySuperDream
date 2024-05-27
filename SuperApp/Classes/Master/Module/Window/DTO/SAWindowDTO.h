//
//  SAWindowDTO.h
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAWindowRspModel;


@interface SAWindowDTO : SAModel

/// 获取window
/// @param page 页面
/// @param location 位置
/// @param clientType 客户端类型
/// @param province 省份 字符串文本
/// @param district 区 字符串文本
/// @param lat 纬度
/// @param lon 经度
/// @param successBlock 成功
/// @param failureBlock 失败
- (void)getWindowWithPage:(SAPagePosition)page
                 location:(SAWindowLocation)location
               clientType:(SAClientType _Nullable)clientType
                 province:(NSString *_Nullable)province
                 district:(NSString *_Nullable)district
                 latitude:(NSNumber *)lat
                longitude:(NSNumber *)lon
                  success:(void (^)(SAWindowRspModel *rspModel))successBlock
                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
