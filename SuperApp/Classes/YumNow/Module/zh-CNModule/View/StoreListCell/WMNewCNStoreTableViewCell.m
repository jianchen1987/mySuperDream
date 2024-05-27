//
//  WMNewCNStoreTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewCNStoreTableViewCell.h"
#import "SACaculateNumberTool.h"
#import "WMManage.h"


@interface WMNewCNStoreTableViewCell ()

@property (nonatomic, strong) UIView *containView;
/// icon
@property (nonatomic, strong) UIImageView *logoIV;
@property (nonatomic, strong) UIView *logoStatusView;
@property (nonatomic, strong) UIImageView *logoStatusImageView;
@property (nonatomic, strong) UILabel *logoStatusLabel;
/// 新标签背景
@property (nonatomic, strong) UIImageView *logoTagBgView;

@property (nonatomic, strong) SALabel *nameLB;
/// 评分、评价
@property (nonatomic, strong) YYLabel *ratingAndReviewLB;
/// 配送时间和距离
@property (nonatomic, strong) YYLabel *deliveryTimeAndDistanceLB;

/// 门店休息中
@property (nonatomic, strong) UIView *storeRestView;
/// 门店休息中文本
@property (nonatomic, strong) UILabel *storeRestLB;


/// 自定义标签label
@property (nonatomic, strong) SALabel *customTagLabel;

/// 更多按钮
@property (nonatomic, strong) HDUIButton *moreBtn;
/// tagView
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;

@end


@implementation WMNewCNStoreTableViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];

    [self.contentView addSubview:self.containView];

    [self.containView addSubview:self.logoIV];
    [self.logoIV addSubview:self.logoStatusView];
    [self.logoStatusView addSubview:self.logoStatusImageView];
    [self.logoStatusView addSubview:self.logoStatusLabel];

    [self.containView addSubview:self.logoTagBgView];
    //    [self.logoTagBgView addSubview:self.logoTagLabel];
    [self.containView addSubview:self.nameLB];
    [self.containView addSubview:self.ratingAndReviewLB];
    [self.containView addSubview:self.deliveryTimeAndDistanceLB];
    [self.containView addSubview:self.floatLayoutView];
    [self.containView addSubview:self.moreBtn];
    //    [self.containView addSubview:self.lineView];
    [self.containView addSubview:self.storeRestView];
    //    [self.storeRestView addSubview:self.storeRestIV];
    [self.storeRestView addSubview:self.storeRestLB];
    [self.containView addSubview:self.customTagLabel];
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];

    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), 0, kRealWidth(12)));
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(86), kRealWidth(86)));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        make.left.mas_equalTo(kRealWidth(8));
    }];


    [self.logoStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.logoStatusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(21));
        make.centerX.mas_equalTo(0);
    }];

    [self.logoStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoStatusImageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];

    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV.mas_top).offset(-2);
        make.left.equalTo(self.logoIV.mas_left).offset(-2);
        //        make.width.lessThanOrEqualTo(self.logoIV.mas_width);
    }];

    //    [self.logoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(kRealWidth(4));
    //        make.top.bottom.mas_equalTo(0);
    //        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    //        make.right.mas_equalTo(kRealWidth(-4));
    //    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(22));
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    __block UIView *lastView = self.nameLB;

    [self.ratingAndReviewLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.left.mas_lessThanOrEqualTo(self.nameLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(16));
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
        lastView = self.ratingAndReviewLB;
    }];

    [self.deliveryTimeAndDistanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ratingAndReviewLB.mas_right).offset(kRealWidth(4));
        make.centerY.equalTo(lastView);
        make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.storeRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestView.isHidden) {
            make.left.equalTo(self.nameLB);
            make.top.equalTo(self.ratingAndReviewLB.mas_bottom).offset(kRealWidth(4));
            make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(20));
            lastView = self.storeRestView;
        }
    }];

    [self.storeRestLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestLB.isHidden) {
            make.edges.equalTo(self.storeRestView).insets(UIEdgeInsetsMake(kRealWidth(3), kRealWidth(4), kRealWidth(3), kRealWidth(4)));
        }
    }];

    [self.customTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.customTagLabel.isHidden) {
            make.left.equalTo(self.nameLB);
            make.top.equalTo(self.ratingAndReviewLB.mas_bottom).offset(kRealWidth(4));
            make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(20));
            lastView = self.customTagLabel;
        }
    }];


    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.floatLayoutView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(20)));
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(4));
            make.left.equalTo(self.nameLB);
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(12) * 2 - kRealWidth(8) * 2 - kRealWidth(100) - kRealWidth(40), CGFLOAT_MAX)];
            make.size.mas_equalTo(size);

            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
            lastView = self.floatLayoutView;
        }
    }];


    [self.ratingAndReviewLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.ratingAndReviewLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moreBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setModel:(WMStoreModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(kRealWidth(86), kRealWidth(86))] imageView:self.logoIV];
    ///文本
    [self updateRatingAndDeleveryLabelContent];
    ///优惠活动
    [self configPromotions];
    ///休息中或爆单
    [self restOrFullOrderAction];

    [self setNeedsUpdateConstraints];
}

///配送费距离等文本显示
- (void)updateRatingAndDeleveryLabelContent {
    self.logoTagBgView.hidden = YES;
    //    HDLog(@"%@",self.model.storeType);
    //    HDLog(@"%d",self.model.isNewStore);
    if (self.model.isNewStore || [self.model.storeType isEqualToString:@"ST0002"] || [self.model.storeType isEqualToString:@"ST0004"]) {
        self.logoTagBgView.hidden = NO;
        if (self.model.isNewStore) {
            self.logoTagBgView.image = [UIImage imageNamed:@"yn_home_new_shop"];
        } else {
            self.logoTagBgView.image = [UIImage imageNamed:@"yn_home_brand"];
        }
    }
    ///关键词高亮
    NSString *lowerCaseStoreName = self.model.storeName.desc.lowercaseString;
    NSString *lowerCaseKeyWord = self.model.keyWord.lowercaseString;
    NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = @[];
    if (lowerCaseStoreName) {
        matches = [regex matchesInString:lowerCaseStoreName options:0 range:NSMakeRange(0, lowerCaseStoreName.length)];
    }
    if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
        NSMutableAttributedString *attrStr =
            [[NSMutableAttributedString alloc] initWithString:self.model.storeName.desc
                                                   attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:16]}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:16]} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        self.nameLB.font = [HDAppTheme.WMFont wm_boldForSize:16];
        self.nameLB.textColor = HDAppTheme.WMColor.B3;
        self.nameLB.text = self.model.storeName.desc;
    }
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:11];
    ///拼接分数
    if (true) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

        // 拼接分数
        if (self.model.ratingScore > 0) {
            NSString *score = [NSString stringWithFormat:@"%.1f", self.model.ratingScore];
            NSMutableAttributedString *scoreStr = [[NSMutableAttributedString alloc]
                initWithString:score
                    attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.sa_C1, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Bold"]}];
            [text appendAttributedString:scoreStr];

            score = @"分";
            scoreStr = [[NSMutableAttributedString alloc] initWithString:score
                                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.sa_C1, NSFontAttributeName: HDAppTheme.font.sa_standard11}];
            [text appendAttributedString:scoreStr];
        }

        ///已售
        NSString *sold = self.model.sale;
        if (!sold) {
            sold = [NSString stringWithFormat:@"•%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.ordered];
        }
        NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc] initWithString:sold attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B9, NSFontAttributeName: font}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
        [text appendAttributedString:soldStr];
        self.ratingAndReviewLB.attributedText = text;
        self.ratingAndReviewLB.numberOfLines = 1;
    }
    ///拼接备餐时间和距离
    if (true) {
        NSMutableAttributedString *deliveryTimeAndDistanceStr = [[NSMutableAttributedString alloc] initWithString:@""];

        UIImage *chucanImage = [UIImage imageNamed:@"yn_home_time_gray"];
        NSMutableAttributedString *chuImageString = [NSMutableAttributedString yy_attachmentStringWithContent:chucanImage contentMode:UIViewContentModeCenter
                                                                                               attachmentSize:CGSizeMake(chucanImage.size.width, chucanImage.size.height)
                                                                                                  alignToFont:font
                                                                                                    alignment:YYTextVerticalAlignmentCenter];
        [deliveryTimeAndDistanceStr appendAttributedString:chuImageString];

        NSString *deliveryTime = self.model.deliveryTime;
        if (self.model.estimatedDeliveryTime) {
            if (self.model.estimatedDeliveryTime.integerValue > 60) {
                deliveryTime = @">60";
            } else {
                deliveryTime = self.model.estimatedDeliveryTime;
            }
        }
        [deliveryTimeAndDistanceStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分钟", deliveryTime]]];

        [deliveryTimeAndDistanceStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                                           attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B9, NSFontAttributeName: font}]];
        //        UIImage *localImage = [UIImage imageNamed:@"yn_store_local"];
        //        NSMutableAttributedString *localImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:localImage contentMode:UIViewContentModeCenter
        //                                                                                              attachmentSize:CGSizeMake(localImage.size.width, localImage.size.height)
        //                                                                                                 alignToFont:font
        //                                                                                                   alignment:YYTextVerticalAlignmentCenter];
        //        [deliveryTimeAndDistanceStr appendAttributedString:localImageAtt];
        [deliveryTimeAndDistanceStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[SACaculateNumberTool distanceStringFromNumber:self.model.distance toFixedCount:0
                                                                                                                                               roundingMode:SANumRoundingModeOnlyUp]]];
        deliveryTimeAndDistanceStr.yy_font = font;
        deliveryTimeAndDistanceStr.yy_color = HDAppTheme.WMColor.B9;
        self.deliveryTimeAndDistanceLB.attributedText = deliveryTimeAndDistanceStr;
    }
}

///优惠活动
- (void)configPromotions {
    BOOL hasFastService = self.model.slowPayMark.boolValue;
    self.floatLayoutView.hidden = HDIsArrayEmpty(self.model.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    self.moreBtn.hidden = YES;
    if (!self.floatLayoutView.hidden) {
        if (!self.model.tagArr) {
            NSMutableArray *mArr = [WMStoreDetailPromotionModel configNewPromotions:self.model.promotions productPromotion:self.model.productPromotions hasFastService:YES shouldAddStoreCoupon:YES newStyle:YES].mutableCopy;
            if (self.model.serviceLabel.count) {
                [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.model.serviceLabel newStyle:YES]];
            }
            self.model.tagArr = mArr;
        }
        self.floatLayoutView.maxRowCount = self.model.numberOfLinesOfPromotion;
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (HDUIGhostButton *button in self.model.tagArr) {
            [self.floatLayoutView addSubview:button];
        }
        if (!self.model.lines) {
            NSInteger row = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(kScreenWidth - kRealWidth(12) * 2 - kRealWidth(8) * 2 - kRealWidth(100) - kRealWidth(40), CGFLOAT_MAX)];
            self.model.lines = row;
            if (self.model.lines == 0 && !self.floatLayoutView.hidden) {
                self.model.lines = 1;
            }
        }
        self.moreBtn.hidden = self.model.lines <= 1;
        self.moreBtn.selected = self.model.numberOfLinesOfPromotion ? NO : YES;
    }
}

///休息中或爆单
- (void)restOrFullOrderAction {
    self.storeRestView.hidden = self.storeRestLB.hidden = YES;
    NSString *str = nil;

    self.logoStatusView.hidden = self.logoStatusLabel.hidden = self.logoStatusImageView.hidden = YES;

    if (![self.model.storeStatus.status isEqualToString:WMStoreStatusOpening] || self.model.nextServiceTime) {
        if (self.model.nextServiceTime) {
            str = [NSString stringWithFormat:@"%@: %@ %@",
                                             WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                             self.model.nextServiceTime.weekday.code ? WMManage.shareInstance.weekInfo[self.model.nextServiceTime.weekday.code] : @"",
                                             self.model.nextServiceTime.time ?: @""];
            self.logoStatusView.hidden = self.logoStatusLabel.hidden = self.logoStatusImageView.hidden = NO;
            self.logoStatusLabel.text = @"休息";
            self.logoStatusImageView.image = [UIImage imageNamed:@"yn_zh_home_rest2"];
        } else {
            str = SALocalizedString(@"cart_resting", @"Resting");
        }
    } else {
        if (self.model.fullOrderState == WMStoreFullOrderStateFull) {
            str = WMLocalizedString(@"wm_store_busy", @"繁忙");
        } else if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
            str = [NSString stringWithFormat:@"%@分钟后可下单", @"30"];
            self.logoStatusView.hidden = self.logoStatusLabel.hidden = self.logoStatusImageView.hidden = NO;
            self.logoStatusLabel.text = @"繁忙";
            self.logoStatusImageView.image = [UIImage imageNamed:@"yn_zh_home_busy2"];
        } else if (self.model.slowMealState == WMStoreSlowMealStateSlow) {
            str = WMLocalizedString(@"wm_store_many_order", @"订单较多");
        }
    }

    self.storeRestLB.hidden = HDIsStringEmpty(str);
    self.storeRestLB.text = str;
    self.storeRestView.hidden = self.storeRestLB.isHidden;

    self.customTagLabel.hidden = YES;
    if (self.storeRestView.isHidden && HDIsStringNotEmpty(self.model.tags)) {
        self.customTagLabel.hidden = NO;
        self.customTagLabel.text = self.model.tags;
    }
}

#pragma mark - lazy load
- (UIView *)containView {
    if (!_containView) {
        _containView = UIView.new;
        _containView.backgroundColor = UIColor.whiteColor;
        _containView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(12)];
        };
    }
    return _containView;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = UIImageView.new;
        _logoIV.contentMode = UIViewContentModeScaleAspectFill;
        _logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.borderColor = HDAppTheme.WMColor.bgGray.CGColor;
            view.layer.cornerRadius = kRealWidth(8);
            view.layer.borderWidth = 1;
            view.clipsToBounds = YES;
        };
    }
    return _logoIV;
}

- (UIImageView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_home_new_shop"]];
    }
    return _logoTagBgView;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:15];
        label.textColor = HDAppTheme.WMColor.B3;
        _nameLB = label;
    }
    return _nameLB;
}

- (YYLabel *)ratingAndReviewLB {
    if (!_ratingAndReviewLB) {
        _ratingAndReviewLB = YYLabel.new;
        _ratingAndReviewLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(112);
    }
    return _ratingAndReviewLB;
}

- (YYLabel *)deliveryTimeAndDistanceLB {
    if (!_deliveryTimeAndDistanceLB) {
        _deliveryTimeAndDistanceLB = YYLabel.new;
        _deliveryTimeAndDistanceLB.textColor = HDAppTheme.WMColor.B9;
        _deliveryTimeAndDistanceLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _deliveryTimeAndDistanceLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(112);
    }
    return _deliveryTimeAndDistanceLB;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 4, 4);
        _floatLayoutView.maxRowCount = 1;
    }
    return _floatLayoutView;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_home_arrow_up"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_home_arrow_down"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            self.model.numberOfLinesOfPromotion = btn.isSelected ? 0 : 1;
            UIView *view = btn;
            while (view.superview) {
                if ([view isKindOfClass:UITableView.class]) {
                    UITableView *tableView = (UITableView *)view;
                    [tableView reloadData];
                    break;
                }
                view = view.superview;
            }
        }];
        _moreBtn = button;
    }
    return _moreBtn;
}

- (UIView *)storeRestView {
    if (!_storeRestView) {
        _storeRestView = UIView.new;
        _storeRestView.layer.cornerRadius = kRealWidth(2);
        _storeRestView.layer.backgroundColor = HDAppTheme.WMColor.B6.CGColor;
    }
    return _storeRestView;
}

- (UILabel *)storeRestLB {
    if (!_storeRestLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        label.textColor = HDAppTheme.WMColor.ffffff;
        label.textAlignment = NSTextAlignmentCenter;
        _storeRestLB = label;
    }
    return _storeRestLB;
}

- (SALabel *)customTagLabel {
    if (!_customTagLabel) {
        _customTagLabel = SALabel.new;
        _customTagLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#FBF5E8"];
        _customTagLabel.textColor = [UIColor hd_colorWithHexString:@"#9B722E"];
        _customTagLabel.font = HDAppTheme.font.sa_standard11SB;
        _customTagLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(4), kRealWidth(3), kRealWidth(4));
    }
    return _customTagLabel;
}

- (UIView *)logoStatusView {
    if (!_logoStatusView) {
        _logoStatusView = UIView.new;
        _logoStatusView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    }
    return _logoStatusView;
}

- (UIImageView *)logoStatusImageView {
    if (!_logoStatusImageView) {
        _logoStatusImageView = UIImageView.new;
    }
    return _logoStatusImageView;
}

- (UILabel *)logoStatusLabel {
    if (!_logoStatusLabel) {
        _logoStatusLabel = UILabel.new;
        _logoStatusLabel.textColor = UIColor.whiteColor;
        _logoStatusLabel.font = HDAppTheme.font.sa_standard12M;
    }
    return _logoStatusLabel;
}

@end
