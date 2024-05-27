//
//  WMStoreShoppingCartViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreShoppingCartViewController.h"
#import "HDPopViewManager.h"
#import "SAInfoView.h"
#import "SATableView.h"
#import "SAViewController.h"
#import "WMCustomViewActionView.h"
#import "WMPromotionLabel.h"
#import "WMShoppingCartAddGoodsRspModel.h"
#import "WMShoppingCartMinusGoodsRspModel.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartUpdateGoodsRspModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMStoreShoppingCartDTO.h"
#import "WMStoreShoppingCartProductCell.h"
#import "WMStoreShoppingCartPromotionInfoView.h"

static CGFloat const kMarginTitle2Container = 15;
static CGFloat const kMarginTitle2Line = 10;
static CGFloat const kMarginTitleLine2TableView = 5;
#define kPromotionInfoHeight kRealWidth(30)


@interface WMStoreShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>
/// 阴影
@property (nonatomic, strong) UIView *shadowView;
/// 容器
@property (nonatomic, strong) UIView *containerView;
/// 容器背景，解决高度变矮时穿透
@property (nonatomic, strong) UIView *containerBackgroundView;
/// 优惠信息
@property (nonatomic, strong) WMStoreShoppingCartPromotionInfoView *promotionInfo;
/// 是否可以展开
@property (nonatomic, assign) BOOL canExpand;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 清除按钮
@property (nonatomic, strong) HDUIButton *clearBTN;
/// 标题底部分割线
@property (nonatomic, strong) UIView *titleBottomLine;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 打包费
@property (nonatomic, strong) SAInfoView *packingFeeView;
/// 底部留空距离
@property (nonatomic, assign) CGFloat bottomMargin;
/// 数据源
@property (nonatomic, copy) NSArray<WMShoppingCartStoreProduct *> *dataSource;
/// 购物车数据
@property (nonatomic, strong) WMShoppingCartStoreItem *shopppingCartStoreItem;
/// 试算数据
@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *payFeeTrialCalRspModel;
/// DTO
@property (nonatomic, strong) WMStoreShoppingCartDTO *storeShoppingCartDTO;
/// 记录总数
@property (nonatomic, assign) NSUInteger totalGoodsCount;
@end


@implementation WMStoreShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.containerBackgroundView];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.promotionInfo];
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.clearBTN];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.titleBottomLine];

    self.canExpand = true;

    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
    self.containerBackgroundView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)updateViewConstraints {
    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)updateContainerSubViewsConstraintsShouldUpdateTableView:(BOOL)shouldUpdateTableView layoutImmediately:(BOOL)layoutImmediately {
    [self.promotionInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionInfo.isHidden) {
            make.left.right.top.equalTo(self.containerView);
            make.height.mas_equalTo(kPromotionInfoHeight);
        }
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.promotionInfo.isHidden) {
            make.top.equalTo(self.containerView).offset(kMarginTitle2Container);
        } else {
            make.top.equalTo(self.promotionInfo.mas_bottom).offset(kMarginTitle2Container);
        }
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.clearBTN.mas_left).offset(-kRealWidth(5));
    }];
    [self.clearBTN sizeToFit];
    [self.clearBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.clearBTN.bounds.size);
        make.right.equalTo(self.containerView).offset(-kRealWidth(5));
        make.centerY.equalTo(self.titleLB);
    }];
    [self.titleBottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kMarginTitle2Line);
        make.height.mas_equalTo(PixelOne);
    }];
    if (shouldUpdateTableView) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleBottomLine.mas_bottom).offset(kMarginTitleLine2TableView);
            make.left.right.equalTo(self.containerView);
            make.bottom.equalTo(self.containerView).offset(-self.bottomMargin);
        }];
    }
    if (layoutImmediately) {
        for (UIView *subView in self.containerView.subviews) {
            [subView setNeedsLayout];
            [subView layoutIfNeeded];
        }
    }
}

- (void)updateContainerFrameIsInitialLayout:(BOOL)isInitialLayout {
    // 最小高度
    [self.titleLB sizeToFit];
    CGFloat minContainerHeight = self.titleLB.height + kMarginTitle2Container + self.bottomMargin + kMarginTitleLine2TableView;

    if (!self.promotionInfo.isHidden) {
        minContainerHeight += kPromotionInfoHeight;
    }

    if (!self.packingFeeView.isHidden) {
        self.packingFeeView.height = 50;
    } else {
        self.packingFeeView.height = 0;
    }

    [self.tableView successGetNewDataWithNoMoreData:true];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    CGFloat containerHeight = tableViewContentHeight + minContainerHeight + kMarginTitleLine2TableView;

    // 最大屏幕 80%
    if (containerHeight > kScreenHeight * 0.8) {
        containerHeight = kScreenHeight * 0.8;
    }

    // 不能小于最大高度
    if (containerHeight < minContainerHeight) {
        containerHeight = minContainerHeight;
    }

    self.view.hidden = false;
    if (isInitialLayout) {
        self.containerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, containerHeight);
        self.containerBackgroundView.frame = self.containerView.frame;
    } else {
        self.containerBackgroundView.frame = CGRectMake(0, kScreenHeight - containerHeight, kScreenWidth, containerHeight);
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.frame = CGRectMake(0, kScreenHeight - containerHeight, kScreenWidth, containerHeight);
        }];
    }

    // 重新布局
    [self updateContainerSubViewsConstraintsShouldUpdateTableView:true layoutImmediately:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMShoppingCartStoreProduct.class]) {
        WMStoreShoppingCartProductCell *cell = [WMStoreShoppingCartProductCell cellWithTableView:tableView];
        WMShoppingCartStoreProduct *trueModel = (WMShoppingCartStoreProduct *)model;
        trueModel.needShowBottomLine = true;
        @HDWeakify(self);
        @HDWeakify(cell);
        cell.goodsCountShouldChangeBlock = ^BOOL(WMShoppingCartStoreProduct *_Nonnull productModel, BOOL isIncrease, NSUInteger count) {
            @HDStrongify(self);
            NSUInteger otherSkuCount = [self goodsCountInShoppingCartWithGoodsId:productModel];
            if (otherSkuCount + count > productModel.availableStock && isIncrease) {
                [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), productModel.availableStock] type:HDTopToastTypeWarning];
                return NO;
            }
            return YES;
        };
        cell.goodsCountChangedBlock = ^(WMShoppingCartStoreProduct *_Nonnull productModel, BOOL isIncrease, NSUInteger count) {
            @HDStrongify(self);
            @HDStrongify(cell);
            if (isIncrease) {
                WMManage.shareInstance.selectGoodId = productModel.goodsId;
                [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:productModel.productPromotion currentCount:count
                                                                      otherSkuCount:[self goodsCountInShoppingCartWithGoodsId:productModel]];
                if (productModel.bestSale) {
                    [WMPromotionLabel showToastWithMaxCount:self.shopppingCartStoreItem.availableBestSaleCount currentCount:count
                                              otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:productModel]
                                                 promotions:self.payFeeTrialCalRspModel.promotions];
                }
            }
            [self updateGoodsCountForCell:cell productModel:productModel count:count];
        };
        cell.clickedMinusBTNBlock = ^{
            @HDStrongify(self);
            !self.storeCartMinusGoodsBlock ?: self.storeCartMinusGoodsBlock();
        };
        // 赋值 model 写在最后，不要改变位置
        cell.model = trueModel;
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - Data

- (void)updateGoodsCountForCell:(WMStoreShoppingCartProductCell *)cell productModel:(WMShoppingCartStoreProduct *)productModel count:(NSUInteger)count {
    @HDWeakify(self);
    [self.storeShoppingCartDTO updateGoodsCountInShoppingCartWithClientType:SABusinessTypeYumNow count:count goodsId:productModel.goodsId goodsSkuId:productModel.goodsSkuId
        propertyIds:[productModel.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
            return obj.propertyId;
        }]
        storeNo:self.shopppingCartStoreItem.storeNo
        inEffectVersionId:productModel.inEffectVersionId success:^(WMShoppingCartUpdateGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"更新单个商品数量成功");
            @HDStrongify(self);
            [self invokeStoreCartGoodsDidChangedBlock];
            // 订单金额试算
            productModel.totalDiscountAmount = rspModel.updateItem.totalDiscountAmount;
            productModel.purchaseQuantity = rspModel.updateItem.purchaseQuantity;
            [self updateTitleText];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            HDLog(@"更新单个商品数量失败");
            @HDStrongify(self);
            [self addToCartFailureWithRspModel:rspModel];
        }];
}

/// 删除门店购物项
- (void)deleteStoreGoods {
    @HDWeakify(self);
    [self.storeShoppingCartDTO removeStoreGoodsFromShoppingCartWithClientType:SABusinessTypeYumNow storeNo:self.shopppingCartStoreItem.storeNo
        success:^(WMShoppingCartRemoveStoreGoodsRspModel *_Nonnull rspModel) {
            HDLog(@"删除整个门店商品成功");
            @HDStrongify(self);
            [self invokeStoreCartGoodsDidChangedBlock];
            [self dismiss];
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            HDLog(@"删除整个门店商品失败");
        }];
}

#pragma mark - public methods
- (void)showWithBottomMargin:(CGFloat)bottomMargin
      shopppingCartStoreItem:(WMShoppingCartStoreItem *)shopppingCartStoreItem
      payFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    // 过滤下架和售罄的商品
    NSArray<WMShoppingCartStoreProduct *> *validGoodsList = [shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        return model.goodsState == WMGoodsStatusOn && model.availableStock > 0;
        //        return model.availableStock > 0;
    }];

    // 购物项为空，不展示
    if (HDIsArrayEmpty(validGoodsList))
        return;

    self.canExpand = false;

    self.bottomMargin = bottomMargin;

    [self updateUIWithShopppingCartStoreItem:shopppingCartStoreItem payFeeTrialCalRspModel:payFeeTrialCalRspModel shouldUpdateContainerFrame:false];

    // 随便给个高度让布局正常
    self.containerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, bottomMargin + 100);
    [self updateContainerSubViewsConstraintsShouldUpdateTableView:false layoutImmediately:true];

    // 计算容器大小
    [self updateContainerFrameIsInitialLayout:true];

    self.shadowView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 1;
        self.containerView.top = kScreenHeight - CGRectGetHeight(self.containerView.frame);
    }];
}

- (void)dismiss {
    !self.willDissmissHandler ?: self.willDissmissHandler();
    self.canExpand = true;
    self.containerView.top = kScreenHeight - CGRectGetHeight(self.containerView.frame);
    self.containerBackgroundView.top = self.containerView.top;
    self.shadowView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0;
        self.containerView.top = kScreenHeight;
        self.containerBackgroundView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
        self.dataSource = nil;
        self.shopppingCartStoreItem = nil;
    }];
}

- (void)updateUIWithShopppingCartStoreItem:(WMShoppingCartStoreItem *)shopppingCartStoreItem payFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel {
    [self updateUIWithShopppingCartStoreItem:shopppingCartStoreItem payFeeTrialCalRspModel:payFeeTrialCalRspModel shouldUpdateContainerFrame:true];
}

#pragma mark - event response
- (void)clickedShadowViewHandler {
    [self dismiss];
}

- (void)clickedClearAllBTNHandler {
    [self deleteStoreGoods];
}

#pragma mark - private methods
- (void)updateUIWithShopppingCartStoreItem:(WMShoppingCartStoreItem *)shopppingCartStoreItem
                    payFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel
                shouldUpdateContainerFrame:(BOOL)shouldUpdateContainerFrame {
    // 更新优惠信息
    [self.promotionInfo updateUIWithPayFeeTrialCalRspModel:payFeeTrialCalRspModel isStoreResting:[shopppingCartStoreItem.merchantStoreStatus isEqualToString:WMStoreStatusResting]];

    // 过滤下架和售罄的商品
    NSArray<WMShoppingCartStoreProduct *> *validGoodsList = [shopppingCartStoreItem.goodsList hd_filterWithBlock:^BOOL(WMShoppingCartStoreProduct *_Nonnull model) {
        // 商品再售+ 商品下架但是列表存在 + 库存>0
        return (model.goodsState == WMGoodsStatusOn || [self checkShoppingCartItemExistWithItemModel:model]) && model.availableStock > 0;
        //                return model.availableStock > 0;
    }];
    if (HDIsArrayEmpty(validGoodsList)) {
        [self dismiss];
        return;
    }

    self.totalGoodsCount = 0;
    for (WMShoppingCartStoreProduct *product in validGoodsList) {
        // 设置门店状态
        product.storeStatus = shopppingCartStoreItem.merchantStoreStatus;
        self.totalGoodsCount += product.purchaseQuantity;
    }
    self.shopppingCartStoreItem = shopppingCartStoreItem;
    self.payFeeTrialCalRspModel = payFeeTrialCalRspModel;

    // 如果数据源已经有该数据，就只更新数量，否则增加在最后面，因为后台返回的商品的顺序会变化
    if (!HDIsArrayEmpty(self.dataSource)) {
        NSMutableArray<WMShoppingCartStoreProduct *> *existedItemList = [NSMutableArray arrayWithCapacity:3];
        for (WMShoppingCartStoreProduct *oldProduct in self.dataSource) {
            for (WMShoppingCartStoreProduct *newProduct in validGoodsList) {
                if ([newProduct.identifyObj isEqual:oldProduct.identifyObj]) {
                    oldProduct.purchaseQuantity = newProduct.purchaseQuantity;
                    oldProduct.totalDiscountAmount = newProduct.totalDiscountAmount;
                    [existedItemList addObject:oldProduct];
                }
            }
        }
        // 新增的
        NSMutableArray<WMShoppingCartStoreProduct *> *newItemList = validGoodsList.mutableCopy;
        for (WMShoppingCartStoreProduct *newProduct in validGoodsList) {
            for (WMShoppingCartStoreProduct *existedProduct in existedItemList) {
                if ([newProduct.identifyObj isEqual:existedProduct.identifyObj]) {
                    [newItemList removeObject:newProduct];
                }
            }
        }

        NSMutableArray *mutableDataSource = [NSMutableArray array];
        if (!HDIsArrayEmpty(existedItemList)) {
            [mutableDataSource addObjectsFromArray:existedItemList];
        }
        if (!HDIsArrayEmpty(newItemList)) {
            [mutableDataSource addObjectsFromArray:newItemList];
        }
        self.dataSource = mutableDataSource;
    } else {
        self.dataSource = validGoodsList;
    }

    [self updateTitleText];

    self.packingFeeView.hidden = payFeeTrialCalRspModel.packageFee.cent.doubleValue <= 0;
    if (!self.packingFeeView.isHidden) {
        self.packingFeeView.model.valueText = payFeeTrialCalRspModel.packageFee.thousandSeparatorAmount;
        [self.packingFeeView setNeedsUpdateContent];
    }

    if (shouldUpdateContainerFrame) {
        // 计算容器大小
        [self updateContainerFrameIsInitialLayout:false];
    }
}

// 判断当前数据源是否存在这个购物项
- (BOOL)checkShoppingCartItemExistWithItemModel:(WMShoppingCartStoreProduct *)productModel {
    BOOL exist = NO;
    for (WMShoppingCartStoreProduct *oldItem in self.dataSource) {
        if ([oldItem.identifyObj isEqual:productModel.identifyObj]) {
            exist = YES;
            break;
        }
    }
    return exist;
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.money;
    model.keyText = key;
    model.keyFont = HDAppTheme.font.standard3Bold;
    model.valueFont = HDAppTheme.font.standard3Bold;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(15));
    return model;
}

- (void)updateTitleText {
    NSUInteger itemCount = 0;
    for (WMShoppingCartStoreProduct *productModel in self.shopppingCartStoreItem.goodsList) {
        if (productModel.goodsState == WMGoodsStatusOn && productModel.availableStock > 0) {
            //        if (productModel.availableStock > 0) {
            itemCount += productModel.purchaseQuantity;
        }
    }

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr = [[NSAttributedString alloc] initWithString:WMLocalizedString(@"cart_title", @"购物车")
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    [text appendAttributedString:appendingStr];

    // 空格
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
    [text appendAttributedString:whiteSpace];

    appendingStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%zd)", itemCount]
                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.standard3Bold, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
    [text appendAttributedString:appendingStr];
    self.titleLB.attributedText = text;
}

/// 从数据源中某门店的商品数据以及刷新该 cell
- (void)reloadCellAfterRemovingProductModel:(WMShoppingCartStoreProduct *)productModel {
    if (HDIsArrayEmpty(self.dataSource)) {
        [self.tableView successGetNewDataWithNoMoreData:true];
        return;
    }

    // 从当前数据源中删除该 model
    NSInteger destProductIndex = -1;
    BOOL hasFound = false;
    NSMutableArray<WMShoppingCartStoreProduct *> *dataSourceCopyed = self.dataSource.mutableCopy;
    for (WMShoppingCartStoreProduct *product in self.dataSource) {
        if (product == productModel) {
            destProductIndex = [self.dataSource indexOfObject:product];
            [dataSourceCopyed removeObject:product];
            hasFound = true;
            break;
        }
    }

    // 由于是动画移除，数据源变化后再移除可能导致崩溃（如最后一个 cell）
    NSMutableArray<WMShoppingCartStoreItem *> *originDataSource = self.dataSource.mutableCopy;
    self.dataSource = dataSourceCopyed;

    if (destProductIndex != -1 && originDataSource.count > destProductIndex) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:destProductIndex inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateContainerFrameIsInitialLayout:false];
        if (HDIsArrayEmpty(self.dataSource)) {
            [self updateTitleText];
            [self dismiss];
        }
    }
}

- (void)invokeStoreCartGoodsDidChangedBlock {
    !self.storeCartGoodsDidChangedBlock ?: self.storeCartGoodsDidChangedBlock();
}

- (NSUInteger)goodsCountInShoppingCartWithGoodsId:(WMShoppingCartStoreProduct *)model {
    __block NSUInteger count = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.identifyObj.goodsId isEqual:model.goodsId] && ![obj.itemDisplayNo isEqualToString:model.itemDisplayNo]) {
            count += obj.purchaseQuantity;
        }
    }];
    return count;
}
// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMShoppingCartStoreProduct *)currentGoods {
    __block NSUInteger otherCount = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.bestSale && ![obj.identifyObj isEqual:currentGoods.identifyObj]) {
            otherCount += obj.purchaseQuantity;
        }
    }];
    return otherCount;
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
        showAlert(rspModel.msg, nil, nil, nil);
    } else if ([rspModel.code isEqualToString:@"ME1003"] || // 查询购物项详细信息出现异常
               [rspModel.code isEqualToString:@"ME1005"] || // 商品状态为空异常
               [rspModel.code isEqualToString:@"ME3005"]) { // 订单中的商品都卖光啦，再看看其他商品吧.
        showAlert(rspModel.msg, nil, nil, ^{
            [self dismiss];
            !self.refreshDataBlock ?: self.refreshDataBlock();
        });
    } else if ([rspModel.code isEqualToString:@"ME3008"]) { // 购物车已满
        showAlert(WMLocalizedString(@"wm_shopcar_full_clear_title", @"购物车已满，请及时清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_confirm_clear", @"去清理"),
                  WMLocalizedString(@"wm_shopcar_full_clear_cancel_see", @"再想想"),
                  ^{
                      [HDMediator.sharedInstance navigaveToShoppingCartViewController:@{@"willDelete": @(YES)}];
                  });
    } else {
        showAlert(rspModel.msg, nil, nil, nil);
    }
}

#pragma mark - lazy load
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
        _shadowView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedShadowViewHandler)];
        [_shadowView addGestureRecognizer:recognizer];
    }
    return _shadowView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UIView *)containerBackgroundView {
    if (!_containerBackgroundView) {
        _containerBackgroundView = UIView.new;
        _containerBackgroundView.backgroundColor = UIColor.whiteColor;
    }
    return _containerBackgroundView;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = self.packingFeeView;
    }
    return _tableView;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:22];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"cart_title", @"购物车");
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)clearBTN {
    if (!_clearBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G3 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard4;
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 10);
        [button setTitle:WMLocalizedString(@"delete_all", @"删除全部") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedClearAllBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _clearBTN = button;
    }
    return _clearBTN;
}

- (SAInfoView *)packingFeeView {
    if (!_packingFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"packing_fee", @"包装费")];
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        view.model.lineWidth = 0;
        view.model.valueContentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(30), 0, 0);
        view.model.valueTextAlignment = NSTextAlignmentLeft;
        view.model.valueAlignmentToOther = NSTextAlignmentLeft;
        view.model.valueColor = HDAppTheme.color.money;
        @HDWeakify(self);
        view.model.clickedKeyButtonHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToProductPackingFeeViewController:@{@"productList": self.payFeeTrialCalRspModel.products, @"packingFee": self.payFeeTrialCalRspModel.packingFee}];
        };
        [view setNeedsUpdateContent];
        view.clipsToBounds = true;
        _packingFeeView = view;
    }
    return _packingFeeView;
}

- (UIView *)titleBottomLine {
    if (!_titleBottomLine) {
        _titleBottomLine = UIView.new;
        _titleBottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _titleBottomLine;
}

- (WMStoreShoppingCartDTO *)storeShoppingCartDTO {
    if (!_storeShoppingCartDTO) {
        _storeShoppingCartDTO = WMStoreShoppingCartDTO.new;
    }
    return _storeShoppingCartDTO;
}

- (WMStoreShoppingCartPromotionInfoView *)promotionInfo {
    if (!_promotionInfo) {
        _promotionInfo = WMStoreShoppingCartPromotionInfoView.new;
    }
    return _promotionInfo;
}
@end
