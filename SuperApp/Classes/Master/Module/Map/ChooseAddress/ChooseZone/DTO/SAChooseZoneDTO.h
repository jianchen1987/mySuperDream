//
//  SAChooseZoneDTO.h
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressZoneModel;


@interface SAChooseZoneDTO : SAModel

/// 查询省/市/区
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getZoneListWithSuccess:(void (^)(NSArray<SAAddressZoneModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 模糊查询省/市/区
/// @param province 省或市
/// @param district 区
/// @param commune 社
/// @param lat 纬度
/// @param lon 经度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)fuzzyQueryZoneListWithProvince:(NSString *_Nullable)province
                              district:(NSString *_Nullable)district
                               commune:(NSString *_Nullable)commune
                              latitude:(NSNumber *)lat
                             longitude:(NSNumber *)lon
                               success:(void (^_Nullable)(SAAddressZoneModel *zoneModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)fuzzyQueryZoneListWithoutDefaultWithProvince:(NSString *_Nullable)province
                                            district:(NSString *_Nullable)district
                                             commune:(NSString *_Nullable)commune
                                            latitude:(NSNumber *)lat
                                           longitude:(NSNumber *)lon
                                             success:(void (^_Nullable)(SAAddressZoneModel *zoneModel))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
