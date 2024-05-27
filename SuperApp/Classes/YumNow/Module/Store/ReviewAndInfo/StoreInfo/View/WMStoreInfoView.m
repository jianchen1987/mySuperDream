//
//  WMStoreInfoView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreInfoView.h"
#import "GNEvent.h"


@interface WMStoreInfoView ()

@end


@implementation WMStoreInfoView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.bgView];
    [self.bgView addSubview:self.headerView];
    self.bgView.hidden = YES;
    [self addNormalView];
    [self hd_beginSkeletonAnimation];
}

- (void)addNormalView {
    [self.bgView addSubview:self.promotionsTitleLabel];
    [self.bgView addSubview:self.promotionsBgView];
    [self.promotionsBgView addSubview:self.giveCouponItemView];
    [self.promotionsBgView addSubview:self.lessItemView];
    [self.promotionsBgView addSubview:self.offItemView];
    [self.promotionsBgView addSubview:self.couponItemView];
    [self.promotionsBgView addSubview:self.deliveryItemView];
    [self.promotionsBgView addSubview:self.firstItemView];
    [self.promotionsBgView addSubview:self.fillGiftView];

    [self.bgView addSubview:self.noticeTitleLabel];
    [self.bgView addSubview:self.noticeLabel];
    [self.bgView addSubview:self.noticeLine];
    [self.bgView addSubview:self.businessIconView];
    [self.bgView addSubview:self.businessTitleLabel];
    [self.bgView addSubview:self.businessLabel];
    [self.bgView addSubview:self.businessLine];
    [self.bgView addSubview:self.businessScopesIconView];
    [self.bgView addSubview:self.businessScopesTitleLabel];
    [self.bgView addSubview:self.businessScopesLabel];
    [self.bgView addSubview:self.businessScopesLine];
    [self.bgView addSubview:self.payMethodIconView];
    [self.bgView addSubview:self.payMethodTitleLabel];
    [self.bgView addSubview:self.payMethodLabel];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    _viewModel = viewModel;

    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"repModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.bgView.hidden = NO;
        [self hd_endSkeletonAnimation];
        [self hd_reloadData];
    }];
}

- (void)hd_reloadData {
    self.headerView.viewModel = self.viewModel;

    if (HDIsStringNotEmpty(self.viewModel.notice)) {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self.viewModel.notice];
        mStr.yy_lineSpacing = kRealWidth(4);
        mStr.yy_alignment = NSTextAlignmentLeft;
        self.noticeLabel.attributedText = mStr;
        self.noticeLabel.hidden = NO;
        self.noticeTitleLabel.hidden = NO;
        self.noticeLine.hidden = NO;
    } else {
        self.noticeLine.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.noticeTitleLabel.hidden = YES;
    }

    if (HDIsStringNotEmpty(self.viewModel.businessHours)) {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self.viewModel.businessHours];
        mStr.yy_lineSpacing = kRealWidth(4);
        mStr.yy_alignment = NSTextAlignmentLeft;
        self.businessLabel.attributedText = mStr;
    }

    if (HDIsStringNotEmpty(self.viewModel.cusines)) {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self.viewModel.cusines];
        mStr.yy_lineSpacing = kRealWidth(4);
        mStr.yy_alignment = NSTextAlignmentLeft;
        self.businessScopesLabel.attributedText = mStr;
    }

    if (HDIsStringNotEmpty(self.viewModel.payMethod)) {
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self.viewModel.payMethod];
        mStr.yy_lineSpacing = kRealWidth(4);
        mStr.yy_alignment = NSTextAlignmentLeft;
        self.payMethodLabel.attributedText = mStr;
    }

    BOOL isPromotionsHide = HDIsArrayEmpty(self.viewModel.repModel.promotions) && HDIsArrayEmpty(self.viewModel.repModel.productPromotions);
    if (SAMultiLanguageManager.isCurrentLanguageCN && isPromotionsHide) {
        isPromotionsHide = HDIsArrayEmpty(self.viewModel.repModel.couponPackageCodes);
    }
    self.promotionsBgView.hidden = self.promotionsTitleLabel.hidden = isPromotionsHide;

    if (!isPromotionsHide) {
        [self configPromotionItemView];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)configPromotionItemView {
    [self.promotionsBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (!HDIsArrayEmpty(self.viewModel.repModel.productPromotions)) {
        WMPromotionItemView *promotionItemView = [[WMPromotionItemView alloc] init];
        [promotionItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"item_discount", @"Discount")];
        promotionItemView.showTips = [self.viewModel.repModel.productPromotions componentsJoinedByString:@","];
        [self.promotionsBgView addSubview:promotionItemView];
    }
    [self.viewModel.repModel.promotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        switch (obj.marketingType) {
            case WMStorePromotionMarketingTypeDiscount: {
                if (obj.discountRatio > 0) {
                    NSString *showText = nil;
                    if (SAMultiLanguageManager.isCurrentLanguageCN) {
                        showText = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%@折"), obj.discountRadioStr];
                    } else {
                        showText = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%.0f%%off"), obj.discountRatio.doubleValue];
                    }
                    self.offItemView.hidden = NO;
                    self.offItemView.showTips = showText;
                    [self.promotionsBgView addSubview:self.offItemView];
                }
            } break;
            case WMStorePromotionMarketingTypeLabber:
            case WMStorePromotionMarketingTypeStoreLabber: {
                NSString *labber = [[obj.ladderRules mapObjectsUsingBlock:^id _Nonnull(WMStoreLadderRuleModel *_Nonnull obj, NSUInteger idx) {
                    NSString *labber = @"";
                    labber = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), obj.thresholdAmt.thousandSeparatorAmount, obj.discountAmt.thousandSeparatorAmount];

                    return labber;
                }] componentsJoinedByString:@"、"];
                self.lessItemView.hidden = NO;
                self.lessItemView.showTips = labber;
                [self.promotionsBgView addSubview:self.lessItemView];
            } break;
            case WMStorePromotionMarketingTypeDelievry: {
                //                double cent = 0;
                //                BOOL free = YES;
                //                if (!HDIsArrayEmpty(obj.ladderRules)) {
                //                    NSArray *proArr = [obj.ladderRules hd_filterWithBlock:^BOOL(WMStoreLadderRuleModel *_Nonnull item) {
                //                        return item.preferentialRatio > 0;
                //                    }];
                //                    if (proArr.count > 0) {
                //                        for (WMStoreLadderRuleModel *ladderModel in proArr) {
                //                            if (self.viewModel.repModel.distance >= ladderModel.startDistance * 1000 && self.viewModel.repModel.distance <= ladderModel.endDistance * 1000) {
                //                                cent = self.viewModel.repModel.deliveryFee.cent.integerValue * ladderModel.preferentialRatio / 100;
                //                                break;
                //                            }
                //                        }
                //                    } else {
                //                        cent = obj.ladderRules.firstObject.discountAmt.cent.doubleValue;
                //                    }
                //                }
                //                if (cent > 0)
                //                    free = NO;
                //                if (cent == self.viewModel.repModel.deliveryFee.cent.doubleValue) {
                //                    free = YES;
                //                }

                BOOL free = YES;
                if (!HDIsArrayEmpty(obj.ladderRules)) {
                    NSArray *proArr = [obj.ladderRules hd_filterWithBlock:^BOOL(WMStoreLadderRuleModel *_Nonnull item) {
                        return item.preferentialRatio > 0;
                    }];
                    if (proArr.count) {
                        for (WMStoreLadderRuleModel *item in obj.ladderRules) {
                            if (item.preferentialRatio != 100) {
                                free = NO;
                                break;
                            } else if (item.preferentialRatio == 100) {
                                free = YES;
                            }
                        }
                    } else {
                        free = obj.ladderRules.firstObject.discountAmt.cent.doubleValue <= 0;
                    }
                }

                NSString *showTips = !free ? WMLocalizedString(@"wm_free_fee", @"减配送费") : WMLocalizedString(@"wm_free_delivery", @"减免配送费");
                self.deliveryItemView.hidden = NO;
                self.deliveryItemView.showTips = showTips;
                [self.promotionsBgView addSubview:self.deliveryItemView];
            } break;
            case WMStorePromotionMarketingTypeFirst: {
                NSString *showTips = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), obj.firstOrderReductionAmount.thousandSeparatorAmount];
                self.firstItemView.hidden = NO;
                self.firstItemView.showTips = showTips;
                [self.promotionsBgView addSubview:self.firstItemView];
            } break;
            case WMStorePromotionMarketingTypeCoupon: {
                if (obj.isStoreCoupon && !HDIsArrayEmpty(obj.storeCouponActivitys.coupons)) {
                    NSString *coupon = [[obj.storeCouponActivitys.coupons mapObjectsUsingBlock:^id _Nonnull(WMStoreCouponDetailModel *_Nonnull obj, NSUInteger idx) {
                        NSString *labber = @"";
                        if (obj.threshold.doubleValue == 0) {
                            labber = [NSString stringWithFormat:WMLocalizedString(@"wm_no_threshold", @"无门槛减%@"), WMFillMonEmpty(obj.faceValueStr)];
                        } else {
                            labber = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@"), WMFillMonEmpty(obj.threshold), WMFillMonEmpty(obj.faceValueStr)];
                        }
                        return labber;
                    }] componentsJoinedByString:@"、"];
                    self.giveCouponItemView.showTips = coupon;
                    [self.giveCouponItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"wm_storecoupon", @"门店券")];
                    self.giveCouponItemView.hidden = NO;
                    [self.promotionsBgView addSubview:self.giveCouponItemView];
                } else {
                    NSString *coupon = [[obj.ladderRules mapObjectsUsingBlock:^id _Nonnull(WMStoreLadderRuleModel *_Nonnull obj, NSUInteger idx) {
                        NSString *labber = @"";
                        labber =
                            [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), obj.thresholdAmt.thousandSeparatorAmount, obj.discountAmt.thousandSeparatorAmount];

                        return labber;
                    }] componentsJoinedByString:@"、"];
                    self.couponItemView.hidden = NO;
                    self.couponItemView.showTips = coupon;
                    [self.promotionsBgView addSubview:self.couponItemView];
                }
            } break;
            case WMStorePromotionMarketingTypeBestSale: {
                WMPromotionItemView *promotionItemView = [[WMPromotionItemView alloc] init];
                [promotionItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"bENzYfgi", @"Promotion")];
                promotionItemView.showTips = obj.promotionDesc;
                [self.promotionsBgView addSubview:promotionItemView];
            } break;
            case WMStorePromotionMarketingTypeFillGift: {
                NSMutableString *fillName = [[NSMutableString alloc] initWithString:obj.title];
                if (obj.activityContentResps.count) {
                    NSString *productName = [[obj.activityContentResps mapObjectsUsingBlock:^id _Nonnull(WMStoreFillGiftRuleModel *_Nonnull obj1, NSUInteger idx) {
                        NSString *labber = @"";
                        labber = [NSString stringWithFormat:WMLocalizedString(@"wm_gift_buy_free", @"满%@赠%@%ld件"), [NSString stringWithFormat:@"$%@", obj1.amount], obj1.giftName, obj1.quantity];

                        return labber;
                    }] componentsJoinedByString:@"，"];
                    [fillName appendString:@"，"];
                    [fillName appendString:productName];
                }
                self.fillGiftView.hidden = NO;
                self.fillGiftView.showTips = fillName;
                [self.promotionsBgView addSubview:self.fillGiftView];
            } break;

            case WMStorePromotionMarketingTypePromoCode: {
            } break;
            case WMStorePromotionMarketingTypeProductPromotions: {
                WMPromotionItemView *promotionItemView = [[WMPromotionItemView alloc] init];
                [promotionItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"item_discount", @"折扣")];
                promotionItemView.showTips = obj.promotionDesc;
                [self.promotionsBgView addSubview:promotionItemView];
            } break;

            case WMStorePromotionMarketingTypePlatform: {
                WMPromotionItemView *promotionItemView = [[WMPromotionItemView alloc] init];
                [promotionItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"item_discount", @"Discount")];
                promotionItemView.showTips = obj.promotionDesc;
                [self.promotionsBgView addSubview:promotionItemView];
            } break;

            default:
                break;
        }
    }];

    [self.viewModel.repModel.serviceLabel enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (HDIsStringNotEmpty(obj)) {
            WMPromotionItemView *promotionItemView = [[WMPromotionItemView alloc] init];
            [promotionItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"wm_store_Store_Services", @"商家服务")];
            promotionItemView.showTips = obj;
            [self.promotionsBgView addSubview:promotionItemView];
        }
    }];

    if (SAMultiLanguageManager.isCurrentLanguageCN) {
        if (!self.giveCouponItemView.isHidden) {
            NSMutableAttributedString *text = NSMutableAttributedString.new;
            UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];
            NSMutableAttributedString *couponsStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_storecoupon", @"门店优惠券")];
            couponsStr.yy_color = HDAppTheme.WMColor.mainRed;
            couponsStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightMedium];
            YYTextBorder *couponBorder = YYTextBorder.new;
            couponBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(4), -kRealWidth(4), -kRealWidth(4));
            couponBorder.fillColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
            couponBorder.cornerRadius = kRealWidth(2);
            couponsStr.yy_textBackgroundBorder = couponBorder;

            UIImage *lineImage = [UIImage imageNamed:@"yn_get_line"];

            NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                              attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                 alignToFont:[UIFont systemFontOfSize:0]
                                                                                                   alignment:YYTextVerticalAlignmentCenter];
            [couponsStr insertAttributedString:spaceText atIndex:0];
            [couponsStr appendAttributedString:spaceText];

            NSMutableAttributedString *lineStr = [NSMutableAttributedString yy_attachmentStringWithContent:lineImage contentMode:UIViewContentModeCenter
                                                                                            attachmentSize:CGSizeMake(lineImage.size.width, kRealWidth(20))
                                                                                               alignToFont:font
                                                                                                 alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:lineStr];

            spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                      alignToFont:[UIFont systemFontOfSize:0]
                                                                        alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:spaceText];

            NSString *state = WMLocalizedString(@"wm_coupon_give", @"wm_coupon_getting");

            NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:state];
            getStr.yy_color = UIColor.whiteColor;
            getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightBold];
            YYTextBorder *getBorder = YYTextBorder.new;
            getBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(8), -kRealWidth(4), -kRealWidth(8));
            getBorder.fillColor = HDAppTheme.WMColor.mainRed;
            getBorder.cornerRadius = kRealWidth(2);
            getStr.yy_textBackgroundBorder = getBorder;
            [couponsStr appendAttributedString:getStr];

            spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                      alignToFont:[UIFont systemFontOfSize:0]
                                                                        alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:spaceText];
            [text appendAttributedString:couponsStr];

            ///领取优惠券
            NSRange range = [text.string rangeOfString:couponsStr.string];
            YYTextHighlight *layHightlight = [[YYTextHighlight alloc] init];
            layHightlight.tapAction = ^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                [GNEvent eventResponder:self target:self key:@"showBottomCouponAction"];
            };
            [text yy_setTextHighlight:layHightlight range:range];

            self.giveCouponItemView.showTips = (id)text;
        }
        if (!HDIsArrayEmpty(self.viewModel.repModel.couponPackageCodes)) {
            self.couponPackItemView.hidden = NO;

            NSMutableAttributedString *text = NSMutableAttributedString.new;
            UIFont *font = [HDAppTheme.WMFont wm_boldForSize:14];
            NSMutableAttributedString *couponsStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_food_delivery_coupons", @"外卖优惠券包")];
            couponsStr.yy_color = HDAppTheme.WMColor.mainRed;
            couponsStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightMedium];
            YYTextBorder *couponBorder = YYTextBorder.new;
            couponBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(4), -kRealWidth(4), -kRealWidth(4));
            couponBorder.fillColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1];
            couponBorder.cornerRadius = kRealWidth(2);
            couponsStr.yy_textBackgroundBorder = couponBorder;

            UIImage *lineImage = [UIImage imageNamed:@"yn_get_line"];

            NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                              attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                 alignToFont:[UIFont systemFontOfSize:0]
                                                                                                   alignment:YYTextVerticalAlignmentCenter];
            [couponsStr insertAttributedString:spaceText atIndex:0];
            [couponsStr appendAttributedString:spaceText];

            NSMutableAttributedString *lineStr = [NSMutableAttributedString yy_attachmentStringWithContent:lineImage contentMode:UIViewContentModeCenter
                                                                                            attachmentSize:CGSizeMake(lineImage.size.width, kRealWidth(20))
                                                                                               alignToFont:font
                                                                                                 alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:lineStr];

            spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                      alignToFont:[UIFont systemFontOfSize:0]
                                                                        alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:spaceText];

            NSMutableAttributedString *getStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"wm_BUY", @"购")];
            getStr.yy_color = UIColor.whiteColor;
            getStr.yy_font = [HDAppTheme.WMFont wm_ForSize:11 weight:UIFontWeightBold];
            YYTextBorder *getBorder = YYTextBorder.new;
            getBorder.insets = UIEdgeInsetsMake(-kRealWidth(4), -kRealWidth(8), -kRealWidth(4), -kRealWidth(8));
            getBorder.fillColor = HDAppTheme.WMColor.mainRed;
            getBorder.cornerRadius = kRealWidth(2);
            getStr.yy_textBackgroundBorder = getBorder;
            [couponsStr appendAttributedString:getStr];

            spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                      alignToFont:[UIFont systemFontOfSize:0]
                                                                        alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:spaceText];

            spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(kRealWidth(8), 1)
                                                                      alignToFont:[UIFont systemFontOfSize:0]
                                                                        alignment:YYTextVerticalAlignmentCenter];
            [couponsStr appendAttributedString:spaceText];

            [text appendAttributedString:couponsStr];

            ///跳转券包
            NSRange range = [text.string rangeOfString:couponsStr.string];
            YYTextHighlight *layHightlight = [[YYTextHighlight alloc] init];
            layHightlight.tapAction = ^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                [HDMediator.sharedInstance navigaveToWebViewViewController:@{
                    @"path": [NSString stringWithFormat:@"/mobile-h5/marketing/coupon-package/coupon-list?lon=%@&&lat=%@", self.viewModel.repModel.longitude, self.viewModel.repModel.latitude]
                }];
            };
            [text yy_setTextHighlight:layHightlight range:range];
            [self.couponPackItemView setColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"", @"券包")];
            self.couponPackItemView.showTips = (id)text;
            [self.promotionsBgView insertSubview:self.couponPackItemView atIndex:0];
        }
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];
    [self updateConstrainAction];
}

- (void)updateConstrainAction {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollViewContainer);
    }];

    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-kRealWidth(30));
    }];

    [self.promotionsTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.promotionsTitleLabel.isHidden) {
            make.top.equalTo(self.headerView.mas_bottom).offset(kRealHeight(20));
            make.left.equalTo(self.scrollViewContainer.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
        }
    }];

    NSMutableArray *tempArr = [NSMutableArray array];

    [self.promotionsBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.isHidden) {
            [tempArr addObject:obj];
        }
    }];

    UIView *lastView = nil;
    for (UIView *view in tempArr) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.promotionsBgView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.promotionsBgView);
            if (view == tempArr.lastObject) {
                make.bottom.equalTo(self.promotionsBgView.mas_bottom);
            }
        }];
        lastView = view;
    }

    [self.promotionsBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promotionsTitleLabel.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.promotionsTitleLabel);
        make.right.equalTo(self.bgView.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.noticeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeTitleLabel.isHidden) {
            UIView *view = self.promotionsBgView.isHidden ? self.headerView : self.promotionsBgView;
            make.top.equalTo(view.mas_bottom).offset(kRealHeight(12));
            make.left.equalTo(self.scrollViewContainer.mas_left).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
        }
    }];

    [self.noticeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeLabel.isHidden) {
            make.top.equalTo(self.noticeTitleLabel.mas_bottom).offset(kRealHeight(10));
            make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-HDAppTheme.value.padding.right);
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-kRealWidth(30));
        }
    }];

    [self.noticeLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noticeLine.isHidden) {
            make.top.equalTo(self.noticeLabel.mas_bottom).offset(kRealHeight(20));
            make.left.equalTo(self.noticeTitleLabel.mas_left);
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [self.businessIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessIconView.isHidden) {
            make.top.equalTo(self.businessTitleLabel);
            make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
        }
    }];

    [self.businessTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noticeLine.isHidden) {
            UIView *view = self.noticeLabel.isHidden ? self.promotionsBgView : self.noticeLabel;
            view = view.isHidden ? self.headerView : view;
            make.top.equalTo(view.mas_bottom).offset(kRealHeight(20));
        } else {
            make.top.equalTo(self.noticeLine.mas_bottom).offset(kRealHeight(15));
        }
        make.left.equalTo(self.businessIconView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.bgView.mas_right).offset(kRealWidth(-10));
    }];

    [self.businessLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessLabel.isHidden) {
            make.top.equalTo(self.businessTitleLabel.mas_bottom).offset(kRealWidth(3));
            make.left.equalTo(self.businessIconView.mas_right).offset(kRealWidth(10));
            make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-kRealWidth(30));
        }
    }];

    [self.businessLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessLine.isHidden) {
            make.top.equalTo(self.businessLabel.mas_bottom).offset(kRealHeight(15));
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-HDAppTheme.value.padding.right);
            make.centerX.equalTo(self.bgView);
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [self.businessScopesIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesIconView.isHidden) {
            make.centerY.equalTo(self.businessScopesTitleLabel);
            make.left.equalTo(self.businessIconView);
            make.width.equalTo(self.businessIconView);
            if (self.businessScopesIconView.image) {
                CGSize size = self.businessScopesIconView.image.size;
                make.height.equalTo(self.businessScopesIconView.mas_width).multipliedBy(size.height / size.width);
            } else {
                make.size.equalTo(self.businessIconView);
            }
        }
    }];

    [self.businessScopesTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesTitleLabel.isHidden) {
            make.left.right.equalTo(self.businessLabel);
            make.top.equalTo(self.businessLine.mas_bottom).offset(kRealHeight(18));
        }
    }];

    [self.businessScopesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesLabel.isHidden) {
            make.top.equalTo(self.businessScopesTitleLabel.mas_bottom).offset(kRealWidth(5));
            make.left.right.equalTo(self.businessLabel);
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-kRealWidth(30));
        }
    }];

    [self.businessScopesLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.businessScopesLine.isHidden) {
            make.top.equalTo(self.businessScopesLabel.mas_bottom).offset(kRealHeight(15));
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-HDAppTheme.value.padding.right);
            make.centerX.equalTo(self.bgView);
            make.height.mas_equalTo(PixelOne);
        }
    }];

    [self.payMethodIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payMethodIconView.isHidden) {
            make.centerY.equalTo(self.payMethodTitleLabel);
            make.left.equalTo(self.businessIconView);
            make.width.equalTo(self.businessIconView);
            if (self.payMethodIconView.image) {
                CGSize size = self.payMethodIconView.image.size;
                make.height.equalTo(self.payMethodIconView.mas_width).multipliedBy(size.height / size.width);
            } else {
                make.size.equalTo(self.businessIconView);
            }
        }
    }];

    [self.payMethodTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payMethodTitleLabel.isHidden) {
            make.left.right.equalTo(self.businessLabel);
            make.top.equalTo(self.businessScopesLine.mas_bottom).offset(kRealHeight(18));
        }
    }];

    [self.payMethodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.payMethodLabel.isHidden) {
            make.top.equalTo(self.payMethodTitleLabel.mas_bottom).offset(kRealWidth(5));
            make.left.right.equalTo(self.businessLabel);
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(-kRealWidth(30));
        }
    }];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (WMStoreInfoTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WMStoreInfoTableHeaderView alloc] init];
    }
    return _headerView;
}

- (SALabel *)promotionsTitleLabel {
    if (!_promotionsTitleLabel) {
        _promotionsTitleLabel = [[SALabel alloc] init];
        _promotionsTitleLabel.textColor = HDAppTheme.color.G1;
        _promotionsTitleLabel.font = HDAppTheme.font.standard2Bold;
        _promotionsTitleLabel.text = WMLocalizedString(@"promotions", @"促销活动");
    }
    return _promotionsTitleLabel;
}

- (SALabel *)noticeTitleLabel {
    if (!_noticeTitleLabel) {
        _noticeTitleLabel = [[SALabel alloc] init];
        _noticeTitleLabel.textColor = HDAppTheme.color.G1;
        _noticeTitleLabel.font = HDAppTheme.font.standard2Bold;
        _noticeTitleLabel.text = WMLocalizedString(@"store_notice", @"门店告示");
    }
    return _noticeTitleLabel;
}

- (SALabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[SALabel alloc] init];
        _noticeLabel.textColor = HDAppTheme.color.G2;
        _noticeLabel.font = HDAppTheme.font.standard3;
        _noticeLabel.numberOfLines = 0;
    }
    return _noticeLabel;
}

- (UIView *)noticeLine {
    if (!_noticeLine) {
        _noticeLine = [[UIView alloc] init];
        _noticeLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _noticeLine;
}

- (UIImageView *)businessIconView {
    if (!_businessIconView) {
        _businessIconView = [[UIImageView alloc] init];
        _businessIconView.image = [UIImage imageNamed:@"store_info_bussiness_times"];
    }
    return _businessIconView;
}

- (YYLabel *)businessLabel {
    if (!_businessLabel) {
        _businessLabel = [[YYLabel alloc] init];
        _businessLabel.textColor = HDAppTheme.color.G2;
        _businessLabel.font = HDAppTheme.font.standard3;
        _businessLabel.numberOfLines = 0;
    }
    return _businessLabel;
}

- (UIView *)businessLine {
    if (!_businessLine) {
        _businessLine = [[UIView alloc] init];
        _businessLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _businessLine;
}

- (UIImageView *)businessScopesIconView {
    if (!_businessScopesIconView) {
        _businessScopesIconView = [[UIImageView alloc] init];
        _businessScopesIconView.image = [UIImage imageNamed:@"store_info_merch"];
    }
    return _businessScopesIconView;
}

- (SALabel *)businessScopesTitleLabel {
    if (!_businessScopesTitleLabel) {
        _businessScopesTitleLabel = [[SALabel alloc] init];
        _businessScopesTitleLabel.textColor = HDAppTheme.color.G2;
        _businessScopesTitleLabel.font = HDAppTheme.font.standard3Bold;
        _businessScopesTitleLabel.numberOfLines = 0;
        _businessScopesTitleLabel.text = WMLocalizedString(@"store_detail_cusines", @"经营范围");
    }
    return _businessScopesTitleLabel;
}

- (SALabel *)businessTitleLabel {
    if (!_businessTitleLabel) {
        _businessTitleLabel = [[SALabel alloc] init];
        _businessTitleLabel.textColor = HDAppTheme.color.G2;
        _businessTitleLabel.font = HDAppTheme.font.standard3Bold;
        _businessTitleLabel.text = WMLocalizedString(@"store_detail_business_hours", @"营业时间");
    }
    return _businessTitleLabel;
}

- (SALabel *)businessScopesLabel {
    if (!_businessScopesLabel) {
        _businessScopesLabel = [[SALabel alloc] init];
        _businessScopesLabel.textColor = HDAppTheme.color.G2;
        _businessScopesLabel.font = HDAppTheme.font.standard3;
        _businessScopesLabel.numberOfLines = 0;
    }
    return _businessScopesLabel;
}

- (UIView *)businessScopesLine {
    if (!_businessScopesLine) {
        _businessScopesLine = [[UIView alloc] init];
        _businessScopesLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _businessScopesLine;
}

- (UIImageView *)payMethodIconView {
    if (!_payMethodIconView) {
        _payMethodIconView = [[UIImageView alloc] init];
        _payMethodIconView.image = [UIImage imageNamed:@"store_info_pay_method"];
    }
    return _payMethodIconView;
}

- (SALabel *)payMethodTitleLabel {
    if (!_payMethodTitleLabel) {
        _payMethodTitleLabel = [[SALabel alloc] init];
        _payMethodTitleLabel.textColor = HDAppTheme.color.G2;
        _payMethodTitleLabel.font = HDAppTheme.font.standard3Bold;
        _payMethodTitleLabel.text = WMLocalizedString(@"order_payment_method", @"Payment method");
    }
    return _payMethodTitleLabel;
}
- (SALabel *)payMethodLabel {
    if (!_payMethodLabel) {
        _payMethodLabel = [[SALabel alloc] init];
        _payMethodLabel.textColor = HDAppTheme.color.G2;
        _payMethodLabel.font = HDAppTheme.font.standard3;
        _payMethodLabel.numberOfLines = 0;
    }
    return _payMethodLabel;
}

- (UIView *)promotionsBgView {
    if (!_promotionsBgView) {
        _promotionsBgView = [[UIView alloc] init];
    }
    return _promotionsBgView;
}

- (WMPromotionItemView *)offItemView {
    if (!_offItemView) {
        _offItemView = [[WMPromotionItemView alloc] init];
        _offItemView.itemType = WMStorePromotionMarketingTypeDiscount;
        _offItemView.hidden = YES;
    }
    return _offItemView;
}

- (WMPromotionItemView *)lessItemView {
    if (!_lessItemView) {
        _lessItemView = [[WMPromotionItemView alloc] init];
        _lessItemView.itemType = WMStorePromotionMarketingTypeLabber;
        _lessItemView.hidden = YES;
    }
    return _lessItemView;
}

- (WMPromotionItemView *)deliveryItemView {
    if (!_deliveryItemView) {
        _deliveryItemView = [[WMPromotionItemView alloc] init];
        _deliveryItemView.itemType = WMStorePromotionMarketingTypeDelievry;
        _deliveryItemView.hidden = YES;
    }
    return _deliveryItemView;
}

- (WMPromotionItemView *)firstItemView {
    if (!_firstItemView) {
        _firstItemView = [[WMPromotionItemView alloc] init];
        _firstItemView.itemType = WMStorePromotionMarketingTypeFirst;
        _firstItemView.hidden = YES;
    }
    return _firstItemView;
}

- (WMPromotionItemView *)couponItemView {
    if (!_couponItemView) {
        _couponItemView = [[WMPromotionItemView alloc] init];
        _couponItemView.itemType = WMStorePromotionMarketingTypeCoupon;
        _couponItemView.hidden = YES;
    }
    return _couponItemView;
}

- (WMPromotionItemView *)fillGiftView {
    if (!_fillGiftView) {
        _fillGiftView = [[WMPromotionItemView alloc] init];
        _fillGiftView.itemType = WMStorePromotionMarketingTypeFillGift;
        _fillGiftView.hidden = YES;
    }
    return _fillGiftView;
}

- (WMPromotionItemView *)giveCouponItemView {
    if (!_giveCouponItemView) {
        _giveCouponItemView = [[WMPromotionItemView alloc] init];
        _giveCouponItemView.itemType = WMStorePromotionMarketingTypeCoupon;
        _giveCouponItemView.hidden = YES;
    }
    return _giveCouponItemView;
}

- (WMPromotionItemView *)couponPackItemView {
    if (!_couponPackItemView) {
        _couponPackItemView = [[WMPromotionItemView alloc] init];
        _couponPackItemView.hidden = YES;
    }
    return _couponPackItemView;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *c0 = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 20;
    [c0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.centerY.hd_equalTo(50);
        make.left.hd_equalTo(15);
    }];
    c0.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];

    const CGFloat r0W = 100 - 2 * 15;
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(r0W);
        make.height.hd_equalTo(r0W);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(c0.hd_right).offset(10);
    }];
    r0.skeletonCornerRadius = 5;

    CGFloat margin = 10;
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(15);
        make.left.hd_equalTo(r0.hd_right + margin);
        make.top.hd_equalTo(r0.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(70);
        make.top.hd_equalTo(r1.hd_bottom).offset(10);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(130);
        make.bottom.hd_equalTo(r0.hd_bottom).offset(10);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3_1 = [[HDSkeletonLayer alloc] init];
    [r3_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.width.hd_equalTo(60);
        make.top.hd_equalTo(r3.hd_top);
        make.height.hd_equalTo(r3.hd_height);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r3.hd_bottom).offset(15);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(r4.hd_bottom).offset(15);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r0.hd_left);
        make.width.hd_equalTo(300);
        make.top.hd_equalTo(r5.hd_bottom).offset(15);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r7 = [[HDSkeletonLayer alloc] init];
    const CGFloat r7W = 100 - 2 * 15;
    [r7 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(r7W);
        make.height.hd_equalTo(r7W);
        make.top.hd_equalTo(r6.hd_bottom).offset(30);
        make.left.hd_equalTo(c0.hd_right).offset(10);
    }];
    r7.skeletonCornerRadius = 5;

    HDSkeletonLayer *r8 = [[HDSkeletonLayer alloc] init];
    [r8 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r7.hd_right).offset(margin);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r7.hd_top).offset(15);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r9 = [[HDSkeletonLayer alloc] init];
    [r9 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r8.hd_left);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r8.hd_bottom).offset(15);
        make.height.hd_equalTo(15);
    }];

    return @[c0, r0, r1, r2, r3, r3_1, r4, r5, r6, r7, r8, r9];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return kScreenHeight;
}

@end
