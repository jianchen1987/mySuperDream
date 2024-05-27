//
//  WMNewSpecialActivesProductCollectionViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/8/1.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewSpecialActivesProductCollectionViewCell.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMManage.h"
#import "WMSpecialActivesProductModel.h"
#import "SAView.h"


@interface WMNewSpecialActivesProductShopView : SAView
;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *shopLabel;

@end


@implementation WMNewSpecialActivesProductShopView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    [self addSubview:self.iconView];
    [self addSubview:self.shopLabel];
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [self.shopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(2);
        make.right.mas_equalTo(-4);
        make.centerY.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_special_actives_delicacy_shop"]];
    }
    return _iconView;
}

- (UILabel *)shopLabel {
    if (!_shopLabel) {
        _shopLabel = UILabel.new;
        _shopLabel.textColor = UIColor.whiteColor;
        _shopLabel.font = HDAppTheme.font.sa_standard11;
    }
    return _shopLabel;
}

@end


@interface WMNewSpecialActivesProductCollectionViewCell ()
/// container
@property (nonatomic, strong) UIView *containerView;
/// 图片
@property (nonatomic, strong) UIImageView *bgIV;
/// 商品名称
@property (nonatomic, strong) UILabel *productNameLB;
/// 销量和配送时间
@property (nonatomic, strong) UILabel *soldAndTimeLB;
/// 价格
@property (nonatomic, strong) UILabel *priceLB;
/// 原价
@property (nonatomic, strong) SALabel *originalPriceLB;
/// 店铺view
@property (nonatomic, strong) WMNewSpecialActivesProductShopView *shopView;
/// 商品优惠标签
@property (nonatomic, strong) SALabel *promotionnLB;
/// 休息中遮罩层
@property (nonatomic, strong) UIView *restView;
/// 休息中图标
@property (nonatomic, strong) HDUIButton *restBTN;
/// 休息中文本
@property (nonatomic, strong) SALabel *restLB;

/// 配送时间和距离
@property (nonatomic, strong) HDUIGhostButton *deliveryTimeAndDistanceLB;

@end


@implementation WMNewSpecialActivesProductCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.bgIV];
    [self.containerView addSubview:self.productNameLB];
    [self.containerView addSubview:self.deliveryTimeAndDistanceLB];
    [self.containerView addSubview:self.soldAndTimeLB];
    [self.containerView addSubview:self.priceLB];
    [self.containerView addSubview:self.originalPriceLB];
    [self.containerView addSubview:self.promotionnLB];
    [self.bgIV addSubview:self.shopView];
    [self.bgIV addSubview:self.restView];
    [self.restView addSubview:self.restBTN];
    [self.restView addSubview:self.restLB];
    
    [self.deliveryTimeAndDistanceLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.deliveryTimeAndDistanceLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.equalTo(self.containerView.mas_width);
    }];
    [self.productNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.model.contentEdgeInsets.left);
        make.right.equalTo(self.deliveryTimeAndDistanceLB.mas_left).offset(-self.model.contentEdgeInsets.right);
        make.top.equalTo(self.bgIV.mas_bottom).offset(kRealWidth(8));
    }];
    
    [self.deliveryTimeAndDistanceLB sizeToFit];
    [self.deliveryTimeAndDistanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productNameLB.mas_top).offset(2);
        make.right.equalTo(self.containerView).offset(-self.model.contentEdgeInsets.right);
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.model.contentEdgeInsets.left);
        make.top.equalTo(self.productNameLB.mas_bottom).offset(kRealWidth(8));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-self.model.contentEdgeInsets.bottom);
    }];
    [self.originalPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self.priceLB.mas_centerY);
    }];

    [self.soldAndTimeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-self.model.contentEdgeInsets.right);
        make.centerY.equalTo(self.priceLB);
    }];

    [self.promotionnLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionnLB.isHidden) {
            make.left.top.equalTo(self.bgIV);
            make.height.mas_equalTo(18);
        }
    }];

    [self.restView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restView.isHidden) {
            if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
                make.edges.equalTo(self.bgIV);
            } else {
                make.bottom.left.right.mas_equalTo(0);
            }
        }
    }];

    [self.restBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restBTN.isHidden) {
            make.centerX.mas_equalTo(0);
            if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
                make.top.mas_equalTo(kRealWidth(60));
                make.height.mas_greaterThanOrEqualTo(kRealWidth(30));
            } else {
                if (self.restLB.isHidden) {
                    make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
                    make.top.bottom.mas_equalTo(0);
                } else {
                    make.top.mas_equalTo(kRealWidth(5));
                }
            }
        }
    }];

    [self.restLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restLB.isHidden) {
            if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
                make.top.equalTo(self.restBTN.mas_bottom).offset(kRealWidth(4));
                make.left.mas_equalTo(2);
                make.right.mas_equalTo(-2);
            } else {
                make.left.mas_equalTo(2);
                make.right.mas_equalTo(-2);
                make.top.equalTo(self.restBTN.mas_bottom).offset(kRealHeight(3));
                make.bottom.mas_equalTo(-5);
            }
        }
    }];

    [self.shopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(-4);
    }];

    [super updateConstraints];
}

- (void)setModel:(WMSpecialActivesProductModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.photo placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(170), kRealWidth(170))] imageView:self.bgIV];
    self.productNameLB.text = model.name.desc;
    self.soldAndTimeLB.text = [NSString stringWithFormat:@"%@ %@", WMLocalizedString(@"wm_sold", @"Sold"), model.sold];
    self.priceLB.text = model.showPrice.thousandSeparatorAmount;
    self.shopView.shopLabel.text = model.storeName.desc;
    NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.sa_standard12,
        NSForegroundColorAttributeName: UIColor.sa_searchBarTextColor,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: UIColor.sa_searchBarTextColor
    }];
    self.originalPriceLB.attributedText = priceStr;

    // 优惠显示字符串
    NSString *preferentialText = [WMStoreGoodsPromotionModel preferentialLabelTextWithProductPromotions:model.productPromotion];
    self.promotionnLB.hidden = preferentialText == nil;
    self.promotionnLB.text = preferentialText;
    self.restView.hidden = YES;
    self.restBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];

    self.shopView.hidden = NO;
    ///下次营业时间
    if (self.model.nextServiceTime) {
        self.shopView.hidden = YES;
        self.restView.backgroundColor = [UIColor colorWithRed:48 / 255.0 green:80 / 255.0 blue:157 / 255.0 alpha:0.9];
        self.restLB.hidden = self.restView.hidden = NO;
        self.restLB.text = [NSString stringWithFormat:@"%@ %@ %@",
                                                      WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                                      self.model.nextServiceTime.weekday.message ? WMManage.shareInstance.weekInfo[self.model.nextServiceTime.weekday.code] : @"",
                                                      self.model.nextServiceTime.time ?: @""];
        [self.restBTN setImage:[UIImage imageNamed:@"home_rest"] forState:UIControlStateNormal];
        [self.restBTN setTitle:WMLocalizedString(@"cart_resting", @"休息中") forState:UIControlStateNormal];
    } else {
        ///爆单
        if (self.model.fullOrderState == WMStoreFullOrderStateFull || self.model.fullOrderState == WMStoreFullOrderStateFullAndStop || self.model.slowMealState == WMStoreSlowMealStateSlow) {
            self.restView.hidden = NO;
            self.restView.backgroundColor = [UIColor hd_colorWithHexString:@"B3333333"];
            NSString *imageName = nil;
            NSString *str = nil;
            if (self.model.fullOrderState == WMStoreFullOrderStateFull) {
                imageName = @"yn_home_full_busy";
                str = WMLocalizedString(@"wm_store_busy", @"繁忙");
                self.restLB.hidden = YES;
                self.restView.hidden = YES;
            } else if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
                str = WMLocalizedString(@"wm_store_busy", @"繁忙");
                imageName = @"yn_home_full_busy_big";
                self.restView.backgroundColor = [UIColor hd_colorWithHexString:@"B3000000"];
                self.restLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_before", @"%@分钟后可下单"), @"30"];
                self.restBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:20];
                self.restLB.hidden = NO;
            } else {
                if (self.model.slowMealState == WMStoreSlowMealStateSlow) {
                    str = WMLocalizedString(@"wm_store_many_order", @"订单较多");
                    imageName = @"yn_home_full_order";
                    self.restLB.hidden = YES;
                    self.restView.hidden = YES;
                }
            }
            [self.restBTN setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self.restBTN setTitle:str forState:UIControlStateNormal];
        }
    }
    
    NSString *deliveryTime = model.deliveryTime;
    if (model.estimatedDeliveryTime) {
        if (model.estimatedDeliveryTime.integerValue > 60) {
            deliveryTime = @">60";
        } else {
            deliveryTime = model.estimatedDeliveryTime;
        }
    }
    [self.deliveryTimeAndDistanceLB setTitle:[NSString stringWithFormat:@"%@min", deliveryTime] forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(4);
            view.clipsToBounds = YES;
        };
    }
    return _containerView;
}
/** @lazy bgiv */
- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] init];
        _bgIV.contentMode = UIViewContentModeScaleAspectFill;
        _bgIV.clipsToBounds = YES;
        _bgIV.backgroundColor = [UIColor hd_colorWithHexString:@"#f5f7fa"];
    }
    return _bgIV;
}
/** @lazy productNameLB */
- (UILabel *)productNameLB {
    if (!_productNameLB) {
        _productNameLB = [[UILabel alloc] init];
        _productNameLB.textColor = UIColor.sa_C333;
        _productNameLB.font = HDAppTheme.font.sa_standard14;
        _productNameLB.numberOfLines = 2;
    }
    return _productNameLB;
}
/** @lazy soldAndTime */
- (UILabel *)soldAndTimeLB {
    if (!_soldAndTimeLB) {
        _soldAndTimeLB = [[UILabel alloc] init];
        _soldAndTimeLB.textColor = UIColor.sa_C999;
        _soldAndTimeLB.font = HDAppTheme.font.sa_standard11;
    }
    return _soldAndTimeLB;
}
/** @lazy priceLB */
- (UILabel *)priceLB {
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = HDAppTheme.font.sa_standard14B;
        _priceLB.textColor = HDAppTheme.WMColor.mainRed;
    }
    return _priceLB;
}

- (WMNewSpecialActivesProductShopView *)shopView {
    if (!_shopView) {
        _shopView = WMNewSpecialActivesProductShopView.new;
        _shopView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _shopView;
}

- (SALabel *)originalPriceLB {
    if (!_originalPriceLB) {
        _originalPriceLB = [[SALabel alloc] init];
    }
    return _originalPriceLB;
}

- (SALabel *)promotionnLB {
    if (!_promotionnLB) {
        _promotionnLB = [[SALabel alloc] init];
        _promotionnLB.font = HDAppTheme.font.standard4;
        _promotionnLB.textColor = UIColor.whiteColor;
        _promotionnLB.hd_edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _promotionnLB.backgroundColor = HDAppTheme.WMColor.mainRed;
        _promotionnLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:5];
        };
    }
    return _promotionnLB;
}

- (UIView *)restView {
    if (!_restView) {
        _restView = UIView.new;
        _restView.backgroundColor = [UIColor colorWithRed:48 / 255.0 green:80 / 255.0 blue:157 / 255.0 alpha:0.9];
    }
    return _restView;
}

- (HDUIButton *)restBTN {
    if (!_restBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"home_rest"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:WMLocalizedString(@"cart_resting", @"休息中") forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard4Bold;
        button.spacingBetweenImageAndTitle = kRealWidth(4);
        button.userInteractionEnabled = false;
        _restBTN = button;
    }
    return _restBTN;
}

- (SALabel *)restLB {
    if (!_restLB) {
        _restLB = SALabel.new;
        _restLB.textAlignment = NSTextAlignmentCenter;
        _restLB.textColor = UIColor.whiteColor;
        _restLB.font = [HDAppTheme.WMFont wm_ForSize:11];
    }
    return _restLB;
}

- (HDUIGhostButton *)deliveryTimeAndDistanceLB {
    if (!_deliveryTimeAndDistanceLB) {
        HDUIGhostButton *button = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B9 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button setImage:[UIImage imageNamed:@"yn_home_store_time"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 3, 3);
        button.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 3, 3);
        button.userInteractionEnabled = false;
        _deliveryTimeAndDistanceLB = button;
    }
    return _deliveryTimeAndDistanceLB;
}
@end
