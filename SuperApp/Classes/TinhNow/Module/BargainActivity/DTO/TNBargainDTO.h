//
//  TNBargainDTO.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNBargainGoodListRspModel;
@class TNBargainRecordModel;
@class TNProductDetailsRspModel;
@class TNBargainSuccessModel;
@class TNBargainDetailModel;
@class TNCreateBargainTaskModel;
@class TNBargainRuleModel;
@class TNBargainRecordListRspModel;
@class TNHelpBargainModel;
@class TNBargainPeopleRecordRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainDTO : TNModel
/// 请求砍价商品列表页
- (void)queryBargainListWithPage:(NSUInteger)page
                            size:(NSUInteger)size
                         success:(void (^_Nullable)(TNBargainGoodListRspModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 请求正在进行中的助力活动
- (void)queryBargainUnderwayTaskListSuccess:(void (^_Nullable)(NSArray<TNBargainRecordModel *> *records))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///创建砍价任务
- (void)createBargainTaskWithModel:(TNCreateBargainTaskModel *)taskModel Success:(void (^_Nullable)(NSString *taskId))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///助力详情接口  pageType; 1-助力详情,2-帮助好友助力页面
- (void)queryBargainDetailWithTaskId:(NSString *)taskId
                            pageType:(NSInteger)pageType
                             Success:(void (^_Nullable)(TNBargainDetailModel *detailModel))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///查询活动商品sku
- (void)queryGoodSkuSpecWithActivityId:(NSString *)activityId Success:(void (^_Nullable)(TNProductDetailsRspModel *skuModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  查询砍价成功的任务单
- (void)queryBargainSuccessTaskListSuccess:(void (^_Nullable)(NSArray<TNBargainSuccessModel *> *records))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  查询我的助力任务记录
- (void)queryMyBargainTaskListWithPage:(NSUInteger)page
                                  size:(NSUInteger)size
                               success:(void (^_Nullable)(TNBargainRecordListRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///查询活动规则  也即邀人攻略
- (void)queryBargainRulesSuccess:(void (^_Nullable)(TNBargainRuleModel *ruleModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///查询首页活动广告图
- (void)queryBargainBannerSuccess:(void (^_Nullable)(NSString *banner))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///帮砍一刀
- (void)helpBargainWithTaskId:(NSString *)taskId
                   activityId:(NSString *)activityId
                      Success:(void (^_Nullable)(TNHelpBargainModel *rspModel))successBlock
                      failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 请求砍价商品列表页  需要传分类ID
- (void)queryBargainCategoryListWithCategoryId:(NSString *)categoryId
                                          page:(NSUInteger)page
                                          size:(NSUInteger)size
                                       success:(void (^_Nullable)(TNBargainGoodListRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取砍价专题数据
/// @param activityId 活动id
/// @param categoryId 分类id  如果是推荐   categoryId可不传
/// @param page 页码
/// @param size 页数
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryBargainActivityListActivityId:(NSString *)activityId
                                categoryId:(NSString *)categoryId
                                      page:(NSUInteger)page
                                      size:(NSUInteger)size
                                   success:(void (^_Nullable)(TNBargainGoodListRspModel *rspModel))successBlock
                                   failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取助力人记录列表数据
/// @param taskId 任务id
/// @param page 页码
/// @param size 一页数量
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryHelpPeopleRecordByTaskId:(NSString *)taskId
                                 page:(NSUInteger)page
                                 size:(NSUInteger)size
                              success:(void (^_Nullable)(TNBargainPeopleRecordRspModel *rspModel))successBlock
                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///砍价商品详情
- (void)queryBargainProductDetailsWithActivityId:(NSString *)activityId success:(void (^_Nullable)(TNProductDetailsRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
