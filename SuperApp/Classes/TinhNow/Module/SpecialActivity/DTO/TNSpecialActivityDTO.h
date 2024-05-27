//
//  TNSpecialActivityDTO.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "TNQueryGoodsRspModel.h"
#import "TNSpeciaActivityDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TNCategoryModel;
@class TNActivityCardRspModel;
@class TNRedZoneActivityModel;


@interface TNSpecialActivityDTO : TNModel

/// 获取专题详情数据回调
/// @param activityId 活动id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySpecialActivityDetailWithActivityId:(NSString *)activityId
                                         success:(void (^_Nullable)(TNSpeciaActivityDetailModel *detailModel))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取商品分类数据
/// @param activityId 活动id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryGoodCategoryDataWithActivityId:(NSString *)activityId
                                    success:(void (^_Nullable)(NSArray<TNCategoryModel *> *categoryArr))successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询专题活动卡片数据
/// @param activityId 活动id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)querySpeciaActivityCardWithActivityId:(NSString *)activityId success:(void (^_Nullable)(TNActivityCardRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///  通过经纬度查询红区专题id
/// @param longitude 经度
/// @param latitude  纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryRedZoneSpeciaActivityIdWithLongitude:(NSNumber *)longitude
                                         latitude:(NSNumber *)latitude
                                          success:(void (^_Nullable)(TNRedZoneActivityModel *model))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
