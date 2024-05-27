//
//  WMOrderFeedBackFoodView.m
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackFoodView.h"
#import "SAInfoView.h"
#import "SAModifyShoppingCountView.h"
#import "WMOrderFeedBackDTO.h"


@interface WMOrderFeedBackFoodView ()
/// selectAllBTN
@property (nonatomic, strong) HDUIButton *selectAllBTN;
/// headLine
@property (nonatomic, strong) UIView *headLine;
/// productContainView
@property (nonatomic, strong) UIView *productContainView;
/// bottomLine
@property (nonatomic, strong) UIView *bottomLine;
/// orderLine
@property (nonatomic, strong) UIView *orderLine;
/// totalView
@property (nonatomic, strong) SAInfoView *totalView;
/// packingFeeView
@property (nonatomic, strong) SAInfoView *packingFeeView;
/// vatView
@property (nonatomic, strong) SAInfoView *vatView;
/// deliveryFeeView
@property (nonatomic, strong) SAInfoView *deliveryFeeView;
/// actualView
@property (nonatomic, strong) SAInfoView *actualView;
/// infoViewArr
@property (nonatomic, strong) NSMutableArray<SAInfoView *> *infoViewArr;
/// DTO
@property (nonatomic, strong) WMOrderFeedBackDTO *DTO;

@end


@implementation WMOrderFeedBackFoodView

- (void)hd_setupViews {
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.selectAllBTN];
    [self addSubview:self.headLine];
    [self addSubview:self.productContainView];
    [self addSubview:self.bottomLine];
    [self addSubview:self.totalView];
    [self addSubview:self.packingFeeView];
    [self addSubview:self.vatView];
    [self addSubview:self.deliveryFeeView];
    [self addSubview:self.actualView];
    [self addSubview:self.orderLine];
    self.infoViewArr = NSMutableArray.new;
}

- (void)setType:(WMOrderFeedBackPostShowType)type {
    _type = type;
    if ([type isEqualToString:WMOrderFeedBackPostRefuse]) {
        [self addSubview:self.packingFeeView];
        [self addSubview:self.vatView];
        [self addSubview:self.deliveryFeeView];
        [self addSubview:self.actualView];
        [self addSubview:self.orderLine];
        self.infoViewArr = NSMutableArray.new;
        [self.infoViewArr addObject:self.totalView];
        [self.infoViewArr addObject:self.packingFeeView];
        [self.infoViewArr addObject:self.vatView];
        [self.infoViewArr addObject:self.deliveryFeeView];
        [self.infoViewArr addObject:self.actualView];
        [self setNeedsUpdateConstraints];
        [self getFeeInfo];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.selectAllBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.headLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.selectAllBTN.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
    }];

    [self.productContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headLine.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.top.equalTo(self.productContainView.mas_bottom);
            make.height.mas_equalTo(HDAppTheme.WMValue.line);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    SAView *lastView;
    for (SAView *infoView in self.productContainView.subviews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.mas_equalTo(kRealWidth(12));
            }
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        lastView = infoView;
    }

    NSArray<SAView *> *visableInfoViews = [self.infoViewArr hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];
    NSArray<SAView *> *invisableInfoViews = [self.infoViewArr hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return item.isHidden;
    }];
    for (SAInfoView *infoView in invisableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make){

        }];
    }

    SAInfoView *lastInfoView;
    int i = 0;
    for (SAInfoView *infoView in visableInfoViews) {
        if (i == 0) {
            infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(4), kRealWidth(12));
            [infoView setNeedsUpdateContent];
        }
        if (i == visableInfoViews.count - 2) {
            infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(12), kRealWidth(12));
            [infoView setNeedsUpdateContent];
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.mas_equalTo(self.bottomLine.mas_bottom);
            }
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
        if (infoView == visableInfoViews.lastObject) {
            [self.orderLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!self.orderLine.isHidden) {
                    make.top.equalTo(infoView.mas_top);
                    make.left.right.height.equalTo(self.bottomLine);
                }
            }];
        }
        lastInfoView = infoView;
        i++;
    }
}

- (void)setProductArr:(NSArray<WMShoppingCartStoreProduct *> *)productArr {
    _productArr = productArr;
    @HDWeakify(self)[self.productContainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (WMShoppingCartStoreProduct *product in productArr) {
        WMOrderFeedBackFoodItemView *itemView = WMOrderFeedBackFoodItemView.new;
        itemView.model = product;
        itemView.clickedConfirmBlock = ^(WMShoppingCartStoreProduct *_Nonnull model) {
            @HDStrongify(self) self.flag = !self.flag;
            [self checkAction];
            [self getFeeInfo];
        };
        itemView.changeNumBlock = ^(WMShoppingCartStoreProduct *_Nonnull model) {
            @HDStrongify(self) self.flag = !self.flag;
            [self checkAction];
            if (model.isSelected) {
                [self getFeeInfo];
            }
        };
        [self.productContainView addSubview:itemView];
    }
    [self setNeedsUpdateConstraints];
}

///判断是否全选
- (void)checkAction {
    BOOL selectAll = YES;
    for (WMShoppingCartStoreProduct *product in self.productArr) {
        if (!product.isSelected || product.purchaseQuantity != product.maxQuantity) {
            selectAll = NO;
            break;
        }
    }
    self.selectAllBTN.selected = selectAll;
}

///获取计算金额
- (void)getFeeInfo {
    if ([self.type isEqualToString:WMOrderFeedBackPostRefuse]) {
        @HDWeakify(self)[self.viewController.view showloading];
        NSMutableArray *commodityInfo = NSMutableArray.new;
        for (WMShoppingCartStoreProduct *product in self.productArr) {
            if (product.isSelected) {
                [commodityInfo addObject:@{@"orderCommodityId": product.orderCommodityId, @"quantity": @(product.purchaseQuantity).stringValue}];
            }
        }
        [self.DTO requestCalculationRefundAmountWithNO:self.orderNo commodityInfo:commodityInfo success:^(WMFeedBackRefundAmountModel *_Nonnull rspModel) {
            @HDStrongify(self) self.rspModel = rspModel;
            [self.viewController.view dismissLoading];
            self.totalView.model.valueText = rspModel.commodityAmount.thousandSeparatorAmount;
            self.packingFeeView.model.valueText = rspModel.packageFee.thousandSeparatorAmount;
            self.vatView.model.valueText = rspModel.vat.thousandSeparatorAmount;
            self.deliveryFeeView.model.valueText = rspModel.deliveryFee.thousandSeparatorAmount;
            NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]
                initWithString:[NSString stringWithFormat:@"%@ %@", WMLocalizedString(@"wm_order_feedback_actual_refund_amount", @"Actual refund amount"), rspModel.refund.thousandSeparatorAmount]];
            mstr.yy_color = HDAppTheme.WMColor.B3;
            mstr.yy_font = [HDAppTheme.WMFont wm_boldForSize:14];
            [mstr yy_setFont:[HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"] range:[mstr.string rangeOfString:rspModel.refund.thousandSeparatorAmount]];
            [mstr yy_setFont:[HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Bold"] range:[mstr.string rangeOfString:rspModel.refund.currencySymbol]];
            self.actualView.model.attrValue = mstr;
            for (SAInfoView *view in self.infoViewArr) {
                if ([view isKindOfClass:SAInfoView.class]) {
                    [view setNeedsUpdateContent];
                }
                view.hidden = NO;
                if (HDIsArrayEmpty(commodityInfo)) {
                    view.hidden = YES;
                }
            }
            if (!self.deliveryFeeView.isHidden && rspModel.deliveryFee.cent.doubleValue == 0) {
                self.deliveryFeeView.hidden = YES;
            }
            if (!self.packingFeeView.isHidden && rspModel.packageFee.cent.doubleValue == 0) {
                self.packingFeeView.hidden = YES;
            }
            [self setNeedsUpdateConstraints];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self) self.rspModel = nil;
            [self.viewController.view dismissLoading];
            for (SAInfoView *view in self.infoViewArr) {
                view.hidden = YES;
            }
            [self setNeedsUpdateConstraints];
        }];
    }
}

- (UIView *)productContainView {
    if (!_productContainView) {
        _productContainView = UIView.new;
    }
    return _productContainView;
}

- (HDUIButton *)selectAllBTN {
    if (!_selectAllBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsButtonWhenHighlighted = NO;
        btn.spacingBetweenImageAndTitle = kRealWidth(8);
        btn.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedString(@"wm_order_feedback_select_all", @"Select All") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.selectAllBTN.selected = !self.selectAllBTN.isSelected;
            for (WMShoppingCartStoreProduct *product in self.productArr) {
                product.purchaseQuantity = product.maxQuantity;
                product.isSelected = self.selectAllBTN.isSelected;
            }
            [self.productContainView.subviews makeObjectsPerformSelector:@selector(updateContent)];
            self.flag = !self.flag;
            [self getFeeInfo];
        }];
        _selectAllBTN = btn;
    }
    return _selectAllBTN;
}

- (UIView *)headLine {
    if (!_headLine) {
        _headLine = UIView.new;
        _headLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _headLine;
}

- (UIView *)orderLine {
    if (!_orderLine) {
        _orderLine = UIView.new;
        _orderLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _orderLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _bottomLine;
}

- (SAInfoView *)totalView {
    if (!_totalView) {
        SAInfoView *infoView = SAInfoView.new;
        infoView.hidden = YES;
        infoView.model = [self customModelWithColor:nil keyText:WMLocalizedString(@"wm_order_feedback_product_total_price", @"Total")];
        _totalView = infoView;
    }
    return _totalView;
}

- (SAInfoView *)packingFeeView {
    if (!_packingFeeView) {
        SAInfoView *infoView = SAInfoView.new;
        infoView.hidden = YES;
        infoView.model = [self customModelWithColor:nil keyText:WMLocalizedString(@"packing_fee", @"Packing fee")];
        _packingFeeView = infoView;
    }
    return _packingFeeView;
}

- (SAInfoView *)vatView {
    if (!_vatView) {
        SAInfoView *infoView = SAInfoView.new;
        infoView.hidden = YES;
        infoView.model = [self customModelWithColor:nil keyText:WMLocalizedString(@"vat_fee", @"VAT")];
        _vatView = infoView;
    }
    return _vatView;
}

- (SAInfoView *)deliveryFeeView {
    if (!_deliveryFeeView) {
        SAInfoView *infoView = SAInfoView.new;
        infoView.hidden = YES;
        infoView.model = [self customModelWithColor:nil keyText:WMLocalizedString(@"delivery_fee", @"Delivery fee")];
        _deliveryFeeView = infoView;
    }
    return _deliveryFeeView;
}

- (SAInfoView *)actualView {
    if (!_actualView) {
        SAInfoView *infoView = SAInfoView.new;
        infoView.hidden = YES;
        infoView.model = [self customModelWithColor:HDAppTheme.WMColor.B3 keyText:nil];
        infoView.model.valueFont = [HDAppTheme.WMFont wm_boldForSize:14];
        infoView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(14), kRealWidth(12), kRealWidth(16), kRealWidth(12));
        _actualView = infoView;
    }
    return _actualView;
}

- (SAInfoViewModel *)customModelWithColor:(nullable UIColor *)color keyText:(NSString *)keyText {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.WMColor.B9;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.valueColor = color ?: HDAppTheme.WMColor.B3;
    model.keyText = keyText;
    model.lineWidth = 0;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DINPro-Regular"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(4), kRealWidth(12));
    return model;
}

- (WMOrderFeedBackDTO *)DTO {
    if (!_DTO) {
        _DTO = WMOrderFeedBackDTO.new;
    }
    return _DTO;
}

@end


@interface WMOrderFeedBackFoodItemView ()
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// detailLB
@property (nonatomic, strong) HDLabel *detailLB;
/// countView
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// checkBTN
@property (nonatomic, strong) HDUIButton *checkBTN;

@end


@implementation WMOrderFeedBackFoodItemView

- (void)hd_setupViews {
    [self addSubview:self.checkBTN];
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.detailLB];
    [self addSubview:self.countView];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.checkBTN sizeToFit];
    [self.checkBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(kRealWidth(44));
        make.centerY.equalTo(self.iconIV.mas_centerY);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(72), kRealWidth(72)));
        make.top.mas_equalTo(0);
        make.left.equalTo(self.checkBTN.mas_right);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.iconIV.mas_top);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(6));
    }];

    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.detailLB.mas_bottom).offset(kRealWidth(6));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];
}

- (void)setModel:(WMShoppingCartStoreProduct *)model {
    _model = model;
    self.countView.minCount = 1;
    self.countView.maxCount = self.model.maxQuantity;
    if (self.model.maxQuantity == 1) {
        [self.countView enableOrDisablePlusButton:NO];
        [self.countView enableOrDisableMinusButton:NO];
    }
    [self updateContent];
}

- (void)updateContent {
    [HDWebImageManager setImageWithURL:self.model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(72), kRealWidth(72))] imageView:self.iconIV];
    self.titleLB.text = self.model.name.desc;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.titleLB.attributedText = mstr;
    NSArray<NSString *> *propertyNames = [self.model.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    self.detailLB.text =
        [self.model.goodsSkuName.desc stringByAppendingFormat:@"%@%@", HDIsArrayEmpty(propertyNames) ? @"" : @",", HDIsArrayEmpty(propertyNames) ? @"" : [propertyNames componentsJoinedByString:@"/"]];
    self.checkBTN.selected = self.model.isSelected;
    [self.countView updateCount:self.model.purchaseQuantity];
    [self setNeedsUpdateConstraints];
}

- (HDUIButton *)checkBTN {
    if (!_checkBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsButtonWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.model.isSelected = !self.model.isSelected;
            if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock(self.model);
            }
            [self updateContent];
        }];
        _checkBTN = btn;
    }
    return _checkBTN;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        _titleLB = label;
    }
    return _titleLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.numberOfLines = 0;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        _detailLB = label;
    }
    return _detailLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.layer.cornerRadius = kRealWidth(8);
        _iconIV.clipsToBounds = YES;
    }
    return _iconIV;
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
        _countView.blockTime = 0;
        @HDWeakify(self);
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self) self.model.purchaseQuantity = count;
            if (self.changeNumBlock) {
                self.changeNumBlock(self.model);
            }
        };
    }
    return _countView;
}
@end
