//
//  WMStoreListViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMAssociateSearchModel.h"
#import "WMCategoryItem.h"
#import "WMHomeTipView.h"
#import "WMSearchStoreRspModel.h"
#import "WMStoreFilterModel.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreListViewModel : WMViewModel
/// 获取门店列表
@property (nonatomic, strong) CMNetworkRequest *getStoreListRequest;
/// 是否显示购物车按钮
@property (nonatomic, assign) BOOL shouldShowShoppingCartBTN;
/// 过滤模型
@property (nonatomic, strong) WMStoreFilterModel *filterModel;
/// 品类
@property (nonatomic, copy) NSString *businessScope;
/// 成功获取品类数据
@property (nonatomic, copy) void (^successGetCategoryListBlock)(void);
/// 提示层枚举
@property (nonatomic, assign) WMHomeTipViewStyle tipViewStyle;
/// 是否从超A首页进入
@property (nonatomic, assign) BOOL isFromMasterHome;


/// 获取门店列表
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getStoreListWithPageSize:(NSUInteger)pageSize
                                       pageNum:(NSUInteger)pageNum
                                       success:(void (^_Nullable)(WMSearchStoreRspModel *rspModel))successBlock
                                       failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取门店搜索热门关键字
/// @param province 省市
/// @param district 地区
/// @param lat 纬度
/// @param lon 经度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getStoreSearchHotKeywordsWithProvince:(NSString *_Nullable)province
                                                   district:(NSString *_Nullable)district
                                                   latitude:(NSNumber *)lat
                                                  longitude:(NSNumber *)lon
                                                    success:(void (^)(NSArray<NSString *> *list))successBlock
                                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取品类
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getMerchantCategorySuccess:(void (^_Nullable)(NSArray<WMCategoryItem *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 搜索联想词
/// @param keyword 搜索关键词
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getAssociateSearchKeyword:(NSString *)keyword success:(void (^)(NSArray<WMAssociateSearchModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取活动配置参数
/// @param key key值
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock;

+ (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock;


- (CMNetworkRequest *)getNewStoreListWithPageSize:(NSUInteger)pageSize
                                          pageNum:(NSUInteger)pageNum
                                          success:(void (^_Nullable)(WMSearchStoreNewRspModel *rspModel))successBlock
                                          failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
