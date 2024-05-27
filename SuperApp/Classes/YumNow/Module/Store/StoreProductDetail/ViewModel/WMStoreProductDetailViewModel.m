//
//  WMStoreProductDetailViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailViewModel.h"
#import "SANoDataCellModel.h"
#import "SATableViewViewMoreViewModel.h"
#import "WMCustomViewActionView.h"
#import "WMGetUserShoppingCartRspModel.h"
#import "WMProductReviewListRspModel.h"
#import "WMReviewsDTO.h"
#import "WMShoppingCartPayFeeCalItem.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMStoreDetailAdaptor.h"
#import "WMStoreDetailDTO.h"
#import "WMStoreProductDetailDTO.h"


@interface WMStoreProductDetailViewModel ()
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 详情模型
@property (nonatomic, strong) WMStoreProductDetailRspModel *productDetailRspModel;
/// 门店详情信息
@property (nonatomic, strong) WMStoreDetailRspModel *storeDetailInfoModel;
/// 评论列表返回
@property (nonatomic, strong) WMProductReviewListRspModel *productReviewListRspModel;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 头部 Section
@property (nonatomic, strong) HDTableViewSectionModel *headerSection;
/// 评论 Section
@property (nonatomic, strong) HDTableViewSectionModel *listSection;
/// 查看更多/骨架时不需要，单独分组
@property (nonatomic, strong) HDTableViewSectionModel *viewMoreSectionModel;
/// 门店购物车 DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 门店详情 DTO
@property (nonatomic, strong) WMStoreDetailDTO *storeDetailDTO;
/// 商品详情 DTO
@property (nonatomic, strong) WMStoreProductDetailDTO *productDetailDTO;
/// 评论 DTO
@property (nonatomic, strong) WMReviewsDTO *reviewDTO;
/// 刷新标志
@property (nonatomic, assign) BOOL refreshFlag;
/// 试算模型
@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// 该店在购物车中的购物项
@property (nonatomic, strong) WMShoppingCartStoreItem *shopppingCartStoreItem;
/// 是否已经进行过初始数据加载进行订单试算的操作
@property (nonatomic, assign) BOOL hasInitializedOrderPayTrialCalculate;
/// 当前起送价
@property (nonatomic, strong) SAMoneyModel *requiredPrice;
@end


@implementation WMStoreProductDetailViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = @[self.headerSection, self.listSection, self.viewMoreSectionModel];
    }
    return self;
}

- (void)getInitializedData {
    @HDWeakify(self);
    dispatch_group_enter(self.taskGroup);
    [self.storeDetailDTO getStoreDetailInfoWithStoreNo:self.storeNo success:^(WMStoreDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.storeDetailInfoModel = rspModel;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self getStoreProductDetailInfoSuccess:^(WMStoreProductDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    // 获取购物车项
    dispatch_group_enter(self.taskGroup);
    [self.storeShoppingCartDTO queryStoreShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeNo success:^(WMShoppingCartStoreItem *_Nonnull rspModel) {
        @HDStrongify(self);
        self.shopppingCartStoreItem = rspModel;
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.taskGroup ?: dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        HDLog(@"“商品详情”页面初始化所需数据获取完成，刷新界面");
        @HDStrongify(self);
        // 异步处理数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool {
                WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;
                if (!self.hasInitializedOrderPayTrialCalculate && storeItem) {
                    self.shopppingCartStoreItem = storeItem;
                    // 有购物车项，订单试算
                    [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
                    self.hasInitializedOrderPayTrialCalculate = true;
                }

                NSArray<WMShoppingCartStoreProduct *> *productList = [WMStoreDetailAdaptor shoppingCardStoreProductListInStoreItem:storeItem goodsId:self.goodsId];
                self.productDetailRspModel.skuCountModelList =
                    [productList mapObjectsUsingBlock:^WMStoreGoodsSkuCountModel *_Nonnull(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger idx) {
                        WMStoreGoodsSkuCountModel *skuCountModel = WMStoreGoodsSkuCountModel.new;
                        skuCountModel.skuId = productModel.goodsSkuId;
                        skuCountModel.countInCart = productModel.purchaseQuantity;
                        return skuCountModel;
                    }];
                // 设置门店状态到商品模型
                self.productDetailRspModel.storeStatus = self.storeDetailInfoModel.storeStatus;
                if (!HDIsObjectNil(self.productDetailRspModel)) {
                    self.headerSection.list = @[self.productDetailRspModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hasGotInitializedData = true;
                [self getStoreProductReviewListSuccess:nil failure:nil];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.refreshFlag = !self.refreshFlag;
            });
        });
    });
}

- (void)getStoreProductDetailInfoSuccess:(void (^)(WMStoreProductDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.productDetailDTO getStoreProductDetailInfoWithGoodsId:self.goodsId success:^(WMStoreProductDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self.isBusinessDataError) {
            self.isBusinessDataError = false;
        }
        self.productDetailRspModel = rspModel;
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (errorType == CMResponseErrorTypeBusinessDataError) {
            self.isBusinessDataError = true;
        } else {
            self.isNetworkError = true;
        }
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)getStoreProductReviewListSuccess:(void (^)(WMProductReviewListRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.reviewDTO queryStoreProductReviewListWithGoodsId:self.goodsId type:WMReviewFilterTypeAll hasDetailCondition:WMReviewFilterConditionHasDetailOrNone pageSize:10 pageNum:1
        success:^(WMProductReviewListRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.productReviewListRspModel = rspModel;
            if (self.productReviewListRspModel.list.count > 0) {
                // 最多显示2个
                static NSUInteger maxCount = 2;
                if (self.productReviewListRspModel.list.count > maxCount) {
                    NSMutableArray<WMStoreProductReviewModel *> *totalList = [NSMutableArray arrayWithArray:self.productReviewListRspModel.list];
                    [totalList removeObjectsInRange:NSMakeRange(maxCount, totalList.count - maxCount)];

                    self.listSection.list = totalList;

                    // 查看更多
                    SATableViewViewMoreViewModel *viewMoreModel = SATableViewViewMoreViewModel.new;
                    viewMoreModel.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"see_all_reviews", @"查看全部评价"), self.productReviewListRspModel.total];
                    viewMoreModel.image = [[UIImage imageNamed:@"black_arrow"] hd_imageWithTintColor:HDAppTheme.WMColor.mainRed];
                    viewMoreModel.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:0.6];
                    viewMoreModel.borderWidth = PixelOne;
                    viewMoreModel.borderColor = HDAppTheme.color.G4;
                    viewMoreModel.textFont = HDAppTheme.font.standard2;
                    viewMoreModel.textColor = HDAppTheme.WMColor.mainRed;
                    self.viewMoreSectionModel.list = @[viewMoreModel];
                } else {
                    self.listSection.list = self.productReviewListRspModel.list;
                    self.viewMoreSectionModel.list = nil;
                }
            } else {
                SANoDataCellModel *cellModel = SANoDataCellModel.new;
                cellModel.descText = WMLocalizedString(@"no_reviews", @"暂无评论");
                cellModel.image = [UIImage imageNamed:@"placeholder_store_off"];
                self.listSection.list = @[cellModel];
                self.viewMoreSectionModel.list = nil;
            }
            !successBlock ?: successBlock(rspModel);
            self.refreshFlag = !self.refreshFlag;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !failureBlock ?: failureBlock(rspModel, errorType, error);
        }];
}

- (void)reGetShoppingCartItems {
    [self reGetShoppingCartItemsSuccess:nil failure:nil];
}

- (void)reGetShoppingCartItemsSuccess:(void (^)(WMShoppingCartStoreItem *storeItem))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    @HDWeakify(self);
    [self.storeShoppingCartDTO queryStoreShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.storeNo success:^(WMShoppingCartStoreItem *_Nonnull rspModel) {
        HDLog(@"重拿购物车数据成功");
        @HDStrongify(self);
        // 更新
        self.shopppingCartStoreItem = rspModel;
        // 回调
        !successBlock ?: successBlock(self.shopppingCartStoreItem);
        // 获取购物车成功，订单试算
        [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        HDLog(@"重拿购物车数据失败");
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)addShoppingGoodsWithAddDelta:(NSUInteger)addDelta
                             goodsId:(NSString *)goodsId
                          goodsSkuId:(NSString *)goodsSkuId
                         propertyIds:(NSArray<NSString *> *)propertyIds
                   inEffectVersionId:(NSString *)inEffectVersionId {
    @HDWeakify(self);
    [self.storeShoppingCartDTO addGoodsToShoppingCartWithClientType:SABusinessTypeYumNow addDelta:addDelta goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:self.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartAddGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"添加商品数量成功");
            @HDStrongify(self);
            [self reGetShoppingCartItems];
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
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
    @HDWeakify(self);
    [self.storeShoppingCartDTO updateGoodsCountInShoppingCartWithClientType:SABusinessTypeYumNow count:count goodsId:goodsId goodsSkuId:goodsSkuId propertyIds:propertyIds storeNo:self.storeNo
        inEffectVersionId:inEffectVersionId success:^(WMShoppingCartUpdateGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"更新商品数量成功");
            @HDStrongify(self);
            [self updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:rspModel];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"更新商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
        }];
}

/// 更新本地购物车的商品数量
- (void)updateLocalShoppingCartItemCountWithUpdateGoodsRspMode:(WMShoppingCartUpdateGoodsRspModel *)rspModel {
    if (HDIsObjectNil(rspModel)) {
        // 没有获取到需要更新的商品，重新请求购物车
        [self reGetShoppingCartItems];
        return;
    }

    NSArray<WMShoppingCartStoreProduct *> *filterArr = [self.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull item) {
        return [item.itemDisplayNo isEqualToString:rspModel.updateItem.itemDisplayNo];
    }];

    if (filterArr.count > 0) {
        // 当前购物车有
        if (rspModel.updateItem.purchaseQuantity > 0) {
            // 数量不为0 更新数量
            WMShoppingCartStoreProduct *tmp = filterArr.firstObject;
            tmp.purchaseQuantity = rspModel.updateItem.purchaseQuantity;
        } else {
            // 数量为0 删除当前购物车商品
            NSMutableArray<WMShoppingCartStoreProduct *> *tmpList = [[NSMutableArray alloc] initWithArray:self.shopppingCartStoreItem.goodsList];
            [tmpList removeObject:filterArr.firstObject];
            self.shopppingCartStoreItem.goodsList = [NSArray arrayWithArray:tmpList];
        }
    } else {
        // 当前购物车没有
        if (rspModel.updateItem.purchaseQuantity > 0) {
            // 插入
            [self reGetShoppingCartItems];
            return;
        } else {
            // 不处理
        }
    }
    // 重新试算
    [self payFeeTrialCalculateWithCalItem:nil success:nil failure:nil];
}

- (void)payFeeTrialCalculateWithCalItem:(NSArray<WMShoppingCartPayFeeCalItem *> *)items
                                success:(void (^)(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock {
    // 过滤不可用商品
    NSArray<WMShoppingCartStoreProduct *> *validProductList = [self.shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        return model.goodsState == WMGoodsStatusOn && model.availableStock > 0;
        //        return model.availableStock > 0;
    }];

    // 如果没有选中项，直接 return
    if (HDIsArrayEmpty(items)) {
        items = [validProductList mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx) {
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
    }

    // 如果 items 还是为 nil，说明没有购物项，清空了购物车
    if (HDIsArrayEmpty(items)) {
        WMShoppingItemsPayFeeTrialCalRspModel *rspModel = WMShoppingItemsPayFeeTrialCalRspModel.new;
        self.payFeeTrialCalRspModel = rspModel;
        // 更新商品在购物车中信息显示和商品价格信息
        [self updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel];
        !successBlock ?: successBlock(rspModel);
        return;
    }

    @HDWeakify(self);
    [self.view showloading];
    [self.storeShoppingCartDTO orderPayFeeTrialCalculateWithItems:items success:^(WMShoppingItemsPayFeeTrialCalRspModel *_Nonnull rspModel) {
        HDLog(@"门店购物车订单试算成功");
        @HDStrongify(self);
        [self.view dismissLoading];
        self.payFeeTrialCalRspModel = rspModel;
        // 更新商品在购物车中信息显示和商品价格信息
        [self updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel];
        !successBlock ?: successBlock(rspModel);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        HDLog(@"门店购物车订单试算失败");
        @HDStrongify(self);
        [self.view dismissLoading];
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

#pragma mark - private methods
/// 根据最新购物车数据和试算数据更新数据源和商品价格信息
- (void)updateDataSourceWithLatestShoppingCardRspModelAndPayFeeTrialCalRspModel {
    if (HDIsArrayEmpty(self.headerSection.list))
        return;

    // 异步处理数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            WMShoppingCartStoreItem *storeItem = self.shopppingCartStoreItem;

            // 如果是选中的（试算里面只会有选中的商品信息），从试算数据中获取最新商品价格更新本地显示
            for (WMShoppingCartPayFeeCalProductModel *feeCalProductModel in self.payFeeTrialCalRspModel.products) {
                if ([feeCalProductModel.productId isEqualToString:self.productDetailRspModel.goodId]) {
                    // 找到商品之后再查找相同规格 id 的
                    for (WMStoreGoodsProductSpecification *specificationModel in self.productDetailRspModel.specificationList) {
                        if ([specificationModel.specificationId isEqualToString:feeCalProductModel.specId]) {
                            self.productDetailRspModel.inEffectVersionId = feeCalProductModel.inEffectVersionId;
                        }
                    }
                }
            }

            NSArray<WMShoppingCartStoreProduct *> *productList = [WMStoreDetailAdaptor shoppingCardStoreProductListInStoreItem:storeItem goodsId:self.goodsId];
            self.productDetailRspModel.skuCountModelList = [productList mapObjectsUsingBlock:^WMStoreGoodsSkuCountModel *_Nonnull(WMShoppingCartStoreProduct *_Nonnull productModel, NSUInteger idx) {
                WMStoreGoodsSkuCountModel *skuCountModel = WMStoreGoodsSkuCountModel.new;
                skuCountModel.skuId = productModel.goodsSkuId;
                skuCountModel.countInCart = productModel.purchaseQuantity;
                return skuCountModel;
            }];
            if (!HDIsObjectNil(self.productDetailRspModel)) {
                self.headerSection.list = @[self.productDetailRspModel];

                dispatch_async(dispatch_get_main_queue(), ^{
                    !self.refreshProductShoppingInfoBlock ?: self.refreshProductShoppingInfoBlock();
                });
            }
        }
    });
}

// 加购物车异常处理
- (void)addToCartFailureWithRspModel:(SARspModel *)rspModel {
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
        [self reGetShoppingCartItems];
        showAlert(rspModel.msg, nil, nil, nil);
    } else if ([rspModel.code isEqualToString:@"ME1003"] || // 查询购物项详细信息出现异常
               [rspModel.code isEqualToString:@"ME1005"] || // 商品状态为空异常
               [rspModel.code isEqualToString:@"ME3005"]) { // 订单中的商品都卖光啦，再看看其他商品吧.
        showAlert(rspModel.msg, nil, nil, ^{
            [self getInitializedData];
        });
    } else if ([rspModel.code isEqualToString:@"ME3008"]) { // 购物车已满
        [self reGetShoppingCartItems];
        showAlert(WMLocalizedString(@"wm_shopcar_full_clear_title", @"购物车已满，请及时清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_confirm_clear", @"去清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想"),
                  ^{
                      [HDMediator.sharedInstance navigaveToShoppingCartViewController:@{@"willDelete": @(YES)}];
                  });
    } else {
        [self reGetShoppingCartItems];
        showAlert(rspModel.msg, nil, nil, nil);
    }
}
// 更新起送价
- (void)updateRequiredPrice {
    BOOL diff = (self.storeDetailInfoModel.minOrderAmount.cent.intValue != self.storeDetailInfoModel.oldMinOrderAmount.cent.intValue);
    self.requiredDiffStr = diff ? self.storeDetailInfoModel.priceRemark.desc : nil;
    SAMoneyModel *requiredPrice = self.storeDetailInfoModel.minOrderAmount.copy;
    for (WMStoreDetailPromotionModel *promotion in self.payFeeTrialCalRspModel.promotions) {
        if (promotion.requiredPrice.cent.integerValue > requiredPrice.cent.integerValue) {
            requiredPrice = promotion.requiredPrice.copy;
        }
    }
    self.requiredPrice = requiredPrice;
}

#pragma mark - setter
- (void)setStoreDetailInfoModel:(WMStoreDetailRspModel *)storeDetailInfoModel {
    _storeDetailInfoModel = storeDetailInfoModel;
    [self updateRequiredPrice];
}

- (void)setPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    _payFeeTrialCalRspModel = payFeeTrialCalRspModel;
    [self updateRequiredPrice];
}

#pragma mark - lazy load
- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

- (HDTableViewSectionModel *)headerSection {
    if (!_headerSection) {
        _headerSection = HDTableViewSectionModel.new;
    }
    return _headerSection;
}

- (HDTableViewSectionModel *)listSection {
    if (!_listSection) {
        _listSection = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"product_reviews", @"商品评价");
        _listSection.headerModel = headerModel;
    }
    return _listSection;
}

/** 查看更多 */
- (HDTableViewSectionModel *)viewMoreSectionModel {
    if (!_viewMoreSectionModel) {
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        _viewMoreSectionModel = HDTableViewSectionModel.new;
        _viewMoreSectionModel.headerModel = headerModel;
    }
    return _viewMoreSectionModel;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (WMStoreProductDetailDTO *)productDetailDTO {
    if (!_productDetailDTO) {
        _productDetailDTO = WMStoreProductDetailDTO.new;
    }
    return _productDetailDTO;
}

- (WMReviewsDTO *)reviewDTO {
    if (!_reviewDTO) {
        _reviewDTO = WMReviewsDTO.new;
    }
    return _reviewDTO;
}

- (WMStoreDetailDTO *)storeDetailDTO {
    if (!_storeDetailDTO) {
        _storeDetailDTO = WMStoreDetailDTO.new;
    }
    return _storeDetailDTO;
}
@end
