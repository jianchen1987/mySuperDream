//
//  WMCNStoreView.m
//  SuperApp
//
//  Created by Tia on 2023/12/5.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCNStoreView.h"
#import "SACaculateNumberTool.h"
#import "WMManage.h"

@interface WMCNStoreView ()
/// icon
@property (nonatomic, strong) UIImageView *logoIV;
/// 新标签背景
@property (nonatomic, strong) UIView *logoTagBgView;
/// 新标签
@property (nonatomic, strong) SALabel *logoTagLabel;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 评分、评价
@property (nonatomic, strong) YYLabel *ratingAndReviewLB;
/// 配送时间和距离
@property (nonatomic, strong) YYLabel *deliveryTimeAndDistanceLB;
/// line
@property (nonatomic, strong) UIView *lineView;
/// 门店休息中
@property (nonatomic, strong) UIView *storeRestView;
/// 门店休息中文本
@property (nonatomic, strong) UILabel *storeRestLB;
/// 门店休息中图片
@property (nonatomic, strong) UIImageView *storeRestIV;
/// 更多按钮
@property (nonatomic, strong) HDUIButton *moreBtn;
/// 优惠
@property (nonatomic, strong) YYLabel *floatLayoutView;
@end

@implementation WMCNStoreView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.logoIV];
    [self addSubview:self.logoTagBgView];
    [self.logoTagBgView addSubview:self.logoTagLabel];
    [self addSubview:self.nameLB];
    [self addSubview:self.ratingAndReviewLB];
    [self addSubview:self.deliveryTimeAndDistanceLB];
    [self addSubview:self.floatLayoutView];
    [self addSubview:self.moreBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.storeRestView];
    [self.storeRestView addSubview:self.storeRestIV];
    [self.storeRestView addSubview:self.storeRestLB];
    
    [self.storeRestIV setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.storeRestIV setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moreBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.top.mas_equalTo(kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(12));
    }];

    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV.mas_top).offset(-kRealWidth(2));
        make.left.equalTo(self.logoIV.mas_left).offset(-kRealWidth(2));
        make.width.lessThanOrEqualTo(self.logoIV.mas_width);
    }];

    [self.logoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(4));
        make.top.bottom.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        make.right.mas_equalTo(kRealWidth(-4));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    __block UIView *lastView = self.nameLB;

    [self.storeRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestView.isHidden) {
            make.left.equalTo(self.nameLB);
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(4));
            make.right.mas_lessThanOrEqualTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(20));
            lastView = self.storeRestView;
        }
    }];

    [self.storeRestIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestIV.isHidden) {
            make.left.mas_equalTo(kRealWidth(2));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
            make.centerY.mas_equalTo(0);
        }
    }];

    [self.storeRestLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestLB.isHidden) {
//            make.top.mas_equalTo(kRealWidth(3));
//            make.bottom.mas_equalTo(-kRealWidth(3));
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kRealWidth(8));
            //            make.height.mas_greaterThanOrEqualTo(kRealWidth(16));
            if (self.storeRestIV.isHidden) {
                make.left.mas_equalTo(kRealWidth(8));
            } else {
                make.left.equalTo(self.storeRestIV.mas_right);
            }
        }
    }];

    [self.ratingAndReviewLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.height.mas_equalTo(kRealWidth(18));
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        lastView = self.ratingAndReviewLB;
    }];

    [self.deliveryTimeAndDistanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.height.mas_equalTo(kRealWidth(18));
        make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        lastView = self.deliveryTimeAndDistanceLB;
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
            make.right.equalTo(self.moreBtn.mas_left);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            lastView = self.floatLayoutView;
        }
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];


}

- (void)setModel:(WMBaseStoreModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(kRealWidth(80), kRealWidth(80))] imageView:self.logoIV];
    ///文本
    [self updateRatingAndDeleveryLabelContent];
    ///优惠活动
    [self configPromotions];
    ///休息中或爆单
    [self restOrFullOrderAction];

    [self setNeedsUpdateConstraints];
}

///休息中或爆单
- (void)restOrFullOrderAction {
    self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = YES;
    NSString *imageName = nil;
    NSString *str = nil;
    if (![self.model.storeStatus.status isEqualToString:WMStoreStatusOpening] || self.model.nextServiceTime) {
        imageName = @"yn_zh_home_rest";
        if (self.model.nextServiceTime) {
            str = [NSString stringWithFormat:@"%@•%@: %@ %@",
                                             SALocalizedString(@"cart_resting", @"Resting"),
                                             WMLocalizedString(@"store_detail_business_hours", @"营业时间"),
                                             self.model.nextServiceTime.weekday.code ? WMManage.shareInstance.weekInfo[self.model.nextServiceTime.weekday.code] : @"",
                                             self.model.nextServiceTime.time ?: @""];
        } else {
            str = SALocalizedString(@"cart_resting", @"Resting");
        }
    } else {
        if (self.model.fullOrderState == WMStoreFullOrderStateFull) {
            imageName = @"yn_zh_home_busy";
            str = WMLocalizedString(@"wm_store_busy", @"繁忙");
        } else if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
            imageName = @"yn_zh_home_busy";
            str = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_minu", @"繁忙·%@分钟后可下单"), @"30"];
        } else if (self.model.slowMealState == WMStoreSlowMealStateSlow) {
            str = WMLocalizedString(@"wm_store_many_order", @"订单较多");
            imageName = @"yn_zh_home_order";
        }
    }
    self.storeRestIV.hidden = HDIsStringEmpty(imageName);
    self.storeRestLB.hidden = HDIsStringEmpty(str);
    self.storeRestLB.text = str;
    self.storeRestIV.image = [UIImage imageNamed:imageName];
    self.storeRestView.hidden = (self.storeRestLB.isHidden && self.storeRestIV.isHidden);
}

///优惠活动
- (void)configPromotions {
    BOOL hasFastService = self.model.slowPayMark.boolValue;
    
    if([self.model isKindOfClass:[WMNewStoreModel class]]){
        WMNewStoreModel *m = (WMNewStoreModel *)self.model;
        self.floatLayoutView.hidden = HDIsArrayEmpty(m.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    }else{
        WMStoreModel *m = (WMStoreModel *)self.model;
        self.floatLayoutView.hidden = HDIsArrayEmpty(m.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    }

    if (!self.model.tagString) {
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
    if (!self.model.lines) {
        self.floatLayoutView.lineBreakMode = NSLineBreakByTruncatingTail;
        self.floatLayoutView.numberOfLines = 0;
        self.floatLayoutView.attributedText = self.model.tagString;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.floatLayoutView.preferredMaxLayoutWidth, CGFLOAT_MAX) text:self.model.tagString];
        self.model.lines = layout.rowCount;
        if (self.model.lines == 0 && !self.floatLayoutView.hidden) {
            self.model.lines = 1;
        }
    }
    self.floatLayoutView.lineBreakMode = NSLineBreakByWordWrapping;
    self.floatLayoutView.numberOfLines = self.model.numberOfLinesOfPromotion;
    self.floatLayoutView.attributedText = self.model.tagString;
    self.moreBtn.hidden = self.model.lines <= 1;
    self.moreBtn.selected = self.model.numberOfLinesOfPromotion ? NO : YES;
}

///配送费距离等文本显示
- (void)updateRatingAndDeleveryLabelContent {
    ///新店或自定义标签
    self.logoTagBgView.hidden = YES;
    if (self.model.isNewStore || HDIsStringNotEmpty(self.model.tags)) {
        self.logoTagBgView.hidden = NO;
        if (self.model.isNewStore) {
            self.logoTagLabel.text = WMLocalizedString(@"is_new_store", @"New");
        } else {
            self.logoTagLabel.text = self.model.tags;
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
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:12];
    ///拼接分数
    if (true) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];

        UIImage *image = [UIImage imageNamed:@"yn_home_star"];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter
                                                                                           attachmentSize:CGSizeMake(image.size.width, font.lineHeight)
                                                                                              alignToFont:font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachment];

        // 拼接分数
        NSString *score = [NSString stringWithFormat:@"%.1f", self.model.ratingScore];
        if (self.model.ratingScore == 0)
            score = WMLocalizedString(@"wm_no_ratings_yet", @"暂无评分");
        NSMutableAttributedString *scoreStr =
            [[NSMutableAttributedString alloc] initWithString:score
                                                   attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DIN-Bold"]}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [text appendAttributedString:scoreStr];

        if (self.model.ratingScore > 0) {
            // 拼接评价
            NSString *commments = [NSString stringWithFormat:@"(%@)", [NSString stringWithFormat:@"%zd", self.model.commentsCount]];
            NSMutableAttributedString *commmentsStr = [[NSMutableAttributedString alloc] initWithString:commments
                                                                                             attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: font}];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [text appendAttributedString:commmentsStr];
        }
        ///已售
        NSString *sold = self.model.sale;
        if (!sold) {
            if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
                sold = [NSString stringWithFormat:@"•%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.ordered];
            } else {
                sold = [NSString stringWithFormat:@"•%zd %@", self.model.ordered, WMLocalizedString(@"wm_sold", @"Sold")];
            }
        }
        NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc] initWithString:sold attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: font}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
        [text appendAttributedString:soldStr];
        self.ratingAndReviewLB.attributedText = text;
        self.ratingAndReviewLB.numberOfLines = 0;
    }
    ///拼接备餐时间和距离
    if (true) {
        NSMutableAttributedString *deliveryTimeAndDistanceStr = [[NSMutableAttributedString alloc] initWithString:@""];

        UIImage *chucanImage = [UIImage imageNamed:@"yn_home_chucan"];
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
                                                                                           attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B6, NSFontAttributeName: font}]];
        UIImage *localImage = [UIImage imageNamed:@"yn_store_local"];
        NSMutableAttributedString *localImageAtt = [NSMutableAttributedString yy_attachmentStringWithContent:localImage contentMode:UIViewContentModeCenter
                                                                                              attachmentSize:CGSizeMake(localImage.size.width, localImage.size.height)
                                                                                                 alignToFont:font
                                                                                                   alignment:YYTextVerticalAlignmentCenter];
        [deliveryTimeAndDistanceStr appendAttributedString:localImageAtt];
        [deliveryTimeAndDistanceStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[SACaculateNumberTool distanceStringFromNumber:self.model.distance toFixedCount:0
                                                                                                                                               roundingMode:SANumRoundingModeOnlyUp]]];
        deliveryTimeAndDistanceStr.yy_font = font;
        deliveryTimeAndDistanceStr.yy_color = HDAppTheme.WMColor.B6;
        self.deliveryTimeAndDistanceLB.attributedText = deliveryTimeAndDistanceStr;
    }
}

#pragma mark - lazy load
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

- (UIView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIView alloc] init];
        _logoTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.backgroundColor = HDAppTheme.WMColor.mainRed;
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:kRealWidth(4)];
        };
    }
    return _logoTagBgView;
}

- (SALabel *)logoTagLabel {
    if (!_logoTagLabel) {
        _logoTagLabel = [[SALabel alloc] init];
        _logoTagLabel.textColor = UIColor.whiteColor;
        _logoTagLabel.font = [HDAppTheme.WMFont wm_ForSize:10];
        _logoTagLabel.numberOfLines = 1;
        _logoTagLabel.text = WMLocalizedString(@"is_new_store", @"New");
    }
    return _logoTagLabel;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
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
        _deliveryTimeAndDistanceLB.textColor = HDAppTheme.WMColor.B6;
        _deliveryTimeAndDistanceLB.font = [HDAppTheme.WMFont wm_ForSize:12];
        _deliveryTimeAndDistanceLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(112);
    }
    return _deliveryTimeAndDistanceLB;
}

- (YYLabel *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = YYLabel.new;
        _floatLayoutView.userInteractionEnabled = NO;
        _floatLayoutView.numberOfLines = 0;
        _floatLayoutView.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(140);
    }
    return _floatLayoutView;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_home_d"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_home_u"] forState:UIControlStateNormal];
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
                }else if ([view isKindOfClass:UICollectionView.class]) {
                    UICollectionView *tableView = (UICollectionView *)view;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _lineView;
}

- (UIView *)storeRestView {
    if (!_storeRestView) {
        _storeRestView = UIView.new;
        _storeRestView.layer.cornerRadius = kRealWidth(2);
        _storeRestView.layer.backgroundColor = HDAppTheme.WMColor.B6.CGColor;
    }
    return _storeRestView;
}

- (UIImageView *)storeRestIV {
    if (!_storeRestIV) {
        UIImageView *imageView = UIImageView.new;
        _storeRestIV = imageView;
    }
    return _storeRestIV;
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

@end
