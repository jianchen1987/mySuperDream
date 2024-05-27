//
//  TNStoreViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "TNFirstLevelCategoryModel.h"
#import "TNMicroShopDTO.h"
#import "TNMicroShopDetailInfoModel.h"
#import "TNStoreInfoRspModel.h"
#import "TNStoreSceneModel.h"
#import "TNStoreSceneRspModel.h"
#import "TNViewModel.h"

@class TNSellerProductRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNStoreViewModel : TNViewModel
/// 店铺信息
@property (nonatomic, strong) TNStoreInfoRspModel *storeInfo;
/// 微店信息
@property (strong, nonatomic) TNMicroShopDetailInfoModel *microShopInfo;
/// 店铺推荐分类数据
@property (nonatomic, strong) NSArray<TNCategoryModel *> *categoryList;
/// 店铺NO
@property (nonatomic, copy) NSString *storeNo;
/// 店铺dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 店铺实景数据
@property (strong, nonatomic) NSMutableArray<TNStoreSceneModel *> *sceneList;
/// 当前的实景数据rsp
@property (strong, nonatomic) TNStoreSceneRspModel *rspModel;
/// 是否请求过实景数据
@property (nonatomic, assign) BOOL hasLoadSceneData;
///  商家实景更改刷新
@property (nonatomic, assign) BOOL sceneRefreshTag;
/// 漏斗埋点用
@property (nonatomic, copy) NSString *funnel;
/// 获取店铺数据失败
@property (nonatomic, copy) void (^failGetStoreInfoDataCallBack)(void);
/// 是否来自选品中心
@property (nonatomic, assign) BOOL isFromProductCenter;
///  卖家ID
@property (nonatomic, copy) NSString *sp;
/// 是否显示全部商品列表  NO 显示商家实景
@property (nonatomic, assign) BOOL isShowAllProductList;
/// 商品列表Section
@property (nonatomic, strong) HDTableViewSectionModel *goodsListSection;

/// 埋点相关
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;

/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;
/*
 * 店铺展示的类型   根据 isFromProductCenter  和 sp 一起来判断   如果都有值  就是TNStoreViewShowTypeSellerToAdd
 * isFromProductCenter  和 sp  都没有值 TNStoreViewShowTypeNormal
 * isFromProductCenter 为false  和 sp 有值  TNStoreViewShowTypeUserToSeller
 */
@property (nonatomic, assign) TNStoreViewShowType storeViewShowType;

/// 获取门店信息
- (void)requestStoreInfoCompletion:(void (^)(void))completion;
/// 获取微店信息
- (void)requestMircoShopInfoCompletion:(void (^)(void))completion;
/// 获取店铺分类信息
- (void)requestStoreRecommendCategoryCompletion:(void (^)(void))completion;
/// 获取店铺实景数据
- (void)requestNewStoreSceneData;
/// 获取更多店铺实景数据
- (void)requestMoreStoreSceneData;
/// 添加收藏夹
//- (void)addStoreToFavoriteWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///// 移除收藏
//- (void)removeStoreFromFavoriteWithStoreNo:(NSString *)storeNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 请求所有分类数据
- (void)requestStoreAllCategoryDataSuccess:(void (^_Nullable)(NSArray<TNFirstLevelCategoryModel *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  微店主页的分类数据在 ES搜索列表返回  这里处理数据
- (void)prepareMicroShopCategoryDataByRspModel:(TNSellerProductRspModel *)rspModel;

///上送店铺滚动商品埋点
- (void)trackScrollProductsExposure;
@end

NS_ASSUME_NONNULL_END
