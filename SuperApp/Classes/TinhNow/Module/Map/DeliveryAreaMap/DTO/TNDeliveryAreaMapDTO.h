//
//  TNDeliveryAreaMapDTO.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <Foundation/Foundation.h>
@class TNDeliveryAreaMapModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNDeliveryAreaMapDTO : TNModel
/// 获取配送区域地图展示数据
/// @param longitude 经度
/// @param latitude  纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryStoreRegionListWithLongitude:(NSNumber *)longitude
                                 latitude:(NSNumber *)latitude
                                  success:(void (^_Nullable)(TNDeliveryAreaMapModel *model))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
