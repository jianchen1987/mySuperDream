//
//  SASearchAddressDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressSearchRspModel;
@class SAAddressAutoCompleteRspModel;


@interface SASearchAddressDTO : SAModel

/// 根据关键词搜索地址
/// @param keyword 关键词
/// @param coordinate 搜索中心点
/// @param radius 搜索半径
/// @param sessionToken 会话token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)searchAddressWithKeyword:(NSString *)keyword
                        location:(CLLocationCoordinate2D)coordinate
                          radius:(CGFloat)radius
                    sessionToken:(NSString *)sessionToken
                         success:(void (^_Nullable)(SAAddressAutoCompleteRspModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据位置编码查询位置详情，配合关键字搜索使用
/// @param placeId 地址编码
/// @param sessionToken 会话token
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getPlaceDetailsWithPlaceId:(NSString *)placeId
                      sessionToken:(NSString *)sessionToken
                           success:(void (^_Nullable)(SAAddressSearchRspModel *rspModel))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
