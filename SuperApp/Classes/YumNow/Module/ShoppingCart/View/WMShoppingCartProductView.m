//
//  WMShoppingCartProductView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartProductView.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "WMShoppingCartStoreProduct.h"


@interface WMShoppingCartProductView ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 展示价
@property (nonatomic, strong) SALabel *showPriceLB;
/// 划线价
@property (nonatomic, strong) SALabel *linePriceLB;
@property (nonatomic, strong) UIView *countViewMask; ///< 屏蔽点击
/// 修改数量 View
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// 删除按钮
@property (nonatomic, strong) SAOperationButton *deleteBTN;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 是否触发点击回调
@property (nonatomic, assign) BOOL shouldInvokeClickedProductViewBlock;
/// 提示文字
@property (nonatomic, strong) HDLabel *tipLB;
/// 线
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation WMShoppingCartProductView
- (void)hd_setupViews {
    [self addSubview:self.selectBTN];
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.descLB];
    [self addSubview:self.showPriceLB];
    [self addSubview:self.linePriceLB];
    [self addSubview:self.countViewMask];
    [self addSubview:self.countView];
    [self addSubview:self.deleteBTN];
    [self addSubview:self.tipLB];
    [self addSubview:self.bottomLine];

    self.iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
    };
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    button.selected = !button.isSelected;
    if (self.onEditing) {
        self.model.isDeleteSelected = !self.model.isDeleteSelected;
        !self.onEditingSelectedProductBlock ?: self.onEditingSelectedProductBlock(self.model);
    } else {
        self.model.isSelected = button.isSelected;
        !self.clickedSelectBTNBlock ?: self.clickedSelectBTNBlock(button.isSelected, self.model);
    }
}

- (void)clickedDeleteBTNHandler {
    !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
}

- (void)hd_clickedViewHandler {
    if (self.onEditing) {
        self.model.isDeleteSelected = !self.model.isDeleteSelected;
        !self.onEditingSelectedProductBlock ?: self.onEditingSelectedProductBlock(self.model);
    } else {
        !self.clickedProductViewBlock ?: self.clickedProductViewBlock();
    }
}

#pragma mark - override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.shouldInvokeClickedProductViewBlock) {
        if (self.onEditing) {
            self.model.isDeleteSelected = !self.model.isDeleteSelected;
            !self.onEditingSelectedProductBlock ?: self.onEditingSelectedProductBlock(self.model);
        } else {
            !self.clickedProductViewBlock ?: self.clickedProductViewBlock();
        }
    }
}
// 判断点击区域
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.selectBTN.frame, point)) {
        self.shouldInvokeClickedProductViewBlock = false;
        return;
    }
    if (CGRectContainsPoint(self.countViewMask.frame, point)) {
        self.shouldInvokeClickedProductViewBlock = false;
        return;
    }
    self.shouldInvokeClickedProductViewBlock = true;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.shouldInvokeClickedProductViewBlock = false;
}

#pragma mark - setter
- (void)setOnEditing:(BOOL)onEditing {
    _onEditing = onEditing;
}
- (void)setModel:(WMShoppingCartStoreProduct *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 70)] imageView:self.iconIV];

    self.nameLB.text = model.name.desc;

    NSArray<NSString *> *propertyNames = [model.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    self.descLB.text =
        [model.goodsSkuName.desc stringByAppendingFormat:@"%@%@", HDIsArrayEmpty(propertyNames) ? @"" : @",", HDIsArrayEmpty(propertyNames) ? @"" : [propertyNames componentsJoinedByString:@"、"]];
    const BOOL isStoreOpening = [model.storeStatus isEqualToString:WMShopppingCartStoreStatusOpening];
    const BOOL isStoreResting = [model.storeStatus isEqualToString:WMShopppingCartStoreStatusResting];
    const BOOL isGoodsOnSale = model.goodsState == WMGoodsStatusOn;
    const BOOL isGoodsOffSale = model.goodsState == WMGoodsStatusOff;
    const BOOL isGoodsSoldOut = model.availableStock <= 0;
    // 已选数量超出库存 弱库存
    const BOOL isGoodsPurchaseQuantityOverAvailableStock = model.purchaseQuantity > model.availableStock;
    self.selectBTN.enabled = model.canSelected;
    self.deleteBTN.hidden = !isGoodsOffSale && !isGoodsSoldOut;
    self.showPriceLB.hidden = self.linePriceLB.hidden = !self.deleteBTN.isHidden;
    self.countView.hidden = !isGoodsOnSale || isGoodsSoldOut;
    if (self.onEditing) {
        self.selectBTN.selected = model.isDeleteSelected;
    } else {
        self.selectBTN.selected = self.selectBTN.isEnabled ? model.isSelected : false;
        if (!isStoreOpening || isGoodsSoldOut || isGoodsOffSale) {
            self.nameLB.textColor = HDAppTheme.color.G3;
            self.showPriceLB.textColor = HDAppTheme.color.G3;
        } else {
            self.nameLB.textColor = HDAppTheme.WMColor.B3;
            self.showPriceLB.textColor = HDAppTheme.color.money;
        }
    }

    [self.countView updateCount:model.purchaseQuantity];
    self.countView.maxCount = model.availableStock > 150 ? 150 : model.availableStock;
    //    self.countView.disableMinusLogic = (model.purchaseQuantity == self.countView.firstStepCount);
    self.oldCount = self.countView.count;
    // 按需求方要求，休息中也可以删减
    [self.countView enableOrDisableMinusButton:isStoreOpening || isStoreResting];
    // 超出库存只允许减
    // 11/14 modify 弱库存处理，不做判断
    [self.countView enableOrDisablePlusButton:(isStoreOpening || isStoreResting) && self.countView.count < self.countView.maxCount];

    if (isGoodsOffSale || isGoodsSoldOut || isGoodsPurchaseQuantityOverAvailableStock) {
        self.tipLB.hidden = false;
        if (isGoodsOffSale || isGoodsSoldOut) {
            self.tipLB.text = WMLocalizedString(@"wm_shopcar_good_fail", @"Failure of goods");
        }
        //        if (isGoodsOffSale) {
        //            self.tipLB.text = WMLocalizedString(@"item_is_no_longer_available", @"Product is no longer available.");
        //        } else if (isGoodsSoldOut) {
        //            self.tipLB.text = WMLocalizedString(@"temporarily_out_of_stock", @"Temporarily out of stock.");
        //        }
        else if (isGoodsPurchaseQuantityOverAvailableStock) {
            self.tipLB.text = [NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"Only %zd left in stock."), model.availableStock];
        }
    } else {
        self.tipLB.hidden = true;
    }
    self.bottomLine.hidden = !model.needShowBottomLine;

    [self updatePrice];

    if (self.onEditing) { //编辑状态全关闭
        self.countView.hidden = YES;
        self.deleteBTN.hidden = YES;
        self.bottomLine.hidden = YES;
        self.selectBTN.enabled = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (void)updatePrice {
    self.showPriceLB.text = self.model.showPrice.thousandSeparatorAmount;
    NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:self.model.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.standard3,
        NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
    }];
    self.linePriceLB.attributedText = priceStr;
}

- (void)updateCanSelected {
    self.selectBTN.enabled = self.model.canSelected;
}

#pragma mark - public methods
- (void)setSelectBtnSelected:(BOOL)selected {
    // 先判断是否可选中
    if (self.selectBTN.enabled) {
        self.selectBTN.selected = selected;
        self.model.isSelected = selected;
    } else {
        self.model.isSelected = false;
        self.selectBTN.selected = false;
    }
}

- (BOOL)isSelected {
    return self.model.isSelected;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.selectBTN.size);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(72), kRealWidth(72)));
        make.left.equalTo(self.selectBTN.mas_right).offset(kRealWidth(8));
        make.top.equalTo(self).offset(kRealWidth(12));
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
        if (HDIsStringNotEmpty(self.descLB.text)) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        }
    }];
    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.greaterThanOrEqualTo(self.iconIV).offset(-kRealWidth(2));
        if (self.tipLB.isHidden) {
            make.bottom.equalTo(self).offset(-kRealWidth(15));
        }
    }];
    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showPriceLB.mas_right).offset(kRealWidth(4));
        make.centerY.equalTo(self.showPriceLB);
        UIView *view = self.countView.isHidden ? self.deleteBTN : self.countView;
        make.right.equalTo(view.mas_left).offset(-5);
    }];
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countView.isHidden) {
            make.centerY.equalTo(self.showPriceLB);
            make.right.equalTo(self).offset(-kRealWidth(12));
        }
    }];
    [self.countViewMask mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countView.mas_left).offset(-20);
        make.right.equalTo(self.countView.mas_right).offset(20);
        make.top.equalTo(self.countView.mas_top).offset(-5);
        make.bottom.equalTo(self.countView.mas_bottom).offset(5);
    }];
    [self.deleteBTN sizeToFit];
    [self.deleteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deleteBTN.isHidden) {
            make.centerY.greaterThanOrEqualTo(self);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(48));
            make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(5));
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(self.deleteBTN.size.height);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(48));
        }
    }];
    [self.deleteBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.deleteBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLB.isHidden) {
            make.left.equalTo(self.showPriceLB);
            if (!self.deleteBTN.isHidden) {
                make.centerY.equalTo(self.deleteBTN);
            } else {
                if (self.showPriceLB.isHidden) {
                    make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(4));
                } else {
                    make.top.greaterThanOrEqualTo(self.showPriceLB.mas_bottom).offset(kRealWidth(15));
                }
            }
            make.right.mas_lessThanOrEqualTo(-HDAppTheme.value.padding.right);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.mas_right).offset(kRealWidth(-10));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(clickedSelectBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _selectBTN = button;
    }
    return _selectBTN;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(70, 70)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 1;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B9;
        label.numberOfLines = 2;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.color.money;
        label.numberOfLines = 1;
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _showPriceLB = label;
    }
    return _showPriceLB;
}

- (SALabel *)linePriceLB {
    if (!_linePriceLB) {
        _linePriceLB = SALabel.new;
        [_linePriceLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _linePriceLB;
}

/** @lazy countViewmask */
- (UIView *)countViewMask {
    if (!_countViewMask) {
        _countViewMask = [[UIView alloc] init];
    }
    return _countViewMask;
}

- (SAModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = SAModifyShoppingCountView.new;
        _countView.minusIcon = @"yn_store_minus";
        _countView.plusIcon = @"yn_store_plus";
        _countView.customCountLB = ^(SALabel *_Nonnull countLb) {
            countLb.textColor = HDAppTheme.WMColor.B3;
            countLb.font = [HDAppTheme.WMFont wm_boldForSize:14];
        };
        @HDWeakify(self);
        _countView.countShouldChange = ^BOOL(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            if (type == SAModifyShoppingCountViewOperationTypeMinus && count == 0) {
                !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
                return NO;
            }
            return self.countShouldChangeBlock ? self.countShouldChangeBlock(type, count) : YES;
        };
        _countView.maxCountLimtedHandler = ^(NSUInteger count) {
            @HDStrongify(self);
            !self.maxCountLimtedHandler ?: self.maxCountLimtedHandler(count);
        };
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            @HDWeakify(self);
            !self.countChangedBlock ?: self.countChangedBlock(type, count, ^{
                @HDStrongify(self);
                [self updatePrice];
                [self updateCanSelected];
            });
            //            self.countView.disableMinusLogic = (count == self.countView.firstStepCount);
            self.oldCount = count;
        };
        _countView.clickedMinusBTNHandler = ^{
            @HDStrongify(self);
            !self.clickedMinusBTNHandler ?: self.clickedMinusBTNHandler();
        };
        self.oldCount = _countView.count;
    }
    return _countView;
}

- (SAOperationButton *)deleteBTN {
    if (!_deleteBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        [button setTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedDeleteBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        button.borderColor = HDAppTheme.WMColor.B3;
        [button setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
        _deleteBTN = button;
    }
    return _deleteBTN;
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        HDLabel *label = HDLabel.new;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.layer.cornerRadius = kRealWidth(2);
        label.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        label.layer.borderWidth = 0.7;
        label.numberOfLines = 0;
        label.hidden = true;
        _tipLB = label;
    }
    return _tipLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

@end
