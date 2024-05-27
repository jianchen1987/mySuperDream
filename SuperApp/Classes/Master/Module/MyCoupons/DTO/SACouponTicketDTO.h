//
//  SACouponTicketDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

@class SACouponInfoRspModel;
@class SAGetUserCouponTicketRspModel;
@class SABusinessCouponCountRspModel;
@class SAGetSigninActivityEntranceRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SACouponTicketDTO : SAViewModel

/// 查询优惠券数量
/// @param businessLine 业务线 YumNow：外卖 TinhNow:电商 PhoneTopUp：话费充值 为空代表所有业务线
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getCouponInfoWithBusinessLine:(SAMarketingBusinessType _Nullable)businessLine
                              success:(void (^_Nullable)(SACouponInfoRspModel *rspModel))successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询用户优惠券列表
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param couponState 优惠券查询状态，11-未使用 12-已使用 13-已过期 14-(已使用和已过期)
/// @param businessLine 业务线 YumNow：外卖 TinhNow:电商 PhoneTopUp：话费充值 为空代表所有业务线
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getCouponTicketListWithPageSize:(NSUInteger)pageSize
                                pageNum:(NSUInteger)pageNum
                            couponState:(SACouponState)couponState
                           businessLine:(SAClientType)businessLine
                               sortType:(SACouponListSortType)sortType
                                success:(void (^)(SAGetUserCouponTicketRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询新版用户优惠券列表
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param couponState 优惠券查询状态，11-未使用 12-已使用 13-已过期 14-(已使用和已过期)
/// @param businessLine 业务线 YumNow：外卖 TinhNow:电商 PhoneTopUp：话费充值 为空代表所有业务线
/// @param topFilterSortType 顶部筛选条件 10-默认 11-新到 12-快过期 13-外卖 14-电商 15-话费充值 16-游戏 17-酒店
/// @param couponType 优惠券类型 9-全部 15-现金券 34-运费券 37-支付券
/// @param sceneType 券类别 9-全部 10-平台券 11-门店券
/// @param orderBy 排序 10-默认 11-新到 12-快过期 13-面额由大到小 14-面额由小到大
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getNewSortCouponTicketListWithPageSize:(NSUInteger)pageSize
                                       pageNum:(NSUInteger)pageNum
                                   couponState:(SACouponState)couponState
                                  businessLine:(SAClientType)businessLine
                             topFilterSortType:(SACouponListNewSortType)topFilterSortType
                                    couponType:(SACouponListCouponType)couponType
                                     sceneType:(SACouponListSceneType)sceneType
                                       orderBy:(SACouponListOrderByType)orderBy
                                       success:(void (^)(SAGetUserCouponTicketRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取各业务线可用优惠券数
/// @param couponState 优惠券状态
/// @param operatorNo 操作员编号
/// @param success 成功回调
/// @param failure 失败回调
- (void)getBusinessCouponCountWithCouponState:(SACouponState)couponState
                                   operatorNo:(NSString *_Nonnull)operatorNo
                                      success:(void (^)(SABusinessCouponCountRspModel *rspModel))success
                                      failure:(CMNetworkFailureBlock)failure;

- (void)getBusinessCouponCountWithOperatorNo:(NSString *_Nonnull)operatorNo success:(void (^)(SABusinessCouponCountRspModel *rspModel))success failure:(CMNetworkFailureBlock)failure;

/// 获取签到活动入口
/// @param success 成功回调
/// @param failure 失败回调
- (void)getSigninActivityEntranceSuccess:(void (^)(SAGetSigninActivityEntranceRspModel *rspModel))success failure:(CMNetworkFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
