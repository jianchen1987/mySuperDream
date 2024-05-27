//
//  TNBatchShopCarSkuCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBatchShopCarSkuCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNModifyShoppingCountView.h"
#import "TNShoppingCarBatchGoodsModel.h"
#import "TNShoppingCarItemModel.h"


@interface TNBatchShopCarSkuCell ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 规格名称
@property (nonatomic, strong) SALabel *specLB;
/// 售价
@property (nonatomic, strong) SALabel *salePriceLB;
/// 修改数量 View
@property (nonatomic, strong) TNModifyShoppingCountView *countView;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 缺货提示
@property (strong, nonatomic) SALabel *outOfStockTipsLabel;
/// 提示文本
@property (strong, nonatomic) SALabel *tipsLabel;
/// 删除按钮
@property (nonatomic, strong) SAOperationButton *deleteBTN;
@end


@implementation TNBatchShopCarSkuCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.selectBTN];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.specLB];
    [self.contentView addSubview:self.salePriceLB];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.deleteBTN];
    [self.contentView addSubview:self.outOfStockTipsLabel];

    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView)];
    //    [self.contentView addGestureRecognizer:tap];
}
//- (void)clickContentView {
//    if (self.selectBTN.isEnabled) {
//        [self.selectBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
//    }
//}
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    self.model.tempSelected = !self.model.tempSelected;
    !self.clickedSelectBTNBlock ?: self.clickedSelectBTNBlock();
}
- (void)clickedDeleteBTNHandler {
    !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
}

- (void)setModel:(TNShoppingCarItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(80, 80)] imageView:self.iconIV];

    self.specLB.text = HDIsStringNotEmpty(model.goodsSkuName) ? model.goodsSkuName : TNLocalizedString(@"tn_page_default_title", @"默认");
    self.salePriceLB.text = model.salePrice.thousandSeparatorAmount;
    self.selectBTN.selected = model.isSelected;
    self.countView.maxCount = model.availableStock.integerValue;
    [self.countView updateCount:model.quantity.integerValue];
    self.countView.step = model.goodModel.productCatDTO.batchNumber > 0 ? model.goodModel.productCatDTO.batchNumber : 1;
    self.oldCount = self.countView.count;
    if (model.goodsState == TNStoreItemStateOnSale) {
        if (model.availableStock.integerValue > 0) {
            self.deleteBTN.hidden = YES;
            self.countView.hidden = NO;
            self.outOfStockTipsLabel.hidden = YES;
            // 判断是否满足起批数量
            if (!model.goodModel.productCatDTO.mixWholeSale) {
                if (model.quantity.integerValue < model.goodModel.startQuantity) {
                    //小于起批量
                    self.tipsLabel.hidden = NO;
                    self.tipsLabel.text = [NSString stringWithFormat:TNLocalizedString(@"zXpfvxcb", @"最小起批量为%ld件"), model.goodModel.startQuantity];
                    self.selectBTN.enabled = NO;
                } else {
                    if (model.goodModel.productCatDTO.batchNumber > 0 && [model.quantity integerValue] % model.goodModel.productCatDTO.batchNumber != 0) {
                        self.tipsLabel.hidden = NO;
                        self.tipsLabel.text = [NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), model.goodModel.productCatDTO.batchNumber];
                        self.selectBTN.enabled = NO;
                    } else {
                        self.tipsLabel.hidden = YES;
                        self.selectBTN.enabled = YES;
                    }
                }

            } else {
                if (model.goodModel.productCatDTO.batchNumber > 0 && [model.quantity integerValue] % model.goodModel.productCatDTO.batchNumber != 0) {
                    self.tipsLabel.hidden = NO;
                    self.tipsLabel.text = [NSString stringWithFormat:TNLocalizedString(@"mk3QbbX9", @"数量是%ld的倍数"), model.goodModel.productCatDTO.batchNumber];
                    self.selectBTN.enabled = NO;
                } else {
                    self.tipsLabel.hidden = YES;
                    if (model.tempSelected && !model.isSelected) {
                        self.selectBTN.enabled = NO;
                    } else {
                        self.selectBTN.enabled = YES;
                    }
                }
            }
        } else {
            //缺货
            self.outOfStockTipsLabel.hidden = NO;
            self.deleteBTN.hidden = NO;
            self.countView.hidden = YES;
            self.tipsLabel.hidden = YES;
            self.selectBTN.enabled = NO;
        }

    } else {
        //商品下架
        self.countView.hidden = YES;
        self.outOfStockTipsLabel.hidden = YES;
        self.tipsLabel.hidden = YES;
        self.deleteBTN.hidden = YES;
        self.selectBTN.enabled = NO;
    }

    [self setNeedsUpdateConstraints];
}
#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.iconIV);
        make.size.mas_equalTo(self.selectBTN.bounds.size);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(25), kRealWidth(25)));
        make.left.equalTo(self.selectBTN.mas_right);
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
    }];

    [self.specLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    }];

    if (self.model.availableStock.integerValue > 0) {
        [self.salePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.specLB);
            if (!self.countView.isHidden) {
                make.centerY.equalTo(self.countView);
            } else {
                make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(12));
            }
            if (self.countView.isHidden && self.tipsLabel.isHidden) {
                make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
            }
        }];
        if (!self.countView.isHidden) {
            [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(10));
                make.right.equalTo(self.contentView).offset(-kRealWidth(15));
                make.height.mas_equalTo(kRealWidth(23));
                if (self.tipsLabel.isHidden) {
                    make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
                }
            }];
        }

        if (!self.tipsLabel.isHidden) {
            [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.countView.mas_bottom).offset(kRealWidth(5));
                make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
                make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
            }];
        }
    } else {
        [self.deleteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(20));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
        [self.salePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.specLB);
            make.centerY.equalTo(self.deleteBTN.mas_centerY).offset(-kRealWidth(8));
        }];

        [self.outOfStockTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.specLB);
            make.top.equalTo(self.salePriceLB.mas_bottom).offset(kRealWidth(5));
        }];
    }

    [super updateConstraints];
}
#pragma mark - lazy load
- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
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
        imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)specLB {
    if (!_specLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.TinhNowFont.standard12;
        label.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        label.numberOfLines = 2;
        _specLB = label;
    }
    return _specLB;
}

- (SALabel *)salePriceLB {
    if (!_salePriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.TinhNowFont.standard15;
        label.textColor = HDAppTheme.TinhNowColor.cFF2323;
        label.numberOfLines = 1;
        _salePriceLB = label;
    }
    return _salePriceLB;
}
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.TinhNowFont fontRegular:10];
        label.textColor = HDAppTheme.TinhNowColor.cFF2323;
        label.numberOfLines = 2;
        _tipsLabel = label;
    }
    return _tipsLabel;
}
- (SALabel *)outOfStockTipsLabel {
    if (!_outOfStockTipsLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.TinhNowFont fontRegular:10];
        label.textColor = HDAppTheme.TinhNowColor.cFF2323;
        label.numberOfLines = 2;
        label.text = TNLocalizedString(@"tn_out_of_stock_now", @"暂时缺货");
        _outOfStockTipsLabel = label;
    }
    return _outOfStockTipsLabel;
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
            self.oldCount = count;
        };
        self.oldCount = _countView.count;
    }
    return _countView;
}
- (SAOperationButton *)deleteBTN {
    if (!_deleteBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.titleEdgeInsets = UIEdgeInsetsMake(3, 15, 3, 15);
        [button setTitle:TNLocalizedString(@"tn_delete", @"删除") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedDeleteBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        [button sizeToFit];
        _deleteBTN = button;
    }
    return _deleteBTN;
}
@end
