//
//  TNBatchShopCarProductCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBatchShopCarProductCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"


@interface TNBatchShopCarProductCell ()
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 提示
@property (nonatomic, strong) SALabel *tipsLB;
/// 删除按钮
@property (nonatomic, strong) SAOperationButton *deleteBTN;
///批量标签
@property (nonatomic, strong) HDLabel *mixStagePriceTag;
@end


@implementation TNBatchShopCarProductCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.selectBTN];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.mixStagePriceTag];
    [self.contentView addSubview:self.tipsLB];
    [self.contentView addSubview:self.deleteBTN];
}
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    self.model.tempSelected = !self.model.tempSelected;
    !self.clickedSelectBTNBlock ?: self.clickedSelectBTNBlock();
}
- (void)clickedDeleteBTNHandler {
    !self.clickedDeleteBTNBlock ?: self.clickedDeleteBTNBlock();
}

- (void)setModel:(TNShoppingCarBatchGoodsModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(80, 80)] imageView:self.iconIV];
    self.nameLB.text = model.goodsName;
    self.selectBTN.selected = model.isSelected;
    self.mixStagePriceTag.hidden = !model.productCatDTO.mixWholeSale;
    if (model.goodsState == TNStoreItemStateOffSale) {
        //商品下架了
        self.deleteBTN.hidden = NO;
        self.tipsLB.hidden = NO;
        self.selectBTN.enabled = NO;
        self.tipsLB.text = TNLocalizedString(@"tn_good_no_available", @"商品已下架");
    } else {
        if (!model.isSelected && model.tempSelected) {
            self.selectBTN.enabled = NO;
        } else {
            self.selectBTN.enabled = YES;
        }
        self.deleteBTN.hidden = YES;
        if (!model.isExceedTotalStartQuantity) {
            self.tipsLB.hidden = NO;
            self.tipsLB.text = [NSString stringWithFormat:TNLocalizedString(@"ju2TZTyz", @"商品总数起批量为%ld件"), model.startQuantity];
        } else {
            if (model.showStartQuantityTips) {
                self.tipsLB.hidden = NO;
                self.tipsLB.text = [NSString stringWithFormat:TNLocalizedString(@"ju2TZTyz", @"商品总数起批量为%ld件"), model.startQuantity];
            } else {
                self.tipsLB.hidden = YES;
            }
        }
    }
    [self setNeedsUpdateConstraints];
}
#pragma mark - layout
- (void)updateConstraints {
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(self.selectBTN.bounds.size);
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.left.equalTo(self.selectBTN.mas_right);
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView);
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
        make.right.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
    if (!self.mixStagePriceTag.isHidden) {
        [self.mixStagePriceTag sizeToFit];
        [self.mixStagePriceTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(5));
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
            make.height.mas_equalTo(kRealWidth(15));
        }];
    }
    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
        if (!self.deleteBTN.isHidden) {
            make.right.lessThanOrEqualTo(self.deleteBTN.mas_left).offset(-kRealWidth(5));
        } else {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }

        make.bottom.equalTo(self.iconIV.mas_bottom);
    }];
    [self.deleteBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV.mas_bottom);
        make.right.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
    [self.deleteBTN setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.tipsLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
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

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 2;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)tipsLB {
    if (!_tipsLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.TinhNowColor.cFF2323;
        label.numberOfLines = 2;
        _tipsLB = label;
    }
    return _tipsLB;
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
/** @lazy mixStagePriceTag */
- (HDLabel *)mixStagePriceTag {
    if (!_mixStagePriceTag) {
        _mixStagePriceTag = [[HDLabel alloc] init];
        _mixStagePriceTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _mixStagePriceTag.textColor = HexColor(0xFF2323);
        _mixStagePriceTag.backgroundColor = [UIColor whiteColor];
        _mixStagePriceTag.textAlignment = NSTextAlignmentCenter;
        _mixStagePriceTag.text = TNLocalizedString(@"tn_mix_batch", @"混批");
        _mixStagePriceTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _mixStagePriceTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (HDIsArrayEmpty(view.layer.sublayers)) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:2 borderWidth:0.5 borderColor:HexColor(0xFF2323)];
            }
        };
    }
    return _mixStagePriceTag;
}
@end
