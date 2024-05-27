//
//  WMStoreProductDetailView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailView.h"
#import "LKDataRecord.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "SATableViewViewMoreView.h"
#import "WMChooseGoodsPropertyAndSkuView.h"
#import "WMManage.h"
#import "WMPromotionLabel.h"
#import "WMShoppingCartOrderCheckItem.h"
#import "WMStoreCartBottomDock.h"
#import "WMStoreGoodsItem.h"
#import "WMStoreProductDetailHeaderCell+Skeleton.h"
#import "WMStoreProductDetailHeaderCell.h"
#import "WMStoreProductDetailNavigationBarView.h"
#import "WMStoreProductDetailViewModel.h"
#import "WMStoreProductReviewCell+Skeleton.h"
#import "WMStoreProductReviewCell.h"
#import "WMStoreShoppingCartViewController.h"
#import "WMGoodFailView.h"
#import "WMCustomViewActionView.h"
#import "WMShoppingCartBatchDeleteItem.h"

#define kTableViewContentInsetTop (kScreenHeight * 0.4)
#define kZoomImageViewHeight (kTableViewContentInsetTop + 10)


@interface WMStoreProductDetailView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) WMStoreProductDetailViewModel *viewModel;
/// 导航部分
@property (nonatomic, strong) WMStoreProductDetailNavigationBarView *customNavigationBar;
/// 门店图片
@property (nonatomic, strong) UIImageView *zoomableImageV;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 门店购物车 Dock
@property (nonatomic, strong) WMStoreCartBottomDock *shoppingCartDockView;
/// 门店购物车
@property (nonatomic, strong) WMStoreShoppingCartViewController *storeShoppingCartVC;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 记录头部 indexPath，即使以后该组换了位置，也无需更改代码
@property (nonatomic, weak) NSIndexPath *headerCellIndexPath;
@end


@implementation WMStoreProductDetailView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.zoomableImageV];
    [self addSubview:self.tableView];
    [self addSubview:self.customNavigationBar];
    // 增加门店购物车界面
    [self.viewController addChildViewController:self.storeShoppingCartVC];
    [self addSubview:self.storeShoppingCartVC.view];
    [self.storeShoppingCartVC didMoveToParentViewController:self.viewController];
    [self addSubview:self.shoppingCartDockView];

    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;

    // 设置 tableView 忽略边距
    self.tableView.contentInset = UIEdgeInsetsMake(kTableViewContentInsetTop, 0, 0, 0);
    self.tableView.hd_ignoreSpace = [[UIScrollViewIgnoreSpaceModel alloc] initWithMinX:0 maxX:0 minY:kTableViewContentInsetTop maxY:0];
    [self.tableView setContentOffset:CGPointMake(0, -kTableViewContentInsetTop) animated:false];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewBlock)(void) = ^void(void) {
        @HDStrongify(self);

        // 启用交互
        self.tableView.userInteractionEnabled = true;

        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self.customNavigationBar updateTitle:self.viewModel.productDetailRspModel.name];
        [HDWebImageManager setImageWithURL:self.viewModel.productDetailRspModel.imagePaths.firstObject
                          placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, CGRectGetHeight(self.zoomableImageV.frame))]
                                 imageView:self.zoomableImageV];

        self.dataSource = self.viewModel.dataSource;
        [self.tableView successGetNewDataWithNoMoreData:true];

        self.shoppingCartDockView.hidden = false;
        [self dealEventWithBottom];
        [self setNeedsUpdateConstraints];
    };

    void (^failedGetNewDataBlock)(void) = ^(void) {
        @HDStrongify(self);
        BOOL isBusinessDataError = self.viewModel.isBusinessDataError;
        BOOL isNetworkError = self.viewModel.isNetworkError;
        if (isBusinessDataError || isNetworkError) {
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView failGetNewData];
            [self.customNavigationBar updateUIWithScrollViewOffsetY:200];
        }
    };

    self.viewModel.refreshProductShoppingInfoBlock = ^{
        @HDStrongify(self);
        // 判断当前tableview是否有headerCellIndexPath，防止崩溃
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.headerCellIndexPath];
        if (!cell) {
            return;
        }
        [self.tableView reloadRowsAtIndexPaths:@[self.headerCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    };

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"refreshFlag"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewBlock();
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"payFeeTrialCalRspModel"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel = change[NSKeyValueChangeNewKey];
        [self updateStoreCartDockViewWithupdateStoreCartDockViewWithPayFeeTrialCalRspModel:payFeeTrialCalRspModel];

        // 更新门店购物车
        if (!self.storeShoppingCartVC.canExpand) { // 已经展开
            [self.storeShoppingCartVC updateUIWithShopppingCartStoreItem:self.viewModel.shopppingCartStoreItem payFeeTrialCalRspModel:payFeeTrialCalRspModel];
        }
        if (change[NSKeyValueChangeOldKey] != nil) {
            // 不是进入页面第一次获取试算的话通知门店页刷新购物车
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreShoppingCart object:nil];
        }
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"isBusinessDataError"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        failedGetNewDataBlock();
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"isNetworkError"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        failedGetNewDataBlock();
    }];

    [self.KVOController hd_observe:self.viewModel
                           keyPath:@"requiredPrice"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.shoppingCartDockView setDeliveryStartPointPrice:self.viewModel.requiredPrice startPointPriceDiff:self.viewModel.requiredDiffStr];
    }];
}

///处理底部显示
- (void)dealEventWithBottom {
    ///下次服务时间
    if (self.viewModel.storeDetailInfoModel.nextServiceTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.storeDetailInfoModel.storeStatus.status
                                            nextServiceTimeModel:self.viewModel.storeDetailInfoModel.nextServiceTime];
        return;
    }
    ///下次营业时间
    if (self.viewModel.storeDetailInfoModel.nextBusinessTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.storeDetailInfoModel.storeStatus.status
                                            nextBuinessTimeModel:self.viewModel.storeDetailInfoModel.nextBusinessTime];
        return;
    }
    ///休息中
    if ([self.viewModel.storeDetailInfoModel.storeStatus.status isEqualToString:WMStoreStatusResting]) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.storeDetailInfoModel.storeStatus.status
                                                   businessHours:self.viewModel.storeDetailInfoModel.businessHours];
        return;
    }
    ///特殊区域
    if (self.viewModel.storeDetailInfoModel.effectTime) {
        [self.shoppingCartDockView setOpeningTimeWithStoreStatus:self.viewModel.storeDetailInfoModel.storeStatus.status
                                             effectTimeTimeModel:self.viewModel.storeDetailInfoModel.effectTime];
        return;
    }
    ///爆单
    if (self.viewModel.storeDetailInfoModel.fullOrderState == WMStoreFullOrderStateFullAndStop) {
        [self.shoppingCartDockView setFullOrderState:self.viewModel.storeDetailInfoModel.fullOrderState storeNo:self.viewModel.storeNo];
        return;
    }
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - Data
/// 下单前检查门店状态
- (void)checkStoreStatus {
    // 过滤不可用商品
    NSArray<WMShoppingCartStoreProduct *> *validProductList = [self.viewModel.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        return model.goodsState == WMGoodsStatusOn && model.availableStock > 0;
        //        return model.availableStock > 0;
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
    NSArray<NSString *> *activityNos = [self.viewModel.payFeeTrialCalRspModel.promotions mapObjectsUsingBlock:^id _Nonnull(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx) {
        return obj.activityNo;
    }];

    @HDWeakify(self);
    void (^goToOrderSubmitPage)(void) = ^(void) {
        @HDStrongify(self);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        // 过滤下架和售罄的商品
        params[@"productList"] = validProductList;
        params[@"storeItem"] = self.viewModel.shopppingCartStoreItem;
        // 埋点透传
        params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖商品详情页"] : @"外卖商品详情页";
        params[@"associatedId"] = self.viewModel.associatedId;

        params[@"plateId"] = self.viewModel.plateId;
        params[@"searchId"] = self.viewModel.searchId;
        params[@"collectContent"] = self.viewModel.collectContent;
        params[@"collectType"] = self.viewModel.collectType;
        if (self.viewModel.topicPageId) {
            params[@"topicPageId"] = self.viewModel.topicPageId;
        }
        if (self.viewModel.payFlag) {
            params[@"payFlag"] = self.viewModel.payFlag;
        }
        if (self.viewModel.shareCode) {
            params[@"shareCode"] = self.viewModel.shareCode;
        }
        /// 3.0.19.0
        [LKDataRecord.shared traceEvent:@"takeawayStoreClick"
                                   name:@"takeawayStoreClick"
                             parameters:@{
            @"storeNo": self.viewModel.storeNo,
            @"type": @"settleOrderPage",
            @"pageSource": [WMManage.shareInstance currentCompleteSource:(id)self.viewController includeSelf:NO],
            @"plateId": WMManage.shareInstance.plateId
        }
                                    SPM:[LKSPM SPMWithPage:@"WMStoreProductDetailViewController" area:@"" node:@""]];
        
        [HDMediator.sharedInstance navigaveToOrderSubmitController:params];
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
            [self.viewModel.storeShoppingCartDTO orderCheckBeforeGoToOrderSubmitWithStoreNo:self.viewModel.storeNo items:items activityNos:activityNos success:^(SARspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self dismissLoading];
                goToOrderSubmitPage();
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
                HDLog(@"检查订单失败，%@", error.localizedDescription);
                [self orderCheckFailureWithRspModel:rspModel];
            }];
        }
    }];
}

#pragma mark - private methods
///检测商品状态
- (void)checkProductsStatus:(NSString *)storeNo productIds:(NSArray<NSString *> *)productIds completion:(void (^)(NSDictionary *info))completion {
    [self.viewModel.storeShoppingCartDTO.shoppingCartDTO checkProductStatusWithStoreNo:storeNo productIds:productIds success:^(NSDictionary *_Nonnull info) {
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
    [self.viewModel.storeShoppingCartDTO.shoppingCartDTO batchDeleteGoodsFromShoppingCartWithDeleteItems:deleteItems success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel reGetShoppingCartItems];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.viewModel reGetShoppingCartItems];
    }];
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

- (void)showChooseGoodsSkuAndPropertyViewWithModel:(WMStoreProductDetailRspModel *)goodsModel {
    WMStoreGoodsItem *storeGoodsItem = [WMStoreGoodsItem modelWithProductDetailRspModel:goodsModel];
    WMChooseGoodsPropertyAndSkuView *chooseView = [[WMChooseGoodsPropertyAndSkuView alloc] initWithStoreGoodsItem:storeGoodsItem availableBestSaleCount:self.viewModel.availableBestSaleCount];
    [chooseView show];
    chooseView.addToCartBlock = ^(NSUInteger count, WMStoreGoodsProductSpecification *specificationModel, NSArray<WMStoreGoodsProductPropertyOption *> *_Nonnull propertyOptionList) {
        // 加购埋点,用于统计转化
        if (self.viewModel.plateId) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"type": self.viewModel.collectType, @"plateId": self.viewModel.plateId, @"content": @[goodsModel.goodId]}];
            if (self.viewModel.topicPageId)
                mdic[@"topicPageId"] = self.viewModel.topicPageId;
            if (self.viewModel.payFlag)
                mdic[@"payFlag"] = self.viewModel.payFlag;

            [LKDataRecord.shared traceEvent:@"addShopCart"
                                       name:@"外卖_购物车"
                                 parameters:mdic
                                        SPM:[LKSPM SPMWithPage:@"WMStoreProductDetailViewController" area:@"" node:@""]];
        }
        // 埋点，请勿删除
        [LKDataRecord traceYumNowEvent:@"add_shopcartV2"
                                  name:@"外卖_购物车_加购"
                                   ext:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖商品详情页"] : @"外卖商品详情页",
            @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
            @"goodsId": goodsModel.goodId,
            @"storeNo" : self.viewModel.storeNo
            
        }];
        // end 埋点

        [self.viewModel addShoppingGoodsWithAddDelta:count goodsId:goodsModel.goodId goodsSkuId:specificationModel.specificationId
                                         propertyIds:[propertyOptionList mapObjectsUsingBlock:^id _Nonnull(WMStoreGoodsProductPropertyOption *_Nonnull obj, NSUInteger idx) {
                                             return obj.optionId;
                                         }]
                                   inEffectVersionId:storeGoodsItem.inEffectVersionId];
    };
    chooseView.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart = ^NSUInteger(WMStoreGoodsItem *_Nonnull model) {
        return [self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:goodsModel];
    };
    chooseView.storeShoppingCartPromotions = ^NSArray<WMStoreDetailPromotionModel *> *_Nonnull {
        return self.viewModel.payFeeTrialCalRspModel.promotions;
    };
}

// 下单检查异常处理
- (void)orderCheckFailureWithRspModel:(SARspModel *)rspModel {
    void (^showAlert)(NSString *, void (^)(void)) = ^void(NSString *msg, void (^afterBlock)(void)) {
        [NAT showAlertWithMessage:msg buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
            !afterBlock ?: afterBlock();
        }];
    };

    SAResponseType code = rspModel.code;
    if ([code isEqualToString:WMOrderCheckFailureReasonStoreClosed]) { // 门店休息
        showAlert(rspModel.msg, ^() {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreDetail object:nil];
            [self.viewController dismissAnimated:YES completion:nil];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonStoreStopped]) { // 门店停业/停用
        showAlert(rspModel.msg, ^() {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameReloadStoreDetail object:nil];
            [self.viewController dismissAnimated:YES completion:nil];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonPromotionEnded] || [code isEqualToString:WMOrderCheckFailureReasonDeliveryFeeChanged]) { // 活动已结束或停用、配送费活动变更
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonHaveRemovedProduct]) { // 包含失效商品
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonProductInfoChanged]) { // 商品信息变更
        showAlert(rspModel.msg, ^() {
            [self.viewModel getInitializedData];
        });
    } else {
        showAlert(rspModel.msg, nil);
    }
}
// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMStoreProductDetailRspModel *)currentGoods {
    NSUInteger otherCount = 0;
    for (WMShoppingCartStoreProduct *goods in self.viewModel.shopppingCartStoreItem.goodsList) {
        if (goods.bestSale && ![goods.identifyObj.goodsId isEqualToString:currentGoods.goodId]) {
            otherCount += goods.purchaseQuantity;
        }
    }
    return otherCount;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return 0;
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
        WMStoreProductReviewCell *cell = [WMStoreProductReviewCell cellWithTableView:tableView];
        WMStoreProductReviewModel *trueModel = (WMStoreProductReviewModel *)model;
        trueModel.cellType = WMStoreProductReviewCellTypeProductDetail;
        trueModel.needHideBottomLine = indexPath.row == sectionModel.list.count - 1 ? true : false;
        cell.model = trueModel;
        @HDWeakify(cell);
        @HDWeakify(self);
        cell.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isUserReviewContentExpanded = !cell.model.isUserReviewContentExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        cell.clickedMerchantReplyReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isMerchantReplyExpanded = !cell.model.isMerchantReplyExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };

        return cell;
    } else if ([model isKindOfClass:WMStoreProductDetailRspModel.class]) {
        WMStoreProductDetailHeaderCell *cell = [WMStoreProductDetailHeaderCell cellWithTableView:tableView];
        ((WMStoreProductDetailRspModel *)model).numberOfLinesOfProductDescLabel = 0;
        cell.model = model;
        @HDWeakify(cell);
        @HDWeakify(self);
        cell.plusGoodsToShoppingCartBlock = ^(WMStoreProductDetailRspModel *model, NSUInteger forwardCount) {
            @HDStrongify(self);
            // 加购埋点,用于统计转化
            if (self.viewModel.plateId) {
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:@{@"type": self.viewModel.collectType, @"plateId": self.viewModel.plateId, @"content": @[model.goodId]}];
                if (self.viewModel.topicPageId)
                    mdic[@"topicPageId"] = self.viewModel.topicPageId;
                if (self.viewModel.payFlag)
                    mdic[@"payFlag"] = self.viewModel.payFlag;

                [LKDataRecord.shared traceEvent:@"addShopCart"
                                           name:@"外卖_购物车"
                                     parameters:mdic
                                            SPM:[LKSPM SPMWithPage:@"WMStoreProductDetailViewController" area:@"" node:@""]];
            }
            //埋点 请勿删除
            [LKDataRecord traceYumNowEvent:@"add_shopcartV2"
                                      name:@"外卖_购物车_加购"
                                       ext:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖商品详情页"] : @"外卖商品详情页",
                @"associatedId": HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : @"",
                @"goodsId": model.goodId,
                @"storeNo" : self.viewModel.storeNo
                
            }];
            // end 埋点
            
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
            [self.viewModel addShoppingGoodsWithAddDelta:forwardCount goodsId:model.goodId goodsSkuId:model.specificationList.firstObject.specificationId propertyIds:propertyIds
                                       inEffectVersionId:model.inEffectVersionId];
        };
        cell.goodsCountChangedBlock = ^(WMStoreProductDetailRspModel *_Nonnull model, BOOL isIncrease, NSUInteger count) {
            @HDStrongify(self);
            if (isIncrease) {
                WMManage.shareInstance.selectGoodId = model.goodId;
                [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:model.productPromotion currentCount:count otherSkuCount:0];
                if (model.bestSale) {
                    [WMPromotionLabel showToastWithMaxCount:self.viewModel.availableBestSaleCount currentCount:count otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:model]
                                                 promotions:self.viewModel.payFeeTrialCalRspModel.promotions];
                }
            }
            NSMutableArray<NSString *> *propertyIds = [NSMutableArray arrayWithCapacity:model.propertyList.count];
            for (WMStoreGoodsProductProperty *propertyModel in model.propertyList) {
                if (propertyModel.optionList.firstObject.optionId) {
                    [propertyIds addObject:propertyModel.optionList.firstObject.optionId];
                }
            }
            [self.viewModel updateShoppingGoodsWithCount:count goodsId:model.goodId goodsSkuId:model.specificationList.firstObject.specificationId propertyIds:propertyIds
                                       inEffectVersionId:model.inEffectVersionId];
        };
        cell.showChooseGoodsPropertyAndSkuViewBlock = ^(WMStoreProductDetailRspModel *_Nonnull model) {
            @HDStrongify(self);
            [self showChooseGoodsSkuAndPropertyViewWithModel:model];
        };
        cell.clickedProductDescReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isProductDescExpanded = !cell.model.isProductDescExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        self.headerCellIndexPath = indexPath;
        return cell;
    } else if ([model isKindOfClass:SATableViewViewMoreViewModel.class]) {
        SATableViewViewMoreView *cell = [SATableViewViewMoreView cellWithTableView:tableView];
        cell.model = (SATableViewViewMoreViewModel *)model;
        @HDWeakify(self);
        cell.clickedOperationButonHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToStoreProductReviewListController:@{@"storeNo": self.viewModel.storeNo, @"goodsId": self.viewModel.goodsId}];
        };
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return nil;
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    model.marginToBottom = kRealWidth(1);
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.dataSource.count)
        return CGFLOAT_MIN;
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return section <= 0 ? CGFLOAT_MIN : 37;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.isScrolling = true;

    if (self.tableView.dataSource != self || self.viewModel.isRequestFailed)
        return;

    // 放大 imageView 及其蒙版
    CGRect newFrame = self.zoomableImageV.frame;
    CGFloat settingViewOffsetY = -scrollView.contentOffset.y;
    newFrame.size.height = settingViewOffsetY;
    if (settingViewOffsetY < kZoomImageViewHeight) {
        newFrame.size.height = kZoomImageViewHeight;
    }
    self.zoomableImageV.frame = newFrame;

    // 更新导航栏
    [self.customNavigationBar updateUIWithScrollViewOffsetY:scrollView.contentOffset.y + kNavigationBarH * 2];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    scrollView.isScrolling = false;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.customNavigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        if (self.shoppingCartDockView.isHidden) {
            make.bottom.equalTo(self);
        } else {
            make.bottom.equalTo(self.shoppingCartDockView.mas_top);
        }
    }];

    [self.shoppingCartDockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(25));
    }];

    [self.storeShoppingCartVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (WMStoreProductDetailNavigationBarView *)customNavigationBar {
    if (!_customNavigationBar) {
        _customNavigationBar = WMStoreProductDetailNavigationBarView.new;
    }
    return _customNavigationBar;
}

- (UIImageView *)zoomableImageV {
    if (!_zoomableImageV) {
        UIImageView *imageView = UIImageView.new;
        imageView.frame = CGRectMake(0, 0, kScreenWidth, kZoomImageViewHeight);
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kZoomImageViewHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        _zoomableImageV = imageView;
    }
    return _zoomableImageV;
}
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.backgroundView.backgroundColor = UIColor.clearColor;
        _tableView.userInteractionEnabled = false;
    }
    return _tableView;
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
    }
    return _shoppingCartDockView;
}

- (WMStoreShoppingCartViewController *)storeShoppingCartVC {
    if (!_storeShoppingCartVC) {
        _storeShoppingCartVC = WMStoreShoppingCartViewController.new;
        _storeShoppingCartVC.view.hidden = true;
        @HDWeakify(self);
        _storeShoppingCartVC.storeCartGoodsDidChangedBlock = ^{
            @HDStrongify(self);
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
    }
    return _storeShoppingCartVC;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [WMStoreProductDetailHeaderCell cellWithTableView:tableview];
            } else {
                return [WMStoreProductReviewCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [WMStoreProductDetailHeaderCell skeletonViewHeight];
            } else {
                return [WMStoreProductReviewCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 6;
    }
    return _provider;
}
@end
