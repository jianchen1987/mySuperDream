
//
//  WMShoppingCartViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartViewController.h"
#import "SATableView.h"
#import "WMCustomViewActionView.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMShoppingCartAddGoodsRspModel.h"
#import "WMShoppingCartBatchDeleteItem.h"
#import "WMShoppingCartDTO.h"
#import "WMShoppingCartEntryWindow.h"
#import "WMShoppingCartMinusGoodsRspModel.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartSelectedAllView.h"
#import "WMShoppingCartTableViewCell+Skeleton.h"
#import "WMShoppingCartTableViewCell.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreDetailViewController.h"
#import "WMGoodFailView.h"


@interface WMShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 底部全选视图
@property (strong, nonatomic) WMShoppingCartSelectedAllView *selectedAllView;
/// 导航栏编辑按钮
@property (strong, nonatomic) UIBarButtonItem *editButtonItem;
/// 编辑按钮
@property (strong, nonatomic) HDUIButton *editBtn;
/// 数据源
@property (nonatomic, strong) NSMutableArray<WMShoppingCartStoreItem *> *dataSource;
/// DTO
@property (nonatomic, strong) WMShoppingCartDTO *shoppingCartDTO;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 记录总数
@property (atomic, assign) NSUInteger totalGoodsCount;
/// 操作 cell 需要自动滚动其至顶部的索引
@property (nonatomic, strong) NSIndexPath *needAutoScrollToTopIndexPath;
/// 用户购物车购物项
@property (nonatomic, strong) WMGetUserShoppingCartRspModel *userShoppingCartRspModel;
/// 试算 model
@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// 是否处于编辑状态
@property (nonatomic, assign) BOOL onEditing;
/// 首次自动进入编辑
@property (nonatomic, assign) BOOL firstShowEdit;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;

@end


@implementation WMShoppingCartViewController

@synthesize dataSource = _dataSource;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.onEditing) { // 离开页面退出编辑模式
        [self editClick:self.editBtn];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!SAUser.hasSignedIn) {
        [SAWindowManager switchWindowToLoginViewController];
    }
}

- (void)hd_setupViews {
    self.hd_interactivePopDisabled = self.navigationController.viewControllers.count <= 1;
    self.miniumGetNewDataDuration = 2;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectedAllView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self updateNavigationTitleCount];
    // 监听下单成功的通知
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orderSubmitSuccessHandler) name:kNotificationNameOrderSubmitSuccess object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameOrderSubmitSuccess object:nil];
}

- (void)hd_getNewData {
    [self getNewData];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        if (self.selectedAllView.isHidden) {
            make.bottom.equalTo(self.view);
        } else {
            make.bottom.equalTo(self.selectedAllView.mas_top);
        }
    }];
    [self.selectedAllView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(60));
    }];
    [super updateViewConstraints];
}

#pragma mark - Notification
- (void)orderSubmitSuccessHandler {
    [self getNewData];
}

#pragma mark - Data
/// 获取购物车数据
- (void)getNewData {
    @HDWeakify(self);
    [self.shoppingCartDTO getUserShoppingCartInfoWithClientType:SABusinessTypeYumNow success:^(WMGetUserShoppingCartRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.userShoppingCartRspModel = rspModel;
        [self reloadShoppingCart];
        [self updateNavigationTitleCount];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self.tableView failGetNewData];
    }];
}

- (void)reloadShoppingCart {
    NSArray<WMShoppingCartStoreItem *> *list = self.userShoppingCartRspModel.list;
    // 还原状态
    NSArray<WMShoppingCartStoreItem *> *copyedDataSource = self.dataSource.mutableCopy;
    for (WMShoppingCartStoreItem *newModel in list) {
        for (WMShoppingCartStoreItem *oldModel in copyedDataSource) {
            if ([oldModel.storeNo isEqualToString:newModel.storeNo]) {
                newModel.isSelected = oldModel.isSelected;
                newModel.isDeleteSelected = oldModel.isDeleteSelected;
                // 取出商品
                NSArray<WMShoppingCartStoreProduct *> *goodsList = newModel.goodsList;
                NSArray<WMShoppingCartStoreProduct *> *copyedGoodsList = oldModel.goodsList;
                for (WMShoppingCartStoreProduct *newGoods in goodsList) {
                    for (WMShoppingCartStoreProduct *oldGoods in copyedGoodsList) {
                        if ([oldGoods.identifyObj isEqual:newGoods.identifyObj]) {
                            newGoods.isSelected = oldGoods.isSelected;
                            newGoods.isDeleteSelected = oldGoods.isDeleteSelected;
                            break;
                        }
                    }
                }
            }
        }
    }
    self.dataSource = [NSMutableArray arrayWithArray:list];
    [self querryCouponAcvitity:list];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView successGetNewDataWithNoMoreData:true];
    //购物车满了 清理
    if (self.parameters[@"willDelete"]) {
        if (!self.onEditing && !self.firstShowEdit) { // 进入编辑模式
            self.firstShowEdit = YES;
            [self.tableView layoutIfNeeded];
            [self editClick:self.editBtn];
        }
    } else if (self.userShoppingCartRspModel.shopCartFull) {
        WMNormalAlertConfig *config = WMNormalAlertConfig.new;
        config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
            [alertView dismiss];
            if (!self.onEditing) { // 进入编辑模式
                [self.tableView layoutIfNeeded];
                [self editClick:self.editBtn];
            }
        };
        config.contentAligment = NSTextAlignmentCenter;
        config.content = WMLocalizedString(@"wm_shopcar_full_clear_title", @"购物车已满，请及时清理");
        config.confirm = WMLocalizedString(@"wm_shopcar_full_clear_confirm_clear", @"去清理");
        config.cancel = WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想");
        [WMCustomViewActionView WMAlertWithConfig:config];
    }
}

///查询购物车门店优惠券活动
- (void)querryCouponAcvitity:(NSArray<WMShoppingCartStoreItem *> *)list {
    __block NSMutableArray *storeNos = NSMutableArray.new;
    NSMutableDictionary *mdic = NSMutableDictionary.new;
    [list enumerateObjectsUsingBlock:^(WMShoppingCartStoreItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [storeNos addObject:obj.storeNo];
        [mdic setObject:obj forKey:obj.storeNo];
    }];
    @HDWeakify(self)[self.shoppingCartDTO getActivityCouponShoppingCartWithStoreNos:storeNos success:^(NSArray<WMCouponActivityContentModel *> *rspList) {
        @HDStrongify(self) for (WMCouponActivityContentModel *couponModel in rspList) {
            WMShoppingCartStoreItem *storeModel = mdic[couponModel.storeNo];
            if ([storeModel isKindOfClass:WMShoppingCartStoreItem.class]) {
                storeModel.couponActivtyModel = couponModel;
            }
        }
        [self.tableView successGetNewDataWithNoMoreData:true];
    } failure:nil];
}

/// 删除单个商品
- (void)deleteSingleGoodsForCell:(WMShoppingCartTableViewCell *)cell productModel:(WMShoppingCartStoreProduct *)productModel storeNo:(NSString *)storeNo {
    @HDWeakify(self);
    [self.shoppingCartDTO removeGoodsFromShoppingCartWithClientType:SABusinessTypeYumNow merchantDisplayNo:cell.model.merchantDisplayNo itemDisplayNo:productModel.itemDisplayNo storeNo:storeNo
        goodsSkuId:productModel.goodsSkuId
        propertyValues:productModel.propertyArray success:^(WMShoppingCartRemoveGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"删除单个商品成功");
            @HDStrongify(self);

            //            self.totalGoodsCount -= productModel.purchaseQuantity;
            //            [self updateNavigationTitleWithGoodsCount:self.totalGoodsCount];

            // 移除该商品在选中列表中的模型
            [cell removeSelectedProductModelFromSelectedProductList:productModel];
            [self reloadCellAfterRemovingProductModel:productModel storeNo:storeNo];
            [self payFeeTrialCalculateForCell:cell selectedProductList:cell.selectedProductList needUpdatePrice:productModel.bestSale];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"删除单个商品失败");
        }];
}

/// 删除门店购物项
- (void)deleteStoreGoodsWithMerchantDisplayNo:(NSString *)merchantDisplayNo storeNo:(NSString *)storeNo {
    @HDWeakify(self);
    [self.shoppingCartDTO removeStoreGoodsFromShoppingCartWithClientType:SABusinessTypeYumNow merchantDisplayNo:merchantDisplayNo storeNo:storeNo
        success:^(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"删除整个门店商品成功");
            @HDStrongify(self);
            [self removeCellAndDataSourceWithMerchantDisplayNo:merchantDisplayNo];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"删除整个门店商品失败");
        }];
}

- (void)updateGoodsCountForCell:(WMShoppingCartTableViewCell *)cell
                   productModel:(WMShoppingCartStoreProduct *)productModel
                          count:(NSUInteger)count
                        storeNo:(NSString *)storeNo
              afterSuccessBlock:(void (^)(void))afterSuccessBlock {
    @HDWeakify(self);
    NSArray<NSString *> *propertyIds = [productModel.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.propertyId;
    }];
    [self.shoppingCartDTO updateGoodsCountInShoppingCartWithClientType:SABusinessTypeYumNow count:count goodsId:productModel.goodsId goodsSkuId:productModel.goodsSkuId propertyIds:propertyIds
        storeNo:storeNo
        inEffectVersionId:productModel.inEffectVersionId success:^(WMShoppingCartUpdateGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"更新单个商品数量成功");
            @HDStrongify(self);
            // 未登录状态，直接刷新购物车
            if (!SAUser.hasSignedIn) {
                [self getNewData];
                return;
            }

            if (HDIsObjectNil(rspModel.updateItem) || count == 0) {
                // 删除商品 理论上不会存在
                self.userShoppingCartRspModel = rspModel.shopCart;
                [self reloadShoppingCart];
            } else {
                // 更新本地数据
                productModel.totalDiscountAmount = rspModel.updateItem.totalDiscountAmount;
                productModel.purchaseQuantity = rspModel.updateItem.purchaseQuantity;
                // 需要在修改完productModel后调用
                !afterSuccessBlock ?: afterSuccessBlock();
            }
            [self updateNavigationTitleCount];
            [self payFeeTrialCalculateForCell:cell selectedProductList:cell.selectedProductList needUpdatePrice:productModel.bestSale];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"更新单个商品数量失败");
            if ([rspModel.code isEqualToString:@"ME1007"]) {
                [NAT showAlertWithMessage:rspModel.msg buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }];
            }
        }];
}

/// 订单金额试算
- (void)payFeeTrialCalculateForCell:(WMShoppingCartTableViewCell *)cell selectedProductList:(NSArray<WMShoppingCartStoreProduct *> *)selectedProductList needUpdatePrice:(BOOL)needUpdatePrice {
    // 如果没有选中项，直接 return
    if (HDIsArrayEmpty(selectedProductList))
        return;

    if (cell.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
        [HDTips showInfo:WMLocalizedString(@"wm_store_busy_to_select", @"商家繁忙，请选择其他门店下单")];
        cell.model.isSelected = NO;
        [selectedProductList enumerateObjectsUsingBlock:^(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
        }];
        [self.tableView successGetNewDataWithNoMoreData:YES];
        return;
    }
    NSArray<WMShoppingCartPayFeeCalItem *> *items = [selectedProductList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        WMShoppingCartPayFeeCalItem *item = WMShoppingCartPayFeeCalItem.new;
        item.productId = obj.goodsId;
        item.count = obj.purchaseQuantity;
        item.properties = [obj.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull property, NSUInteger idx) {
            return property.propertyId;
        }];
        item.specId = obj.goodsSkuId;
        if ((obj.productPromotion.type == WMStoreGoodsPromotionLimitTypeDayProNum || obj.productPromotion.type == WMStoreGoodsPromotionLimitTypeActivityTotalNum) &&
            [item.productId isEqualToString:WMManage.shareInstance.selectGoodId]) {
            item.select = @"";
            WMManage.shareInstance.selectGoodId = nil;
        }
        return item;
    }];
    [self.view showloading];
    @HDWeakify(self);
    [self.shoppingCartDTO orderPayFeeTrialCalculateWithItems:items success:^(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull rspModel) {
        HDLog(@"购物车订单试算成功");
        @HDStrongify(self);
        self.payFeeTrialCalRspModel = rspModel;
        [self.view dismissLoading];
        [self reloadCellForStoreNo:cell.model.storeNo beforeReloadBlock:^(NSIndexPath *indexPath) {
            @HDStrongify(self);
            cell.model.feeTrialCalRspModel = rspModel;
            if (needUpdatePrice) {
                [self updateProductModelPriceInStoreItem:cell.model];
            }
        }];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"购物车订单试算失败");
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 下单前检查门店状态
- (void)checkStoreStatusForCell:(WMShoppingCartTableViewCell *)cell selectedProductList:(NSArray<WMShoppingCartStoreProduct *> *)selectedProductList {
    // 如果没有选中项，直接 return
    if (HDIsArrayEmpty(selectedProductList))
        return;

    NSArray<WMShoppingCartOrderCheckItem *> *items = [selectedProductList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
        WMShoppingCartOrderCheckItem *item = WMShoppingCartOrderCheckItem.new;
        item.productId = obj.goodsId;
        item.count = obj.purchaseQuantity;
        item.specId = obj.goodsSkuId;
        return item;
    }];

    // 未试算
    if (HDIsObjectNil(self.payFeeTrialCalRspModel))
        return;
    NSArray<NSString *> *activityNos = [self.payFeeTrialCalRspModel.promotions mapObjectsUsingBlock:^id _Nonnull(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx) {
        return obj.activityNo;
    }];

    void (^goToOrderSubmitPage)(void) = ^(void) {
        WMShoppingCartStoreItem *storeItem = cell.model;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        params[@"productList"] = selectedProductList;
        params[@"storeItem"] = storeItem;
        params[@"from"] = @1;
        params[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] = @(true);
        [HDMediator.sharedInstance navigaveToOrderSubmitController:params];
    };

    [self showloading];


    NSArray<NSString *> *productIds = [items mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartOrderCheckItem *_Nonnull obj, NSUInteger idx) {
        return obj.productId;
    }];
    @HDWeakify(self);
    [self checkProductsStatus:cell.model.storeNo productIds:productIds completion:^(NSDictionary *info) {
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
            NSArray *productArr = [selectedProductList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull item) {
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
                    [self.shoppingCartDTO batchDeleteGoodsFromShoppingCartWithDeleteItems:deleteItems success:^{
                        @HDStrongify(self);
                        [self dismissLoading];
                        [self hd_getNewData];
                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                        @HDStrongify(self);
                        [self dismissLoading];
                    }];
                }
                [actionView dismiss];
            };
            [actionView show];
        } else {
            @HDWeakify(self);
            [self.shoppingCartDTO orderCheckBeforeGoToOrderSubmitWithStoreNo:cell.model.storeNo items:items activityNos:activityNos success:^(SARspModel *_Nonnull rspModel) {
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

- (void)checkProductsStatus:(NSString *)storeNo productIds:(NSArray<NSString *> *)productIds completion:(void (^)(NSDictionary *info))completion {
    [self.shoppingCartDTO checkProductStatusWithStoreNo:storeNo productIds:productIds success:^(NSDictionary *_Nonnull info) {
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

#pragma mark - private methods
// 点击了门店标题
- (void)adjustClickedStoreTitleActionWithStoreNo:(NSString *)storeNo {
    @HDWeakify(self);
    void (^navigateToNewStoreBlock)(void) = ^(void) {
        @HDStrongify(self);
        [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
            @"storeNo": storeNo,
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖购物车"] : @"外卖购物车",
            @"associatedId" : self.viewModel.associatedId
        }];
    };
    
    NSArray<UIViewController *> *vcList = self.navigationController.viewControllers;
    if (vcList.count >= 2) {
        SAViewController *descVC = (SAViewController *)[vcList objectAtIndex:vcList.count - 2];
        if ([descVC isKindOfClass:SAViewController.class]) {
            if ([descVC isKindOfClass:WMStoreDetailViewController.class]) {
                // 判断上一个页面是不是该店
                if ([storeNo isEqualToString:((WMStoreDetailViewController *)descVC).storeNo]) {
                    [self dismissAnimated:true completion:nil];
                } else {
                    navigateToNewStoreBlock();
                }
            } else {
                navigateToNewStoreBlock();
            }
        } else {
            navigateToNewStoreBlock();
        }
    } else {
        navigateToNewStoreBlock();
    }
}

- (void)updateNavigationTitleCount {
    NSUInteger totalCount = 0;
    NSUInteger failGoodCount = 0;
    if (!HDIsArrayEmpty(self.dataSource)) {
        @autoreleasepool {
            // 计算数量
            for (WMShoppingCartStoreItem *storeItem in self.dataSource) {
                for (WMShoppingCartStoreProduct *productModel in storeItem.goodsList) {
                    if (productModel.goodsState == WMGoodsStatusOn && productModel.availableStock > 0) {
                        totalCount += productModel.purchaseQuantity;
                    }
                    if (productModel.goodsState == WMGoodsStatusOff || (productModel.availableStock <= 0)) {
                        failGoodCount += productModel.purchaseQuantity;
                    }
                }
            }
        }
    }
    self.selectedAllView.failGoodCount = failGoodCount;
    if (totalCount > 0) {
        self.boldTitle = [NSString stringWithFormat:@"%@ (%zd)", WMLocalizedString(@"cart_title", @"Cart"), totalCount];
    } else {
        self.boldTitle = [NSString stringWithFormat:@"%@ (0)", WMLocalizedString(@"cart_title", @"Cart")];
    }
    self.totalGoodsCount = totalCount;
    //    self.totalGoodsCount = self.totalGoodsCount < 0 ? 0 : self.totalGoodsCount;
}

/// 查找指定门店的 indexPath
- (NSIndexPath *)indexPathForStoreNo:(NSString *)storeNo {
    NSInteger destStoreIndex = -1;
    for (WMShoppingCartStoreItem *storeItem in self.dataSource) {
        if ([storeItem.storeNo isEqualToString:storeNo]) {
            destStoreIndex = [self.dataSource indexOfObject:storeItem];
            break;
        }
    }
    destStoreIndex = destStoreIndex >= 0 ? destStoreIndex : 0;
    return [NSIndexPath indexPathForRow:destStoreIndex inSection:0];
}

/// 从数据源中删除某门店的数据以及删除 cell
- (void)removeCellAndDataSourceWithMerchantDisplayNo:(NSString *)merchantDisplayNo {
    // 从当前数据源中删除该店
    NSInteger destStoreIndex = -1;
    NSMutableArray<WMShoppingCartStoreItem *> *storeItemListCopyed = self.dataSource.mutableCopy;

    for (WMShoppingCartStoreItem *storeItem in storeItemListCopyed) {
        if ([storeItem.merchantDisplayNo isEqualToString:merchantDisplayNo]) {
            NSUInteger storeProductTotalCount = 0;
            for (WMShoppingCartStoreProduct *product in storeItem.goodsList) {
                storeProductTotalCount += product.purchaseQuantity;
            }
            //            self.totalGoodsCount -= storeProductTotalCount;
            //            [self updateNavigationTitleWithGoodsCount:self.totalGoodsCount];

            destStoreIndex = [storeItemListCopyed indexOfObject:storeItem];
            [storeItemListCopyed removeObject:storeItem];
            break;
        }
    }

    // 由于是动画移除，数据源变化后再移除可能导致崩溃（如最后一个 cell）
    NSMutableArray<WMShoppingCartStoreItem *> *originStoreItemList = self.dataSource.mutableCopy;
    self.dataSource = storeItemListCopyed;
    if (destStoreIndex != -1 && originStoreItemList.count > destStoreIndex) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:destStoreIndex inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (HDIsArrayEmpty(self.dataSource)) {
            [self.tableView successGetNewDataWithNoMoreData:true];

            [WMShoppingCartEntryWindow.sharedInstance updateIndicatorDotWithCount:0];
        }
    }
    [self updateNavigationTitleCount];
}

/// 从数据源中某门店的商品数据以及刷新该 cell
- (void)reloadCellAfterRemovingProductModel:(WMShoppingCartStoreProduct *)productModel storeNo:(NSString *)storeNo {
    if (HDIsArrayEmpty(self.dataSource)) {
        [self.tableView successGetNewDataWithNoMoreData:true];
        [self updateNavigationTitleCount];

        [WMShoppingCartEntryWindow.sharedInstance updateIndicatorDotWithCount:0];
        return;
    }

    // 从当前数据源中删除该 model
    NSInteger destStoreIndex = -1;
    for (WMShoppingCartStoreItem *storeItem in self.dataSource) {
        if ([storeItem.storeNo isEqualToString:storeNo]) {
            destStoreIndex = [self.dataSource indexOfObject:storeItem];
            BOOL hasFound = false;
            NSMutableArray<WMShoppingCartStoreProduct *> *goodsListCopyed = storeItem.goodsList.mutableCopy;
            for (WMShoppingCartStoreProduct *product in goodsListCopyed) {
                if (product == productModel) {
                    [goodsListCopyed removeObject:product];
                    hasFound = true;
                    break;
                }
            }
            if (hasFound) {
                storeItem.goodsList = goodsListCopyed;
            }
            break;
        }
    }
    if (destStoreIndex != -1 && self.dataSource.count > destStoreIndex) {
        if (self.dataSource[destStoreIndex].goodsList.count == 0) {
            [self.dataSource removeObjectAtIndex:destStoreIndex];
        }
        [self.tableView successGetNewDataWithNoMoreData:true];
    }
    [self updateNavigationTitleCount];
}

/// 刷新某门店号的 cell
- (void)reloadCellForStoreNo:(NSString *)storeNo beforeReloadBlock:(void (^_Nullable)(NSIndexPath *indexPath))beforeReloadBlock {
    NSIndexPath *indexPath = [self indexPathForStoreNo:storeNo];
    if (self.dataSource.count > indexPath.row) {
        !beforeReloadBlock ?: beforeReloadBlock(indexPath);
        [UIView performWithoutAnimation:^{
            CGPoint loc = self.tableView.contentOffset;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.tableView.contentOffset = loc;
        }];

        if (self.needAutoScrollToTopIndexPath && self.dataSource.count > self.needAutoScrollToTopIndexPath.row) {
            [self.tableView scrollToRowAtIndexPath:self.needAutoScrollToTopIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.needAutoScrollToTopIndexPath = nil;
        }
    }
}

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
            [self getNewData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonStoreStopped]) { // 门店停业/停用
        showAlert(rspModel.msg, ^() {
            [self getNewData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonPromotionEnded] ||
               [code isEqualToString:WMOrderCheckFailureReasonDeliveryFeeChanged]) { // 活动已结束或停用、配送费活动变更
                                                                                     //        !goToOrderSubmitPage ?: goToOrderSubmitPage(); // 需求修改，暂不需要跳转订单确定页面
        showAlert(rspModel.msg, ^() {
            [self getNewData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonHaveRemovedProduct]) { // 包含失效商品
        showAlert(rspModel.msg, ^() {
            [self getNewData];
        });
    } else if ([code isEqualToString:WMOrderCheckFailureReasonProductInfoChanged]) { // 商品信息变更
        showAlert(rspModel.msg, ^() {
            [self getNewData];
        });
    } else {
        showAlert(rspModel.msg, nil);
    }
}

- (NSUInteger)calcGoodsCountInShoppingWithGoodsModel:(WMShoppingCartStoreProduct *)model {
    NSUInteger count = 0;
    for (WMShoppingCartStoreItem *storeItem in self.userShoppingCartRspModel.list) {
        for (WMShoppingCartStoreProduct *goods in storeItem.goodsList) {
            if ([goods.goodsId isEqualToString:model.goodsId] && ![goods.itemDisplayNo isEqualToString:model.itemDisplayNo]) {
                count += goods.purchaseQuantity;
            }
        }
    }
    return count;
}
// 编辑按钮点击
- (void)editClick:(HDUIButton *)btn {
    btn.selected = !btn.selected;
    self.onEditing = !self.onEditing;
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedAllView.hidden = !btn.isSelected;
        [self.view setNeedsUpdateConstraints];
    }];
    if (!self.onEditing) {
        [self resetOnEditingStatus];
        [btn setTitle:WMLocalizedStringFromTable(@"wm_edit_btn", @"编辑", @"Buttons") forState:UIControlStateNormal];
    } else {
        [btn setTitle:WMLocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    [self.tableView successGetNewDataWithNoMoreData:true];
}
// 根据试算结果更新商品价格
- (void)updateProductModelPriceInStoreItem:(WMShoppingCartStoreItem *)storeItem {
    for (WMShoppingCartStoreProduct *product in storeItem.goodsList) {
        for (WMShoppingCartPayFeeCalProductModel *calProduct in storeItem.feeTrialCalRspModel.products) {
            WMShoppingCartStoreIdentifyableProduct *identifyableProduct = WMShoppingCartStoreIdentifyableProduct.new;
            identifyableProduct.goodsId = calProduct.productId;
            identifyableProduct.goodsSkuId = calProduct.specId;
            identifyableProduct.propertyArray = [calProduct.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
                return obj.propertyId;
            }];
            if ([product.identifyObj isEqual:identifyableProduct]) {
                product.totalDiscountAmount = calProduct.freeProductPromotionAmount;
            }
        }
    }
}

#pragma mark - 购物编辑状态方法
// 重置编辑状态下的数据 将删除的数据清零
- (void)resetOnEditingStatus {
    for (WMShoppingCartStoreItem *item in self.dataSource) {
        item.isDeleteSelected = NO;
        for (WMShoppingCartStoreProduct *product in item.goodsList) {
            product.isDeleteSelected = NO;
        }
    }
    [self.selectedAllView setDeleteBtnEnabled:false];
}
// 编辑状态下 商品选中点击
- (void)onEditingProductClickWithStoreItem:(WMShoppingCartStoreItem *)item product:(WMShoppingCartStoreProduct *)product {
    //门店下是否所有商品都选中了
    BOOL isStoreAllSelected = YES;
    for (WMShoppingCartStoreProduct *subModel in item.goodsList) {
        if (subModel.isDeleteSelected == NO) {
            isStoreAllSelected = NO;
            break;
        }
    }
    if (isStoreAllSelected) {
        item.isDeleteSelected = YES;
    } else {
        item.isDeleteSelected = false;
    }
    // 继续查看所有店铺 是否全部选中
    BOOL isAllSelected = YES;
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        if (subItem.isDeleteSelected == NO) {
            isAllSelected = NO;
            break;
        }
    }
    //设置全选按钮
    [self.selectedAllView setSelectedBtnStatus:isAllSelected];
    //设置删除按钮是否可点击
    BOOL isAnyGoodSelected = NO; //是否有一个商品被选中了
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        for (WMShoppingCartStoreProduct *subModel in subItem.goodsList) {
            if (subModel.isDeleteSelected == YES) {
                isAnyGoodSelected = YES;
                break;
            }
        }
        if (isAnyGoodSelected == YES) {
            break;
        }
    }
    [self.selectedAllView setDeleteBtnEnabled:isAnyGoodSelected];
    [self.tableView successGetNewDataWithNoMoreData:true];
}
// 编辑状态下 门店选中点击
- (void)onEditingStoreClickWithStoreItem:(WMShoppingCartStoreItem *)item {
    for (WMShoppingCartStoreProduct *subModel in item.goodsList) {
        //商品的状态跟随门店的状态
        subModel.isDeleteSelected = item.isDeleteSelected;
    }
    // 继续查看所有店铺 是否全部选中
    BOOL isAllSelected = YES;
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        if (subItem.isDeleteSelected == NO) {
            isAllSelected = NO;
            break;
        }
    }
    //设置全选按钮
    [self.selectedAllView setSelectedBtnStatus:isAllSelected];
    //设置删除按钮是否可点击
    BOOL isAnyStoreSelected = NO; //是否有一个门店被选中了
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        if (subItem.isDeleteSelected == YES) {
            isAnyStoreSelected = YES;
            break;
        }
    }
    [self.selectedAllView setDeleteBtnEnabled:isAnyStoreSelected];
    [self.tableView successGetNewDataWithNoMoreData:true];
}
// 编辑状态下  全选点击
- (void)onEditingAllSelectClick:(BOOL)isSelectAll {
    //所有门店  门店下所有商品状态 跟随isSelectAll
    for (WMShoppingCartStoreItem *item in self.dataSource) {
        item.isDeleteSelected = isSelectAll;
        for (WMShoppingCartStoreProduct *product in item.goodsList) {
            product.isDeleteSelected = isSelectAll;
        }
    }
    [self.selectedAllView setDeleteBtnEnabled:isSelectAll];
    [self.tableView successGetNewDataWithNoMoreData:true];
}
// 全选状态下 批量删除点击
- (void)onEditingBatchDeleteClick {
    NSMutableArray *deleteItems = [NSMutableArray array];
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        for (WMShoppingCartStoreProduct *subModel in subItem.goodsList) {
            if (subModel.isDeleteSelected == YES) {
                WMShoppingCartBatchDeleteItem *deleteItem = [[WMShoppingCartBatchDeleteItem alloc] init];
                deleteItem.itemDisplayNo = subModel.itemDisplayNo;
                deleteItem.inEffectVersionId = subModel.inEffectVersionId;
                [deleteItems addObject:deleteItem];
            }
        }
    }
    if (!HDIsArrayEmpty(deleteItems)) {
        // 弹窗确认
        [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"Do you want to delete store item?")
            confirmButtonTitle:WMLocalizedStringFromTable(@"not_now", @"Not Now", @"Buttons") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }
            cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                [self batchDeleteGoodsWithDeleteItems:deleteItems];
            }];
    }
}

///删除已失效的
- (void)onDeleteFailClick {
    NSMutableArray *deleteItems = [NSMutableArray array];
    for (WMShoppingCartStoreItem *subItem in self.dataSource) {
        for (WMShoppingCartStoreProduct *subModel in subItem.goodsList) {
            BOOL isGoodsOffSale = subModel.goodsState == WMGoodsStatusOff;
            BOOL isGoodsSoldOut = subModel.availableStock <= 0;
            if (isGoodsOffSale || isGoodsSoldOut) {
                WMShoppingCartBatchDeleteItem *deleteItem = [[WMShoppingCartBatchDeleteItem alloc] init];
                deleteItem.itemDisplayNo = subModel.itemDisplayNo;
                deleteItem.inEffectVersionId = subModel.inEffectVersionId;
                [deleteItems addObject:deleteItem];
            }
        }
    }
    if (!HDIsArrayEmpty(deleteItems)) {
        @HDWeakify(self) WMNormalAlertConfig *config = WMNormalAlertConfig.new;
        config.content = WMLocalizedString(@"wm_shopcar_full_clear_content", @"是否确认清空已失效商品");
        config.cancel = WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想");
        config.contentAligment = NSTextAlignmentCenter;
        config.confirm = WMLocalizedString(@"wm_shopcar_full_clear_confirm", @"确认清空");
        config.confirmHandle = ^(WMNormalAlertView *_Nonnull alertView, HDUIButton *_Nonnull button) {
            @HDStrongify(self);
            [alertView dismiss];
            [self batchDeleteGoodsWithDeleteItems:deleteItems];
        };
        WMNormalAlertView *alert = [[WMNormalAlertView alloc] initWithConfig:config];
        [alert show];
    }
}

// 批量删除购物车商品
- (void)batchDeleteGoodsWithDeleteItems:(NSArray<WMShoppingCartBatchDeleteItem *> *)deleteItems {
    [self showloading];
    @HDWeakify(self);
    [self.shoppingCartDTO batchDeleteGoodsFromShoppingCartWithDeleteItems:deleteItems success:^{
        @HDStrongify(self);
        [self dismissLoading];
        //将本地数据删除
        for (WMShoppingCartStoreItem *item in self.dataSource) {
            NSMutableArray *goodsCopy = item.goodsList.mutableCopy;
            [goodsCopy enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WMShoppingCartStoreProduct *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                for (WMShoppingCartBatchDeleteItem *deleteItem in deleteItems) {
                    if ([deleteItem.inEffectVersionId isEqualToString:obj.inEffectVersionId]) {
                        [goodsCopy removeObject:obj]; //清理商品
                    }
                }
            }];
            item.goodsList = goodsCopy;
        }
        //清理门店
        NSMutableArray *itemsCopy = self.dataSource.mutableCopy;
        [itemsCopy enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WMShoppingCartStoreItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.feeTrialCalRspModel = nil;
            if (HDIsArrayEmpty(obj.goodsList)) {
                [itemsCopy removeObject:obj]; //清理门店
            }
        }];
        self.dataSource = itemsCopy;
        [self updateNavigationTitleCount];
        if (self.onEditing) {
            //退出编辑模式
            [self editClick:self.editBtn];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) { // 数组越界的兜底策略
        HDLog(@"数组越界:%zd", indexPath.row);
        return UITableViewCell.new;
    }
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMShoppingCartStoreItem.class]) {
        WMShoppingCartTableViewCell *cell = [WMShoppingCartTableViewCell cellWithTableView:tableView];
        WMShoppingCartStoreItem *trueModel = (WMShoppingCartStoreItem *)model;
        trueModel.isFirstCell = indexPath.row == 0;
        trueModel.isLastCell = indexPath.row == self.dataSource.count - 1;
        @HDWeakify(self);
        @HDWeakify(cell);
        @HDWeakify(tableView);
        // 删除门店
        cell.deleteStoreGoodsBlock = ^(NSString *_Nonnull merchantDisplayNo, NSString *storeNo) {
            @HDStrongify(self);
            // 弹窗确认
            [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"Do you want to delete store item?")
                confirmButtonTitle:WMLocalizedStringFromTable(@"not_now", @"Not Now", @"Buttons") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }
                cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                    [self deleteStoreGoodsWithMerchantDisplayNo:merchantDisplayNo storeNo:storeNo];
                }];
        };
        // 删除单个商品
        cell.deleteSingleGoodsBlock = ^(WMShoppingCartStoreProduct *_Nonnull productModel) {
            @HDStrongify(self);
            @HDStrongify(cell);
            [self deleteSingleGoodsForCell:cell productModel:productModel storeNo:cell.model.storeNo];
        };
        cell.goodsCountChangedBlock = ^(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger count, void (^_Nonnull afterSuccessBlock)(void)) {
            @HDStrongify(self);
            @HDStrongify(cell);
            [self updateGoodsCountForCell:cell productModel:productModel count:count storeNo:cell.model.storeNo afterSuccessBlock:afterSuccessBlock];
        };
        cell.goodsCountShouldChange = ^BOOL(WMShoppingCartStoreProduct *_Nonnull productModel, BOOL isIncrease, NSUInteger count) {
            @HDStrongify(self);
            if (isIncrease && self.totalGoodsCount >= 150) {
                [NAT showToastWithTitle:nil content:WMLocalizedString(@"cart_is_full", @"Shopping cart is full, please clean up.") type:HDTopToastTypeWarning];
                return NO;
            }
            NSUInteger otherSkuCount = [self calcGoodsCountInShoppingWithGoodsModel:productModel];
            if (otherSkuCount + count > productModel.availableStock && isIncrease) {
                [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), productModel.availableStock] type:HDTopToastTypeWarning];
                return NO;
            }

            return YES;
        };

        // 点击门店标题
        cell.clickedStoreTitleBlock = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [self adjustClickedStoreTitleActionWithStoreNo:storeNo];
        };
        cell.anyProductSelectStateChangedHandler = ^(BOOL needUpdatePrice) {
            // 试算
            @HDStrongify(self);
            @HDStrongify(cell);
            [self payFeeTrialCalculateForCell:cell selectedProductList:cell.selectedProductList needUpdatePrice:needUpdatePrice];
        };
        cell.deletedLastProductBlock = ^(NSString *_Nonnull merchantDisplayNo) {
            @HDStrongify(self);
            [self removeCellAndDataSourceWithMerchantDisplayNo:merchantDisplayNo];
        };
        cell.reloadBlock = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [self reloadCellForStoreNo:storeNo beforeReloadBlock:nil];
        };
        cell.userDidDoneSomeActionBlock = ^{
            @HDStrongify(self);
            @HDStrongify(tableView);
            // 如果 cell 不完全可见并且 cell 高度不足一页的，滚动其至顶部
            CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
            BOOL completelyVisible = CGRectContainsRect(tableView.bounds, cellRect);
            if (cellRect.size.height < tableView.bounds.size.height && !completelyVisible) {
                self.needAutoScrollToTopIndexPath = indexPath;
            } else {
                self.needAutoScrollToTopIndexPath = nil;
            }
        };
        cell.clickedOrderNowBTNBlock = ^{
            @HDStrongify(self);
            @HDStrongify(cell);
            [self checkStoreStatusForCell:cell selectedProductList:cell.selectedProductList];
        };
        cell.clickedProductViewBlock = ^(WMShoppingCartStoreProduct *_Nonnull productModel) {
            @HDStrongify(cell);
            const BOOL isGoodsOnSale = productModel.goodsState == WMGoodsStatusOn;
            // 商品下架不处理
            if (isGoodsOnSale) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"storeNo"] = cell.model.storeNo;
                params[@"productId"] = productModel.goodsId;
                params[@"sourceType"] = WMStoreDetailSourceTypeUnionShoppingCart;
                params[@"source"] = HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|外卖购物车"] : @"外卖购物车";
                params[@"associatedId"] = self.viewModel.associatedId;
                [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
            }
        };
        ///编辑状态下事件点击
        cell.onEditingSelectedProductBlock = ^(WMShoppingCartStoreItem *_Nonnull item, WMShoppingCartStoreProduct *_Nonnull productModel) {
            @HDStrongify(self);
            [self onEditingProductClickWithStoreItem:item product:productModel];
        };
        cell.onEditingSelectedStoreBlock = ^(WMShoppingCartStoreItem *_Nonnull item) {
            @HDStrongify(self);
            [self onEditingStoreClickWithStoreItem:item];
        };
        cell.onEditing = self.onEditing;
        // 赋值 model 写在最后，不要改变位置
        cell.model = trueModel;
        cell.contentView.backgroundColor = HDAppTheme.WMColor.bgGray;
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

- (void)setDataSource:(NSMutableArray<WMShoppingCartStoreItem *> *)dataSource {
    _dataSource = dataSource;

    if (HDIsArrayEmpty(dataSource)) {
        self.hd_navigationItem.rightBarButtonItem = nil;
    } else {
        self.hd_navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

#pragma mark - lazy load

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.backgroundColor = HDAppTheme.WMColor.bgGray;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"no_data_placeholder";
        model.title = WMLocalizedString(@"cart_empty", @"购物车为空");
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

- (NSMutableArray<WMShoppingCartStoreItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = NSMutableArray.array; });
}

- (WMShoppingCartDTO *)shoppingCartDTO {
    if (!_shoppingCartDTO) {
        _shoppingCartDTO = WMShoppingCartDTO.new;
    }
    return _shoppingCartDTO;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMShoppingCartTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMShoppingCartTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}
- (WMShoppingCartSelectedAllView *)selectedAllView {
    if (!_selectedAllView) {
        _selectedAllView = [[WMShoppingCartSelectedAllView alloc] init];
        @HDWeakify(self);
        _selectedAllView.selectedAllClickCallBack = ^(BOOL isSelecedAll) {
            @HDStrongify(self);
            [self onEditingAllSelectClick:isSelecedAll];
        };
        _selectedAllView.deleteClickCallBack = ^{
            @HDStrongify(self);
            [self onEditingBatchDeleteClick];
        };
        _selectedAllView.deleteFailClickCallBack = ^{
            @HDStrongify(self);
            [self onDeleteFailClick];
        };
        _selectedAllView.hidden = YES;
    }
    return _selectedAllView;
}
- (UIBarButtonItem *)editButtonItem {
    if (!_editButtonItem) {
        _editBtn = [[HDUIButton alloc] init];
        [_editBtn setTitle:WMLocalizedStringFromTable(@"wm_edit_btn", @"编辑", @"Buttons") forState:UIControlStateNormal];
        [_editBtn setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        _editBtn.titleLabel.font = HDAppTheme.font.standard3;
        [_editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        //        _editBtn.hd_eventTimeInterval = 0.01;
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 7);
        [_editBtn sizeToFit];
        _editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    }
    return _editButtonItem;
}

- (BOOL)needLogin {
    return YES;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeOther;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
