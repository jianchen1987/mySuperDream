//
//  WMStoreDetailViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "SANoDataCellModel.h"
#import "SAWindowManager.h"
#import "WMCouponActivityModel.h"
#import "WMCouponsDTO.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMOneClickResultModel.h"
#import "WMOrderDetailDTO.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailAdaptor.h"
#import "WMStoreDetailDTO.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreFavouriteDTO.h"
#import "WMStoreGoodsItem.h"
#import "WMStoreGoodsRspModel.h"
#import "WMStoreMenuItem.h"
#import "WMStoreMenuModel.h"
#import "WMStoreShoppingCartDTO.h"
#import "WMViewModel.h"
#import <HDUIKit/HDTableHeaderFootViewModel.h>
#import <HDUIKit/HDTableViewSectionModel.h>

/// 一次请求获取商品的基准数量  实际可能会多一点
static NSInteger getGoodsMaxCount = 30;
/// 头部增加的section数量，目前包括门店信息和悬停tab
static const NSUInteger kPinSectionBeforeHasIndex = 2;

NS_ASSUME_NONNULL_BEGIN

@class HDTableViewSectionModel;


@interface WMStoreDetailViewModel : WMViewModel
/// 门店 id
@property (nonatomic, copy) NSString *storeId;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;
/// 商品 id
@property (nonatomic, copy) NSString *productId;
/// 菜单 id
@property (nonatomic, copy) NSString *menuId;
/// 入口是否为再来一单
@property (nonatomic, assign) BOOL isFromOnceAgain;
/// 再来一单订单id
@property (nonatomic, copy, nullable) NSString *onceAgainOrderNo;
/// 是否已获取初始化数据
@property (nonatomic, assign) BOOL hasGotInitializedData;
/// 记录是否已经主动滚动至指定 cell，只应该自动滚动一次
@property (nonatomic, assign) BOOL hasAutoScrolledToSpecIndexPath;
/// scrollMenuId
@property (nonatomic, copy) NSString *scrollMenuId;
/// scrollMenuIndex
@property (nonatomic, assign) NSInteger scrollMenuIndex;
/// 主动滚动至指定 cell 的 indexPath
@property (nonatomic, strong) NSIndexPath *autoScrolledToIndexPath;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否已经进行过初始数据加载进行订单试算的操作
@property (nonatomic, assign) BOOL hasInitializedOrderPayTrialCalculate;
/// 起送价是否因为特殊原因不一致 有的话不为nil 提示语
@property (nonatomic, copy, nullable) NSString *requiredDiffStr;
/// 是否弹起送价改变弹窗
@property (nonatomic, assign) BOOL needShowRequiredPriceChangeToast;

/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;

/// 详情信息
@property (nonatomic, strong, nullable) WMStoreDetailRspModel *detailInfoModel;
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
@property (nonatomic, copy) NSArray<WMStoreMenuItem *> *menuList;
/// 该店在购物车中的购物项
@property (nonatomic, strong, nullable) WMShoppingCartStoreItem *shopppingCartStoreItem;
/// 购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 门店详情 DTO
@property (nonatomic, strong) WMStoreDetailDTO *storeDetailDTO;
/// 订单详情 DTO
@property (nonatomic, strong) WMOrderDetailDTO *orderDetailDTO;
/// 门店收藏 DTO
@property (nonatomic, strong) WMStoreFavouriteDTO *storeFavouriteDTO;
/// 券 DTO
@property (nonatomic, strong) WMCouponsDTO *couponDTO;
/// 菜单是否为空的标志，为空可能是菜单列表为空或者所有菜单的菜品总和为0
@property (nonatomic, assign) BOOL isValidMenuListEmpty;
/// 菜单是否为空的标志子项，菜单列表为空
@property (nonatomic, assign) BOOL isMenuListEmpty;
/// 菜单是否为空的标志子项，所有菜单的菜品总和为0
@property (nonatomic, assign) BOOL isTotalCountZero;
/// 试算模型
@property (nonatomic, strong, nullable) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// 门店菜单查询
@property (nonatomic, strong) CMNetworkRequest *getMenuListRequest;
/// 根据门店id查询所有菜单
@property (nonatomic, strong) CMNetworkRequest *getGoodsListRequest;
/// 购物车总数
@property (nonatomic, assign) NSInteger storeProductTotalCount;
/// 门店是否被禁用或停业
@property (nonatomic, assign) BOOL isStoreClosed;
/// 门店禁用或停业文案
@property (nonatomic, copy) NSString *storeClosedMsg;
/// 当次拉取的商品数据源
@property (strong, nonatomic) NSArray<WMStoreGoodsItem *> *currentRequestGoods;
/// 定位过来的商品所在的menuId
@property (nonatomic, copy) NSString *positionMenuId;
/// 根据商品id获取所在菜单id
@property (nonatomic, strong) CMNetworkRequest *getMenuIdRequest;
/// 是否包含特价商品菜单
@property (nonatomic, assign) BOOL hasBestSaleMenu;
/// 今日可购买特价商品数量
@property (nonatomic, assign) NSUInteger availableBestSaleCount;
/// 已经请求过的菜单id
@property (nonatomic, strong) NSMutableArray<NSString *> *alreadyRequestMenuIds;
/// 当前起送价
@property (nonatomic, strong) SAMoneyModel *requiredPrice;
/// 门店关闭显示的model
@property (nonatomic, strong) SANoDataCellModel *noDateCellModel;

/// 完成了请求详情
@property (nonatomic, assign) BOOL finishRequetDetail;
/// 完成了请求菜单
@property (nonatomic, assign) BOOL finishRequetMenu;

///刷新第一次请求商品
@property (nonatomic, assign) BOOL refreshFlagFirstGoods;

///处理数据
- (void)dealData;
/// 门店菜单查询
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getMenuListSuccess:(void (^)(NSArray<WMStoreMenuItem *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 获取初始化数据
- (void)getInitializedData;

/// 重拿购物车数据
- (void)reGetShoppingCartItems;

/// 更新本地购物车的商品数量
- (void)updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:(WMShoppingCartUpdateGoodsRspModel *)rspModel;

/// 重拿购物车数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)reGetShoppingCartItemsSuccess:(void (^_Nullable)(WMShoppingCartStoreItem *storeItem))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 订单试算（包含优惠信息返回）
/// @param items 试算所需数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)payFeeTrialCalculateWithCalItem:(NSArray<WMShoppingCartPayFeeCalItem *> *_Nullable)items
                                success:(void (^_Nullable)(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 根据滚动位置  去拉取当前菜单前后的数据  如果没有设置loadTop  loadDown默认是按index取前后的数据
/// @param index 滚动的位置
/// @param loadTop 是否向上获取数据源
/// @param loadDown 是否向下获取数据源
/// @param completion 完成回调
- (void)getGoodListByIndex:(NSInteger)index loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown completion:(void (^)(BOOL isSuccess))completion;

///通过商品ID获取菜单
- (CMNetworkRequest *)getMenuIdByGoodId:(NSString *)goodId Success:(void (^)(NSString *_Nonnull menuId))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 通过菜单id获取商品数
- (CMNetworkRequest *)getMenuGoodsListByMemuIds:(NSArray<NSString *> *)menuIds success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
- (BOOL)isValidMenuListEmpty;
/// 收藏/取消收藏门店
- (void)favouriteStore;

/// 获取最新优惠券
- (void)getNewCouponsCompletion:(void (^)(WMCouponActivityContentModel *rspModel))completion;

/// 获取所有优惠券
- (void)getAllCouponsCompletion:(void (^)(WMCouponActivityModel *rspModel))completion;

///  一键领券
- (void)oneClickCouponWithActivityNo:(NSString *)activityNo
                            couponNo:(NSArray<NSString *> *)couponNo
                         storeJoinNo:(NSString *)storeJoinNo
                          completion:(void (^)(WMOneClickResultModel *rspModel))completion;

///私有方法
- (void)updateShoppingCartTotalCount;
- (void)setAutoScollerToTargetIndex;
- (void)setgoodItemSkuCountModel:(NSArray<WMStoreGoodsItem *> *)goodsArr;
- (void)getFirstMenuGoodDataSuccess:(void (^)(void))successBlock;
@end

NS_ASSUME_NONNULL_END
