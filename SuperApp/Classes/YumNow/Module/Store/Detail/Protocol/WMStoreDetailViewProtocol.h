//
//  WMStoreDetailViewProtocol.h
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//
#import "GNEvent.h"
#import "LKDataRecord.h"
#import "SAAddressModel.h"
#import "SAAppEnvManager.h"
#import "SACacheManager.h"
#import "SANoDataCell.h"
#import "SAShareWebpageObject.h"
#import "SASocialShareView.h"
#import "SATableView.h"
#import "WMChooseGoodsPropertyAndSkuView.h"
#import "WMCouponActivityContentModel.h"
#import "WMCustomViewActionView.h"
#import "WMGotCouponsView.h"
#import "WMManage.h"
#import "WMOneClickCouponAlert.h"
#import "WMPromotionLabel.h"
#import "WMRestaurantNavigationBarView.h"
#import "WMShoppingCartOrderCheckItem.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingGoodTableViewCell.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreCartBottomDock.h"
#import "WMStoreDetailCategoryTitleContainerHeaderView.h"
#import "WMStoreDetailHeaderTableViewCell+Skeleton.h"
#import "WMStoreDetailHeaderTableViewCell.h"
#import "WMStoreDetailViewModel.h"
#import "WMStoreImageShareView.h"
#import "WMStoreMenuItem.h"
#import "WMStoreShoppingCartDTO.h"
#import "WMStoreShoppingCartViewController.h"
#import "WMStoreActivityMdoel.h"

NS_ASSUME_NONNULL_BEGIN

#define kTableViewContentInsetTop kNavigationBarH
#define kZoomImageViewHeight (kTableViewContentInsetTop + 10)

@protocol WMStoreDetailViewProtocol <NSObject>
/// 导航部分
@property (nonatomic, strong) WMRestaurantNavigationBarView *customNavigationBar;
/// 门店图片
@property (nonatomic, strong) UIImageView *zoomableImageV;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// VM
@property (nonatomic, strong) WMStoreDetailViewModel *viewModel;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 门店购物车 Dock
@property (nonatomic, strong) WMStoreCartBottomDock *shoppingCartDockView;
/// 门店购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 头部 cell
@property (nonatomic, strong) WMStoreDetailHeaderTableViewCell *headerCell;
/// 门店购物车
@property (nonatomic, strong) WMStoreShoppingCartViewController *storeShoppingCartVC;
/// 限购提示View
@property (nonatomic, strong) UIView *limitTipsView;
/// 限购提示文案
@property (strong, nonatomic) UILabel *limitTipsLabel;
/// 记录上次置顶的section
@property (nonatomic, assign) NSInteger lastSection;
/// 当前section的rect
@property (nonatomic, assign) CGRect currentSectionRect;
/// 正在加载数据
@property (nonatomic, assign) BOOL isLoadingData;
/// 门店图片
@property (nonatomic, strong) SATableView *tableView;
/// shareConfig
@property (nonatomic, strong) NSDictionary *shareConfig;
/// 分享的活动
@property (nonatomic, strong) WMStoreActivityMdoel *shareActivityModel;

///所有优惠券活动
- (void)getAllCouponAction;
///最新优惠券活动
- (void)getNewCouponAction;
///一键领取弹窗
- (void)showOneClickAlert:(WMCouponActivityContentModel *)rspModel;
///展示统一弹窗
- (void)showAlert:(NSString *)info;
///展示底部弹出优惠券
- (void)showBottomCoupons:(WMCouponActivityModel *)rspModel;
///处理底部休息中显示
- (void)dealEventWithBottom;

- (void)addShoppingGoodsWithAddDelta:(NSUInteger)addDelta
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId;

- (void)updateShoppingGoodsWithCount:(NSUInteger)count
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId;
/// 下单前检查门店状态
- (void)checkStoreStatus;

- (void)showChooseGoodsSkuAndPropertyViewWithModel:(WMStoreGoodsItem *)goodsModel;
/// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMStoreGoodsItem *)currentGoods;
/// 根据试算信息更新底门店购物车 Dock
- (void)updateStoreCartDockViewWithupdateStoreCartDockViewWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel;
///分享
- (void)shareStore;
///下单检查异常处理
- (void)orderCheckFailureWithRspModel:(SARspModel *)rspModel goToOrderSubmitPage:(void (^)(void))goToOrderSubmitPage;
///加购物车异常处理
- (void)addToCartFailureWithRspModel:(SARspModel *)rspModel;

- (void)dealingWithAutoScrollToSpecifiedIndexPath;

- (void)reloadTableViewAndTableHeaderView;

- (void)reloadFirstGoodsTableView;

- (UITableViewCell *)setUpModel:(id)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)cellWilldisplayTbleView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(id)model;

- (void)tableViewScollToMenuList:(NSInteger)goodIndex;
/// 根据 UIScrollView 偏移来滚动到对应标题
- (void)handlerSrollNavBarWithScrollView:(UIScrollView *)scrollView;
/// 设置菜单栏的选中位置
- (void)setPinCategoryViewSelectedItem:(NSInteger)selectedIndex;
/// 获取 indexpath所在的位置
- (CGRect)getSectionHeaderPathRect:(NSInteger)section;
/// 根据位置拉取对应的类目数据
- (void)loadGoodsByScrollerIndex:(NSInteger)index isClickIndex:(BOOL)isClickIndex loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown isNeedFixContentOffset:(BOOL)isNeedFixContentOffse;
@end

NS_ASSUME_NONNULL_END
