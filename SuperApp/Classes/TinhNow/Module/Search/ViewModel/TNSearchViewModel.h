//
//  TNSearchViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNGoodsModel;

@class TNQueryGoodsRspModel;
@class TNCategoryModel;


@interface TNSearchViewModel : TNSearchBaseViewModel
///
@property (nonatomic, strong) TNQueryGoodsRspModel *rspModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray<TNGoodsModel *> *searchResult;
/// 三类分类数据源  用于分类搜索页展示分类数据
@property (nonatomic, strong) NSArray<TNCategoryModel *> *categoryList;
/// 热销商品数据
@property (nonatomic, strong) NSArray<TNGoodsModel *> *hotGoodsList;
/// 二级分类id  用于在分类搜索页面  三级id 同父类 一起传给后台
@property (nonatomic, copy) NSString *parentSC;
/// 是否需要调整滚动视图的contentOffset
@property (nonatomic, assign) BOOL isNeedUpdateContentOffset;
/// 漏斗埋点用
@property (nonatomic, copy) NSString *funnel;
/// 店铺id
@property (nonatomic, copy) NSString *storeNo;
/// 专题id
@property (nonatomic, copy) NSString *specialId;
/// 专题或者店铺搜索 标记
@property (nonatomic, assign) BOOL specificRefreshFlag;
/// 专题列表的筛选类型  0 是全部   2 是推荐 不包含热销
@property (nonatomic, assign) NSInteger specificActivityHotType;

/// 页面id  埋点用
@property (nonatomic, copy) NSString *eventPageId;
/// 专题  还是店铺的参数埋点用
@property (nonatomic, copy) NSMutableDictionary *eventProperty;

/// 获取新数据失败回调
@property (nonatomic, copy) void (^failGetNewDataCallback)(void);
- (void)requestNewData;

- (void)loadMoreData;

- (void)searchGoodsPageNo:(NSUInteger)pageNo
                 pageSize:(NSUInteger)pageSize
                  success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取分类热销商品列表
- (void)queryHotGoodsList;
/// 获取专题热销的数据
- (void)querySpecialActivityHotListDataSuccess:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///获取普通专题列表数据
- (void)querySpecialActivityNomalListPageNo:(NSUInteger)pageNo
                                   pageSize:(NSUInteger)pageSize
                                    hotType:(NSInteger)hotType
                                    success:(void (^_Nullable)(TNQueryGoodsRspModel *rspModel))successBlock
                                    failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
