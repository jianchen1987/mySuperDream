//
//  WMStoreInfoView.h
//  SuperApp
//
//  Created by Chaos on 2020/6/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoView.h"
#import "SATableView.h"
#import "SAView.h"
#import "WMPromotionItemView.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreDetailRspModel.h"
#import "WMStoreInfoTableHeaderView.h"
#import "WMStoreInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreInfoView : SAView <HDSkeletonLayerLayoutProtocol>
/// viewModel
@property (nonatomic, strong) WMStoreInfoViewModel *viewModel;
/// 头部信息
@property (nonatomic, strong) WMStoreInfoTableHeaderView *headerView;
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// promotions
@property (nonatomic, strong) SALabel *promotionsTitleLabel;
/// 优惠信息背景
@property (nonatomic, strong) UIView *promotionsBgView;
/// 公告title
@property (nonatomic, strong) SALabel *noticeTitleLabel;
/// 公告
@property (nonatomic, strong) SALabel *noticeLabel;
/// 公告line
@property (nonatomic, strong) UIView *noticeLine;
/// 营业时间图标
@property (nonatomic, strong) UIImageView *businessIconView;
/// 营业时间title
@property (nonatomic, strong) SALabel *businessTitleLabel;
/// 营业时间Label
@property (nonatomic, strong) YYLabel *businessLabel;
/// 营业时间线
@property (nonatomic, strong) UIView *businessLine;
/// 品类图标
@property (nonatomic, strong) UIImageView *businessScopesIconView;
/// 品类标题
@property (nonatomic, strong) SALabel *businessScopesTitleLabel;
/// 品类
@property (nonatomic, strong) SALabel *businessScopesLabel;
/// 品类线
@property (nonatomic, strong) UIView *businessScopesLine;
/// 支付方式图标
@property (nonatomic, strong) UIImageView *payMethodIconView;
/// 支付方式title
@property (nonatomic, strong) SALabel *payMethodTitleLabel;
/// 支付方式Label
@property (nonatomic, strong) SALabel *payMethodLabel;
/// 满减
@property (nonatomic, strong) WMPromotionItemView *offItemView;
/// less
@property (nonatomic, strong) WMPromotionItemView *lessItemView;
/// 配送
@property (nonatomic, strong) WMPromotionItemView *deliveryItemView;
/// 首单
@property (nonatomic, strong) WMPromotionItemView *firstItemView;
/// 优惠券
@property (nonatomic, strong) WMPromotionItemView *couponItemView;
/// 满赠
@property (nonatomic, strong) WMPromotionItemView *fillGiftView;
/// 领取门店优惠券
@property (nonatomic, strong) WMPromotionItemView *giveCouponItemView;
/// 券包
@property (nonatomic, strong) WMPromotionItemView *couponPackItemView;

- (void)addNormalView;

- (void)updateConstrainAction;

- (void)hd_reloadData;

- (void)configPromotionItemView;
@end

NS_ASSUME_NONNULL_END
