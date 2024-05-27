//
//  WMShoppingCartProductView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCartProductView.h"
//#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "TNModifyShoppingCountView.h"
#import "TNShoppingCarItemModel.h"


@interface TNShoppingCartProductView ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 售价
@property (nonatomic, strong) SALabel *salePriceLB;
/// 修改数量 View
@property (nonatomic, strong) TNModifyShoppingCountView *countView;
/// 删除按钮
@property (nonatomic, strong) SAOperationButton *deleteBTN;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 是否触发点击回调
@property (nonatomic, assign) BOOL shouldInvokeClickedProductViewBlock;
/// 提示文本
@property (strong, nonatomic) SALabel *tipsLabel;
@end


@implementation TNShoppingCartProductView
- (void)hd_setupViews {
    [self addSubview:self.selectBTN];
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.descLB];
    [self addSubview:self.salePriceLB];
    [self addSubview:self.countView];
    [self addSubview:self.deleteBTN];
    [self addSubview:self.tipsLabel];

    self.iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
    };
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    button.selected = !button.isSelected;
    self.model.isSelected = button.isSelected;

    !self.clickedSelectBTNBlock ?: self.clickedSelectBTNBlock(button.isSelected, self.model);
}

- (void)clickedDeleteBTNHandler {
    !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
}

- (void)hd_clickedViewHandler {
    !self.clickedProductViewBlock ?: self.clickedProductViewBlock();
}

#pragma mark - override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.shouldInvokeClickedProductViewBlock) {
        !self.clickedProductViewBlock ?: self.clickedProductViewBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.selectBTN.frame, point)) {
        self.shouldInvokeClickedProductViewBlock = false;
    }
    if (CGRectContainsPoint(self.countView.frame, point)) {
        self.shouldInvokeClickedProductViewBlock = false;
    }
    self.shouldInvokeClickedProductViewBlock = true;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.shouldInvokeClickedProductViewBlock = false;
}

#pragma mark - setter
- (void)setModel:(TNShoppingCarItemModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 70)] imageView:self.iconIV];

    self.nameLB.text = model.goodsName;

    self.descLB.text = model.goodsSkuName;
    self.salePriceLB.text = model.salePrice.thousandSeparatorAmount;
    const BOOL isStoreOpening = YES;
    const BOOL isGoodsOnSale = model.goodsState == TNStoreItemStateOnSale;
    const BOOL isGoodsOffSale = model.goodsState == TNStoreItemStateOffSale;

    self.selectBTN.enabled = isStoreOpening && isGoodsOnSale;
    self.deleteBTN.hidden = !isGoodsOffSale;
    self.countView.hidden = !isGoodsOnSale;
    self.selectBTN.selected = self.selectBTN.isEnabled ? model.isSelected : false;

    [self.countView updateCount:model.quantity.integerValue];
    self.countView.maxCount = model.availableStock.integerValue;
    ;
    //    self.countView.disableMinusLogic = (model.quantity.integerValue == self.countView.firstStepCount);
    self.oldCount = self.countView.count;
    [self.countView enableOrDisableButton:isStoreOpening];
    //设置提示文本
    if (isGoodsOffSale) {
        //商家缺货
        self.tipsLabel.hidden = false;
        self.tipsLabel.text = TNLocalizedString(@"tn_good_no_available", @"商品已下架");
    } else {
        //判断库存量
        if (model.availableStock.integerValue <= 0) { //没有库存了
            self.tipsLabel.hidden = false;
            self.tipsLabel.text = TNLocalizedString(@"tn_out_of_stock_now", @"暂时缺货");
            self.selectBTN.enabled = false;
            self.deleteBTN.hidden = false;
            self.countView.hidden = true;
        } else { //购物车数 > 可售数量
            self.deleteBTN.hidden = true;
            self.countView.hidden = false;
            if (model.quantity.integerValue > model.availableStock.integerValue) {
                self.selectBTN.enabled = false;
                self.tipsLabel.hidden = false;
                self.tipsLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_stock_left", @"库存仅剩%@件"), model.availableStock];
            } else {
                self.selectBTN.enabled = true;
                self.tipsLabel.hidden = true;
            }
        }
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)setSelectBtnSelected:(BOOL)selected {
    self.selectBTN.selected = selected;
    // 先判断是否可选中
    if (self.selectBTN.enabled) {
        self.model.isSelected = selected;
    } else {
        self.model.isSelected = false;
    }
}

- (BOOL)isSelected {
    return self.model.isSelected;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.selectBTN.bounds.size);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.left.equalTo(self.selectBTN.mas_right);
        make.top.equalTo(self).offset(kRealWidth(15));
        if (self.tipsLabel.isHidden) {
            make.bottom.equalTo(self).offset(-kRealWidth(15));
        }
    }];
    if (!self.tipsLabel.isHidden) {
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(10));
            make.leading.equalTo(self.iconIV.mas_leading);
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self).offset(-kRealWidth(15));
        }];
    }
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(3));
    }];
    [self.salePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.bottom.equalTo(self.iconIV);
        //        make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(10));
        //        make.bottom.greaterThanOrEqualTo(self.iconIV);
        //        make.bottom.equalTo(self).offset(-kRealWidth(15));
    }];
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countView.isHidden) {
            make.centerY.equalTo(self.salePriceLB);
            make.right.equalTo(self).offset(-10);
        }
    }];
    [self.deleteBTN sizeToFit];
    [self.deleteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deleteBTN.isHidden) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
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
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(70, 70)];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 2;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)salePriceLB {
    if (!_salePriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.C1;
        label.numberOfLines = 1;
        _salePriceLB = label;
    }
    return _salePriceLB;
}
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        label.text = TNLocalizedString(@"tn_good_no_available", @"商品已下架");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (TNModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = TNModifyShoppingCountView.new;
        _countView.needShowModifyCountAlertView = YES;
        _countView.minCount = 0;
        @HDWeakify(self);
        _countView.countShouldChange = ^BOOL(TNModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            if (type == TNModifyShoppingCountViewOperationTypeMinus && count < self.countView.firstStepCount) {
                !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
                return NO;
            }
            return YES;
        };
        _countView.maxCountLimtedHandler = ^(NSUInteger count) {
            @HDStrongify(self);
            !self.maxCountLimtedHandler ?: self.maxCountLimtedHandler(count);
        };
        _countView.changedCountHandler = ^(TNModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            if (type == TNModifyShoppingCountViewOperationTypePlus) {
                !self.clickedPlusBTNBlock ?: self.clickedPlusBTNBlock(count - self.oldCount, count);
            } else {
                !self.clickedMinusBTNBlock ?: self.clickedMinusBTNBlock(self.oldCount - count, count);
            }
            self.countView.disableMinusLogic = (count == self.countView.firstStepCount);
            self.oldCount = count;
        };
        self.oldCount = _countView.count;
    }
    return _countView;
}
- (SAOperationButton *)deleteBTN {
    if (!_deleteBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
        [button setTitle:TNLocalizedString(@"tn_delete", @"删除") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedDeleteBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        _deleteBTN = button;
    }
    return _deleteBTN;
}
@end
