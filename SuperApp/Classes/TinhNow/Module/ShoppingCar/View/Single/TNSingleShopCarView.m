//
//  TNSingleShopCarView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSingleShopCarView.h"
#import "TNGestureTableView.h"
#import "TNShopCarFooterView.h"
#import "TNShopCarHeaderView.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNShoppingCartTableViewCell+Skeleton.h"
#import "TNSingleShopCarProductCell.h"


@interface TNSingleShopCarView () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) TNGestureTableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;

@end


@implementation TNSingleShopCarView
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self addSubview:self.tableView];
    self.tableView.dataSource = self.provider;
    self.tableView.delegate = self.provider;
    //有再来一单也要重新刷新数据
    //    if (HDIsArrayEmpty(self.shopCarDataCenter.singleShopCardataSource) || !HDIsArrayEmpty(self.shopCarDataCenter.reBuySkuIds)) {
    //        [self getNewData];
    //    } else {
    //        self.tableView.delegate = self;
    //        self.tableView.dataSource = self;
    //        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    //    }
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"singleRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //处理失效数据
        [self.shopCarDataCenter.singleShopCardataSource enumerateObjectsUsingBlock:^(TNShoppingCarStoreModel *_Nonnull storeModel, NSUInteger idx, BOOL *_Nonnull stop) {
            __block BOOL hasProductCanSale = NO;
            if (!HDIsArrayEmpty(storeModel.shopCarItems)) {
                [storeModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (obj.goodsState == TNStoreItemStateOnSale) {
                        hasProductCanSale = YES;
                    }
                }];
            }
            storeModel.allProductOffSale = !hasProductCanSale;
        }];
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        [self prepareRebuyOrderSkusAutoSelected:self.shopCarDataCenter.singleShopCardataSource];
    }];
}
#pragma mark -获取新数据
- (void)getNewData {
    if (![SAUser hasSignedIn]) {
        return;
    }
    @HDWeakify(self);
    [self.shopCarDataCenter querySingleUserShoppingCarSuccess:nil failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    }];
}
/// 准备再次购买的订单自动勾选功能
- (void)prepareRebuyOrderSkusAutoSelected:(NSArray *)shopCars {
    if (!HDIsArrayEmpty(self.shopCarDataCenter.reBuySkuIds) && !HDIsArrayEmpty(shopCars)) {
        TNShoppingCarStoreModel *targetStoreModel = nil;
        for (NSString *skuId in self.shopCarDataCenter.reBuySkuIds) {
            for (TNShoppingCarStoreModel *sModel in shopCars) {
                for (TNShoppingCarItemModel *item in sModel.shopCarItems) {
                    if ([skuId isEqualToString:item.goodsSkuId]) {
                        item.isSelected = true;
                        if (HDIsObjectNil(targetStoreModel)) {
                            targetStoreModel = sModel;
                        }
                        break;
                    }
                }
                if (!HDIsObjectNil(targetStoreModel)) {
                    break;
                }
            }
        }
        self.shopCarDataCenter.reBuySkuIds = nil; //处理过一次就置空
        if (!HDIsObjectNil(targetStoreModel)) {
            [self selectedProductWithItem:nil storeModel:targetStoreModel indexPath:[NSIndexPath indexPathWithIndex:[self.shopCarDataCenter.singleShopCardataSource indexOfObject:targetStoreModel]]];
        }
    }
}
#pragma mark -结算下单
- (void)settlementToSubmitOrderWithStoreModel:(TNShoppingCarStoreModel *)storeModel {
    NSMutableArray *selectedArr = [NSMutableArray array];
    for (TNShoppingCarItemModel *model in storeModel.shopCarItems) {
        if (model.isSelected) {
            [selectedArr addObject:model];
        }
    }
    storeModel.selectedItems = [NSArray arrayWithArray:selectedArr];
    storeModel.salesType = TNSalesTypeSingle;
    NSString *trackPrefixName;
    if ([storeModel.type isEqualToString:TNStoreTypeOverseasShopping]) {
        trackPrefixName = TNTrackEventPrefixNameOverseas;
    } else if ([storeModel.type isEqualToString:TNStoreTypePlatfromSelf]) {
        trackPrefixName = TNTrackEventPrefixNameFastConsume;
    } else {
        trackPrefixName = TNTrackEventPrefixNameOther;
    }
    [SATalkingData trackEvent:[trackPrefixName stringByAppendingString:@"购物车_点击结算"]];

    //商品结算埋点
    NSArray *skuIds = [storeModel.selectedItems mapObjectsUsingBlock:^id _Nonnull(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx) {
        return obj.goodsSkuId;
    }];
    [TNEventTrackingInstance trackEvent:@"cart_settle" properties:@{@"skuId": skuIds}];
    @HDWeakify(self);
    void (^callBack)(void) = ^{
        @HDStrongify(self);
        //刷新数据
        [self getNewData];
    };
    [SAWindowManager openUrl:[NSString stringWithFormat:@"SuperApp://TinhNow/OrderSubmit"]
              withParameters:@{@"shoppingCarStoreModel": storeModel, @"funnel": [trackPrefixName stringByAppendingString:@"购物车_"], @"callBack": callBack}];
}

#pragma mark -刷新section
- (void)reloadTableViewSectionWithSection:(NSInteger)section {
    if (section < self.shopCarDataCenter.singleShopCardataSource.count) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } else {
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}
#pragma mark -批量删除多个商品
- (void)onDeleteShopCarProducts {
    if (!HDIsArrayEmpty(self.shopCarDataCenter.singleShopCardataSource)) {
        __block NSMutableArray *items = [NSMutableArray array];
        [self.shopCarDataCenter.singleShopCardataSource enumerateObjectsUsingBlock:^(TNShoppingCarStoreModel *_Nonnull storeModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if (!HDIsArrayEmpty(storeModel.shopCarItems)) {
                [storeModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (obj.isSelected) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[@"itemDisplayNo"] = obj.itemDisplayNo;
                        dict[@"businessType"] = @"11";
                        dict[@"merchantDisplayNo"] = storeModel.storeShoppingCarDisplayNo;
                        [items addObject:dict];
                    }
                }];
            }
        }];

        if (!HDIsArrayEmpty(items)) {
            // 弹窗确认
            NSString *message = [NSString stringWithFormat:TNLocalizedString(@"VXqx9tll", @"确认将这%ld个商品删除？"), items.count];
            [NAT showAlertWithMessage:message confirmButtonTitle:TNLocalizedString(@"tn_delete", @"删除") confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                [self showloading];
                @HDWeakify(self);
                [self.shopCarDataCenter batchDeleteItemsFromShoppingCarWithItems:items salesType:TNSalesTypeSingle success:^{
                    @HDStrongify(self);
                    [self dismissLoading];
                    NSArray *skuids = [items mapObjectsUsingBlock:^id _Nonnull(NSDictionary *_Nonnull obj, NSUInteger idx) {
                        return obj[@"itemDisplayNo"];
                    }];
                    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:self.shopCarDataCenter.singleShopCardataSource];
                    [copyArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNShoppingCarStoreModel *_Nonnull storeModel, NSUInteger idx, BOOL *_Nonnull stop) {
                        if (!HDIsArrayEmpty(storeModel.shopCarItems)) {
                            NSMutableArray *tempShopCarItems = [NSMutableArray arrayWithArray:storeModel.shopCarItems];
                            [tempShopCarItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                if ([skuids containsObject:obj.itemDisplayNo]) {
                                    [tempShopCarItems removeObject:obj];
                                }
                            }];
                            storeModel.shopCarItems = tempShopCarItems;
                            if (HDIsArrayEmpty(storeModel.shopCarItems)) {
                                [copyArray removeObject:storeModel];
                            }
                        }
                    }];
                    self.shopCarDataCenter.singleShopCardataSource = copyArray;
                    [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self dismissLoading];
                }];
            } cancelButtonTitle:TNLocalizedString(@"tn_button_NoYet_title", @"取消") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];

        } else {
            [HDTips showWithText:TNLocalizedString(@"I80nN3yX", @"请选择商品")];
        }
    }
}
#pragma mark -删除商品
- (void)deleteProductWithItem:(TNShoppingCarItemModel *)item storeModel:(TNShoppingCarStoreModel *)storeModel indexPath:(NSIndexPath *)indexPath {
    // 弹窗确认
    //    [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"确认删除商品吗？") confirmButtonTitle:WMLocalizedString(@"cart_not_now", @"暂时不")
    //        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //            [alertView dismiss];
    //        }
    //        cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //            [alertView dismiss];
    //            if (storeModel.shopCarItems.count <= 1) {
    //                //删除整个店铺
    //                [self deleteStoreWithStoreModel:storeModel indexPath:indexPath];
    //            } else {
    //删除单个商品
    [self deleteSingleProductWithItem:item storeModel:storeModel indexPath:indexPath];
    //            }
    //        }];
}
//// 删除整个店铺
//- (void)deleteStoreWithStoreModel:(TNShoppingCarStoreModel *)storeModel indexPath:(NSIndexPath *)indexPath {
//    [self showloading];
//    @HDWeakify(self);
//    [self.shopCarDataCenter clearShoppingWithStoreDisplayNo:storeModel.storeShoppingCarDisplayNo
//        success:^{
//            @HDStrongify(self);
//            [self dismissLoading];
//            if ([self.shopCarDataCenter.singleShopCardataSource containsObject:storeModel]) {
//                [self.shopCarDataCenter.singleShopCardataSource removeObject:storeModel];
//                if (HDIsArrayEmpty(self.shopCarDataCenter.singleShopCardataSource)) {
//                    [self.tableView successGetNewDataWithNoMoreData:YES];
//                } else {
//                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//                }
//            }
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            @HDStrongify(self);
//            [self dismissLoading];
//        }];
//}
// 删除单个商品
- (void)deleteSingleProductWithItem:(TNShoppingCarItemModel *)item storeModel:(TNShoppingCarStoreModel *)storeModel indexPath:(NSIndexPath *)indexPath {
    [self showloading];
    @HDWeakify(self);
    [self.shopCarDataCenter deleteItemFromShoppingCarWithItem:item success:^{
        @HDStrongify(self);
        [self dismissLoading];
        //删除商品埋点
        [TNEventTrackingInstance trackEvent:@"cart_remove" properties:@{@"skuId": @[item.goodsSkuId]}];
        if ([storeModel.shopCarItems containsObject:item]) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:storeModel.shopCarItems];
            [tempArr removeObject:item];
            storeModel.shopCarItems = tempArr;
            //判断店铺下还有商品吗  没有商品 就把店铺数据删除
            if (HDIsArrayEmpty(storeModel.shopCarItems)) {
                if ([self.shopCarDataCenter.singleShopCardataSource containsObject:storeModel]) {
                    [self.shopCarDataCenter.singleShopCardataSource removeObject:storeModel];
                    if (HDIsArrayEmpty(self.shopCarDataCenter.singleShopCardataSource)) {
                        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                        });
                    }
                }
            } else {
                [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            }
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark -增加单个商品的数量
- (void)plusProductCountWithItem:(TNShoppingCarItemModel *)item addDelta:(NSInteger)addDelta indexPath:(NSIndexPath *)indexPath {
    [self showloading];
    @HDWeakify(self);
    [self.shopCarDataCenter increaseItemQuantityWithItem:item quantity:[NSNumber numberWithInteger:addDelta] salesType:TNSalesTypeSingle success:^{
        @HDStrongify(self);
        [self dismissLoading];
        item.quantity = [NSNumber numberWithInteger:(item.quantity.integerValue + addDelta)];
        [self reloadTableViewSectionWithSection:indexPath.section];
        //增加商品个数埋点
        [TNEventTrackingInstance trackEvent:@"cart_add_num" properties:@{@"skuId": item.goodsSkuId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        //失败刷新回原来的显示
        [self reloadTableViewSectionWithSection:indexPath.section];
    }];
}

#pragma mark -减少单个商品的数量
- (void)minusProductCountWithItem:(TNShoppingCarItemModel *)item decreaseDelta:(NSInteger)decreaseDelta indexPath:(NSIndexPath *)indexPath {
    [self showloading];
    @HDWeakify(self);
    [self.shopCarDataCenter decreaseItemQuantityWithItem:item quantity:[NSNumber numberWithInteger:decreaseDelta] salesType:TNSalesTypeSingle success:^{
        @HDStrongify(self);
        [self dismissLoading];
        item.quantity = [NSNumber numberWithInteger:(item.quantity.integerValue - decreaseDelta)];
        [self reloadTableViewSectionWithSection:indexPath.section];
        //减少商品个数埋点
        [TNEventTrackingInstance trackEvent:@"cart_minus_num" properties:@{@"skuId": item.goodsSkuId}];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        //失败刷新回原来的显示
        [self reloadTableViewSectionWithSection:indexPath.section];
    }];
}

#pragma mark -选中店铺全选
- (void)selectedStoreAllProductsWithStoreModel:(TNShoppingCarStoreModel *)storeModel section:(NSInteger)section {
    storeModel.isSelected = storeModel.tempSelected;
    [storeModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.goodsState == TNStoreItemStateOnSale && obj.availableStock.integerValue >= obj.quantity.integerValue) {
            obj.isSelected = storeModel.isSelected;
        }
    }];
    [self reloadTableViewSectionWithSection:section];
}
#pragma mark -选择单个商品
- (void)selectedProductWithItem:(TNShoppingCarItemModel *)item storeModel:(TNShoppingCarStoreModel *)storeModel indexPath:(NSIndexPath *)indexPath {
    __block BOOL allSelected = YES;
    [storeModel.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.isSelected) {
            allSelected = NO;
            *stop = YES;
        }
    }];
    storeModel.isSelected = allSelected;
    [self reloadTableViewSectionWithSection:indexPath.section];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shopCarDataCenter.singleShopCardataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[section];
    return storeModel.shopCarItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[indexPath.section];
    TNShoppingCarItemModel *itemModel = storeModel.shopCarItems[indexPath.row];
    TNSingleShopCarProductCell *cell = [TNSingleShopCarProductCell cellWithTableView:tableView];
    cell.model = itemModel;
    @HDWeakify(self);
    cell.clickedPlusBTNBlock = ^(NSUInteger addDelta, NSUInteger forwardCount) {
        @HDStrongify(self);
        [self plusProductCountWithItem:itemModel addDelta:addDelta indexPath:indexPath];
    };
    cell.clickedMinusBTNBlock = ^(NSUInteger deleteDelta, NSUInteger currentCount) {
        @HDStrongify(self);
        [self minusProductCountWithItem:itemModel decreaseDelta:deleteDelta indexPath:indexPath];
    };
    cell.maxCountLimtedHandler = ^(NSUInteger count) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
    };
    cell.clickedSelectBTNBlock = ^(BOOL isSelected, TNShoppingCarItemModel *_Nonnull productModel) {
        @HDStrongify(self);
        [self selectedProductWithItem:productModel storeModel:storeModel indexPath:indexPath];
    };
    cell.clickedDeleteBTNBlock = ^{
        @HDStrongify(self);
        [self deleteProductWithItem:itemModel storeModel:storeModel indexPath:indexPath];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNShopCarHeaderView *headerView = [TNShopCarHeaderView headerWithTableView:tableView];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[section];
    headerView.model = storeModel;
    @HDWeakify(self);
    headerView.clickAllSelectedStoreProductCallBack = ^{
        @HDStrongify(self);
        [self selectedStoreAllProductsWithStoreModel:storeModel section:section];
    };
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TNShopCarFooterView *footerView = [TNShopCarFooterView headerWithTableView:tableView];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[section];
    footerView.calculateAmount = storeModel.singleCalcTotalPayPriceStr;
    @HDWeakify(self);
    footerView.clickToSubmitOrderCallback = ^{
        @HDStrongify(self);
        [self settlementToSubmitOrderWithStoreModel:storeModel];
    };
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealWidth(60);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealWidth(60);
}
#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell hd_endSkeletonAnimation];
//    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
//    if (height) return height.doubleValue;
//    return UITableViewAutomaticDimension;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[indexPath.section];
    TNShoppingCarItemModel *itemModel = storeModel.shopCarItems[indexPath.row];
    @HDWeakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:TNLocalizedString(@"tn_delete", @"删除")
                                                                          handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
                                                                              @HDStrongify(self);
                                                                              [self deleteProductWithItem:itemModel storeModel:storeModel indexPath:indexPath];
                                                                          }];

    return @[deleteAction];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TNShoppingCarStoreModel *storeModel = self.shopCarDataCenter.singleShopCardataSource[indexPath.section];
    TNShoppingCarItemModel *itemModel = storeModel.shopCarItems[indexPath.row];
    if (itemModel.goodsState == TNStoreItemStateOnSale) {
        //在售的才可以跳转
        [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": itemModel.goodsId, @"sp": itemModel.sp}];
    }
}
#pragma mark - lazy load
- (TNGestureTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TNGestureTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = NO;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self getNewData];
        };

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.image = @"no_data_placeholder";
        model.title = WMLocalizedString(@"cart_empty", @"购物车为空");
        _tableView.placeholderViewModel = model;

        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, kRealWidth(30))];
    }
    return _tableView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNShoppingCartTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNShoppingCartTableViewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
- (void)listWillAppear {
    //每次进来刷新购物车
    [self getNewData];
}

@end
