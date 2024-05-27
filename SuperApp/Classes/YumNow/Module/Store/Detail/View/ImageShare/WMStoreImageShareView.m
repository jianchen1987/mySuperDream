//
//  WMStoreImageShareView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreImageShareView.h"
#import "GNTheme.h"
#import "SAAddressModel.h"
#import "SAAppEnvManager.h"
#import "SACacheManager.h"
#import "SAShareManager.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreDetailRspModel.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDWebImageManager.h>
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "SAAddressCacheAdaptor.h"

@interface WMStoreImageShareView ()

/// 背景图
@property (nonatomic, strong) UIImageView *bgIV;
/// logo、标题所在视图
@property (nonatomic, strong) UIView *topView;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
/// 标题
@property (nonatomic, strong) UIImageView *topTitleLB;
/// 门店logo
@property (nonatomic, strong) UIImageView *storeLogoIV;
/// 门店名称
@property (nonatomic, strong) UILabel *storeNameLB;
/// 描述
@property (nonatomic, strong) UIStackView *descLB;
/// 描述
@property (nonatomic, strong) UIView *descBg;
/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
/// 底部文字
@property (nonatomic, strong) UILabel *bottomLB;
/// 底部文字
@property (nonatomic, strong) HDLabel *bottomEnjoy;
/// 二维码底图
@property (nonatomic, strong) UIView *qrCodeView;
/// 二维码
@property (nonatomic, strong) UIImageView *qrCodeIV;
/// detailLB
@property (nonatomic, strong) YYLabel *detailLB;
/// 模型
@property (nonatomic, strong) WMStoreDetailRspModel *model;
@end


@implementation WMStoreImageShareView

+ (instancetype)storeImageShareWithModel:(WMStoreDetailRspModel *)detailModel activityModel:(WMStoreActivityMdoel *)activityModel {
    WMStoreImageShareView *shareAlertView = [[WMStoreImageShareView alloc] init];
    [shareAlertView setupViews];
    shareAlertView.activityModel = activityModel;
    shareAlertView.model = detailModel;
    return shareAlertView;
}

- (void)setupViews {
    [self addSubview:self.bgIV];
    [self addSubview:self.topView];
    [self.topView addSubview:self.logoIV];
    //    [self.topView addSubview:self.topTitleLB];
    [self addSubview:self.storeLogoIV];
    [self addSubview:self.storeNameLB];
    [self addSubview:self.detailLB];
    [self addSubview:self.descBg];
    [self.descBg addSubview:self.descLB];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLB];
    [self.bottomView addSubview:self.bottomEnjoy];
    [self.bottomView addSubview:self.qrCodeView];
    [self.qrCodeView addSubview:self.qrCodeIV];
}

- (void)updateLayout {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
        make.width.mas_equalTo(295 * kScreenWidth / 375.0);
        make.height.equalTo(self.bgIV.mas_width).multipliedBy(412.0 / 295.0);
    }];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(0);
    }];
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(16));
        make.top.mas_equalTo(kRealWidth(19));
        make.size.mas_equalTo(self.logoIV.image.size);
        make.bottom.mas_equalTo(0);
    }];
    //    [self.topTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.logoIV);
    //        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(9));
    //        make.size.mas_equalTo(self.topTitleLB.image.size);
    //        make.bottom.mas_equalTo(0);
    //    }];
    [self.storeLogoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(10));
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(kRealWidth(66));
    }];
    [self.storeNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeLogoIV.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeNameLB.mas_bottom).offset(kRealWidth(2));
        make.left.equalTo(self).offset(kRealWidth(16));
        make.right.mas_equalTo(-kRealWidth(16));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    self.descBg.hidden = HDIsArrayEmpty(self.descLB.arrangedSubviews);
    [self.descBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLB.mas_bottom).offset(4);
        make.left.equalTo(self).offset(kRealWidth(13));
        make.right.mas_equalTo(-kRealWidth(13));
    }];

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(12));
        make.left.mas_equalTo(0);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
    }];

    [self.bottomLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeView.mas_top).offset(kRealWidth(6));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.left.equalTo(self).offset(kRealWidth(16));
    }];

    [self.bottomEnjoy mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLB.mas_bottom).offset(kRealWidth(6));
        make.height.mas_equalTo(kRealWidth(16));
        make.left.equalTo(self.bottomLB);
    }];

    [self.qrCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-13);
        make.right.mas_equalTo(-kRealWidth(16));
    }];

    [self.qrCodeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(4));
        make.bottom.right.mas_equalTo(-kRealWidth(4));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(48), kRealWidth(48)));
    }];
}

#pragma mark - setter
- (void)setModel:(WMStoreDetailRspModel *)model {
    _model = model;
    UIImage *placeholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G4 cornerRadius:0 size:CGSizeMake(kRealWidth(90), kRealWidth(90))
                                                            logoImage:[UIImage imageNamed:@"icon_store_placeholder"]
                                                             logoSize:CGSizeMake(kRealWidth(50), kRealWidth(50))];
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:placeholderImage imageView:self.storeLogoIV];
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:[NSUserDefaults.standardUserDefaults objectForKey:@"wm_imagePath"]] placeholderImage:[UIImage imageNamed:@"yn_share_bg"]];
    self.storeNameLB.text = model.storeName.desc;
    //    SAAddressModel *addressModel = [SACacheManager.shared objectForKey:kCacheKeyYumNowUserChoosedCurrentAddress type:SACacheTypeDocumentPublic];

    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    NSString *language = @"en";
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        language = @"zh";
    } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
        language = @"km";
    }
    NSString *routePath = [NSString stringWithFormat:@"SuperApp://YumNow/storeDetail?storeNo=%@", model.storeNo];
    NSString *encodeRoutePath = [routePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?="].invertedSet];
    NSString *qrCodeUrl = [NSString stringWithFormat:@"%@?storeNo=%@&lon=%@&lat=%@&fromId=%@&routePath=%@&language=%@",
                                                     model.shareLink,
                                                     model.storeNo,
                                                     addressModel.lon.stringValue,
                                                     addressModel.lat.stringValue,
                                                     [[SAUser shared] operatorNo] ?: @"",
                                                     encodeRoutePath,
                                                     language];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:qrCodeUrl size:CGSizeMake(58, 58) level:HDInputCorrectionLevelL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrCodeIV.image = qrCodeImage;
        });
    });
    [self updateDetailContent];
    [self updateDescLabelContent];
    [self updateLayout];
}

#pragma mark - private methods

- (void)updateDetailContent {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:14];

    NSAttributedString *point = [[NSAttributedString alloc] initWithString:@" · " attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];

    /// 拼接分数
    if (self.model.reviewScore <= 0) {
        NSAttributedString *scoreStr = [[NSAttributedString alloc] initWithString:WMLocalizedString(@"wm_no_ratings_yet", @"暂无评分")
                                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];
        [text appendAttributedString:scoreStr];
    } else {
        UIImage *image = [UIImage imageNamed:@"yn_share_rate"];
        NSAttributedString *attachText = [NSAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeLeft attachmentSize:image.size alignToFont:font
                                                                                  alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];

        NSString *score = [NSString stringWithFormat:@" %.1f", self.model.reviewScore];
        NSAttributedString *scoreStr = [[NSAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];
        [text appendAttributedString:scoreStr];
    }
    [text appendAttributedString:point];

    /// 拼接品类
    NSString *categories;
    if ([self.model.businessScopesV2 isKindOfClass:NSArray.class] && self.model.businessScopesV2.count) {
        NSArray<NSString *> *scopes = [self.model.businessScopesV2 mapObjectsUsingBlock:^id _Nonnull(IficationModel *_Nonnull obj, NSUInteger idx) {
            if (idx < 2) {
                return obj.classificationName ?: @"";
            } else {
                return nil;
            }
        }];
        categories = [scopes componentsJoinedByString:@"、"];
    }
    if (categories) {
        NSMutableAttributedString *categoriesStr = [[NSMutableAttributedString alloc] initWithString:categories
                                                                                          attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];
        [text appendAttributedString:categoriesStr];
    }

    ///备餐时间
    if (true) {
        [text appendAttributedString:point];
        UIImage *image = [UIImage imageNamed:@"yn_share_buinesstime"];
        NSAttributedString *attachText = [NSAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeLeft attachmentSize:image.size alignToFont:font
                                                                                  alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        NSString *distanceAndTimeStr = [NSString stringWithFormat:@"%zdmins", self.model.deliveryTime];
        NSMutableAttributedString *categoriesStr = [[NSMutableAttributedString alloc] initWithString:distanceAndTimeStr
                                                                                          attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];
        [text appendAttributedString:categoriesStr];
    }
    self.detailLB.attributedText = text;
    self.detailLB.textAlignment = NSTextAlignmentCenter;
}

- (void)updateDescLabelContent {
    if (self.activityModel) {
        ///商品优惠
        if (!HDIsArrayEmpty(self.activityModel.productDiscountItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = WMLocalizedString(@"item_discount", @"");
            NSArray *arr = [self.activityModel.productDiscountItems mapObjectsUsingBlock:^id _Nonnull(WMShareProductDiscountItems *_Nonnull obj, NSUInteger idx) {
                if (SAMultiLanguageManager.isCurrentLanguageCN) {
                    return obj.activityTitleZh;
                } else if (SAMultiLanguageManager.isCurrentLanguageEN) {
                    return obj.activityTitleEn;
                } else {
                    return obj.activityTitleCb;
                }
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
        ///爆品
        if (!HDIsArrayEmpty(self.activityModel.bestSaleItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = WMLocalizedString(@"item_discount", @"");
            NSArray *arr = [self.activityModel.bestSaleItems mapObjectsUsingBlock:^id _Nonnull(WMShareProductDiscountItems *_Nonnull obj, NSUInteger idx) {
                if (SAMultiLanguageManager.isCurrentLanguageCN) {
                    return obj.activityTitleZh;
                } else if (SAMultiLanguageManager.isCurrentLanguageEN) {
                    return obj.activityTitleEn;
                } else {
                    return obj.activityTitleCb;
                }
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
        ///减免配送费
        if (!HDIsArrayEmpty(self.activityModel.deliveryFeeItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = WMLocalizedString(@"item_delivery", @"");
            NSArray *arr = [self.activityModel.deliveryFeeItems mapObjectsUsingBlock:^id _Nonnull(WMShareDeliveryFeeItems *_Nonnull obj, NSUInteger idx) {
                if (obj.deliveryFeeAfterDiscount.cent.doubleValue <= 0) {
                    return WMLocalizedString(@"free_delivery", @"");
                } else {
                    return obj.deliveryFeeAfterDiscount.thousandSeparatorAmount;
                }
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
        ///门店满减
        if (!HDIsArrayEmpty(self.activityModel.fullReductionItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = WMLocalizedString(@"item_money_off", @"");
            NSArray *arr = [self.activityModel.fullReductionItems mapObjectsUsingBlock:^id _Nonnull(WMShareFullReductionItems *_Nonnull obj, NSUInteger idx) {
                return [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @""), obj.thresholdAmt.thousandSeparatorAmount, obj.discountAmt.thousandSeparatorAmount];
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
        ///门店首单
        if (!HDIsArrayEmpty(self.activityModel.storeFirstItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = WMLocalizedString(@"item_1st_order", @"");
            NSArray *arr = [self.activityModel.storeFirstItems mapObjectsUsingBlock:^id _Nonnull(WMShareFirstItems *_Nonnull obj, NSUInteger idx) {
                return [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @""), obj.discountAmt.thousandSeparatorAmount];
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
        ///门店优惠券
        if (!HDIsArrayEmpty(self.activityModel.storeCouponItems)) {
            WMStoreShareActivityItemView *itemView = WMStoreShareActivityItemView.new;
            itemView.name = PNLocalizedString(@"coupon_get", @"");
            NSArray *arr = [self.activityModel.storeCouponItems mapObjectsUsingBlock:^id _Nonnull(WMShareStoreCouponItems *_Nonnull obj, NSUInteger idx) {
                return [NSString stringWithFormat:WMLocalizedString(@"item_get_coupon", @""), obj.faceValue.thousandSeparatorAmount];
            }];
            itemView.detail = [arr componentsJoinedByString:@" "];
            [self.descLB addArrangedSubview:itemView];
        }
    }
}

#pragma mark - lazy load
- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.layer.cornerRadius = kRealWidth(8);
        _bgIV.contentMode = UIViewContentModeScaleAspectFill;
        _bgIV.clipsToBounds = YES;
    }
    return _bgIV;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
    }
    return _topView;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = UIImageView.new;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _logoIV.image = [UIImage imageNamed:@"yn_share_logo_zh"];
        } else {
            _logoIV.image = [UIImage imageNamed:@"yn_share_logo_en"];
        }
    }
    return _logoIV;
}

- (UIImageView *)topTitleLB {
    if (!_topTitleLB) {
        _topTitleLB = UIImageView.new;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            _topTitleLB.image = [UIImage imageNamed:@"yn_share_title_zh"];
        } else if (SAMultiLanguageManager.isCurrentLanguageEN) {
            _topTitleLB.image = [UIImage imageNamed:@"yn_share_title_en"];
        } else {
            _topTitleLB.image = [UIImage imageNamed:@"yn_share_title_km"];
        }
    }
    return _topTitleLB;
}

- (UIImageView *)storeLogoIV {
    if (!_storeLogoIV) {
        _storeLogoIV = UIImageView.new;
        _storeLogoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = CGRectGetHeight(precedingFrame) * 0.5;
            view.layer.borderColor = UIColor.whiteColor.CGColor;
            view.layer.borderWidth = kRealWidth(2.6);
        };
        _storeLogoIV.clipsToBounds = YES;
        _storeLogoIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _storeLogoIV;
}

- (UILabel *)storeNameLB {
    if (!_storeNameLB) {
        _storeNameLB = UILabel.new;
        _storeNameLB.numberOfLines = 2;
        _storeNameLB.textColor = HDAppTheme.WMColor.B3;
        _storeNameLB.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _storeNameLB.textAlignment = NSTextAlignmentCenter;
    }
    return _storeNameLB;
}

- (YYLabel *)detailLB {
    if (!_detailLB) {
        _detailLB = YYLabel.new;
        _detailLB.numberOfLines = 2;
        _detailLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            ((YYLabel *)view).preferredMaxLayoutWidth = CGRectGetWidth(precedingFrame);
        };
    }
    return _detailLB;
}

- (UIStackView *)descLB {
    if (!_descLB) {
        _descLB = UIStackView.new;
        _descLB.axis = UILayoutConstraintAxisVertical;
        _descLB.spacing = 8;
    }
    return _descLB;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
    }
    return _bottomView;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = UILabel.new;
        _bottomLB.text = WMLocalizedString(@"wm_store_share_scanenter", @"Scan to enter");
        _bottomLB.textColor = HDAppTheme.WMColor.B3;
        _bottomLB.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        _bottomLB.numberOfLines = 2;
    }
    return _bottomLB;
}

- (HDLabel *)bottomEnjoy {
    if (!_bottomEnjoy) {
        _bottomEnjoy = HDLabel.new;
        _bottomEnjoy.textColor = UIColor.whiteColor;
        _bottomEnjoy.font = [HDAppTheme.WMFont wm_ForSize:10];
        _bottomEnjoy.text = WMLocalizedString(@"wm_store_share_enjoy", @"Enjoy Delicious");
        _bottomEnjoy.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(7), kRealWidth(4), kRealWidth(7));
        _bottomEnjoy.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(2);
            view.layer.backgroundColor =
                [HDAppTheme.color gn_ColorGradientChangeWithSize:precedingFrame.size direction:GNGradientChangeDirectionLevel colors:@[HexColor(0xFE4374), HDAppTheme.WMColor.mainRed]].CGColor;
        };
    }
    return _bottomEnjoy;
}

- (UIView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = UIView.new;
        _qrCodeView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        _qrCodeView.layer.borderWidth = 1;
        _qrCodeView.layer.borderColor = HDAppTheme.WMColor.B3.CGColor;
    }
    return _qrCodeView;
}

- (UIView *)descBg {
    if (!_descBg) {
        _descBg = UIView.new;
        _descBg.layer.cornerRadius = kRealWidth(4);
        _descBg.layer.backgroundColor = UIColor.whiteColor.CGColor;
    }
    return _descBg;
}

- (UIImageView *)qrCodeIV {
    if (!_qrCodeIV) {
        _qrCodeIV = UIImageView.new;
    }
    return _qrCodeIV;
}

@end


@interface WMStoreShareActivityItemView ()
@property (nonatomic, strong) HDLabel *statusLB;
@property (nonatomic, strong) HDLabel *detailLB;
@end


@implementation WMStoreShareActivityItemView

- (void)hd_setupViews {
    [self addSubview:self.statusLB];
    [self addSubview:self.detailLB];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(16));
        make.top.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.top.mas_equalTo(0);
        make.left.equalTo(self.statusLB.mas_right).offset(kRealWidth(10));
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    [self.statusLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.statusLB.text = GNFillEmpty(name);
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    self.detailLB.text = GNFillEmpty(detail);
}

- (HDLabel *)statusLB {
    if (!_statusLB) {
        _statusLB = HDLabel.new;
        _statusLB.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(4), 0, kRealWidth(4));
        _statusLB.textColor = UIColor.whiteColor;
        _statusLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _statusLB.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        _statusLB.layer.cornerRadius = 2;
    }
    return _statusLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        _detailLB = HDLabel.new;
        _detailLB.textColor = HDAppTheme.WMColor.B3;
        _detailLB.numberOfLines = 1;
        _detailLB.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
    }
    return _detailLB;
}

@end
