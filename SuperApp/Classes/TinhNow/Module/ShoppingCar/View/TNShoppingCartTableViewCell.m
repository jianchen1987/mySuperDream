//
//  WMShoppingCartTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCartTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDPopViewManager.h"
#import "SAInfoView.h"
#import "SAMoneyTools.h"
#import "SAOperationButton.h"
#import "SAShadowBackgroundView.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNGestureTableView.h"
#import "TNShooingCartItemCell.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNShoppingCartProductView.h"


@interface TNShoppingCartTableViewCell () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// 门店icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 门店名称
@property (nonatomic, strong) SALabel *titleLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;
/// 分割线
@property (nonatomic, strong) UIView *sepLine1;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
/// 操作按钮
@property (nonatomic, strong) SAOperationButton *operationBTN;
/// 获取选中项商品模型数组
@property (nonatomic, strong) NSMutableArray<TNShoppingCarItemModel *> *selectedProducts;
/// 购物车商品显示视图
@property (nonatomic, strong) UITableView *goodsTableView;
/// 电商店铺类型标签
@property (strong, nonatomic) HDUIButton *storeTypeTag;

@end


@implementation TNShoppingCartTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.selectBTN];
    [self.bgView addSubview:self.iconIV];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.arrowIV];
    [self.bgView addSubview:self.storeTypeTag];
    [self.bgView addSubview:self.sepLine1];
    [self.bgView addSubview:self.goodsTableView];
    [self.bgView addSubview:self.moneyLB];
    [self.bgView addSubview:self.operationBTN];

    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.storeTypeTag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame))
        return;

    [self.bgView setNeedsDisplay];
}

- (void)setModel:(TNShoppingCarStoreModel *)model {
    _model = model;
    [self.goodsTableView reloadData];
    self.selectBTN.selected = model.isSelected;
    self.titleLB.text = model.storeName;
    //电商店铺标签显示
    if ([model.type isEqualToString:TNStoreTypeOverseasShopping]) {
        self.storeTypeTag.hidden = NO;
        [self.storeTypeTag setTitle:TNStoreTagGlobal forState:UIControlStateNormal];
    } else {
        self.storeTypeTag.hidden = YES;
    }

    [self.selectedProducts removeAllObjects];
    for (TNShoppingCarItemModel *product in model.shopCarItems) {
        if (product.isSelected) {
            [self.selectedProducts addObject:product];
        } else {
            if ([self.selectedProducts containsObject:product]) {
                [self.selectedProducts removeObject:product];
            }
        }
    }
    //    BOOL operationBtnState = !HDIsArrayEmpty(self.selectedProducts) && model.calcTotalFeeTrialRspModel;
    //    BOOL operationBtnState = !HDIsArrayEmpty(self.selectedProducts);
    //
    //    self.operationBTN.userInteractionEnabled = operationBtnState;
    //
    //    if (operationBtnState) {
    //        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
    //        [self.operationBTN applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:1]];
    //        [self.operationBTN setTitle:WMLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
    //    } else {
    //        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
    //        [self.operationBTN applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:0.30]];
    //        [self.operationBTN setTitle:WMLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
    //    }
    // 设置金额
    //    self.moneyLB.hidden = !operationBtnState;
    /*
    if (!self.moneyLB.isHidden) {
        SAMoneyModel *totalMoney = model.calcTotalFeeTrialRspModel.amountPayable;
        [self updateTotalMoneyTextWithTotalMoney:totalMoney];
    }


    // setModel 之后调用一次以在界面初次加载后正确决定是否发起试算
    if (HDIsObjectNil(model.calcTotalFeeTrialRspModel)) {
        [self adjustShouldInvokeFeeTrialBlock];
    }
     */
    //更改为不调用试算接口 改为本地计算
    [self calculateAmount];

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (BOOL)isSelected {
    return self.model.isSelected;
}

- (NSArray<TNShoppingCarItemModel *> *)selectedProductList {
    return self.selectedProducts;
}

- (void)removeSelectedProductModelFromSelectedProductList:(TNShoppingCarItemModel *)productModel {
    [self.selectedProducts removeObject:productModel];
    if (self.model.shopCarItems.count <= 1) {
        !self.deletedLastProductBlock ?: self.deletedLastProductBlock(self.model.storeShoppingCarDisplayNo);
    }
}

#pragma mark - private methods
- (void)setSelectBtnSelected:(BOOL)selected {
    self.selectBTN.selected = selected;
    self.model.isSelected = selected;
}

- (void)adjustSelectBTNState {
    BOOL isAllItemSelected = true;
    for (TNShoppingCarItemModel *item in self.model.shopCarItems) {
        if (!item.isSelected) {
            isAllItemSelected = false;
            break;
        }
    }
    [self setSelectBtnSelected:isAllItemSelected];
}

/// 单个商品选中状态变化触发选中列表统计
/// @param isSelected 是否选中
/// @param productModel 单个的商品模型
- (void)statisticSelectedProductsListWithSingleItemSelected:(BOOL)isSelected model:(TNShoppingCarItemModel *)productModel {
    if (isSelected) {
        [self.selectedProducts addObject:productModel];
    } else {
        [self.selectedProducts removeObject:productModel];
    }
    [self calculateAmount];
    //    [self adjustShouldInvokeFeeTrialBlock];
}

- (void)updateTotalMoneyTextWithTotalMoney:(SAMoneyModel *)totalMoney {
    self.moneyLB.hidden = false;
    NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:TNLocalizedString(@"sub_total", @"总计")
                                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    if (HDIsStringNotEmpty(totalMoney.thousandSeparatorAmount)) {
        NSAttributedString *moneyStr = [[NSAttributedString alloc] initWithString:totalMoney.thousandSeparatorAmount
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.money}];
        [text appendAttributedString:moneyStr];
    }
    self.moneyLB.attributedText = text;
}

- (void)dealingWithProductViewBlock:(TNShoppingCartProductView *)productView {
    @HDWeakify(self);
    @HDWeakify(productView);
    productView.clickedDeleteBTNBlock = ^{
        @HDStrongify(self);
        @HDStrongify(productView);
        [self removeGoodHandle:productView.model];
    };
    productView.clickedPlusBTNBlock = ^(NSUInteger addDelta, NSUInteger forwardCount) {
        @HDStrongify(self);
        @HDStrongify(productView);
        !self.plusGoodsCountBlock ?: self.plusGoodsCountBlock(productView.model, addDelta);
    };
    productView.clickedMinusBTNBlock = ^(NSUInteger deleteDelta, NSUInteger currentCount) {
        @HDStrongify(self);
        @HDStrongify(productView);
        !self.minusGoodsCountBlock ?: self.minusGoodsCountBlock(productView.model, deleteDelta);
    };
    productView.maxCountLimtedHandler = ^(NSUInteger count) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
    };
    productView.clickedSelectBTNBlock = ^(BOOL isSelected, TNShoppingCarItemModel *_Nonnull productModel) {
        @HDStrongify(self);
        !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
        if (isSelected) {
            !self.selectedItemTrackEventBlock ?: self.selectedItemTrackEventBlock(productModel);
        }
        [self adjustSelectBTNState];
        [self statisticSelectedProductsListWithSingleItemSelected:isSelected model:productModel];
    };
    productView.clickedProductViewBlock = ^{
        @HDStrongify(self);
        @HDStrongify(productView);
        if (productView.model.goodsState == TNStoreItemStateOnSale) {
            !self.clickedProductViewBlock ?: self.clickedProductViewBlock(productView.model);
        }
    };
}
// 移除购物车商品
- (void)removeGoodHandle:(TNShoppingCarItemModel *)item {
    // 弹窗确认
    [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"确认删除商品吗？") confirmButtonTitle:WMLocalizedString(@"cart_not_now", @"暂时不")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }
        cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            if (self.model.shopCarItems.count <= 1) {
                !self.deleteStoreGoodsBlock ?: self.deleteStoreGoodsBlock(self.model.storeShoppingCarDisplayNo);
            } else {
                !self.deleteSingleGoodsBlock ?: self.deleteSingleGoodsBlock(item);
            }
        }];
}
- (void)adjustShouldInvokeFeeTrialBlock {
    if (HDIsArrayEmpty(self.selectedProducts)) {
        if (!HDIsObjectNil(self.model.calcTotalFeeTrialRspModel)) {
            self.model.calcTotalFeeTrialRspModel = nil;
            !self.reloadBlock ?: self.reloadBlock(self.model.storeNo);
        }
    } else {
        !self.anyProductSelectStateChangedHandler ?: self.anyProductSelectStateChangedHandler();
    }
}

- (void)calculateAmount {
    if (HDIsArrayEmpty(self.selectedProducts)) {
        self.moneyLB.hidden = YES;
        self.moneyLB.text = @"";
    } else {
        self.moneyLB.hidden = NO;

        __block NSInteger amount = 0;
        __block SACurrencyType cy;
        [self.selectedProducts enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            //取第一个item 的币种
            if (idx == 0) {
                cy = obj.salePrice.cy;
            }
            amount += (obj.salePrice.cent.integerValue * obj.quantity.integerValue);
        }];

        NSString *amountStr = [SAMoneyTools thousandSeparatorNoCurrencySymbolWithAmountYuan:[SAMoneyTools fenToyuan:[NSString stringWithFormat:@"%zd", amount]] currencyCode:cy];

        NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:TNLocalizedString(@"sub_total", @"总计")
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1}];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        if (HDIsStringNotEmpty(amountStr)) {
            NSAttributedString *moneyStr = [[NSAttributedString alloc] initWithString:amountStr
                                                                           attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.money}];
            [text appendAttributedString:moneyStr];
        }
        self.moneyLB.attributedText = text;
    }

    //更变结算按钮状态
    BOOL operationBtnState = !HDIsArrayEmpty(self.selectedProducts);

    self.operationBTN.userInteractionEnabled = operationBtnState;

    if (operationBtnState) {
        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
        [self.operationBTN applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:1]];
        [self.operationBTN setTitle:TNLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
    } else {
        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
        [self.operationBTN applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:0.30]];
        [self.operationBTN setTitle:TNLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
    }

    [self setNeedsUpdateConstraints];
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G3;
    model.valueColor = HDAppTheme.color.G1;
    model.keyText = key;
    return model;
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
    button.selected = !button.isSelected;
    self.model.isSelected = button.isSelected;
    self.selectBTN.selected = self.model.isSelected;

    if (button.selected) {
        for (TNShoppingCarItemModel *item in self.model.shopCarItems) {
            if (item.goodsState == TNStoreItemStateOnSale && ![item.availableStock isEqualToString:@"0"]) {
                item.isSelected = button.isSelected; //在售的才可以选中
            }
            if (item.isSelected) { //全选
                if (![self.selectedProducts containsObject:item]) {
                    [self.selectedProducts addObject:item];
                }
            }
        }
    } else {
        for (TNShoppingCarItemModel *item in self.model.shopCarItems) {
            item.isSelected = button.isSelected;
            if ([self.selectedProducts containsObject:item]) {
                [self.selectedProducts removeObject:item];
            }
        }
    }

    [self.goodsTableView reloadData];

    [self calculateAmount];
    //    [self adjustShouldInvokeFeeTrialBlock];
}

- (void)clickedOperationBTNHandler {
    if (!HDIsArrayEmpty(self.selectedProducts)) {
        !self.clickedOrderNowBTNBlock ?: self.clickedOrderNowBTNBlock();
    }
}

- (void)clickedStoreTitleHandler {
    !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
    !self.clickedStoreTitleBlock ?: self.clickedStoreTitleBlock(self.model.storeNo);
}

#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(5);
        make.top.equalTo(self.bgView).offset(10);
        make.size.mas_equalTo(self.selectBTN.bounds.size);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.centerY.equalTo(self.selectBTN);
        make.left.equalTo(self.selectBTN.mas_right).offset(5);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBTN);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowIV.image.size);
        make.centerY.equalTo(self.selectBTN);
        make.left.equalTo(self.titleLB.mas_right).offset(kRealWidth(5));
        if (self.storeTypeTag.isHidden) {
            make.right.lessThanOrEqualTo(self.bgView).offset(-kRealWidth(10));
        }
    }];
    if (!self.storeTypeTag.isHidden) {
        [self.storeTypeTag sizeToFit];
        [self.storeTypeTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectBTN);
            make.left.equalTo(self.arrowIV.mas_right).offset(kRealWidth(5));
            make.right.lessThanOrEqualTo(self.bgView).offset(-kRealWidth(10));
        }];
    }
    const CGFloat lineHeight = PixelOne;
    [self.sepLine1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(15));
    }];
    //    [self.goodsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.bgView);
    //        make.top.equalTo(self.sepLine1.mas_bottom);
    //        make.height.mas_equalTo(self.model.goodTableHeight);
    //    }];
    [self.operationBTN sizeToFit];
    [self.operationBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTableView.mas_bottom).offset(kRealWidth(13));
        make.right.equalTo(self.bgView).offset(-kRealWidth(10));
        make.bottom.equalTo(self.bgView).offset(-kRealWidth(15));
    }];
    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.moneyLB.isHidden) {
            make.left.equalTo(self.bgView).offset(kRealWidth(15));
            make.centerY.equalTo(self.operationBTN);
            make.right.lessThanOrEqualTo(self.operationBTN.mas_left).offset(-10.f);
        }
    }];

    //    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.contentView).offset(kRealWidth(self.model.isFirstCell ? 15 : 7.5));
    //        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
    //        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    //        make.bottom.equalTo(self.contentView).offset(-kRealWidth(self.model.isLastCell ? 15 : 7.5));
    //    }];

    [super updateConstraints];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.shopCarItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShoppingCarItemModel *item = self.model.shopCarItems[indexPath.row];
    return item.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShooingCartItemCell *cell = [TNShooingCartItemCell cellWithTableView:tableView];
    TNShoppingCarItemModel *item = self.model.shopCarItems[indexPath.row];
    cell.model = item;
    [self dealingWithProductViewBlock:cell.productView];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:TNLocalizedString(@"tn_delete", @"删除")
                                                                          handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
                                                                              TNShoppingCarItemModel *item = self.model.shopCarItems[indexPath.row];
                                                                              [self removeGoodHandle:item];
                                                                          }];

    return @[deleteAction];
}

#pragma mark - lazy load
- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        _bgView = view;
    }
    return _bgView;
}

- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setImage:[UIImage imageNamed:@"goods_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"goods_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"goods_disabled"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [button addTarget:self action:@selector(clickedSelectBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _selectBTN = button;
    }
    return _selectBTN;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"shopping_cart_shop"];
        imageView.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [imageView addGestureRecognizer:recognizer];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        label.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [label addGestureRecognizer:recognizer];
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"arrow_narrow_gray"];
        imageView.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [imageView addGestureRecognizer:recognizer];
        _arrowIV = imageView;
    }
    return _arrowIV;
}

- (UIView *)sepLine1 {
    if (!_sepLine1) {
        _sepLine1 = UIView.new;
        _sepLine1.backgroundColor = HDAppTheme.color.G4;
    }
    return _sepLine1;
}
- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        label.text = TNLocalizedString(@"sub_total", @"总计");
        label.adjustsFontSizeToFitWidth = YES;
        _moneyLB = label;
    }
    return _moneyLB;
}

- (SAOperationButton *)operationBTN {
    if (!_operationBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 26, 8, 26);
        [button addTarget:self action:@selector(clickedOperationBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _operationBTN = button;
    }
    return _operationBTN;
}

- (NSMutableArray<TNShoppingCarItemModel *> *)selectedProducts {
    if (!_selectedProducts) {
        _selectedProducts = NSMutableArray.array;
    }
    return _selectedProducts;
}
- (UITableView *)goodsTableView {
    if (!_goodsTableView) {
        _goodsTableView = [[TNGestureTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTableView.showsVerticalScrollIndicator = false;
        _goodsTableView.showsHorizontalScrollIndicator = false;
        _goodsTableView.bounces = false;
    }
    return _goodsTableView;
}
/** @lazy storeTypeTag */
- (HDUIButton *)storeTypeTag {
    if (!_storeTypeTag) {
        _storeTypeTag = [[HDUIButton alloc] init];
        _storeTypeTag.titleLabel.font = HDAppTheme.TinhNowFont.standard12B;
        [_storeTypeTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _storeTypeTag.titleEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
        _storeTypeTag.userInteractionEnabled = NO;
        _storeTypeTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
            [view setGradualChangingColorFromColor:HexColor(0xC41EF8) toColor:HexColor(0x7300F8)];
        };
    }
    return _storeTypeTag;
}
@end
