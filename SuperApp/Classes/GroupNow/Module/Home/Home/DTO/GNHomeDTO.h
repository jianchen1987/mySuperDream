//
//  GNHomeDTO.h
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNArticlePagingRspModel.h"
#import "GNClassificationModel.h"
#import "GNColumnModel.h"
#import "GNCommentPagingRspModel.h"
#import "GNEnum.h"
#import "GNFilterModel.h"
#import "GNModel.h"
#import "GNProductPagingRspModel.h"
#import "GNStoreDetailModel.h"
#import "GNStorePagingRspModel.h"
#import "GNTopicModel.h"
#import "SAAddressZoneModel.h"
#import "SAAppEnvManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeDTO : GNModel

/// 查询商家详情
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)merchantDetailStoreNo:(nonnull NSString *)storeNo
                  productCode:(nullable NSString *)productCode
                      success:(nullable void (^)(GNStoreDetailModel *detailModel))successBlock
                      failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 获取产品详情
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)productGetDetailRequestCode:(nonnull NSString *)code success:(nullable void (^)(GNProductModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 查询城市是否有门店
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)merchantCheckCityWithCityCode:(nonnull NSString *)cityCode success:(void (^_Nullable)(BOOL result))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 模糊查询省/市/区
/// @param province 省或市
/// @param district 区
/// @param commune 社
/// @param defaultNum  是否返回默认值
/// @param lat 纬度
/// @param lon 经度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)fuzzyQueryZoneListWithProvince:(nullable NSString *)province
                                            district:(nullable NSString *)district
                                             commune:(nullable NSString *)commune
                                          defaultNum:(NSInteger)defaultNum
                                            latitude:(nullable NSString *)lat
                                           longitude:(nullable NSString *)lon
                                             success:(void (^_Nullable)(NSArray<SAAddressZoneModel *> *list))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询门店的状态
/// @param storeNo 门店
/// @param successBlock 成功回调
- (void)checkMerchantStatusWithStoreNo:(nonnull NSString *)storeNo success:(void (^_Nullable)(BOOL result, GNMessageCode *model))successBlock;

/// 评论列表
/// @param storeNo  storeNo
/// @param productCode productCode
/// @param pageNum pageNum
- (void)productReviewListWithStoreNo:(nonnull NSString *)storeNo
                         productCode:(nullable NSString *)productCode
                             pageNum:(NSInteger)pageNum
                             success:(void (^_Nullable)(BOOL result, GNCommentPagingRspModel *rspModel))successBlock;

/// 专题页信息
/// @param pageNum pageNum
/// @param topicPageNo 专题
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreTopicWithPageNum:(nullable NSNumber *)pageNum
                     topicPageNo:(nullable NSString *)topicPageNo
                         success:(void (^_Nullable)(GNTopicModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 2.0
///阿波罗配置
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getAplioConfigSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///首页栏目
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getHomeColumnListSuccess:(void (^)(NSArray<GNColumnModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///首页栏目商家列表
///@param pageNum 分页
///@param columnCode 栏目id
///@param columnType 栏目类型
///@param filter 筛选model
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getHomeColumnStoreListWithpageNum:(NSInteger)pageNum
                               columnCode:(nonnull NSString *)columnCode
                               columnType:(nonnull GNHomeColumnType)columnType
                                   filter:(nullable GNFilterModel *)filter
                                  success:(void (^)(GNStorePagingRspModel *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock)failureBlock;

///首页栏目文章列表
///@param pageNum 分页
///@param columnCode 栏目id
///@param columnType 栏目类型
///@param filter 筛选model
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getHomeColumnArticleListWithpageNum:(NSInteger)pageNum
                                 columnCode:(nonnull NSString *)columnCode
                                 columnType:(nonnull GNHomeColumnType)columnType
                                     filter:(nullable GNFilterModel *)filter
                                    success:(void (^)(GNArticlePagingRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock;
///获取二级分类
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getClassificationListWithCode:(nonnull NSString *)classificationCode success:(void (^)(NSArray<GNClassificationModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///获取分类下的商家列表
///@param pageNum 分页
///@param classificationCode 分类编码
///@param filter 筛选model
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getHomeClassificationStoreListWithPageNum:(NSInteger)pageNum
                                       parentCode:(nullable NSString *)parentCode
                               classificationCode:(nullable NSString *)classificationCode
                                           filter:(nullable GNFilterModel *)filter
                                          success:(void (^)(GNStorePagingRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock)failureBlock;

///获取分类下的商品列表
///@param pageNum 分页
///@param classificationCode 分类编码
///@param filter 筛选model
///@param successBlock 成功回调
///@param failureBlock 失败回调
- (void)getHomeClassificationProductListWithPageNum:(NSInteger)pageNum
                                         parentCode:(nullable NSString *)parentCode
                                 classificationCode:(nullable NSString *)classificationCode
                                             filter:(nullable GNFilterModel *)filter
                                            success:(void (^)(GNProductPagingRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
