//
//  TNSectionTableViewSceneViewModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNGoodsModel.h"
#import "TNProductNavTitleModel.h"
#import "TNProductPurchaseTypeModel.h"
#import "TNSellerProductModel.h"
#import "TNViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TNProductDetailsRspModel;
@class TNAddItemToShoppingCarRspModel;
@class TNItemModel;
@class TNMarketingActivityModel;


@interface TNProductDetailsViewModel : TNViewModel
/// dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
/// 商品详情
@property (nonatomic, strong) TNProductDetailsRspModel *productDetailsModel;
/// 新品推荐数据
@property (strong, nonatomic) NSArray *recommendNewProductList;
/// 刷新标识
@property (nonatomic, assign) BOOL refreshFlag;
/// 刷新tableView
@property (nonatomic, assign) BOOL reloadData;

/// 详情显示样式
@property (nonatomic, assign) TNProductDetailViewType detailViewStyle;
/// 销售类型
@property (nonatomic, copy) TNSalesType salesType;
/// shareCode 解析 H5 link 带过来
@property (nonatomic, copy) NSString *shareCode;
/// fValue 控制 TNProductDetailBottomView 显示  /// 接受H5 带过来的参数key = f, f == buyNow
@property (nonatomic, copy) NSString *fValue;
/// 商品详情显示的标题数组
@property (strong, nonatomic) NSMutableArray<TNProductNavTitleModel *> *titleArr;
/// 记录原始入参记录
@property (nonatomic, strong) NSDictionary *originParameters;
/// 漏斗埋点用
@property (nonatomic, copy) NSString *funnel;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品sn  有些1688等海外购的商品没有商品id  通过sn 拉取详情数据
@property (nonatomic, copy) NSString *sn;
/// 商品来源渠道  获取详情入参给后台用
@property (nonatomic, copy) NSString *channel;
/// 供销码  卖家专有
@property (nonatomic, copy) NSString *sp;
/// 是否来自选品中心
@property (nonatomic, assign) BOOL isFromProductCenter;
/// 获取商品详情数据失败
@property (nonatomic, copy) void (^failGetProductDetaulDataCallBack)(SARspModel *rspModel);

///  微店id  查看第三方卖家  新增supplierId  用于标识
@property (nonatomic, copy) NSString *supplierId;
//埋点
///< 来源
@property (nonatomic, copy) NSString *source;
///< 关联ID
@property (nonatomic, copy) NSString *associatedId;
/// 埋点前缀
@property (nonatomic, copy) NSString *trackPrefixName;

///选品商品的模型  加入或取消回传用
@property (strong, nonatomic) TNSellerProductModel *sellerProductModel;
///选品店铺 加入或者取消销售回调
@property (nonatomic, copy) void (^addOrCancelSellerProductCallBack)(TNSellerProductModel *model);

///单买 批量购买说明
@property (strong, nonatomic) TNProductPurchaseTypeModel *purchaseTypeModel;

/// 获取普通商品详情
- (void)queryNomalProductDetailsData;
/// 获取 评论数据
- (void)queryReviewDataComplete:(void (^)(NSIndexPath *indexPath))complete;
/// 获取 店铺热卖推荐数据
- (void)queryStoreHotProductRecommendComplete:(void (^)(NSIndexPath *indexPath))complete;
/// 获取 新品推荐数据
- (void)queryNewProductRecommendComplete:(void (^)(NSIndexPath *indexPath))complete;
/// 添加购物车
/// @param itemModel 购物项模型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)addProductToShoppingCartWithItemModel:(TNItemModel *)itemModel
                                      success:(void (^_Nullable)(TNAddItemToShoppingCarRspModel *rspModel))successBlock
                                      failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
