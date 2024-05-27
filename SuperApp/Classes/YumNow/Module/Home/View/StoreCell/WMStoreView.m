//
//  WMStoreView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreView.h"
#import "GNStringUntils.h"
#import "SACaculateNumberTool.h"
#import "WMManage.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreModel.h"


@interface WMStoreView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 门店图
@property (nonatomic, strong) UIImageView *storeImageView;
/// 新店标签背景
@property (nonatomic, strong) UIView *newTagBgView;
/// 新店标签
@property (nonatomic, strong) SALabel *newTagLabel;
/// 休息中标签背景
@property (nonatomic, strong) UIView *restingTagBgView;
/// 休息中标签
@property (nonatomic, strong) SALabel *restingTagLabel;
/// 是否新店标志
@property (nonatomic, strong) UIImageView *isNewStoreImageView;
///名称
@property (nonatomic, strong) SALabel *nameLabel;
///描述
@property (nonatomic, strong) YYLabel *descLB;
/// 优惠信息
@property (nonatomic, strong) YYLabel *floatLayoutView;
/// 自定义标签
@property (nonatomic, strong) SALabel *cusTagLB;
/// 极速服务标签背景
@property (nonatomic, strong) UIView *fastServiceTagBgView;
/// 极速服务标签
@property (nonatomic, strong) HDUIButton *fastServiceBTN;
/// 休息中遮罩层
@property (nonatomic, strong) UIView *restView;
/// 休息中图标
@property (nonatomic, strong) HDUIButton *restBTN;
/// 休息中文本
@property (nonatomic, strong) SALabel *restLB;
/// 高斯模糊
@property (nonatomic, strong) UIVisualEffectView *effectview;
/// 门店图用于高斯模糊
@property (nonatomic, strong) UIImageView *storeEffectImageView;
/// line
@property (nonatomic, strong) UIView *lineView;
/// 距离和时间视图
@property (nonatomic, strong) UIView *timeAndDistanceView;
/// 距离
@property (nonatomic, strong) HDUIButton *timeBTN;
/// 时间
@property (nonatomic, strong) HDUIButton *distanceBTN;
/// 爆单
@property (nonatomic, strong) HDUIButton *fullOrderBTN;
@end


@implementation WMStoreView
- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.storeImageView];
    [self.bgView addSubview:self.storeEffectImageView];
    [self.storeImageView addSubview:self.effectview];

    [self addSubview:self.newTagBgView];
    [self.newTagBgView addSubview:self.newTagLabel];
    [self.bgView addSubview:self.restingTagBgView];
    [self.restingTagBgView addSubview:self.restingTagLabel];
    [self.bgView addSubview:self.isNewStoreImageView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.descLB];
    [self.bgView addSubview:self.floatLayoutView];
    [self.bgView addSubview:self.cusTagLB];

    [self.bgView addSubview:self.timeAndDistanceView];
    [self.timeAndDistanceView addSubview:self.timeBTN];
    [self.timeAndDistanceView addSubview:self.distanceBTN];

    [self.bgView addSubview:self.fullOrderBTN];

    [self.bgView addSubview:self.restView];
    [self.restView addSubview:self.restBTN];
    [self.restView addSubview:self.restLB];

    [self addSubview:self.fastServiceTagBgView];
    [self.fastServiceTagBgView addSubview:self.fastServiceBTN];
    [self addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12.5));
        make.right.equalTo(self).offset(kRealWidth(-12.5));
        make.top.equalTo(self).offset(self.model.isFirst ? 0 : kRealWidth(20));
        make.bottom.equalTo(self).offset(-kRealWidth(20));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.8);
        make.left.right.equalTo(self.bgView);
        make.bottom.mas_equalTo(0);
    }];

    [self.storeEffectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.storeImageView);
        make.height.equalTo(self.storeImageView.mas_width).multipliedBy(self.model.rate);
    }];

    [self.storeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.height.equalTo(self.storeImageView.mas_width).multipliedBy(175.0 / 350.0);
    }];

    if (!self.newTagBgView.isHidden) {
        [self.newTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.storeImageView).offset(kRealWidth(6));
        }];

        [self.newTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.newTagBgView.mas_left).offset(kRealWidth(7));
            make.top.equalTo(self.newTagBgView.mas_top).offset(kRealWidth(4));
            make.bottom.equalTo(self.newTagBgView.mas_bottom).offset(kRealWidth(-4));
            make.right.equalTo(self.newTagBgView.mas_right).offset(kRealWidth(-7));
        }];
    }

    if (!self.cusTagLB.isHidden) {
        [self.cusTagLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.storeImageView.mas_left).offset(kRealWidth(6));
            if (!self.newTagBgView.isHidden) {
                make.top.equalTo(self.newTagBgView.mas_bottom).offset(kRealWidth(6));
            } else {
                make.top.equalTo(self.storeImageView.mas_top).offset(kRealWidth(6));
            }
            make.right.lessThanOrEqualTo(self.storeImageView.mas_right).offset(-kRealWidth(109));
        }];
    }

    [self.restingTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.storeImageView);
    }];

    [self.restingTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.restingTagBgView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.restingTagBgView.mas_top).offset(5);
        make.bottom.equalTo(self.restingTagBgView.mas_bottom).offset(-5);
        make.right.equalTo(self.restingTagBgView.mas_right).offset(kRealWidth(-5));
    }];

    [self.isNewStoreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.isNewStoreImageView.isHidden) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(25)));
            if (self.storeImageView.isHidden) {
                make.top.equalTo(self.bgView);
                make.right.equalTo(self.bgView).offset(-kRealWidth(20));
            } else {
                make.top.equalTo(self.storeImageView).offset(kRealWidth(6));
                make.right.equalTo(self.storeImageView).offset(-kRealWidth(10));
            }
        }
    }];

    [self.timeAndDistanceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeImageView).offset(kRealWidth(6));
        make.bottom.equalTo(self.storeImageView).offset(-kRealWidth(6));
    }];

    [self.fullOrderBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.fullOrderBTN.isHidden) {
            make.left.equalTo(self.timeAndDistanceView.mas_right).offset(kRealWidth(4));
            make.centerY.equalTo(self.timeAndDistanceView);
            make.height.mas_equalTo(kRealWidth(20));
        }
    }];
    
    [self.timeBTN sizeToFit];
    [self.distanceBTN sizeToFit];
    
    [self.distanceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(6));
        make.top.mas_equalTo(kRealWidth(3));
        make.bottom.mas_equalTo(-kRealWidth(3));
    }];

    [self.timeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRealWidth(-6));
        make.top.bottom.height.equalTo(self.distanceBTN);
        make.left.equalTo(self.distanceBTN.mas_right).offset(kRealWidth(10));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *view = self.storeImageView;
        make.top.equalTo(view.mas_bottom).offset(kRealWidth(9.5));
        make.left.equalTo(self.bgView).offset(kRealWidth(2.5));
        make.right.equalTo(self.bgView).offset(kRealWidth(-2.5));
        make.bottom.lessThanOrEqualTo(self.bgView).offset(-kRealWidth(10));
    }];

    self.descLB.preferredMaxLayoutWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(8));
        if (self.floatLayoutView.isHidden) {
            make.bottom.equalTo(self.bgView);
        }
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            make.top.hd_equalTo(self.descLB.mas_bottom).offset(kRealWidth(10));
            make.left.right.equalTo(self.descLB);
            make.bottom.equalTo(self.bgView.mas_bottom);
        }
    }];

    if (!self.fastServiceTagBgView.isHidden) {
        [self.fastServiceTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storeImageView).offset(-2);
            make.right.equalTo(self.storeImageView).offset(1);
            make.height.mas_equalTo(kRealWidth(20));
        }];
        [self.fastServiceBTN sizeToFit];
        [self.fastServiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.fastServiceTagBgView);
            make.left.equalTo(self.fastServiceTagBgView).offset(kRealWidth(10));
            make.right.equalTo(self.fastServiceTagBgView).offset(-kRealWidth(10));
            make.width.mas_equalTo(self.fastServiceBTN.width);
        }];
    }

    [self.restView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.storeImageView);
    }];

    [self.restBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.restLB.isHidden) {
            make.centerY.mas_equalTo(0);
        } else {
            make.centerY.mas_equalTo(-kRealWidth(20));
        }
        make.centerX.mas_equalTo(0);
    }];

    [self.restLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restLB.isHidden) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.top.equalTo(self.restBTN.mas_bottom).offset(kRealHeight(15));
        }
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMBaseStoreModel *)model {
    _model = model;
    if (!self.storeImageView.isHidden) {
        [HDWebImageManager setImageWithURL:model.photo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(355), kRealWidth(175)) logoWidth:kRealWidth(64)]
                                 imageView:self.storeImageView];
    }
    if (!self.storeEffectImageView.isHidden) {
        [HDWebImageManager setImageWithURL:model.photo placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(355), kRealWidth(150)) logoWidth:kRealWidth(64)]
                                 imageView:self.storeEffectImageView completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     if (image.size.width / image.size.height == 2.0 && model.rate != (175.0 / 350.0)) {
                                         model.rate = 175.0 / 350.0;
                                         self.storeEffectImageView.layer.cornerRadius = kRealWidth(4);
                                         [self setNeedsUpdateConstraints];
                                     }
                                 }];
        self.storeEffectImageView.layer.cornerRadius = (model.rate == (175.0 / 350.0)) ? kRealWidth(4) : 0;
    }

    self.newTagBgView.hidden = self.newTagLabel.hidden = !model.isNewStore;
    self.fullOrderBTN.hidden = YES;
    self.restView.hidden = self.restBTN.hidden = self.restLB.hidden = self.restingTagBgView.hidden = self.restingTagLabel.hidden = YES;
    ///下次营业时间或者休息中
    if (model.nextServiceTime || [model.storeStatus.status isEqualToString:WMStoreStatusResting]) {
        self.restView.hidden = self.restBTN.hidden = self.restLB.hidden = NO;
        if (model.nextServiceTime) {
            [self.restBTN setImage:[UIImage imageNamed:@"home_releax"] forState:UIControlStateNormal];
            [self.restBTN setTitle:WMLocalizedString(@"cart_resting", @"休息中") forState:UIControlStateNormal];
            self.restBTN.titleLabel.font = HDAppTheme.font.standard2Bold;
            self.restView.hidden = !self.model.nextServiceTime;
            self.restLB.text = [NSString stringWithFormat:@"%@ %@ %@",
                                                          WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                                          self.model.nextServiceTime.weekday.message ? WMManage.shareInstance.weekInfo[self.model.nextServiceTime.weekday.code] : @"",
                                                          self.model.nextServiceTime.time ?: @""];
        } else {
            self.restLB.hidden = YES;
            [self.restBTN setImage:[UIImage imageNamed:@"home_releax"] forState:UIControlStateNormal];
            [self.restBTN setTitle:WMLocalizedString(@"cart_resting", @"休息中") forState:UIControlStateNormal];
            self.restBTN.titleLabel.font = HDAppTheme.font.standard2Bold;
        }
    } else {
        ///爆单停止接单
        if (model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
            self.restView.hidden = self.restBTN.hidden = self.restLB.hidden = NO;
            self.restingTagBgView.hidden = self.restingTagLabel.hidden = YES;
            self.restBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:22];
            [self.restBTN setImage:[UIImage imageNamed:@"yn_home_full_busy_bigger"] forState:UIControlStateNormal];
            [self.restBTN setTitle:WMLocalizedString(@"wm_store_busy", @"繁忙") forState:UIControlStateNormal];
            self.restLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_before", @"%@分钟后可下单"), @"30"];
        } else if (model.fullOrderState == WMStoreFullOrderStateFull) { ///爆单
            self.fullOrderBTN.hidden = NO;
            [self.fullOrderBTN setImage:[UIImage imageNamed:@"yn_home_full_busy"] forState:UIControlStateNormal];
            [self.fullOrderBTN setTitle:WMLocalizedString(@"wm_store_busy", @"繁忙") forState:UIControlStateNormal];
        } else {
            if (model.slowMealState == WMStoreSlowMealStateSlow) { ///出餐慢
                self.fullOrderBTN.hidden = NO;
                [self.fullOrderBTN setImage:[UIImage imageNamed:@"yn_home_full_order"] forState:UIControlStateNormal];
                [self.fullOrderBTN setTitle:WMLocalizedString(@"wm_store_many_order", @"订单较多") forState:UIControlStateNormal];
            }
        }
    }

    NSString *deliveryTime = self.model.deliveryTime;
    if (self.model.estimatedDeliveryTime) {
        if (self.model.estimatedDeliveryTime.integerValue > 60) {
            deliveryTime = @">60";
        } else {
            deliveryTime = self.model.estimatedDeliveryTime;
        }
    }
    [self.timeBTN setTitle:[NSString stringWithFormat:@"%@min", deliveryTime] forState:UIControlStateNormal];
    [self.distanceBTN setTitle:[SACaculateNumberTool distanceStringFromNumber:model.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp] forState:UIControlStateNormal];

    self.nameLabel.text = model.storeName.desc;
    self.nameLabel.numberOfLines = model.numberOfLinesOfNameLabel;
    if (HDIsStringNotEmpty(model.tags)) {
        [self.cusTagLB setHidden:NO];
        self.cusTagLB.text = model.tags;
    } else {
        [self.cusTagLB setHidden:YES];
    }

    self.fastServiceTagBgView.hidden = self.fastServiceBTN.hidden = !self.restingTagBgView.hidden || !model.speedDelivery.boolValue;

    // 拼接描述
    [self updateDescLabelContent];

    ///优惠活动
    BOOL hasFastService = self.model.slowPayMark.boolValue;
    //    self.floatLayoutView.hidden = HDIsArrayEmpty(self.model.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService;
    //    ///优化滑动卡顿 使用HDFloatLayoutView滑动的时候会一直创建和移除 更换为YYLabel 在不影响之前UI的情况下使用插入UIView的方法  2022-7-15 wmz
    //    if (!self.model.tagString) {
    //        NSArray *arr = [WMStoreDetailPromotionModel configPromotions:self.model.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService];
    //        self.model.tagString = NSMutableAttributedString.new;
    //        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    //            NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
    //                                                                                              alignToFont:obj.titleLabel.font
    //                                                                                                alignment:YYTextVerticalAlignmentCenter];
    //            if (idx != arr.count - 1) {
    //                NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
    //                                                                                                  attachmentSize:CGSizeMake(kRealWidth(4), 1)
    //                                                                                                     alignToFont:[UIFont systemFontOfSize:0]
    //                                                                                                       alignment:YYTextVerticalAlignmentCenter];
    //                [objStr appendAttributedString:spaceText];
    //            }
    //            [self.model.tagString appendAttributedString:objStr];
    //        }];
    //        self.model.tagString.yy_lineSpacing = kRealWidth(4);
    //    }
    
    
    if([self.model isKindOfClass:[WMNewStoreModel class]]){
        WMNewStoreModel *m = (WMNewStoreModel *)self.model;
        self.floatLayoutView.hidden = HDIsArrayEmpty(m.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    }else{
        WMStoreModel *m = (WMStoreModel *)self.model;
        self.floatLayoutView.hidden = HDIsArrayEmpty(m.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    }

//    self.floatLayoutView.hidden = HDIsArrayEmpty(self.model.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    if (!self.model.tagString) {
//        NSMutableArray *mArr = [WMStoreDetailPromotionModel configPromotions:self.model.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService].mutableCopy;
        NSMutableArray *mArr = @[].mutableCopy;
        if([self.model isKindOfClass:[WMNewStoreModel class]]){
            WMNewStoreModel *m = (WMNewStoreModel *)self.model;
            [mArr addObjectsFromArray: [WMStoreDetailPromotionModel configNewPromotions:m.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService].mutableCopy];
        }else{
            WMStoreModel *m = (WMStoreModel *)self.model;
            [mArr addObjectsFromArray: [WMStoreDetailPromotionModel configPromotions:m.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService].mutableCopy];
        }
        if (self.model.serviceLabel.count) {
            [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.model.serviceLabel]];
        }
        self.model.tagString = NSMutableAttributedString.new;
        [mArr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                              alignToFont:obj.titleLabel.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
            if (idx != mArr.count - 1) {
                NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                  attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                     alignToFont:[UIFont systemFontOfSize:0]
                                                                                                       alignment:YYTextVerticalAlignmentCenter];
                [objStr appendAttributedString:spaceText];
            }
            [self.model.tagString appendAttributedString:objStr];
        }];
        self.model.tagString.yy_lineSpacing = kRealWidth(4);
    }
    self.floatLayoutView.attributedText = self.model.tagString;

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)updateDescLabelContent {
    if (!self.model.attribStr) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

        UIFont *font = [HDAppTheme.WMFont wm_boldForSize:13];
        UIFont *detailFont = [HDAppTheme.WMFont wm_ForSize:13];
        UIImage *image = [UIImage imageNamed:@"yn_home_star"];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter
                                                                                           attachmentSize:CGSizeMake(image.size.width, self.descLB.font.lineHeight)
                                                                                              alignToFont:font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachment];

        // 拼接分数
        NSString *score = [NSString stringWithFormat:@"%.1f", self.model.ratingScore];
        if (self.model.ratingScore == 0)
            score = WMLocalizedString(@"wm_no_ratings_yet", @"暂无评分");

        NSMutableAttributedString *scoreStr = [[NSMutableAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: font}];

        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [text appendAttributedString:scoreStr];

        NSString *sold = self.model.sale;
        if (!sold) {
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
                sold = [NSString stringWithFormat:@"%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.ordered];
            } else {
                sold = [NSString stringWithFormat:@"%zd %@", self.model.ordered, WMLocalizedString(@"wm_sold", @"Sold")];
            }
        }
        NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc] initWithString:sold
                                                                                    attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: detailFont}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" · " attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: detailFont}]];
        [text appendAttributedString:soldStr];

        // 拼接品类
        NSString *categories;
        if ([self.model.businessScopesV2 isKindOfClass:NSArray.class] && self.model.businessScopesV2.count > 0) {
            NSArray<NSString *> *scopes = [self.model.businessScopesV2 mapObjectsUsingBlock:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
                if (idx < 2) {
                    return obj;
                } else {
                    return nil;
                }
            }];

            categories = [@" · " stringByAppendingString:[scopes componentsJoinedByString:@"、"]];
        }
        if (categories) {
            NSMutableAttributedString *categoriesStr = [[NSMutableAttributedString alloc] initWithString:categories
                                                                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: detailFont}];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [text appendAttributedString:categoriesStr];
        }
        self.model.attribStr = text;
    }
    self.descLB.attributedText = self.model.attribStr;
    self.descLB.numberOfLines = self.model.numberOfLinesOfDescLabel;
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}
/** @lazy cusTagsLb */
- (SALabel *)cusTagLB {
    if (!_cusTagLB) {
        _cusTagLB = [[SALabel alloc] init];
        _cusTagLB.textColor = UIColor.whiteColor;
        _cusTagLB.backgroundColor = HDAppTheme.WMColor.mainRed;
        _cusTagLB.font = [HDAppTheme.WMFont wm_boldForSize:13];
        _cusTagLB.hd_edgeInsets = UIEdgeInsetsMake(4, 5, 4, 5);
        _cusTagLB.numberOfLines = 0;
        _cusTagLB.hd_lineSpace = 3;
        _cusTagLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:5];
        };
    }
    return _cusTagLB;
}

- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        imageView.layer.cornerRadius = kRealWidth(4);
        @HDWeakify(self) imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self) self.effectview.frame = CGRectMake(0, 0, precedingFrame.size.width, precedingFrame.size.height);
        };
        _storeImageView = imageView;
    }
    return _storeImageView;
}

- (UIImageView *)storeEffectImageView {
    if (!_storeEffectImageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _storeEffectImageView = imageView;
    }
    return _storeEffectImageView;
}

- (UIView *)newTagBgView {
    if (!_newTagBgView) {
        _newTagBgView = [[UIView alloc] init];
        _newTagBgView.backgroundColor = HDAppTheme.WMColor.mainRed;
        _newTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:kRealWidth(4)];
        };
    }
    return _newTagBgView;
}

- (SALabel *)newTagLabel {
    if (!_newTagLabel) {
        _newTagLabel = [[SALabel alloc] init];
        _newTagLabel.textColor = UIColor.whiteColor;
        _newTagLabel.font = [HDAppTheme.WMFont wm_boldForSize:13];
        _newTagLabel.text = WMLocalizedString(@"is_new_store", @"New");
    }
    return _newTagLabel;
}

- (UIView *)restingTagBgView {
    if (!_restingTagBgView) {
        _restingTagBgView = [[UIView alloc] init];
        _restingTagBgView.backgroundColor = HDAppTheme.color.G3;
        _restingTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomLeft radius:5];
        };
    }
    return _restingTagBgView;
}

- (SALabel *)restingTagLabel {
    if (!_restingTagLabel) {
        _restingTagLabel = [[SALabel alloc] init];
        _restingTagLabel.textColor = HDAppTheme.color.G4;
        _restingTagLabel.font = HDAppTheme.font.standard4;
        _restingTagLabel.text = WMLocalizedString(@"cart_resting", @"Closed");
    }
    return _restingTagLabel;
}

- (UIImageView *)isNewStoreImageView {
    if (!_isNewStoreImageView) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"pretty_new"];
        _isNewStoreImageView = imageView;
        _isNewStoreImageView.hidden = true;
    }
    return _isNewStoreImageView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (YYLabel *)descLB {
    if (!_descLB) {
        _descLB = YYLabel.new;
        _descLB.font = HDAppTheme.font.standard4;
    }
    return _descLB;
}

- (YYLabel *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = YYLabel.new;
        _floatLayoutView.numberOfLines = 0;
        _floatLayoutView.userInteractionEnabled = NO;
        _floatLayoutView.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(30);
    }
    return _floatLayoutView;
}

- (UIView *)fastServiceTagBgView {
    if (!_fastServiceTagBgView) {
        _fastServiceTagBgView = UIView.new;
        _fastServiceTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomLeft radius:5];
            view.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        };
    }
    return _fastServiceTagBgView;
}

- (HDUIButton *)fastServiceBTN {
    if (!_fastServiceBTN) {
        _fastServiceBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_fastServiceBTN setImage:[UIImage imageNamed:@"wm_fast_service"] forState:UIControlStateNormal];
        [_fastServiceBTN setTitle:WMLocalizedString(@"wm_fast_service", @"极速达") forState:UIControlStateNormal];
        [_fastServiceBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _fastServiceBTN.titleLabel.font = HDAppTheme.font.standard3Bold;
        _fastServiceBTN.spacingBetweenImageAndTitle = 4;
        _fastServiceBTN.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _fastServiceBTN;
}

- (UIView *)restView {
    if (!_restView) {
        _restView = UIView.new;
        _restView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _restView.layer.masksToBounds = YES;
        _restView.layer.cornerRadius = kRealWidth(4);
    }
    return _restView;
}

- (HDUIButton *)restBTN {
    if (!_restBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = kRealWidth(4);
        button.userInteractionEnabled = false;
        _restBTN = button;
    }
    return _restBTN;
}

- (HDUIButton *)fullOrderBTN {
    if (!_fullOrderBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = kRealWidth(2);
        button.userInteractionEnabled = false;
        button.layer.cornerRadius = kRealWidth(10);
        button.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, kRealWidth(5));
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        _fullOrderBTN = button;
    }
    return _fullOrderBTN;
}

- (SALabel *)restLB {
    if (!_restLB) {
        _restLB = SALabel.new;
        _restLB.textAlignment = NSTextAlignmentCenter;
        _restLB.textColor = UIColor.whiteColor;
        _restLB.font = [HDAppTheme.font forSize:14];
    }
    return _restLB;
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectview;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColor;
    }
    return _lineView;
}

- (UIView *)timeAndDistanceView {
    if (!_timeAndDistanceView) {
        _timeAndDistanceView = UIView.new;
        _timeAndDistanceView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0].CGColor;
            view.layer.cornerRadius = 10;
            view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.12].CGColor;
            view.layer.shadowOffset = CGSizeMake(0, 0);
            view.layer.shadowOpacity = 1;
            view.layer.shadowRadius = precedingFrame.size.height / 2.0;
        };
    }
    return _timeAndDistanceView;
}

- (HDUIButton *)timeBTN {
    if (!_timeBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_home_time"] forState:UIControlStateNormal];
        btn.spacingBetweenImageAndTitle = kRealWidth(3);
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.userInteractionEnabled = NO;
        _timeBTN = btn;
    }
    return _timeBTN;
}

- (HDUIButton *)distanceBTN {
    if (!_distanceBTN) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"yn_home_distance"] forState:UIControlStateNormal];
        btn.spacingBetweenImageAndTitle = kRealWidth(3);
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.userInteractionEnabled = NO;
        _distanceBTN = btn;
    }
    return _distanceBTN;
}

@end
