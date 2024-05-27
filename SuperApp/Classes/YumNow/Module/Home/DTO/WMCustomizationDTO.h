//
//  WMCustomizationDTO.h
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMMoreEatOnTimeRspModel.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
@class WMTimeBucketsRecommandRspModel;
@class WMSpecialPromotionRspModel;


@interface WMCustomizationDTO : WMModel

/// 根据当前位置获取专题活动详情
/// @param promotionNo 专题活动编号
/// @param pageNo 页码
/// @param pageSize 分页大小
/// @param coordinate 当前位置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;


- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                      categoryNo:(NSString *)categoryNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;


- (CMNetworkRequest *)queryYumNowSpecialPromotionWithPromotionNo:(NSString *)promotionNo
                                                      categoryNo:(NSString *)categoryNo
                                                          pageNo:(NSUInteger)pageNo
                                                        pageSize:(NSUInteger)pageSize
                                                        location:(CLLocationCoordinate2D)coordinate
                                                        sortType:(NSString *)sortType
                                                  marketingTypes:(NSArray<NSString *> *)marketingTypes
                                                    storeFeature:(NSArray<NSString *> *)storeFeature
                                                    businessCode:(NSString *)businessCode
                                                         success:(void (^_Nullable)(WMSpecialPromotionRspModel *rspModel))successBlock
                                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据当前位置获取按时吃饭专题页
/// @param ID 活动编号
/// @param pageNo 页码
/// @param coordinate 当前位置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryYumNowEatOnTimeWithId:(NSString *)ID
                            pageNo:(NSUInteger)pageNo
                          location:(CLLocationCoordinate2D)coordinate
                           success:(void (^_Nullable)(WMMoreEatOnTimeRspModel *rspModel))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
