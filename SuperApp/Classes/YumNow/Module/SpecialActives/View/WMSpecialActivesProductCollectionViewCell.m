//
//  WMSpecialActivesProductCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesProductCollectionViewCell.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "WMManage.h"
#import "WMSpecialActivesProductModel.h"


@interface WMSpecialActivesProductCollectionViewCell ()
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
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 门店名
@property (nonatomic, strong) UILabel *storeNameLB;
/// 打分
@property (nonatomic, strong) HDUIButton *scoreBtn;
/// 商品优惠标签
@property (nonatomic, strong) SALabel *promotionnLB;
/// 休息中遮罩层
@property (nonatomic, strong) UIView *restView;
/// 休息中图标
@property (nonatomic, strong) HDUIButton *restBTN;
/// 休息中文本
@property (nonatomic, strong) SALabel *restLB;

@end


@implementation WMSpecialActivesProductCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.bgIV];
    [self.containerView addSubview:self.productNameLB];
    [self.containerView addSubview:self.soldAndTimeLB];
    [self.containerView addSubview:self.priceLB];
    [self.containerView addSubview:self.originalPriceLB];
    [self.containerView addSubview:self.logoIV];
    [self.containerView addSubview:self.storeNameLB];
    [self.containerView addSubview:self.scoreBtn];
    [self.containerView addSubview:self.promotionnLB];
    [self.bgIV addSubview:self.restView];
    [self.restView addSubview:self.restBTN];
    [self.restView addSubview:self.restLB];
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
        make.right.equalTo(self.containerView.mas_right).offset(-self.model.contentEdgeInsets.right);
        make.top.equalTo(self.bgIV.mas_bottom).offset(kRealWidth(8));
    }];
    [self.soldAndTimeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.model.contentEdgeInsets.left);
        make.right.equalTo(self.containerView.mas_right).offset(-self.model.contentEdgeInsets.right);
        make.top.equalTo(self.productNameLB.mas_bottom).offset(kRealWidth(5));
    }];
    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.model.contentEdgeInsets.left);
        make.top.equalTo(self.soldAndTimeLB.mas_bottom).offset(kRealWidth(8));
    }];
    [self.originalPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self.priceLB.mas_centerY);
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(self.model.contentEdgeInsets.left);
        make.top.equalTo(self.priceLB.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-self.model.contentEdgeInsets.bottom);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
    }];

    [self.storeNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.containerView.mas_right).offset(-self.model.contentEdgeInsets.right);
        make.top.equalTo(self.logoIV.mas_top);
    }];
    [self.scoreBtn sizeToFit];
    [self.scoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(5));
        make.bottom.equalTo(self.logoIV.mas_bottom);
        make.size.mas_equalTo(self.scoreBtn.frame.size);
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

    [super updateConstraints];
}

- (void)setModel:(WMSpecialActivesProductModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.photo placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(170), kRealWidth(170))] imageView:self.bgIV];
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:CGSizeMake(kRealWidth(30), kRealWidth(30))] imageView:self.logoIV];
    self.productNameLB.text = model.name.desc;
    self.soldAndTimeLB.text = [NSString stringWithFormat:@"%@ %@ • %@%@", WMLocalizedString(@"wm_sold", @"Sold"), model.sold, model.deliveryTime, @"min"];
    self.priceLB.text = model.showPrice.thousandSeparatorAmount;
    self.storeNameLB.text = model.storeName.desc;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"%@", model.reviewScore] forState:UIControlStateNormal];

    NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.standard3,
        NSForegroundColorAttributeName: HDAppTheme.color.G3,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.color.G3
    }];
    self.originalPriceLB.attributedText = priceStr;

    // 优惠显示字符串
    NSString *preferentialText = [WMStoreGoodsPromotionModel preferentialLabelTextWithProductPromotions:model.productPromotion];
    self.promotionnLB.hidden = preferentialText == nil;
    self.promotionnLB.text = preferentialText;
    self.restView.hidden = YES;
    self.restBTN.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
    ///下次营业时间
    if (self.model.nextServiceTime) {
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
                }
            }
            [self.restBTN setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self.restBTN setTitle:str forState:UIControlStateNormal];
        }
    }

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
        _productNameLB.textColor = HDAppTheme.color.G1;
        _productNameLB.font = [HDAppTheme.WMFont wm_boldForSize:14];
        _productNameLB.numberOfLines = 2;
    }
    return _productNameLB;
}
/** @lazy soldAndTime */
- (UILabel *)soldAndTimeLB {
    if (!_soldAndTimeLB) {
        _soldAndTimeLB = [[UILabel alloc] init];
        _soldAndTimeLB.textColor = HDAppTheme.color.G2;
        _soldAndTimeLB.font = HDAppTheme.font.standard4;
    }
    return _soldAndTimeLB;
}
/** @lazy priceLB */
- (UILabel *)priceLB {
    if (!_priceLB) {
        _priceLB = [[UILabel alloc] init];
        _priceLB.font = HDAppTheme.font.standard2Bold;
        _priceLB.textColor = HDAppTheme.WMColor.mainRed;
    }
    return _priceLB;
}
/** @lazy logoIV */
- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] init];
        _logoIV.contentMode = UIViewContentModeScaleToFill;
        _logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(2);
            view.layer.masksToBounds = YES;
        };
    }
    return _logoIV;
}
/** @lazy storenamelb */
- (UILabel *)storeNameLB {
    if (!_storeNameLB) {
        _storeNameLB = [[UILabel alloc] init];
        _storeNameLB.textColor = HDAppTheme.color.G1;
        _storeNameLB.font = [HDAppTheme.WMFont wm_boldForSize:12];
    }
    return _storeNameLB;
}
/** @lazy scorebtn */
- (HDUIButton *)scoreBtn {
    if (!_scoreBtn) {
        _scoreBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_scoreBtn setImage:[UIImage imageNamed:@"yn_home_star"] forState:UIControlStateNormal];
        [_scoreBtn setImagePosition:HDUIButtonImagePositionLeft];
        _scoreBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, kRealWidth(5));
        [_scoreBtn setTitleColor:HDAppTheme.WMColor.B6 forState:UIControlStateNormal];
        _scoreBtn.titleLabel.font = HDAppTheme.font.standard4;
        _scoreBtn.userInteractionEnabled = NO;
    }
    return _scoreBtn;
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

@end
