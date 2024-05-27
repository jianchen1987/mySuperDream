//
//  WMStoreShoppingCartProductCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreShoppingCartProductCell.h"
#import "SAModifyShoppingCountView.h"
#import "WMShoppingCartStoreProduct.h"


@interface WMStoreShoppingCartProductCell ()
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 售价
@property (nonatomic, strong) SALabel *showPriceLB;
/// 原价
@property (nonatomic, strong) SALabel *linePriceLB;
/// 修改数量 View
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// 底部分割线
@property (nonatomic, strong) UIView *bottomLine;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 提示文字
@property (nonatomic, strong) SALabel *tipLB;
@end


@implementation WMStoreShoppingCartProductCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.showPriceLB];
    [self.contentView addSubview:self.linePriceLB];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.tipLB];
}

#pragma mark - setter
- (void)setModel:(WMShoppingCartStoreProduct *)model {
    _model = model;

    self.nameLB.text = model.name.desc;

    NSArray<NSString *> *propertyNames = [model.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    self.descLB.text =
        [model.goodsSkuName.desc stringByAppendingFormat:@"%@%@", HDIsArrayEmpty(propertyNames) ? @"" : @",", HDIsArrayEmpty(propertyNames) ? @"" : [propertyNames componentsJoinedByString:@"、"]];

    // 已选数量超出库存
    const BOOL isGoodsPurchaseQuantityOverAvailableStock = model.purchaseQuantity > model.availableStock;
    const BOOL isStoreOpening = [model.storeStatus isEqualToString:WMShopppingCartStoreStatusOpening];
    //    const BOOL isGoodsOnSale = model.goodsState == WMGoodsStatusOn;
    //    self.countView.hidden = !isGoodsOnSale;
    [self.countView updateCount:model.purchaseQuantity];
    self.countView.maxCount = model.availableStock > 150 ? 150 : model.availableStock;
    //    self.countView.disableMinusLogic = (model.purchaseQuantity == self.countView.firstStepCount);
    self.oldCount = self.countView.count;
    [self.countView enableOrDisableMinusButton:isStoreOpening];
    // 超出库存只允许减
    [self.countView enableOrDisablePlusButton:isStoreOpening ? (model.purchaseQuantity < model.availableStock) : false];

    if (isGoodsPurchaseQuantityOverAvailableStock) {
        self.tipLB.hidden = false;
        self.tipLB.text = [NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"Only %zd left in stock."), model.availableStock];
    } else {
        self.tipLB.hidden = true;
    }

    self.bottomLine.hidden = !model.needShowBottomLine;

    self.showPriceLB.text = model.showPrice.thousandSeparatorAmount;
    NSAttributedString *linePriceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.standard3,
        NSForegroundColorAttributeName: HDAppTheme.color.G3,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.color.G3
    }];
    self.linePriceLB.attributedText = linePriceStr;

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(10));
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(3));
    }];
    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(10));
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(10));
    }];
    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showPriceLB.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self.showPriceLB.mas_centerY);
    }];
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showPriceLB);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(10));
    }];
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLB.isHidden) {
            make.left.equalTo(self.nameLB);
            make.top.greaterThanOrEqualTo(self.showPriceLB.mas_bottom).offset(kRealWidth(5));
            make.top.greaterThanOrEqualTo(self.countView.mas_bottom).offset(kRealWidth(5));
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-kRealWidth(10));
        }
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.money;
        label.numberOfLines = 1;
        _showPriceLB = label;
    }
    return _showPriceLB;
}

- (SAModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = SAModifyShoppingCountView.new;
        _countView.disableMinusLogic = NO;
        _countView.minusIcon = @"yn_store_minus";
        _countView.plusIcon = @"yn_store_plus";
        @HDWeakify(self);
        _countView.countShouldChange = ^BOOL(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            return self.goodsCountShouldChangeBlock ? self.goodsCountShouldChangeBlock(self.model, type, count) : YES;
        };
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            !self.goodsCountChangedBlock ?: self.goodsCountChangedBlock(self.model, type, count);
            //            self.countView.disableMinusLogic = (count == self.countView.firstStepCount);
            self.oldCount = count;
        };
        _countView.maxCountLimtedHandler = ^(NSUInteger count) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
        };
        _countView.clickedMinusBTNHandler = ^{
            @HDStrongify(self);
            !self.clickedMinusBTNBlock ?: self.clickedMinusBTNBlock();
        };
        self.oldCount = _countView.count;
    }
    return _countView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
        _bottomLine.hidden = true;
    }
    return _bottomLine;
}

- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.hidden = true;
        _tipLB = label;
    }
    return _tipLB;
}

- (SALabel *)linePriceLB {
    if (!_linePriceLB) {
        _linePriceLB = [[SALabel alloc] init];
    }
    return _linePriceLB;
}

@end
