//
//  TNMicroShopViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSearchSortFilterModel.h"
#import "TNViewModel.h"
@class TNFirstLevelCategoryModel;
@class TNSellerProductModel;
@class TNMicroShopDetailInfoModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopViewModel : TNViewModel
/// 微店分类数据
@property (strong, nonatomic) NSMutableArray<TNFirstLevelCategoryModel *> *categoryList;
@property (nonatomic, assign) BOOL refreshFlag; ///< 刷新标记

@property (nonatomic, copy) void (^failGetNewDataCallback)(void);
/// 商品刷新标记
@property (nonatomic, assign) BOOL productsRefreshFlag;
/// 微店商品数组
@property (strong, nonatomic) NSMutableArray *productList;
/// 筛选模型
@property (nonatomic, strong) TNSearchSortFilterModel *searchSortFilterModel;
/// 加载商品数据当前页码
@property (nonatomic, assign) NSInteger currentPage;
/// 是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 商品列表请求失败
@property (nonatomic, copy) void (^productFailGetNewDataCallback)(void);

///获取微店分类数据
- (void)getMicroShopCategoryData;
///获取我的微店信息
- (void)getMyMicroShopInfoComplete:(void (^)(void))complete;
///获取商品第一页数据
- (void)getProductsNewData:(BOOL)isNeedShowSkeleton;
///加载更多商品数据
- (void)loadProductMoreData;

///通过卖家ID获取微店信息
- (void)getMicroShopInfoBySupplierId:(NSString *)supplierId complete:(void (^)(TNMicroShopDetailInfoModel *_Nullable infoModel, BOOL isSuccess))complete;
/// 获取用户加价策略
- (void)getSellerPricePolicyData;

/// 批量删除商品
- (void)batchDeleteProductsByProductArr:(NSArray<TNSellerProductModel *> *)productArr complete:(void (^)(void))complete;
/// 默认的全部分类模型
- (TNFirstLevelCategoryModel *)getDefaultCategoryModel;
@end

NS_ASSUME_NONNULL_END
