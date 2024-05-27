//
//  WMStoreDetailBaseView.m
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//
#import "WMStoreDetailBaseView.h"
#import "WMGoodFailView.h"
#import "WMShoppingCartBatchDeleteItem.h"
#import "SACommonConst.h"
#import "SAAddressCacheAdaptor.h"
#import "HDAppTheme+TinhNow.h"
#import "SJFloatSmallViewController.h"

@implementation WMStoreDetailBaseView
@synthesize customNavigationBar = _customNavigationBar;
@synthesize zoomableImageV = _zoomableImageV;
@synthesize dataSource = _dataSource;
@synthesize viewModel = _viewModel;
@synthesize provider = _provider;
@synthesize shoppingCartDockView = _shoppingCartDockView;
@synthesize storeShoppingCartDTO = _storeShoppingCartDTO;
@synthesize headerCell = _headerCell;
@synthesize storeShoppingCartVC = _storeShoppingCartVC;
@synthesize limitTipsView = _limitTipsView;
@synthesize limitTipsLabel = _limitTipsLabel;
@synthesize lastSection = _lastSection;
@synthesize currentSectionRect = _currentSectionRect;
@synthesize isLoadingData = _isLoadingData;
@synthesize tableView = _tableView;
@synthesize shareConfig = _shareConfig;
@synthesize shareActivityModel = _shareActivityModel;

static SJEdgeControlButtonItemTag WMEdgeControlBottomMuteButtonItemTag = 101; //声音按钮
static SJEdgeControlButtonItemTag WMEdgeControlCenterPlayButtonItemTag = 102; //播放按钮

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bgGray;
    // 增加门店购物车界面
    [self.viewController addChildViewController:self.storeShoppingCartVC];
    [self addSubview:self.storeShoppingCartVC.view];
    [self.storeShoppingCartVC didMoveToParentViewController:self.viewController];
    [self addSubview:self.shoppingCartDockView];
    [self getNewCouponAction];
    [self getShareConfig];
    [self getShareActivity];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"refreshFlag"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self reloadTableViewAndTableHeaderView];
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"refreshFlagFirstGoods"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self reloadFirstGoodsTableView];
        [HDFunctionThrottle throttleCancelWithKey:@"dealingWithAutoScrollToSpecifiedIndexPath"];
        [HDFunctionThrottle throttleWithInterval:0.5 key:@"dealingWithAutoScrollToSpecifiedIndexPath" handler:^{
            [self dealingWithAutoScrollToSpecifiedIndexPath];
        }];
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"payFeeTrialCalRspModel"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel = change[NSKeyValueChangeNewKey];
        [self updateStoreCartDockViewWithupdateStoreCartDockViewWithPayFeeTrialCalRspModel:payFeeTrialCalRspModel];
        [self dealingWithAutoScrollToSpecifiedIndexPath];

        // 更新门店购物车
        if (!self.storeShoppingCartVC.canExpand) { // 已经展开,不更新，按需求商品下架后需要保留显示
            [self.storeShoppingCartVC updateUIWithShopppingCartStoreItem:self.viewModel.shopppingCartStoreItem payFeeTrialCalRspModel:payFeeTrialCalRspModel];
        }
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"detailInfoModel.favourite"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL favourite = [change[NSKeyValueChangeNewKey] boolValue];
        [self.customNavigationBar updateFavouriteBTN:favourite];
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"requiredPrice"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.shoppingCartDockView setDeliveryStartPointPrice:self.viewModel.requiredPrice startPointPriceDiff:self.viewModel.requiredDiffStr];
    }];
}

- (void)reloadFirstGoodsTableView {
}

- (void)reloadTableViewAndTableHeaderView {
}

- (void)dealingWithAutoScrollToSpecifiedIndexPath {
}

///所有优惠券活动
- (void)getAllCouponAction {
    @HDWeakify(self)
    [self showloading];
    [self.viewModel getAllCouponsCompletion:^(WMCouponActivityModel *_Nonnull rspModel) {
        @HDStrongify(self)
        [self dismissLoading];
        if (rspModel) {
            [self showBottomCoupons:rspModel];
        }
    }];
}

///最新优惠券活动
- (void)getNewCouponAction {
    @HDWeakify(self)
    [self.viewModel getNewCouponsCompletion:^(WMCouponActivityContentModel *_Nonnull rspModel) {
        @HDStrongify(self)
        NSString *key = [NSString stringWithFormat:@"%@_%@", SAUser.shared.operatorNo, rspModel.activityNo];
        BOOL show = YES;
        if (!rspModel || [NSUserDefaults.standardUserDefaults objectForKey:key])
            show = NO;
        if (show)
            [self showOneClickAlert:rspModel];
    }];
}

///一键领取弹窗
- (void)showOneClickAlert:(WMCouponActivityContentModel *)rspModel {
    WMOneClickCouponAlert *alert = [[WMOneClickCouponAlert alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    alert.rspModel = rspModel;
    @HDWeakify(self)
    @HDWeakify(alert)
    alert.clickedConfirmBlock = ^(WMCouponActivityContentModel *_Nonnull rspModel) {
        @HDStrongify(self)
        __block NSMutableArray *couponArr = NSMutableArray.new;
        [rspModel.coupons enumerateObjectsUsingBlock:^(WMStoreCouponDetailModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [couponArr addObject:obj.couponNo];
        }];
        @HDStrongify(alert)
        [self showloading];
        [self.viewModel oneClickCouponWithActivityNo:rspModel.activityNo couponNo:couponArr storeJoinNo:rspModel.storeJoinNo completion:^(WMOneClickResultModel *_Nonnull rspModel) {
            [alert dissmiss];
            [self dismissLoading];
            if ([rspModel.resultCode isEqualToString:WMGiveCouponResultAllFail]) {
                if (!HDIsArrayEmpty(rspModel.couponResult) && rspModel.couponResult.firstObject.errorCode) {
                    [self showAlert:WMManage.shareInstance.giveCouponErrorInfo[rspModel.couponResult.firstObject.errorCode]];
                } else {
                    [self showAlert:WMManage.shareInstance.giveCouponErrorInfo[rspModel.errorCode]];
                }
            } else {
                [self showAlert:WMLocalizedString(@"wm_receive_successful", @"领取成功，快去使用吧！")];
            }
        }];
    };
    [self addSubview:alert];
    [alert show];
}

- (void)showAlert:(NSString *)info {
    [NAT showAlertWithMessage:info buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
        [alertView dismiss];
    }];
}

///展示底部弹出优惠券
- (void)showBottomCoupons:(WMCouponActivityModel *)rspModel {
    WMGotCouponsView *reasonView = [[WMGotCouponsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.8)];
    reasonView.rspModel = rspModel;
    reasonView.storeNo = self.viewModel.storeNo;
    [reasonView layoutyImmediately];
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"wm_storecoupon", @"门店优惠券");
    }];
    [actionView show];
    @HDWeakify(actionView) reasonView.hideBlock = ^(BOOL hide) {
        @HDStrongify(actionView);
        if (hide) {
            [actionView dismiss];
        } else {
            [actionView show];
        }
    };
    reasonView.clickedConfirmBlock = ^(WMStoreCouponDetailModel *_Nonnull rspModel) {
        [actionView dismiss];
        if ([SAWindowManager canOpenURL:rspModel.appLink]) {
            if (![rspModel.appLink containsString:self.viewModel.storeNo]) {
                [SAWindowManager openUrl:rspModel.appLink withParameters:nil];
            }
        }
    };
}

///处理底部显示
- (void)dealEventWithBottom {
    ///下次服务时间
    if (self.viewModel.detailInfoModel.nextServiceTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.detailInfoModel.storeStatus.status nextServiceTimeModel:self.viewModel.detailInfoModel.nextServiceTime];
        return;
    }
    ///下次营业时间
    if (self.viewModel.detailInfoModel.nextBusinessTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.detailInfoModel.storeStatus.status nextBuinessTimeModel:self.viewModel.detailInfoModel.nextBusinessTime];
        return;
    }
    ///休息中
    if ([self.viewModel.detailInfoModel.storeStatus.status isEqualToString:WMStoreStatusResting]) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.detailInfoModel.storeStatus.status businessHours:self.viewModel.detailInfoModel.businessHours];
        return;
    }
    ///特殊区域
    if (self.viewModel.detailInfoModel.effectTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.detailInfoModel.storeStatus.status effectTimeTimeModel:self.viewModel.detailInfoModel.effectTime];
        return;
    }
    ///爆单
    if (self.viewModel.detailInfoModel.fullOrderState == WMStoreFullOrderStateFullAndStop) {
        [self.shoppingCartDockView setFullOrderState:self.viewModel.detailInfoModel.fullOrderState storeNo:self.viewModel.storeNo];
        return;
    }
}

///响应传递事件
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///底部全部优惠券弹窗
    if ([event.key isEqualToString:@"showBottomCouponAction"]) {
        [self getAllCouponAction];
    }
}

- (void)cellWilldisplayTbleView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(id)model {
    if ([model isKindOfClass:WMStoreGoodsItem.class]) {
        WMStoreGoodsItem *itemModel = model;
        if (itemModel.goodId) {
            /// 3.0.19.0曝光埋点
            NSDictionary *param = @{
                @"exposureSort": @(indexPath.row).stringValue,
                @"storeNo": itemModel.storeNo,
                @"productId": itemModel.goodId,
                @"type": @"storePageProduct",
                @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:NO],
                @"plateId": WMManage.shareInstance.plateId
            };
            [tableView recordStoreExposureCountWithValue:itemModel.storeNo key:itemModel.mShowTime indexPath:indexPath info:param eventName:@"takeawayProductExposure"];
        }
    }
}

- (UITableViewCell *)setUpModel:(id)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    if ([model isKindOfClass:WMStoreGoodsItem.class]) {
        WMShoppingGoodTableViewCell *cell = [WMShoppingGoodTableViewCell cellWithTableView:tableView];
        WMStoreGoodsItem *trueModel = (WMStoreGoodsItem *)model;
        trueModel.needHideBottomLine = true;
        
        cell.model = trueModel;
        cell.goodsFromShoppingCartShouldChangeBlock = ^BOOL(WMStoreGoodsItem *model, BOOL isIncreate, NSUInteger count) {
            @HDStrongify(self);
            if (isIncreate && self.viewModel.storeProductTotalCount >= 150) {
                [NAT showAlertWithTitle:nil
                                message:WMLocalizedString(@"cart_is_full", @"Shopping cart is full, please clean up.") confirmButtonTitle:WMLocalizedString(@"view_cart", @"View Cart")
                   confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [HDMediator.sharedInstance navigaveToShoppingCartViewController:nil];
                        [alertView dismiss];
                    
                    }
                      cancelButtonTitle:WMLocalizedString(@"cart_not_now", @"Not now") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    
                    }];
                return NO;
            }
            return YES;
        };
        cell.goodsFromShoppingCartChangedBlock = ^(WMStoreGoodsItem *model, BOOL isIncreate, NSUInteger count) {
            @HDStrongify(self);
            if (isIncreate) {
                WMManage.shareInstance.selectGoodId = model.goodId;
                [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:model.productPromotion currentCount:count otherSkuCount:0];
                if (model.bestSale) {
                    [WMPromotionLabel showToastWithMaxCount:self.viewModel.availableBestSaleCount
                                               currentCount:count
                                              otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model]
                                                 promotions:self.viewModel.payFeeTrialCalRspModel.promotions];
                }
            }
            NSMutableArray<NSString *> *propertyIds = [NSMutableArray arrayWithCapacity:model.propertyList.count];
            for (WMStoreGoodsProductProperty *propertyModel in model.propertyList) {
                if (propertyModel.optionList.firstObject.optionId) {
                    [propertyIds addObject:propertyModel.optionList.firstObject.optionId];
                }
            }
            [self updateShoppingGoodsWithCount:count
                                       goodsId:model.goodId
                                    goodsSkuId:model.specificationList.firstObject.specificationId
                                   propertyIds:propertyIds
                             inEffectVersionId:model.inEffectVersionId];
        };
        cell.plusGoodsToShoppingCartBlock = ^(WMStoreGoodsItem *model, NSUInteger forwardCount) {
            @HDStrongify(self);
            // 加购埋点,用于统计转化
            if (self.viewModel.plateId) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
                    @"type": self.viewModel.collectType,
                    @"plateId": self.viewModel.plateId,
                    @"content": @[model.goodId]}];
                if (self.viewModel.topicPageId)
                    mdic[@"topicPageId"] = self.viewModel.topicPageId;
                [LKDataRecord.shared traceEvent:@"addShopCart"
                                           name:@"外卖_购物车"
                                     parameters:mdic
                                            SPM:[LKSPM SPMWithPage:@"WMStoreDetailViewController" area:@"AddShopCartView" node:@""]];
            }

            // 埋点，请勿删除
            [LKDataRecord traceYumNowEvent:@"add_shopcartV2"
                                      name:@"外卖_购物车_加购"
                                       ext:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖门店详情页"] : @"外卖门店详情页",
                @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
                @"goodsId": model.goodId,
                @"storeNo" : self.viewModel.storeNo
            }];
            
            WMManage.shareInstance.selectGoodId = model.goodId;
            [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:model.productPromotion currentCount:forwardCount otherSkuCount:0];
            if (model.bestSale) {
                [WMPromotionLabel showToastWithMaxCount:self.viewModel.availableBestSaleCount currentCount:forwardCount
                                          otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model]
                                             promotions:self.viewModel.payFeeTrialCalRspModel.promotions];
            }
            NSMutableArray<NSString *> *propertyIds = [NSMutableArray arrayWithCapacity:model.propertyList.count];
            for (WMStoreGoodsProductProperty *propertyModel in model.propertyList) {
                if (propertyModel.optionList.firstObject.optionId) {
                    [propertyIds addObject:propertyModel.optionList.firstObject.optionId];
                }
            }
            if (self.viewModel.storeProductTotalCount >= 150) {
                [NAT showAlertWithTitle:nil message:WMLocalizedString(@"cart_is_full", @"Shopping cart is full, please clean up.") confirmButtonTitle:WMLocalizedString(@"view_cart", @"View Cart")
                    confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [HDMediator.sharedInstance navigaveToShoppingCartViewController:nil];
                        [alertView dismiss];
                    }
                    cancelButtonTitle:WMLocalizedString(@"cart_not_now", @"Not now") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }];
            } else {
                [self addShoppingGoodsWithAddDelta:forwardCount
                                           goodsId:model.goodId
                                        goodsSkuId:model.specificationList.firstObject.specificationId
                                       propertyIds:propertyIds
                                 inEffectVersionId:model.inEffectVersionId];
            }
        };
        cell.cellClickedEventBlock = ^(WMStoreGoodsItem *_Nonnull model) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToStoreProductDetailController:@{
                @"storeNo": self.viewModel.storeNo,
                @"goodsId": model.goodId,
                @"isPresent": @(false),
                @"availableBestSaleCount": @(self.viewModel.availableBestSaleCount),
                /// 3.0埋点
                @"plateId": self.viewModel.plateId,
                @"searchId": self.viewModel.searchId,
                @"topicPageId": self.viewModel.topicPageId,
                @"collectType": self.viewModel.collectType,
                @"collectContent": self.viewModel.collectContent,
                @"payFlag": self.viewModel.payFlag,
                @"shareCode": self.viewModel.shareCode,
                @"source" : HDIsStringEmpty(self.viewModel.source) ? @"外卖门店详情页" : [self.viewModel.source stringByAppendingString:@"|外卖门店详情页"],
                @"associatedId" : self.viewModel.associatedId
            }];

            /// 3.0.19.0 点击
            NSDictionary *param = @{
                @"storeNo": model.storeNo,
                @"exposureSort": @(indexPath.row),
                @"productId": model.goodId,
                @"type": @"storePageProduct",
                @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:NO],
                @"plateId": WMManage.shareInstance.plateId
            };
            [LKDataRecord.shared traceEvent:@"takeawayProductClick" name:@"takeawayProductClick" parameters:param SPM:nil];
        };
        cell.showChooseGoodsPropertyAndSkuViewBlock = ^(WMStoreGoodsItem *_Nonnull model) {
            @HDStrongify(self);
            [self showChooseGoodsSkuAndPropertyViewWithModel:model];
        };
        cell.minusGoodsToShoppingCartBlock = ^{
            @HDStrongify(self);
            [self.shoppingCartDockView setOrderButtonUnClick];
        };
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            cell.contentView.backgroundColor = HDAppTheme.WMColor.white;
        } else {
            cell.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;
        }
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = model;
        cell.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;
        return cell;
    } else if ([model isKindOfClass:WMStoreDetailRspModel.class]) {
        WMStoreDetailHeaderTableViewCell *cell = [WMStoreDetailHeaderTableViewCell cellWithTableView:tableView];
        cell.model = model;
        self.headerCell = cell;
        cell.backgroundColor = cell.contentView.backgroundColor = UIColor.clearColor;
        cell.headView.videoTapClick = ^(HDCyclePagerView * _Nonnull pagerView, NSIndexPath * _Nonnull indexPath, NSURL * _Nonnull videoUrl) {
            @HDStrongify(self);
            SJPlayModel *playModel = [SJPlayModel playModelWithCollectionView:pagerView.collectionView indexPath:indexPath superviewSelector:NSSelectorFromString(@"videoContentView")];
            self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:videoUrl playModel:playModel];
            HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
            if (reachability.currentReachabilityStatus == ReachableViaWWAN) {
                [HDTips showWithText:TNLocalizedString(@"tn_video_play_tip", @"您正在使用非WiFi播放，请注意手机流量消耗") hideAfterDelay:3];
            }
            [self.player play];
            
            [LKDataRecord.shared traceEvent:@"playVedioClickCount"
                                       name:@"playVedioClickCount"
                                      parameters:@{
                @"type": @"playVedioClickCount",
                @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                @"storeNo": self.viewModel.storeNo
                
            }
                                             SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
            self.videoTime = time(NULL);
        };
        return cell;
    } else if ([model isKindOfClass:WMStoreMenuItem.class]) {
        WMCNStoreDetailOrderFoodCateCell *cell = [WMCNStoreDetailOrderFoodCateCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)addShoppingGoodsWithAddDelta:(NSUInteger)addDelta
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId {
    @HDWeakify(self);
    [self showloading];
    [self.storeShoppingCartDTO addGoodsToShoppingCartWithClientType:SABusinessTypeYumNow addDelta:addDelta goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:self.viewModel.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartAddGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"添加商品数量成功");
            @HDStrongify(self);
            self.viewModel.needShowRequiredPriceChangeToast = true;
            [self.viewModel reGetShoppingCartItems];
        
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"添加商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
            
        }];
}

- (void)updateShoppingGoodsWithCount:(NSUInteger)count
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId {
    [self showloading];
    @HDWeakify(self);
    [self.storeShoppingCartDTO updateGoodsCountInShoppingCartWithClientType:SABusinessTypeYumNow count:count goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds
        storeNo:self.viewModel.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartUpdateGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"更新商品数量成功");
            @HDStrongify(self);
            self.viewModel.needShowRequiredPriceChangeToast = true;
            [self.viewModel updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:rspModel];
        
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"更新商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
            
        }];
}

/// 下单前检查门店状态
- (void)checkStoreStatus {
    // 过滤不可用商品
    NSArray<WMShoppingCartStoreProduct *> *validProductList = [self.viewModel.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        return model.goodsState == WMGoodsStatusOn && model.availableStock > 0;
    }];

    // 如果没有商品项，直接 return
    if (HDIsArrayEmpty(validProductList))
        return;

    NSArray<WMShoppingCartOrderCheckItem *> *items = [validProductList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        WMShoppingCartOrderCheckItem *item = WMShoppingCartOrderCheckItem.new;
        item.productId = obj.goodsId;
        item.count = obj.purchaseQuantity;
        item.specId = obj.goodsSkuId;
        return item;
    }];

    // 未试算，直接 return
    if (HDIsObjectNil(self.viewModel.payFeeTrialCalRspModel))
        return;
    // 过滤爆款活动
    NSArray<WMStoreDetailPromotionModel *> *noneBestSalePromotions = [self.viewModel.payFeeTrialCalRspModel.promotions hd_filterWithBlock:^BOOL(WMStoreDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeBestSale;
    }];
    NSArray<NSString *> *activityNos = [noneBestSalePromotions mapObjectsUsingBlock:^id _Nonnull(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx) {
        return obj.activityNo;
    }];

    @HDWeakify(self);
    void (^goToOrderSubmitPage)(void) = ^(void) {
        @HDStrongify(self);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        // 过滤下架和售罄的商品
        params[@"productList"] = validProductList;
        params[@"storeItem"] = self.viewModel.shopppingCartStoreItem;
        params[@"from"] = @0;
        
        // 埋点
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖门店详情页"] : @"外卖门店详情页";
        params[@"associatedId"] = self.viewModel.associatedId;
        
        params[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] = @(true);
        /// 3.0埋点
        if (self.viewModel.plateId)
            params[@"plateId"] = self.viewModel.plateId;
        if (self.viewModel.topicPageId)
            params[@"topicPageId"] = self.viewModel.topicPageId;
        if (self.viewModel.collectType)
            params[@"collectType"] = self.viewModel.collectType;
        if (self.viewModel.collectContent)
            params[@"collectContent"] = self.viewModel.collectContent;
        if (self.viewModel.searchId)
            params[@"searchId"] = self.viewModel.searchId;
        if (self.viewModel.payFlag)
            params[@"payFlag"] = self.viewModel.payFlag;
        if (self.viewModel.shareCode)
            params[@"shareCode"] = self.viewModel.shareCode;

        //是否到店自取
        params[@"pickUpStatus"] = @(self.viewModel.detailInfoModel.pickUpStatus);

        [HDMediator.sharedInstance navigaveToOrderSubmitController:params];

        /// 3.0.19.0
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick"
                                   name:@"takeawayStoreClick"
                             parameters:@{
            @"storeNo": self.viewModel.storeNo,
            @"type": @"settleOrderPage",
            @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:NO],
            @"plateId": WMManage.shareInstance.plateId
        }
                                    SPM:[LKSPM SPMWithPage:@"WMOrderDetailViewController" area:@"" node:@""]];
        
        //有视频的店
        if(self.viewModel.detailInfoModel.videoUrls.count && self.videoTime > 0 && time(NULL) - self.videoTime < 15 * 60 ) {
                
            [LKDataRecord.shared traceEvent:@"playVideoOrderCount"
                                       name:@"playVideoOrderCount"
                                 parameters:@{
                @"type": @"playVideoOrderCount",
                @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                @"storeNo": self.viewModel.storeNo
            }
                                        SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
        }
        
    };

    [self showloading];
    NSArray<NSString *> *productIds = [items mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartOrderCheckItem *_Nonnull obj, NSUInteger idx) {
        return obj.productId;
    }];
    [self checkProductsStatus:self.viewModel.storeNo productIds:productIds completion:^(NSDictionary *info) {
        @HDStrongify(self);
        if (info) {
            [self dismissLoading];
            HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
            config.containerMinHeight = kScreenHeight * 0.3;
            config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
            config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
            config.title = WMLocalizedString(@"wm_product_unavailable", @"商品已失效");
            config.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
            config.titleColor = HDAppTheme.WMColor.B3;
            config.style = HDCustomViewActionViewStyleClose;
            config.shouldAddScrollViewContainer = NO;
            config.iPhoneXFillViewBgColor = UIColor.whiteColor;
            config.contentHorizontalEdgeMargin = 0;
            NSArray *productArr = [validProductList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull item) {
                if (info[item.goodsId]) {
                    item.statusResult = info[item.goodsId];
                    return YES;
                }
                return NO;
            }];
            WMGoodFailView *reasonView = [[WMGoodFailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.8)];
            reasonView.dataSource = productArr;
            [reasonView layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView config:config];
            reasonView.clickedConfirmBlock = ^{
                @HDStrongify(self);
                __block NSMutableArray *deleteItems = [NSMutableArray array];
                [productArr enumerateObjectsUsingBlock:^(WMShoppingCartStoreProduct *subModel, NSUInteger idx, BOOL *_Nonnull stop) {
                    WMShoppingCartBatchDeleteItem *deleteItem = [[WMShoppingCartBatchDeleteItem alloc] init];
                    deleteItem.itemDisplayNo = subModel.itemDisplayNo;
                    deleteItem.inEffectVersionId = subModel.inEffectVersionId;
                    [deleteItems addObject:deleteItem];
                }];
                if (!HDIsArrayEmpty(deleteItems)) {
                    [self batchDeleteGoodsWithDeleteItems:deleteItems];
                }
                [actionView dismiss];
            };
            [actionView show];
        } else {
            @HDWeakify(self);
            [self.storeShoppingCartDTO orderCheckBeforeGoToOrderSubmitWithStoreNo:self.viewModel.storeNo items:items activityNos:activityNos success:^(SARspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self dismissLoading];
                goToOrderSubmitPage();
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
                HDLog(@"检查订单失败，%@", error.localizedDescription);
                [self orderCheckFailureWithRspModel:rspModel goToOrderSubmitPage:goToOrderSubmitPage];
            }];
        }
    }];
}


///检测商品状态
- (void)checkProductsStatus:(NSString *)storeNo productIds:(NSArray<NSString *> *)productIds completion:(void (^)(NSDictionary *info))completion {
    [self.storeShoppingCartDTO.shoppingCartDTO checkProductStatusWithStoreNo:storeNo productIds:productIds success:^(NSDictionary *_Nonnull info) {
        if ([info isKindOfClass:NSDictionary.class] && info.allKeys.count) {
            if (completion)
                completion(info);
        } else {
            if (completion)
                completion(nil);
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        if (completion)
            completion(nil);
    }];
}

/// 批量删除购物车商品
- (void)batchDeleteGoodsWithDeleteItems:(NSArray<WMShoppingCartBatchDeleteItem *> *)deleteItems {
    [self showloading];
    @HDWeakify(self);
    [self.storeShoppingCartDTO.shoppingCartDTO batchDeleteGoodsFromShoppingCartWithDeleteItems:deleteItems success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel reGetShoppingCartItems];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel reGetShoppingCartItems];
    }];
}

- (void)showChooseGoodsSkuAndPropertyViewWithModel:(WMStoreGoodsItem *)goodsModel {
    WMChooseGoodsPropertyAndSkuView *chooseView = [[WMChooseGoodsPropertyAndSkuView alloc] initWithStoreGoodsItem:goodsModel availableBestSaleCount:self.viewModel.availableBestSaleCount];
    [chooseView show];
    @HDWeakify(self);
    chooseView.addToCartBlock = ^(NSUInteger count, WMStoreGoodsProductSpecification *specificationModel, NSArray<WMStoreGoodsProductPropertyOption *> *_Nonnull propertyOptionList) {
        @HDStrongify(self);

        // 加购埋点,用于统计转化
        if (self.viewModel.plateId) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{
                @"type": self.viewModel.collectType,
                @"plateId": self.viewModel.plateId,
                @"content": @[goodsModel.goodId]
                
            }];
            if (self.viewModel.topicPageId)
                mdic[@"topicPageId"] = self.viewModel.topicPageId;

            [LKDataRecord.shared traceEvent:@"addShopCart"
                                       name:@"外卖_购物车"
                                 parameters:mdic
                                        SPM:[LKSPM SPMWithPage:@"WMStoreDetailViewController" area:@"AddShopCartView" node:@""]];
        }

        // 埋点，请勿删除
        [LKDataRecord traceYumNowEvent:@"add_shopcartV2"
                                  name:@"外卖_购物车_加购"
                                   ext:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖门店详情页"] : @"外卖门店详情页",
            @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
            @"goodsId": goodsModel.goodId,
            @"storeNo" : self.viewModel.storeNo
        }];
        // 埋点 end
        
        [self addShoppingGoodsWithAddDelta:count goodsId:goodsModel.goodId goodsSkuId:specificationModel.specificationId
                               propertyIds:[propertyOptionList mapObjectsUsingBlock:^id _Nonnull(WMStoreGoodsProductPropertyOption *_Nonnull obj, NSUInteger idx) {
                                   return obj.optionId;
                               }]
                         inEffectVersionId:goodsModel.inEffectVersionId];
    };
    chooseView.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart = ^NSUInteger(WMStoreGoodsItem *_Nonnull model) {
        @HDStrongify(self);
        return [self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model];
    };
    chooseView.storeShoppingCartPromotions = ^NSArray<WMStoreDetailPromotionModel *> *_Nonnull {
        @HDStrongify(self);
        return self.viewModel.payFeeTrialCalRspModel.promotions;
    };
}

// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMStoreGoodsItem *)currentGoods {
    NSUInteger otherCount = 0;
    for (WMShoppingCartStoreProduct *goods in self.viewModel.shopppingCartStoreItem.goodsList) {
        if (goods.bestSale && ![goods.identifyObj.goodsId isEqualToString:currentGoods.goodId]) {
            otherCount += goods.purchaseQuantity;
        }
    }
    return otherCount;
}

/// 根据试算信息更新底门店购物车 Dock
- (void)updateStoreCartDockViewWithupdateStoreCartDockViewWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    if (HDIsObjectNil(payFeeTrialCalRspModel) || HDIsObjectNil(payFeeTrialCalRspModel.totalAmount)) {
        [self.shoppingCartDockView emptyPriceInfo];
        if (!self.storeShoppingCartVC.canExpand) {
            [self.storeShoppingCartVC dismiss];
        }
    } else {
        [self.shoppingCartDockView updateUIWithPayFeeTrialCalRspModel:payFeeTrialCalRspModel];
    }
}

///获取分享配置
- (void)getShareConfig {
    @HDWeakify(self) CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/share-store-title";
    request.requestParameter = @{@"loginName": SAUser.shared.loginName, @"storeNo": self.viewModel.storeNo};
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self) SARspModel *rspModel = response.extraData;
        NSDictionary *info = (NSDictionary *)rspModel.data;
        self.shareConfig = info;
    } failure:nil];
}

///获取分享活动
- (void)getShareActivity {
    @HDWeakify(self)
        //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
        SAAddressModel *addressModel
        = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    CGFloat lat = addressModel.lat.doubleValue;
    CGFloat lon = addressModel.lon.doubleValue;
    BOOL isParamsCoordinate2DValid = [HDLocationManager.shared isCoordinate2DValid:CLLocationCoordinate2DMake(lat, lon)];
    if (!isParamsCoordinate2DValid) {
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            lat = HDLocationManager.shared.coordinate2D.latitude;
            lat = HDLocationManager.shared.coordinate2D.longitude;
        } else {
            lat = kDefaultLocationPhn.latitude;
            lon = kDefaultLocationPhn.longitude;
        }
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-merchant/app/super-app/share-store-activity-list";
    request.requestParameter =
        @{@"loginName": SAUser.shared.loginName, @"storeNo": self.viewModel.storeNo, @"geo": @{@"lat": [NSString stringWithFormat:@"%f", lat], @"lon": [NSString stringWithFormat:@"%f", lon]}};
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self) SARspModel *rspModel = response.extraData;
        self.shareActivityModel = [WMStoreActivityMdoel yy_modelWithJSON:rspModel.data];
    } failure:nil];
}

- (void)shareStore {
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    WMStoreDetailRspModel *model = self.viewModel.detailInfoModel;
    NSString *routePath = [NSString stringWithFormat:@"SuperApp://YumNow/storeDetail?storeNo=%@", self.viewModel.storeNo];
    NSString *encodeRoutePath = [routePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?="].invertedSet];
    NSString *language = @"en";
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        language = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        language = @"km";
    }
    NSString *webpageUrl = [NSString stringWithFormat:@"%@?storeNo=%@&lon=%@&lat=%@&fromId=%@&routePath=%@&language=%@",
                                                      self.viewModel.detailInfoModel.shareLink,
                                                      self.viewModel.storeNo,
                                                      addressModel.lon.stringValue,
                                                      addressModel.lat.stringValue,
                                                      [[SAUser shared] operatorNo] ?: @"",
                                                      encodeRoutePath,
                                                      language];
    NSString *shareTitle = [NSString stringWithFormat:WMLocalizedString(@"share_store_title", @"Here\'s %@ on YumNow."), self.viewModel.storeName];
    NSString *desc = @"";
    if (self.shareConfig) {
        if (self.shareConfig[@"title"]) {
            shareTitle = self.shareConfig[@"title"];
        }
        if (SAMultiLanguageManager.isCurrentLanguageCN && self.shareConfig[@"titleZh"]) {
            shareTitle = self.shareConfig[@"titleZh"];
        } else if (SAMultiLanguageManager.isCurrentLanguageKH && self.shareConfig[@"titleKm"]) {
            shareTitle = self.shareConfig[@"titleKm"];
        }

        if (self.shareConfig[@"description"]) {
            desc = self.shareConfig[@"description"];
        }
        if (SAMultiLanguageManager.isCurrentLanguageCN && self.shareConfig[@"descriptionZh"]) {
            desc = self.shareConfig[@"descriptionZh"];
        } else if (SAMultiLanguageManager.isCurrentLanguageKH && self.shareConfig[@"descriptionKm"]) {
            desc = self.shareConfig[@"descriptionKm"];
        }
    }

    SAShareWebpageObject *shareObject = SAShareWebpageObject.new;
    shareObject.title = shareTitle;
    shareObject.webpageUrl = webpageUrl;
    shareObject.thumbImage = model.logo;
    shareObject.descr = desc;
    HDSocialShareCellModel *generateImageFunctionModel = [SASocialShareView generateImageFunctionModel];
    generateImageFunctionModel.clickedHandler = ^(HDSocialShareCellModel *_Nonnull cellModel, NSInteger index) {
        [LKDataRecord.shared traceEvent:@"generatePictureIcon" name:@"generatePictureIcon"
                             parameters:@{@"type": @"generatePictureIcon", @"storeNo": self.viewModel.storeNo, @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                    SPM:nil];
        WMStoreImageShareView *imageShareView = [WMStoreImageShareView storeImageShareWithModel:model activityModel:self.shareActivityModel];
        [SASocialShareView showShareWithTopCustomView:imageShareView completion:^(BOOL success, NSString *_Nullable shareChannel) {
            if ([shareChannel isEqualToString:@"WeChat"]) {
                [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                    @"type": @"thirdPartyShare",
                    @"storeNo": self.viewModel.storeNo,
                    @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                    @"thirdPartyType": @"wechat"
                }
                                            SPM:nil];
            } else if ([shareChannel isEqualToString:@"FB"]) {
                [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                    @"type": @"thirdPartyShare",
                    @"storeNo": self.viewModel.storeNo,
                    @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                    @"thirdPartyType": @"facebook"
                }
                                            SPM:nil];
            } else if ([shareChannel isEqualToString:@"Telegram"]) {
                [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                    @"type": @"thirdPartyShare",
                    @"storeNo": self.viewModel.storeNo,
                    @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                    @"thirdPartyType": @"telegram"
                }
                                            SPM:nil];
            }
        }];
    };

    [SASocialShareView showShareWithShareObject:shareObject functionModels:@[SASocialShareView.copyLinkFunctionModel, generateImageFunctionModel] completion:^(BOOL success,
                                                                                                                                                               NSString *_Nullable shareChannel) {
        if ([shareChannel isEqualToString:@"WeChat"]) {
            [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                @"type": @"thirdPartyShare",
                @"storeNo": self.viewModel.storeNo,
                @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                @"thirdPartyType": @"wechat"
            }
                                        SPM:nil];
        } else if ([shareChannel isEqualToString:@"FB"]) {
            [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                @"type": @"thirdPartyShare",
                @"storeNo": self.viewModel.storeNo,
                @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                @"thirdPartyType": @"facebook"
            }
                                        SPM:nil];
        } else if ([shareChannel isEqualToString:@"Telegram"]) {
            [LKDataRecord.shared traceEvent:@"thirdPartyShare" name:@"thirdPartyShare" parameters:@{
                @"type": @"thirdPartyShare",
                @"storeNo": self.viewModel.storeNo,
                @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
                @"thirdPartyType": @"telegram"
            }
                                        SPM:nil];
        }

        [LKDataRecord.shared
            traceEvent:@"click_pv_socialShare"
                  name:@""
            parameters:@{@"shareResult": success ? @"success" : @"fail", @"traceId": self.viewModel.storeNo, @"traceUrl": webpageUrl, @"traceContent": @"YumNowStoreShare", @"channel": shareChannel}];
    }];
}

// 下单检查异常处理
- (void)orderCheckFailureWithRspModel:(SARspModel *)rspModel goToOrderSubmitPage:(void (^)(void))goToOrderSubmitPage {
    void (^showAlert)(NSString *, void (^)(void)) = ^void(NSString *msg, void (^afterBlock)(void)) {
        [NAT showAlertWithMessage:msg buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            !afterBlock ?: afterBlock();
        }];
    };

    SAResponseType code = rspModel.code;
    if ([code isEqualToString:WMOrderCheckFailureReasonStoreClosed]) { // 门店休息
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonStoreStopped]) { // 门店停业/停用
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonPromotionEnded] ||
               [code isEqualToString:WMOrderCheckFailureReasonDeliveryFeeChanged]) { // 活动已结束或停用、配送费活动变更
                                                                                     //        !goToOrderSubmitPage ?: goToOrderSubmitPage(); // 需求修改，暂不需要跳转订单确定页面
        showAlert(rspModel.msg, ^() {
            // 重新试算
            self.viewModel.hasInitializedOrderPayTrialCalculate = false;
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonHaveRemovedProduct]) { // 包含失效商品
        showAlert(rspModel.msg, ^() {
            // 重新试算
            self.viewModel.hasInitializedOrderPayTrialCalculate = false;
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonProductInfoChanged]) { // 商品信息变更
        showAlert(rspModel.msg, ^() {
            // 重新试算
            self.viewModel.hasInitializedOrderPayTrialCalculate = false;
            [self.viewModel getInitializedData];
        });
    } else {
        showAlert(rspModel.msg, nil);
    }
}

// 加购物车异常处理
- (void)addToCartFailureWithRspModel:(SARspModel *)rspModel {
    [self dismissLoading];
    void (^showAlert)(NSString *, NSString *, NSString *, void (^)(void)) = ^void(NSString *msg, NSString *confirm, NSString *cancel, void (^afterBlock)(void)) {
        WMNormalAlertConfig *config = WMNormalAlertConfig.new;
        config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
            [alertView dismiss];
            !afterBlock ?: afterBlock();
        };
        config.contentAligment = NSTextAlignmentCenter;
        config.content = msg;
        config.confirm = confirm ?: WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons");
        config.cancel = cancel;
        [WMCustomViewActionView WMAlertWithConfig:config];
    };
    SAResponseType code = rspModel.code;
    if ([code isEqualToString:@"ME1007"]) {
        [self.viewModel reGetShoppingCartItems];
        showAlert(rspModel.msg, nil, nil, nil);
    } else if ([rspModel.code isEqualToString:@"ME1003"] || // 查询购物项详细信息出现异常
               [rspModel.code isEqualToString:@"ME1005"] || // 商品状态为空异常
               [rspModel.code isEqualToString:@"ME3005"]) { // 订单中的商品都卖光啦，再看看其他商品吧.
        showAlert(rspModel.msg, nil, nil, ^{
            [self.viewModel getInitializedData];
        });
    } else if ([rspModel.code isEqualToString:@"ME3008"]) { // 购物车已满
        [self.viewModel reGetShoppingCartItems];
        showAlert(WMLocalizedString(@"wm_shopcar_full_clear_title", @"购物车已满，请及时清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_confirm_clear", @"去清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想"),
                  ^{
                      [HDMediator.sharedInstance navigaveToShoppingCartViewController:@{@"willDelete": @(YES)}];
                  });
    } else {
        [self.viewModel reGetShoppingCartItems];
        showAlert(rspModel.msg, nil, nil, nil);
    }
}

/// 根据 UIScrollView 偏移来滚动到对应标题
- (void)handlerSrollNavBarWithScrollView:(UIScrollView *)scrollView {
}

- (void)setPinCategoryViewSelectedItem:(NSInteger)selectedIndex {
}
//获取 indexpath所在的位置
- (CGRect)getSectionHeaderPathRect:(NSInteger)section {
    CGRect rect = [self.tableView rectForSection:section];
    return rect;
}

// 根据位置拉取对应的类目数据
- (void)loadGoodsByScrollerIndex:(NSInteger)index isClickIndex:(BOOL)isClickIndex loadTop:(BOOL)loadTop loadDown:(BOOL)loadDown isNeedFixContentOffset:(BOOL)isNeedFixContentOffset {
    if (HDIsArrayEmpty(self.dataSource)) {
        return;
    }
    NSInteger goodIndex = index + kPinSectionBeforeHasIndex;
    if (goodIndex >= self.dataSource.count || goodIndex < 0)
        return;
    WMStoreMenuItem *menuItem = index < 0 ? nil : self.viewModel.menuList[index];
    if (menuItem && ![self.viewModel.alreadyRequestMenuIds containsObject:menuItem.menuId] && self.isLoadingData == false) { //当前没有数据
        if (isNeedFixContentOffset) { //需要手动纠正偏移量的时候  就需要定住  不能继续滑动了
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        }
        self.isLoadingData = true;
        @HDWeakify(self);
        [self.viewModel getGoodListByIndex:index loadTop:loadTop loadDown:loadDown completion:^(BOOL isSuccess) { //直接用实际的index  因为要去筛选 菜单栏
            @HDStrongify(self);
            self.isLoadingData = false;
            if (isSuccess) {
                [self.tableView successGetNewDataWithNoMoreData:true];
                if (isClickIndex) {
                    [self tableViewScollToMenuList:goodIndex];
                } else {
                    if (isNeedFixContentOffset && loadTop) {
                        //手动纠正偏移位置
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:goodIndex + 1];
                        //定位到具体的cell
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
                        self.lastSection = goodIndex;
                        [self setPinCategoryViewSelectedItem:index]; //设置偏移量
                    }
                }
            }
        }];
    } else {
        //这个类目有数据  就直接过去  如果是点击的   就跳转到那个位置
        if (isClickIndex) {
            [self tableViewScollToMenuList:goodIndex];
        }
    }
}

- (void)tableViewScollToMenuList:(NSInteger)goodIndex {
    if (goodIndex < [self.tableView numberOfSections]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:goodIndex];
        if ([self.tableView numberOfRowsInSection:goodIndex] == 0)
            return;
        //定位到具体的cell
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
        // 因为定位的地方不会显示section头部  需要向上移动一下
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - kStoreDetailCategoryTitleViewHeight) animated:false];
        self.lastSection = goodIndex;
        self.currentSectionRect = [self getSectionHeaderPathRect:goodIndex];
    }
}

- (void)setUpVideoPlayer {
    //设置颜色
    SJVideoPlayer.update(^(SJVideoPlayerConfigurations *_Nonnull configs) {
        configs.resources.progressThumbSize = 10;
        configs.resources.progressThumbColor = UIColor.whiteColor;
        configs.resources.progressTraceColor = UIColor.whiteColor;
        configs.resources.progressTrackColor = UIColor.darkGrayColor;
        configs.resources.bottomIndicatorTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.backImage = [UIImage imageNamed:@"icon_login_close_white"];
        configs.resources.floatSmallViewCloseImage = [UIImage imageNamed:@"tn_video_close"];
        configs.resources.playFailedButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.noNetworkButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;

        configs.localizedStrings.reload = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        configs.localizedStrings.playbackFailedPrompt = @"";
        configs.localizedStrings.noNetworkPrompt = SALocalizedString(@"network_error", @"网络开小差啦");
    });

    _player.onlyUsedFitOnScreen = YES;
    _player.resumePlaybackWhenScrollAppeared = NO;
    _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = NO;
    if (@available(iOS 14.0, *)) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    } else {
        // Fallback on earlier versions
    }

    //设置占位图图片样式
    _player.presentView.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    //默认静音播放
    _player.muted = YES;
    //设置小窗样式
    SJFloatSmallViewController *floatSmallViewController = (SJFloatSmallViewController *)_player.floatSmallViewController;
    floatSmallViewController.layoutPosition = SJFloatViewLayoutPositionTopRight;
    floatSmallViewController.layoutInsets = UIEdgeInsetsMake(kNavigationBarH - kStatusBarH, 12, 20, 12);
    floatSmallViewController.layoutSize = CGSizeMake(kRealWidth(120), kRealWidth(120));
    floatSmallViewController.floatView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //删除原有的播放  放大按钮
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Play];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];

    //当前时间
    SJEdgeControlButtonItem *currentTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_CurrentTime];
    currentTimeItem.insets = SJEdgeInsetsMake(15, 0);
    [_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_Progress withItemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    SJEdgeControlButtonItem *durationTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    durationTimeItem.insets = SJEdgeInsetsMake(0, 60);

    //声音按钮固定在底部控制层
    __block HDUIButton *muteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [muteBtn setImage:[UIImage imageNamed:@"wm_video_unmute"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"wm_video_mute"] forState:UIControlStateSelected];
    muteBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [muteBtn addTarget:self action:@selector(muteClick) forControlEvents:UIControlEventTouchUpInside];
//    muteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [muteBtn sizeToFit];
    [_player.defaultEdgeControlLayer.controlView addSubview:muteBtn];
    [muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view).offset(-40);
        make.right.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    muteBtn.hidden = YES;

    
    
//    //退出全屏按钮固定在底部控制层
    __block HDUIButton *scaleBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [scaleBtn setImage:[UIImage imageNamed:@"wm_video_scale"] forState:UIControlStateNormal];
    scaleBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [scaleBtn addTarget:_player.defaultEdgeControlLayer action:@selector(_backItemWasTapped) forControlEvents:UIControlEventTouchUpInside];

    [scaleBtn sizeToFit];
    [_player.defaultEdgeControlLayer.controlView addSubview:scaleBtn];
    [scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view);
        make.right.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    scaleBtn.hidden = YES;
    


//    //小窗添加一个是否禁音按钮
//    __block SJEdgeControlButtonItem *muteItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"wm_video_mute"] target:self action:@selector(muteClick)
//                                                                                           tag:WMEdgeControlBottomMuteButtonItemTag];
//    SJEdgeControlButtonItem *fillItem = [[SJEdgeControlButtonItem alloc] initWithTag:200];
//    fillItem.fill = YES;
//    _player.defaultFloatSmallViewControlLayer.bottomHeight = 35;
//    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:fillItem];
//    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:muteItem];
////    [_player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
    //静音回调
    @HDWeakify(self);
    _player.playbackObserver.mutedDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        muteBtn.selected = !player.isMuted;
//        if (player.isMuted) {
//            muteItem.image = [UIImage imageNamed:@"wm_video_mute"];
//        } else {
//            muteItem.image = [UIImage imageNamed:@"wm_video_unmute"];
//        }
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
        }
    };

    //添加 中间播放按钮
    [_player.defaultEdgeControlLayer.centerAdapter removeItemForTag:SJEdgeControlLayerCenterItem_Replay];


    
    
    SJEdgeControlButtonItem *playItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"wm_video_play"] target:self action:@selector(playClick)
                                                                                   tag:WMEdgeControlCenterPlayButtonItemTag];
    playItem.hidden = YES;
    [_player.defaultEdgeControlLayer.centerAdapter addItem:playItem];
    [_player.defaultEdgeControlLayer.centerAdapter reload];

    //播放完毕事件回调
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self.player.presentView showPlaceholderAnimated:YES];
        [self setPlayItemHidden:NO];
        
        [LKDataRecord.shared traceEvent:@"playVideoFinishCount"
                                   name:@"playVideoFinishCount"
                             parameters:@{
            @"type": @"playVideoFinishCount",
            @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000],
            @"storeNo": [NSString stringWithFormat:@"%@",self.viewModel.storeNo]
            
        }
                                         SPM:[LKSPM SPMWithPage:@"WMNewHomeViewController" area:@"" node:@""]];
    };

    //全屏回调
    _player.fitOnScreenObserver.fitOnScreenWillBeginExeBlock = ^(id<SJFitOnScreenManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isFitOnScreen) {
            //进入全屏就打开声音
        } else {
//            if (self.tableView.contentOffset.y > self.playerMaxY) { //这种情况是浮窗进入大屏  再放小的情况  这个时候 暂停视频
//                [self.player pauseForUser];
//            }
            //非全屏自动静音
            if (!self.player.isMuted) {
                self.player.muted = YES;
            }
            //全屏切换回小屏暂停播放
            if (self.player.isPlaying) {
                [self.player pauseForUser];
            }
        }
        scaleBtn.hidden = !mgr.isFitOnScreen;
        muteBtn.hidden = !mgr.isFitOnScreen;
    };

    _player.gestureControl.supportedGestureTypes = SJPlayerGestureTypeMask_SingleTap | SJPlayerGestureTypeMask_Pan;
    //单击事件回调
    _player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl> _Nonnull control, CGPoint location) {
        @HDStrongify(self);
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.floatSmallViewController dismissFloatView];
            [self.player setFitOnScreen:YES animated:YES];
        } else {
            if (!self.player.isFitOnScreen) {
                [self.player setFitOnScreen:YES animated:YES];
            } else {
                if (self.player.controlLayerAppearManager.isAppeared) {
                    [self.player controlLayerNeedDisappear];
                } else {
                    [self.player controlLayerNeedAppear];
                }
            }
        }
    };
    _player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isAppeared) {
            if (self.player.isFitOnScreen) {
                [self setPlayItemHidden:NO];
            } else {
                [self setPlayItemHidden:self.player.isPlaying];
            }
        } else {
            [self setPlayItemHidden:self.player.isPlaying];
        }
    };
    _player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self showPlayItemImage:self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused];
        if (self.player.isPlaying && !self.player.isFitOnScreen) {
            [self setPlayItemHidden:YES];
        }
        //全屏状态下  如果播放后 控制层不在 马上隐藏播放按钮
        if (self.player.isPlaying && self.player.isFitOnScreen && !self.player.controlLayerAppeared) {
            [self setPlayItemHidden:YES];
        }
        if (self.player.isPaused) {
            [self setPlayItemHidden:NO];
        }
    };
}

#pragma mark 静音按钮点击
- (void)muteClick {
    _player.muted = !_player.isMuted;
}

- (void)scaleClick {
//    _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
}
#pragma mark 播放按钮点击
- (void)playClick {
    //放大状态下
    if (self.player.isPlaying) {
        [self.player pauseForUser];
    } else {
        if (!self.player.presentView.isPlaceholderImageViewHidden) {
            [self.player.presentView hiddenPlaceholderAnimated:YES];
        }
        if (self.player.isPlaybackFinished) {
            [self.player replay];
        } else {
            [self.player play];
        }
    }
}

- (void)setPlayItemHidden:(BOOL)hidden {
    SJEdgeControlButtonItem *playitem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:WMEdgeControlCenterPlayButtonItemTag];
    playitem.hidden = hidden;
    [self.player.defaultEdgeControlLayer.centerAdapter reload];
}
//设置播放图片
- (void)showPlayItemImage:(BOOL)isPlaying {
    SJEdgeControlButtonItem *playItem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:WMEdgeControlCenterPlayButtonItemTag];
    if (isPlaying) {
        playItem.image = [UIImage imageNamed:@"wm_video_pause"];
    } else {
        playItem.image = [UIImage imageNamed:@"wm_video_play"];
    }
    [self.player.defaultEdgeControlLayer.centerAdapter reload];

    if (isPlaying && !self.player.presentView.isPlaceholderImageViewHidden) {
        [self.player.presentView hiddenPlaceholderAnimated:YES];
    }
}


- (WMStoreShoppingCartViewController *)storeShoppingCartVC {
    if (!_storeShoppingCartVC) {
        _storeShoppingCartVC = WMStoreShoppingCartViewController.new;
        _storeShoppingCartVC.view.hidden = true;
        @HDWeakify(self);
        _storeShoppingCartVC.storeCartGoodsDidChangedBlock = ^{
            @HDStrongify(self);
            // 最终试算会关闭loading
            [self showloading];
            if (self.viewModel.hasGotInitializedData) {
                [self.viewModel reGetShoppingCartItemsSuccess:nil failure:nil];
            }
        };
        _storeShoppingCartVC.willDissmissHandler = ^{
            @HDStrongify(self);
            [self.shoppingCartDockView showPromotionInfo];
        };
        _storeShoppingCartVC.refreshDataBlock = ^{
            @HDStrongify(self);
            [self.viewModel getInitializedData];
        };
        _storeShoppingCartVC.storeCartMinusGoodsBlock = ^{
            @HDStrongify(self);
            // 点击减号后，结算按钮暂时不可点击，重拿购物车后会恢复，防止跳过起送价限制
            [self.shoppingCartDockView setOrderButtonUnClick];
        };
    }
    return _storeShoppingCartVC;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [WMStoreDetailHeaderTableViewCell cellWithTableView:tableview];
            } else {
                return [WMShoppingGoodTableViewCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [WMStoreDetailHeaderTableViewCell skeletonViewHeight];
            } else {
                return [WMShoppingGoodTableViewCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}

- (WMStoreCartBottomDock *)shoppingCartDockView {
    if (!_shoppingCartDockView) {
        _shoppingCartDockView = WMStoreCartBottomDock.new;
        _shoppingCartDockView.hidden = true;
        @HDWeakify(self);
        _shoppingCartDockView.clickedStoreCartDockBlock = ^{
            @HDStrongify(self);
            if (self.storeShoppingCartVC.canExpand) {
                [self.shoppingCartDockView dismissPromotionInfo];
                [self.storeShoppingCartVC showWithBottomMargin:CGRectGetMaxY(self.frame) - CGRectGetMinY(self.shoppingCartDockView.frame) shopppingCartStoreItem:self.viewModel.shopppingCartStoreItem
                                        payFeeTrialCalRspModel:self.viewModel.payFeeTrialCalRspModel];
            } else {
                [self.storeShoppingCartVC dismiss];
            }
        };
        _shoppingCartDockView.clickedOrdeNowBlock = ^{
            @HDStrongify(self);

            [self checkStoreStatus];
            if (!self.storeShoppingCartVC.canExpand) {
                [self.storeShoppingCartVC dismiss];
            }
        };
        _shoppingCartDockView.backgroundColor = UIColor.clearColor;
    }
    return _shoppingCartDockView;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (WMRestaurantNavigationBarView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = WMRestaurantNavigationBarView.new;
        @HDWeakify(self);
        _customNavigationBar.shareStore = ^{
            @HDStrongify(self);
            [self shareStore];
            [LKDataRecord.shared traceEvent:@"shareIcon" name:@"shareIcon"
                                 parameters:@{@"type": @"shareIcon", @"storeNo": self.viewModel.storeNo, @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                        SPM:nil];
        };
        _customNavigationBar.searchInStore = ^{
            @HDStrongify(self);
            if (HDIsObjectNil(self.viewModel.detailInfoModel)) {
                return;
            }
            [HDMediator.sharedInstance navigaveToProductSearchViewController:@{@"storeDetailViewModel": self.viewModel}];
            [LKDataRecord.shared traceEvent:@"searchIcon" name:@"searchIcon"
                                 parameters:@{@"type": @"searchIcon", @"storeNo": self.viewModel.storeNo, @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                        SPM:nil];
        };
        _customNavigationBar.newList = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{@"clientType": SAClientTypeYumNow}];
            [LKDataRecord.shared traceEvent:@"messageIcon" name:@"messageIcon"
                                 parameters:@{@"type": @"messageIcon", @"storeNo": self.viewModel.storeNo, @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                        SPM:nil];
        };
        _customNavigationBar.favouriteStore = ^{
            @HDStrongify(self);
            [self.viewModel favouriteStore];
            [LKDataRecord.shared traceEvent:@"collectIcon" name:@"collectIcon"
                                 parameters:@{@"type": @"collectIcon", @"storeNo": self.viewModel.storeNo, @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                        SPM:nil];
        };
    }
    return _customNavigationBar;
}

- (UIView *)limitTipsView {
    if (!_limitTipsView) {
        _limitTipsView = [[UIView alloc] init];
        _limitTipsView.clipsToBounds = YES;
        UIImageView *tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yunnow_limit_tips"]];
        [_limitTipsView addSubview:tipsImageView];
        [tipsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(15));
            make.centerY.equalTo(_limitTipsView);
            make.size.mas_equalTo(tipsImageView.image.size);
        }];

        _limitTipsLabel = [[UILabel alloc] init];
        _limitTipsLabel.textColor = HDAppTheme.WMColor.mainRed;
        _limitTipsLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        _limitTipsLabel.numberOfLines = 0;
        [_limitTipsView addSubview:_limitTipsLabel];
        [_limitTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipsImageView.mas_right).offset(kRealWidth(5));
            make.top.equalTo(_limitTipsView).offset(kRealWidth(5));
            make.bottom.equalTo(_limitTipsView).offset(-kRealWidth(5));
            make.right.equalTo(_limitTipsView).offset(-kRealWidth(15));
            make.width.mas_equalTo(kScreenWidth - kRealWidth(30) - kRealWidth(5) - tipsImageView.width);
        }];
    }
    return _limitTipsView;
}

- (UIImageView *)zoomableImageV {
    if (!_zoomableImageV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kZoomImageViewHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(0, 0, kScreenWidth, kZoomImageViewHeight);
        // 增加蒙版
        UIView *shadowView = [[UIView alloc] initWithFrame:imageView.bounds];
        shadowView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [imageView addSubview:shadowView];
        imageView.clipsToBounds = true;
        _zoomableImageV = imageView;
    }
    return _zoomableImageV;
}


- (SJVideoPlayer *)player {
    if (!_player) {
        _player = [SJVideoPlayer player];
        [self setUpVideoPlayer];
    }
    return _player;
}


@end
