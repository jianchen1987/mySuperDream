//
//  WMStoreDetailBaseView.h
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
#import "SAView.h"
#import "WMCNStoreDetailOrderFoodCateCell.h"
#import "WMChooseGoodsPropertyAndSkuView.h"
#import "WMCouponActivityContentModel.h"
#import "WMCustomViewActionView.h"
#import "WMGotCouponsView.h"
#import "WMManage.h"
#import "WMOneClickCouponAlert.h"
#import "WMPromotionLabel.h"
#import "WMShoppingCartOrderCheckItem.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingGoodTableViewCell.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailCategoryTitleContainerHeaderView.h"
#import "WMStoreDetailHeaderTableViewCell+Skeleton.h"
#import "WMStoreDetailViewProtocol.h"
#import "WMStoreImageShareView.h"
#import "WMStoreMenuItem.h"
#import "UITableView+RecordData.h"
#import "SJVideoPlayer.h"

#define kTableViewContentInsetTop kNavigationBarH
#define kZoomImageViewHeight (kTableViewContentInsetTop + 10)
static const NSUInteger kPinSectionIndex = 1;
#define kPinCategoryViewTop kRealWidth(0)
#define kStoreDetailCategoryTitleViewHeight kRealWidth(46)

NS_ASSUME_NONNULL_BEGIN

@interface WMStoreDetailBaseView : SAView <WMStoreDetailViewProtocol>
/// 播放器
@property (strong, nonatomic) SJVideoPlayer *player;
/// 播放器视图的位置  记录一次
@property (nonatomic, assign) CGFloat playerMaxY;
/// 记录视频播放时间用
@property (nonatomic, assign) double videoTime;

@end

NS_ASSUME_NONNULL_END
