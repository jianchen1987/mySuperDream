//
//  WMStoreSearchResultTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreSearchResultTableViewCell.h"
#import "GNEvent.h"
#import "SACaculateNumberTool.h"
#import "SAShadowBackgroundView.h"
#import "WMManage.h"
#import "WMPromotionLabel.h"
#import "WMSpecialSignturesMoreCell.h"
#import "WMSpecialStoreSignaturesCell.h"
#import <YYText/YYText.h>

static CGFloat kIconWidth;
static CGFloat kMarginTen;
static CGFloat kMarginEight;
static CGFloat kMarginBottom;


@interface WMStoreSearchResultTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
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
@property (nonatomic, strong) HDUIGhostButton *deliveryTimeAndDistanceLB;
/// 商品
@property (nonatomic, strong) UICollectionView *collectionView;
/// 数据源
@property (nonatomic, copy) NSArray *dataSource;
/// 优惠
@property (nonatomic, strong) YYLabel *floatLayoutView;
/// 分类
@property (nonatomic, strong) YYLabel *cateFloatLayoutView;
/// 更多按钮
@property (nonatomic, strong) HDUIButton *moreBtn;
/// 招牌菜
@property (nonatomic, strong) UICollectionView *signCollectionView;
/// 招牌菜数据源
@property (nonatomic, copy) NSArray *signDataSource;
/// 下次营业时间文本
@property (nonatomic, strong) SALabel *restTimeLB;
/// 下次营业时间View
@property (nonatomic, strong) UIView *restTimeView;
/// 下次营业文本内容
@property (nonatomic, strong) HDLabel *restLB;
/// 下次营业文本内容
@property (nonatomic, strong) HDUIButton *restBTN;
/// line
@property (nonatomic, strong) UIView *lineView;
/// 门店休息中 3.0
@property (nonatomic, strong) UIView *storeRestView;
/// 门店休息中文本 3.0
@property (nonatomic, strong) UILabel *storeRestLB;
/// 门店休息中图片 3.0
@property (nonatomic, strong) UIImageView *storeRestIV;
/// 爆单
@property (nonatomic, strong) YYLabel *fullOrderLB;
/// borderLayer
@property (nonatomic, strong) CAShapeLayer *borderLayer;
/// 不在配送范围内
@property (nonatomic, strong) HDLabel *limitLB;
@end


@implementation WMStoreSearchResultTableViewCell

- (void)hd_setupViews {
    kIconWidth = kRealWidth(68);
    kMarginTen = kRealWidth(12);
    kMarginEight = kRealWidth(8);
    kMarginBottom = kRealWidth(16);
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.selectBTN];
    [self.contentView addSubview:self.logoIV];
    [self.contentView addSubview:self.logoTagBgView];
    [self.logoTagBgView addSubview:self.logoTagLabel];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.ratingAndReviewLB];
    [self.contentView addSubview:self.deliveryTimeAndDistanceLB];
    [self.contentView addSubview:self.cateFloatLayoutView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.signCollectionView];
    [self.contentView addSubview:self.moreBtn];
    
    [self.contentView addSubview:self.restTimeView];
    [self.restTimeView addSubview:self.restTimeLB];
    [self.contentView addSubview:self.restLB];
    [self.contentView addSubview:self.restBTN];
    [self.contentView addSubview:self.lineView];
    
    [self.logoIV addSubview:self.storeRestView];
    [self.storeRestView addSubview:self.storeRestIV];
    [self.storeRestView addSubview:self.storeRestLB];
    
    [self.contentView addSubview:self.fullOrderLB];
    [self.contentView addSubview:self.limitLB];
    
    self.logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(6)];
        view.clipsToBounds = YES;
    };
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];
    
    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.selectBTN.isHidden) {
            make.left.mas_equalTo(kMarginTen);
            make.centerY.equalTo(self.logoIV);
            make.size.mas_equalTo(self.selectBTN.size);
        }
    }];
    
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kIconWidth, kIconWidth));
        make.top.equalTo(self.contentView).offset(kMarginBottom);
        make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
        if (self.selectBTN.isHidden) {
            make.left.mas_equalTo(kMarginTen);
        } else {
            make.left.equalTo(self.selectBTN.mas_right).offset(kMarginTen);
        }
    }];
    
    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.logoIV);
    }];
    
    [self.logoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoTagBgView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.logoTagBgView.mas_top);
        make.bottom.equalTo(self.logoTagBgView.mas_bottom);
        make.right.equalTo(self.logoTagBgView.mas_right).offset(kRealWidth(-5));
    }];
    
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV);
        make.left.equalTo(self.logoIV.mas_right).offset(kMarginEight);
        make.right.equalTo(self.deliveryTimeAndDistanceLB.mas_left).offset(-kMarginEight);
        if (!HDIsStringEmpty(self.nameLB.text)) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        }
        make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
    }];
    
    [self.restBTN sizeToFit];
    [self.restBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restBTN.isHidden) {
            make.top.right.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(18)));
        }
    }];
    
    [self.fullOrderLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.fullOrderLB.isHidden) {
            CGFloat width = kScreenWidth - kMarginTen * 2 - kMarginEight - kIconWidth;
            CGSize size = [self.fullOrderLB sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.left.equalTo(self.nameLB);
            make.width.mas_equalTo(size.width);
            make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
        }
    }];
    
    [self.cateFloatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.cateFloatLayoutView.isHidden) {
            if (!self.fullOrderLB.isHidden) {
                make.top.equalTo(self.fullOrderLB.mas_bottom).offset(kRealWidth(4));
            } else {
                make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(8));
            }
            make.left.equalTo(self.nameLB);
            make.right.mas_equalTo(-kMarginTen);
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
        }
    }];
    
    [self.deliveryTimeAndDistanceLB sizeToFit];
    [self.deliveryTimeAndDistanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_top);
        make.right.equalTo(self.contentView).offset(-kMarginTen);
        make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
    }];
    
    self.ratingAndReviewLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(60) - 3 * kRealWidth(10);
    [self.ratingAndReviewLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        if (self.cateFloatLayoutView.isHidden) {
            if (!self.fullOrderLB.isHidden) {
                make.top.equalTo(self.fullOrderLB.mas_bottom).offset(kRealWidth(4));
            } else {
                make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(8));
            }
        } else {
            make.top.equalTo(self.cateFloatLayoutView.mas_bottom).offset(kRealWidth(8));
        }
        make.right.mas_equalTo(-kMarginTen);
        make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
    }];
    
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kMarginTen);
        make.top.equalTo(self.floatLayoutView);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(26), kRealWidth(20)));
    }];
    
    __block UIView *topView = self.ratingAndReviewLB;
    [self.restLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restLB.isHidden) {
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.left.equalTo(self.nameLB);
            make.height.mas_equalTo(kRealHeight(24));
            make.width.mas_greaterThanOrEqualTo(kRealWidth(63));
            if (self.collectionView.isHidden && self.signCollectionView.isHidden && self.floatLayoutView.isHidden) {
                make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
            }
            topView = self.restLB;
        }
    }];
    
    [self.restTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restTimeView.isHidden) {
            make.top.equalTo(self.restLB);
            make.left.equalTo(self.restLB.mas_right);
            make.height.mas_equalTo(kRealHeight(24));
        }
    }];
    
    [self.restTimeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.restTimeLB.isHidden) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }
    }];
    
    
    [self.limitLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.limitLB.isHidden) {
            make.left.equalTo(self.nameLB);
            make.height.mas_equalTo(kRealWidth(20));
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
            topView = self.limitLB;
        }
    }];
    
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            make.left.equalTo(self.nameLB);
            make.right.equalTo(self.moreBtn.mas_left);
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            topView = self.floatLayoutView;
        }
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.collectionView.isHidden) {
            make.left.equalTo(self.logoIV);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(kRealWidth(113));
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            topView = self.collectionView;
        }
    }];
    
    [self.signCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.signCollectionView.isHidden) {
            make.left.equalTo(self.logoIV);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(kRealWidth(113));
            make.bottom.mas_lessThanOrEqualTo(-kMarginBottom);
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(8));
            topView = self.collectionView;
        }
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.8);
        make.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
    }];
    
    [self.storeRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestView.isHidden) {
            make.edges.mas_equalTo(0);
        }
    }];
    
    [self.storeRestIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestView.isHidden) {
            make.top.mas_equalTo(kRealWidth(12));
            make.size.mas_equalTo(self.storeRestIV.image.size);
            make.centerX.mas_equalTo(0);
        }
    }];
    
    [self.storeRestLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeRestView.isHidden) {
            make.top.equalTo(self.storeRestIV.mas_bottom).offset(kRealWidth(5));
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }
    }];
    
    [self.deliveryTimeAndDistanceLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.deliveryTimeAndDistanceLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.moreBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moreBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setGNModel:(WMStoreListItemModel *)data {
    if ([data isKindOfClass:WMStoreListItemModel.class]) {
        self.model = data;
    }
}

#pragma mark - setter
- (void)setModel:(WMStoreListItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:HDHelper.placeholderImage imageView:self.logoIV];
    
    NSString *lowerCaseStoreName = model.storeName.desc.lowercaseString;
    NSString *lowerCaseKeyWord = model.keyWord.lowercaseString;
    
    NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *matches = @[];
    if (lowerCaseStoreName) {
        matches = [regex matchesInString:lowerCaseStoreName options:0 range:NSMakeRange(0, lowerCaseStoreName.length)];
    }
    
    if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
        NSMutableAttributedString *attrStr =
        [[NSMutableAttributedString alloc] initWithString:model.storeName.desc
                                               attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14]}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14]} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        self.nameLB.font = [HDAppTheme.WMFont wm_boldForSize:14];
        self.nameLB.textColor = HDAppTheme.WMColor.B3;
        self.nameLB.text = model.storeName.desc;
    }
    self.fullOrderLB.hidden = YES;
    
    for (UIView *view in self.contentView.subviews) {
        view.alpha = 1;
    }
    
    if (![self.model.storeStatus.status isEqualToString:WMStoreStatusOpening] || self.model.nextServiceTime) {
        if (self.model.nextServiceTime) {
            self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = YES;
            self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = !self.model.nextServiceTime;
            self.restTimeLB.text = [NSString stringWithFormat:@"%@ %@",
                                    self.model.nextServiceTime.weekday.code ? WMManage.shareInstance.weekInfo[self.model.nextServiceTime.weekday.code] : @"",
                                    self.model.nextServiceTime.time ?: @""];
            for (UIView *view in self.contentView.subviews) {
                view.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                if ([view isEqual:self.restTimeView] || [view isEqual:self.restLB] || [view isKindOfClass:UIImageView.class] || [view isEqual:self.contentView]) {
                    view.alpha = 1;
                } else if ([view isKindOfClass:UICollectionView.class]) {
                    UICollectionView *collView = (UICollectionView *)view;
                    for (UICollectionViewCell *cell in [collView visibleCells]) {
                        for (UIView *sonView in cell.contentView.subviews) {
                            if ([sonView isKindOfClass:UILabel.class])
                                sonView.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                        }
                    }
                } else {
                    view.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                }
            }
        } else {
            self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = YES;
            self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = ![self.model.storeStatus.status isEqualToString:WMStoreStatusResting];
        }
    } else {
        self.deliveryTimeAndDistanceLB.hidden = NO;
        self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = YES;
        self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = YES;
        if (model.fullOrderState == WMStoreFullOrderStateFull || model.fullOrderState == WMStoreFullOrderStateFullAndStop || model.slowMealState == WMStoreSlowMealStateSlow) {
            self.fullOrderLB.hidden = NO;
        }
    }
    
    if ([self.model.storeStatus.status isEqualToString:WMStoreStatusResting]) {
        self.storeRestLB.text = SALocalizedString(@"cart_resting", @"Resting");
    } else if ([self.model.storeStatus.status isEqualToString:WMStoreStatusClosed]) {
        self.storeRestLB.text = WMLocalizedString(@"jXs1YBee", @"已停业");
    }
    
    [self updateRatingLabelContent];
    
    NSString *deliveryTime = model.deliveryTime;
    if (model.estimatedDeliveryTime) {
        if (model.estimatedDeliveryTime.integerValue > 60) {
            deliveryTime = @">60";
        } else {
            deliveryTime = model.estimatedDeliveryTime;
        }
    }
    
    [self.deliveryTimeAndDistanceLB setTitle:[NSString stringWithFormat:@"%@min", deliveryTime] forState:UIControlStateNormal];
    NSArray<NSString *> *scopes = [self.model.businessScopesV2 mapObjectsUsingBlock:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
        if (idx < 2) {
            return obj;
        }
        return nil;
    }];
    [self configPromotions:scopes];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.products];
    if (array.count >= 6) {
        [array addObject:WMViewMoreCollectionViewCellModel.new];
    }
    self.dataSource = [NSMutableArray arrayWithArray:array];
    
    // 设置关键词
    for (WMStoreProductModel *productModel in array) {
        if ([productModel isKindOfClass:WMStoreProductModel.class]) {
            productModel.keyWord = model.keyWord;
        }
    }
    [self.collectionView reloadData];
    
    self.collectionView.hidden = self.model.products.count <= 0;
    
    NSMutableArray *signArray = [NSMutableArray arrayWithArray:self.model.signatures];
    if (signArray.count > 3) {
        [signArray addObject:WMViewMoreCollectionViewCellModel.new];
    }
    self.signDataSource = signArray;
    [self.signCollectionView reloadData];
    self.signCollectionView.hidden = self.model.signatures.count <= 0;
    
    [self configPromotions];
    
    self.logoTagBgView.hidden = !self.model.isNewStore;
    
    self.selectBTN.hidden = !self.onEditing;
    self.selectBTN.selected = model.isEditSelected;
    
    // 编辑状态或者停业状态不显示底部标签
    if (self.onEditing || [self.model.storeStatus.status isEqualToString:WMStoreStatusClosed]) {
        self.floatLayoutView.hidden = true;
        self.moreBtn.hidden = true;
    }
    [self updateFullOrderLabelContent];
    self.limitLB.hidden = YES;
    if (self.range) {
        self.limitLB.hidden = model.inRange;
    }
    [self setNeedsUpdateConstraints];
}

- (void)setNModel:(WMStoreListNewItemModel *)model {
    _nModel = model;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:HDHelper.placeholderImage imageView:self.logoIV];
    
    NSString *lowerCaseStoreName = model.storeName.desc.lowercaseString;
    NSString *lowerCaseKeyWord = model.keyWord.lowercaseString;
    
    NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *matches = @[];
    if (lowerCaseStoreName) {
        matches = [regex matchesInString:lowerCaseStoreName options:0 range:NSMakeRange(0, lowerCaseStoreName.length)];
    }
    
    if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
        NSMutableAttributedString *attrStr =
        [[NSMutableAttributedString alloc] initWithString:model.storeName.desc
                                               attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14]}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14]} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        self.nameLB.font = [HDAppTheme.WMFont wm_boldForSize:14];
        self.nameLB.textColor = HDAppTheme.WMColor.B3;
        self.nameLB.text = model.storeName.desc;
    }
    self.fullOrderLB.hidden = YES;
    
    for (UIView *view in self.contentView.subviews) {
        view.alpha = 1;
    }
    
    if (![self.nModel.storeStatus.status isEqualToString:WMStoreStatusOpening] || self.nModel.nextServiceTime) {
        if (self.nModel.nextServiceTime) {
            self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = YES;
            self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = !self.nModel.nextServiceTime;
            self.restTimeLB.text = [NSString stringWithFormat:@"%@ %@",
                                    self.nModel.nextServiceTime.weekday.code ? WMManage.shareInstance.weekInfo[self.nModel.nextServiceTime.weekday.code] : @"",
                                    self.nModel.nextServiceTime.time ?: @""];
            for (UIView *view in self.contentView.subviews) {
                view.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                if ([view isEqual:self.restTimeView] || [view isEqual:self.restLB] || [view isKindOfClass:UIImageView.class] || [view isEqual:self.contentView]) {
                    view.alpha = 1;
                } else if ([view isKindOfClass:UICollectionView.class]) {
                    UICollectionView *collView = (UICollectionView *)view;
                    for (UICollectionViewCell *cell in [collView visibleCells]) {
                        for (UIView *sonView in cell.contentView.subviews) {
                            if ([sonView isKindOfClass:UILabel.class])
                                sonView.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                        }
                    }
                } else {
                    view.alpha = [self.restTimeView isHidden] ? 1 : 0.6;
                }
            }
        } else {
            self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = YES;
            self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = ![self.nModel.storeStatus.status isEqualToString:WMStoreStatusResting];
        }
    } else {
        self.deliveryTimeAndDistanceLB.hidden = NO;
        self.restLB.hidden = self.restTimeView.hidden = self.restBTN.hidden = YES;
        self.storeRestView.hidden = self.storeRestIV.hidden = self.storeRestLB.hidden = YES;
        if (model.fullOrderState == WMStoreFullOrderStateFull || model.fullOrderState == WMStoreFullOrderStateFullAndStop || model.slowMealState == WMStoreSlowMealStateSlow) {
            self.fullOrderLB.hidden = NO;
        }
    }
    
    if ([self.nModel.storeStatus.status isEqualToString:WMStoreStatusResting]) {
        self.storeRestLB.text = SALocalizedString(@"cart_resting", @"Resting");
    } else if ([self.nModel.storeStatus.status isEqualToString:WMStoreStatusClosed]) {
        self.storeRestLB.text = WMLocalizedString(@"jXs1YBee", @"已停业");
    }
    
    [self updateNewRatingLabelContent];
    
    NSString *deliveryTime = model.deliveryTime;
    if (model.estimatedDeliveryTime) {
        if (model.estimatedDeliveryTime.integerValue > 60) {
            deliveryTime = @">60";
        } else {
            deliveryTime = model.estimatedDeliveryTime;
        }
    }
    
    [self.deliveryTimeAndDistanceLB setTitle:[NSString stringWithFormat:@"%@min", deliveryTime] forState:UIControlStateNormal];
    NSArray<NSString *> *scopes = [self.nModel.businessScopesV2 mapObjectsUsingBlock:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
        if (idx < 2) {
            return obj;
        }
        return nil;
    }];
    [self configNewPromotions:scopes];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.nModel.products];
    if (array.count >= 6) {
        [array addObject:WMViewMoreCollectionViewCellModel.new];
    }
    self.dataSource = [NSMutableArray arrayWithArray:array];
    
    // 设置关键词
    for (WMStoreProductModel *productModel in array) {
        if ([productModel isKindOfClass:WMStoreProductModel.class]) {
            productModel.keyWord = model.keyWord;
        }
    }
    [self.collectionView reloadData];
    
    self.collectionView.hidden = self.nModel.products.count <= 0;
    
    NSMutableArray *signArray = [NSMutableArray arrayWithArray:self.nModel.signatures];
    if (signArray.count > 3) {
        [signArray addObject:WMViewMoreCollectionViewCellModel.new];
    }
    self.signDataSource = signArray;
    [self.signCollectionView reloadData];
    self.signCollectionView.hidden = self.nModel.signatures.count <= 0;
    
    [self configNewPromotions];
    
    self.logoTagBgView.hidden = !self.nModel.isNewStore;
    
    self.selectBTN.hidden = !self.onEditing;
    self.selectBTN.selected = model.isEditSelected;
    
    // 编辑状态或者停业状态不显示底部标签
    if (self.onEditing || [self.nModel.storeStatus.status isEqualToString:WMStoreStatusClosed]) {
        self.floatLayoutView.hidden = true;
        self.moreBtn.hidden = true;
    }
    [self updateNewFullOrderLabelContent];
    self.limitLB.hidden = YES;
    if (self.range) {
        self.limitLB.hidden = model.inRange;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.signCollectionView)
        return self.signDataSource.count;
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if (collectionView == self.signCollectionView) {
        model = self.signDataSource[MIN(self.signDataSource.count - 1, MAX(0, indexPath.row))];
    } else {
        model = self.dataSource[MIN(self.dataSource.count - 1, MAX(0, indexPath.row))];
    }
    if (!model)
        return nil;
    if ([model isKindOfClass:WMStoreProductModel.class] || [model isKindOfClass:WMSpecialStoreSignaturesModel.class]) {
        WMSpecialStoreSignaturesCell *cell = [WMSpecialStoreSignaturesCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:WMViewMoreCollectionViewCellModel.class]) {
        WMSpecialSignturesMoreCell *cell = [WMSpecialSignturesMoreCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if (collectionView == self.signCollectionView) {
        model = self.signDataSource[MIN(self.signDataSource.count - 1, MAX(0, indexPath.row))];
    } else {
        model = self.dataSource[MIN(self.dataSource.count - 1, MAX(0, indexPath.row))];
    }
    if (!model)
        return CGSizeZero;
    const CGFloat height = CGRectGetHeight(collectionView.frame);
    if ([model isKindOfClass:WMStoreProductModel.class] || [model isKindOfClass:WMSpecialStoreSignaturesModel.class]) {
        return CGSizeMake(kRealWidth(75), height);
    } else if ([model isKindOfClass:WMViewMoreCollectionViewCellModel.class]) {
        return CGSizeMake(kRealWidth(40), height);
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if (collectionView == self.signCollectionView) {
        model = self.signDataSource[MIN(self.signDataSource.count - 1, MAX(0, indexPath.row))];
    } else {
        model = self.dataSource[MIN(self.dataSource.count - 1, MAX(0, indexPath.row))];
    }
    if ([model isKindOfClass:WMStoreProductModel.class]) {
        WMStoreProductModel *trueModel = (WMStoreProductModel *)model;
        !self.clickedProductViewBlock ?: self.clickedProductViewBlock(trueModel.menuId, trueModel.productId);
    } else if ([model isKindOfClass:WMViewMoreCollectionViewCellModel.class]) {
        !self.clickedMoreViewBlock ?: self.clickedMoreViewBlock();
    } else if ([model isKindOfClass:WMSpecialStoreSignaturesModel.class]) {
        WMSpecialStoreSignaturesModel *trueModel = (WMSpecialStoreSignaturesModel *)model;
        !self.clickedProductViewBlock ?: self.clickedProductViewBlock(@"", trueModel.productId);
    }
}

#pragma mark - event response
- (void)clickedCollectionViewHandler {
    !self.clickedMoreViewBlock ?: self.clickedMoreViewBlock();
}

#pragma mark - private methods
- (void)updateRatingLabelContent {
    UIFont *font = HDAppTheme.font.standard4;
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
    [[NSMutableAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: HDAppTheme.font.standard4Bold}];
    
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [text appendAttributedString:scoreStr];
    
    // 拼接评价
    NSString *commments = [NSString stringWithFormat:@"(%@)", self.model.commentsCount > 200 ? @"200+" : [NSString stringWithFormat:@"%zd", self.model.commentsCount]];
    NSMutableAttributedString *commmentsStr = [[NSMutableAttributedString alloc] initWithString:commments attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: font}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [text appendAttributedString:commmentsStr];
    
    ///拼接距离
    NSMutableAttributedString *distanceStr = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"•%@", [SACaculateNumberTool distanceStringFromNumber:self.model.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp]]
                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
    [text appendAttributedString:distanceStr];
    
    ///拼接分数
    NSString *sold = self.model.sale;
    if (!sold) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            sold = [NSString stringWithFormat:@"•%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.ordered];
        } else {
            sold = [NSString stringWithFormat:@"•%zd %@", self.model.ordered, WMLocalizedString(@"wm_sold", @"Sold")];
        }
    }
    NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc] initWithString:sold
                                                                                attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
    [text appendAttributedString:soldStr];
    self.ratingAndReviewLB.attributedText = text;
    self.ratingAndReviewLB.numberOfLines = 0;
}

- (void)updateNewRatingLabelContent {
    UIFont *font = HDAppTheme.font.standard4;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"yn_home_star"];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter
                                                                                       attachmentSize:CGSizeMake(image.size.width, font.lineHeight)
                                                                                          alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachment];
    
    // 拼接分数
    NSString *score = [NSString stringWithFormat:@"%.1f", self.nModel.ratingScore];
    if (self.nModel.ratingScore == 0)
        score = WMLocalizedString(@"wm_no_ratings_yet", @"暂无评分");
    
    NSMutableAttributedString *scoreStr =
    [[NSMutableAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.B3, NSFontAttributeName: HDAppTheme.font.standard4Bold}];
    
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [text appendAttributedString:scoreStr];
    
    // 拼接评价
    NSString *commments = [NSString stringWithFormat:@"(%@)", self.nModel.commentsCount > 200 ? @"200+" : [NSString stringWithFormat:@"%zd", self.nModel.commentsCount]];
    NSMutableAttributedString *commmentsStr = [[NSMutableAttributedString alloc] initWithString:commments attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: font}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [text appendAttributedString:commmentsStr];
    
    ///拼接距离
    NSMutableAttributedString *distanceStr = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"•%@", [SACaculateNumberTool distanceStringFromNumber:self.nModel.distance toFixedCount:0 roundingMode:SANumRoundingModeOnlyUp]]
                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
    [text appendAttributedString:distanceStr];
    
    ///拼接分数
    NSString *sold = self.nModel.sale;
    if (!sold) {
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            sold = [NSString stringWithFormat:@"•%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.nModel.ordered];
        } else {
            sold = [NSString stringWithFormat:@"•%zd %@", self.nModel.ordered, WMLocalizedString(@"wm_sold", @"Sold")];
        }
    }
    NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc] initWithString:sold
                                                                                attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard4}]];
    [text appendAttributedString:soldStr];
    self.ratingAndReviewLB.attributedText = text;
    self.ratingAndReviewLB.numberOfLines = 0;
}

- (void)updateFullOrderLabelContent {
    if (self.fullOrderLB.isHidden)
        return;
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
    
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:12];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:whiteSpace];
    NSString *imageName = nil;
    NSString *str = nil;
    if (self.model.fullOrderState == WMStoreFullOrderStateFull) {
        imageName = @"yn_home_full_busy";
        str = WMLocalizedString(@"wm_store_busy", @"繁忙");
    } else if (self.model.fullOrderState == WMStoreFullOrderStateFullAndStop) {
        str = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_minu", @"繁忙·%@分钟后可下单"), @"30"];
    } else {
        if (self.model.slowMealState == WMStoreSlowMealStateSlow) {
            str = WMLocalizedString(@"wm_store_many_order", @"订单较多");
            imageName = @"yn_home_full_order";
        }
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter
                                                                                       attachmentSize:CGSizeMake(image.size.width, font.lineHeight)
                                                                                          alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachment];
    [text appendAttributedString:whiteSpace];
    
    NSMutableAttributedString *scoreStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: font}];
    [text appendAttributedString:scoreStr];
    [text appendAttributedString:whiteSpace];
    self.fullOrderLB.layer.backgroundColor = HDAppTheme.WMColor.B6.CGColor;
    self.fullOrderLB.layer.cornerRadius = kRealWidth(2);
    self.fullOrderLB.attributedText = text;
}

- (void)updateNewFullOrderLabelContent {
    if (self.fullOrderLB.isHidden)
        return;
    NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
    
    UIFont *font = [HDAppTheme.WMFont wm_ForSize:12];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:whiteSpace];
    NSString *imageName = nil;
    NSString *str = nil;
    if (self.nModel.fullOrderState == WMStoreFullOrderStateFull) {
        imageName = @"yn_home_full_busy";
        str = WMLocalizedString(@"wm_store_busy", @"繁忙");
    } else if (self.nModel.fullOrderState == WMStoreFullOrderStateFullAndStop) {
        str = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_minu", @"繁忙·%@分钟后可下单"), @"30"];
    } else {
        if (self.nModel.slowMealState == WMStoreSlowMealStateSlow) {
            str = WMLocalizedString(@"wm_store_many_order", @"订单较多");
            imageName = @"yn_home_full_order";
        }
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter
                                                                                       attachmentSize:CGSizeMake(image.size.width, font.lineHeight)
                                                                                          alignToFont:font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachment];
    [text appendAttributedString:whiteSpace];
    
    NSMutableAttributedString *scoreStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: font}];
    [text appendAttributedString:scoreStr];
    [text appendAttributedString:whiteSpace];
    self.fullOrderLB.layer.backgroundColor = HDAppTheme.WMColor.B6.CGColor;
    self.fullOrderLB.layer.cornerRadius = kRealWidth(2);
    self.fullOrderLB.attributedText = text;
}

- (void)configPromotions {
    BOOL hasFastService = self.model.slowPayMark.boolValue;
    self.floatLayoutView.hidden = HDIsArrayEmpty(self.model.promotions) && HDIsArrayEmpty(self.model.productPromotions) && !hasFastService && HDIsArrayEmpty(self.model.serviceLabel);
    if (!self.model.tagString) {
        NSMutableArray *mArr = [WMStoreDetailPromotionModel configPromotions:self.model.promotions productPromotion:self.model.productPromotions hasFastService:hasFastService].mutableCopy;
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

- (void)configNewPromotions {
    BOOL hasFastService = self.nModel.slowPayMark.boolValue;
    self.floatLayoutView.hidden = HDIsArrayEmpty(self.nModel.promotions) && HDIsArrayEmpty(self.nModel.productPromotions) && !hasFastService && HDIsArrayEmpty(self.nModel.serviceLabel);
    if (!self.nModel.tagString) {
        NSMutableArray *mArr = [WMStoreDetailPromotionModel configNewPromotions:self.nModel.promotions productPromotion:self.nModel.productPromotions hasFastService:hasFastService].mutableCopy;
        if (self.nModel.serviceLabel.count) {
            [mArr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.nModel.serviceLabel]];
        }
        self.nModel.tagString = NSMutableAttributedString.new;
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
            [self.nModel.tagString appendAttributedString:objStr];
        }];
        self.nModel.tagString.yy_lineSpacing = kRealWidth(4);
    }

    if (!self.nModel.lines) {
        self.floatLayoutView.lineBreakMode = NSLineBreakByTruncatingTail;
        self.floatLayoutView.numberOfLines = 0;
        self.floatLayoutView.attributedText = self.nModel.tagString;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.floatLayoutView.preferredMaxLayoutWidth, CGFLOAT_MAX) text:self.nModel.tagString];
        self.nModel.lines = layout.rowCount;
        if (self.nModel.lines == 0 && !self.floatLayoutView.hidden) {
            self.nModel.lines = 1;
        }
    }
    self.floatLayoutView.lineBreakMode = NSLineBreakByWordWrapping;
    self.floatLayoutView.numberOfLines = self.nModel.numberOfLinesOfPromotion;
    self.floatLayoutView.attributedText = self.nModel.tagString;
    self.moreBtn.hidden = self.nModel.lines <= 1;
    self.moreBtn.selected = self.nModel.numberOfLinesOfPromotion ? NO : YES;
}

///分类
- (void)configPromotions:(NSArray *)cates {
    self.cateFloatLayoutView.hidden = HDIsArrayEmpty(cates);
    if (!self.model.cateString) {
        NSMutableArray *arr = NSMutableArray.new;
        for (NSString *str in cates) {
            [arr addObject:[WMPromotionLabel createBtnWithBackGroundColor:[UIColor hd_colorWithHexString:@"#FDF2F3"] titleColor:HDAppTheme.WMColor.B6 title:str alpha:1]];
        }
        self.model.cateString = NSMutableAttributedString.new;
        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                              alignToFont:obj.titleLabel.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
            if (idx != arr.count - 1) {
                NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                  attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                     alignToFont:[UIFont systemFontOfSize:0]
                                                                                                       alignment:YYTextVerticalAlignmentCenter];
                [objStr appendAttributedString:spaceText];
            }
            [self.model.cateString appendAttributedString:objStr];
        }];
        self.model.cateString.yy_lineSpacing = kRealWidth(4);
    }
    self.cateFloatLayoutView.attributedText = self.model.cateString;
}

///分类
- (void)configNewPromotions:(NSArray *)cates {
    self.cateFloatLayoutView.hidden = HDIsArrayEmpty(cates);
    if (!self.nModel.cateString) {
        NSMutableArray *arr = NSMutableArray.new;
        for (NSString *str in cates) {
            [arr addObject:[WMPromotionLabel createBtnWithBackGroundColor:[UIColor hd_colorWithHexString:@"#FDF2F3"] titleColor:HDAppTheme.WMColor.B6 title:str alpha:1]];
        }
        self.nModel.cateString = NSMutableAttributedString.new;
        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                              alignToFont:obj.titleLabel.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
            if (idx != arr.count - 1) {
                NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                  attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                     alignToFont:[UIFont systemFontOfSize:0]
                                                                                                       alignment:YYTextVerticalAlignmentCenter];
                [objStr appendAttributedString:spaceText];
            }
            [self.nModel.cateString appendAttributedString:objStr];
        }];
        self.nModel.cateString.yy_lineSpacing = kRealWidth(4);
    }
    self.cateFloatLayoutView.attributedText = self.nModel.cateString;
}

#pragma mark - lazy load

- (UIImageView *)logoIV {
    if (!_logoIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        _logoIV = imageView;
    }
    return _logoIV;
}

- (UIView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIView alloc] init];
        _logoTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.backgroundColor = HDAppTheme.WMColor.mainRed;
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:5];
        };
    }
    return _logoTagBgView;
}

- (SALabel *)logoTagLabel {
    if (!_logoTagLabel) {
        _logoTagLabel = [[SALabel alloc] init];
        _logoTagLabel.textColor = UIColor.whiteColor;
        _logoTagLabel.font = HDAppTheme.font.standard5Bold;
        _logoTagLabel.text = WMLocalizedString(@"is_new_store", @"New");
    }
    return _logoTagLabel;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        label.font = [HDAppTheme.WMFont wm_boldForSize:14];
        label.textColor = HDAppTheme.WMColor.B3;
        _nameLB = label;
    }
    return _nameLB;
}

- (YYLabel *)ratingAndReviewLB {
    if (!_ratingAndReviewLB) {
        _ratingAndReviewLB = YYLabel.new;
    }
    return _ratingAndReviewLB;
}

- (YYLabel *)fullOrderLB {
    if (!_fullOrderLB) {
        _fullOrderLB = YYLabel.new;
    }
    return _fullOrderLB;
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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(8);
        flowLayout.minimumInteritemSpacing = kRealWidth(8);
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.backgroundView = UIView.new;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCollectionViewHandler)];
        [collectionView.backgroundView addGestureRecognizer:recognizer];
        collectionView.contentInset = UIEdgeInsetsMake(0, kMarginTen + kIconWidth, 0, kMarginTen);
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionView *)signCollectionView {
    if (!_signCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(8);
        flowLayout.minimumInteritemSpacing = kRealWidth(8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.backgroundView = UIView.new;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedCollectionViewHandler)];
        [collectionView.backgroundView addGestureRecognizer:recognizer];
        collectionView.contentInset = UIEdgeInsetsMake(0, kMarginTen + kIconWidth, 0, kMarginTen);
        _signCollectionView = collectionView;
    }
    return _signCollectionView;
}

- (YYLabel *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = YYLabel.new;
        _floatLayoutView.userInteractionEnabled = NO;
        _floatLayoutView.numberOfLines = 0;
        _floatLayoutView.preferredMaxLayoutWidth = kScreenWidth - kMarginTen * 2 - kMarginEight - kIconWidth - kRealWidth(26);
    }
    return _floatLayoutView;
}

- (YYLabel *)cateFloatLayoutView {
    if (!_cateFloatLayoutView) {
        _cateFloatLayoutView = YYLabel.new;
        _cateFloatLayoutView.numberOfLines = 0;
        _cateFloatLayoutView.preferredMaxLayoutWidth = kScreenWidth - kMarginTen * 2 - kMarginEight - kIconWidth;
        _cateFloatLayoutView.userInteractionEnabled = NO;
    }
    return _cateFloatLayoutView;
}

- (HDUIButton *)moreBtn {
    if (!_moreBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_home_d"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_home_u"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            if(self.model){
                self.model.numberOfLinesOfPromotion = btn.isSelected ? 0 : 1;
            }
            
            if(self.nModel) {
                self.nModel.numberOfLinesOfPromotion = btn.isSelected ? 0 : 1;
            }
            //            if (self.BlockOnClickPromotion) {
            //                self.BlockOnClickPromotion();
            //            }
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

- (HDLabel *)restLB {
    if (!_restLB) {
        _restLB = HDLabel.new;
        _restLB.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(3), 0, kRealWidth(3));
        _restLB.textAlignment = NSTextAlignmentCenter;
        _restLB.textColor = UIColor.whiteColor;
        _restLB.text = WMLocalizedString(@"store_detail_business_hours", @"营业时间");
        _restLB.font = [HDAppTheme.font forSize:11];
        _restLB.backgroundColor = [UIColor hd_colorWithHexString:@"#9aa8cb"];
        _restLB.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:kRealHeight(12)];
        };
    }
    return _restLB;
}

- (UIView *)restTimeView {
    if (!_restTimeView) {
        _restTimeView = UIView.new;
        _restTimeView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        @HDWeakify(self) _restTimeView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self)[view setRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight radius:kRealHeight(12)];
            CGRect rect = view.bounds;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(kRealHeight(12), kRealHeight(12))];
            self.borderLayer.frame = rect;
            self.borderLayer.path = maskPath.CGPath;
            self.borderLayer.fillColor = [UIColor clearColor].CGColor;
            self.borderLayer.strokeColor = [UIColor hd_colorWithHexString:@"#9aa8cb"].CGColor;
            self.borderLayer.lineWidth = ((0.5) * (kWidthCoefficientTo6S));
            [view.layer insertSublayer:self.borderLayer atIndex:0];
        };
    }
    return _restTimeView;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
    }
    return _borderLayer;
}

- (SALabel *)restTimeLB {
    if (!_restTimeLB) {
        _restTimeLB = SALabel.new;
        _restTimeLB.textAlignment = NSTextAlignmentCenter;
        _restTimeLB.textColor = [UIColor hd_colorWithHexString:@"#9aa8cb"];
        _restTimeLB.font = [HDAppTheme.font forSize:11];
    }
    return _restTimeLB;
}

- (HDUIButton *)restBTN {
    if (!_restBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"home_rest"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"cart_resting", @"Resting") forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = kRealWidth(4);
        button.userInteractionEnabled = false;
        button.titleLabel.font = [HDAppTheme.font forSize:11];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor hd_colorWithHexString:@"#30509D"];
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft radius:5];
            view.layer.masksToBounds = YES;
        };
        _restBTN = button;
    }
    return _restBTN;
}

- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        button.userInteractionEnabled = false;
        _selectBTN = button;
    }
    return _selectBTN;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColor;
    }
    return _lineView;
}

- (UIView *)storeRestView {
    if (!_storeRestView) {
        _storeRestView = UIView.new;
        _storeRestView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _storeRestView;
}

- (UIImageView *)storeRestIV {
    if (!_storeRestIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"yn_search_rest"];
        _storeRestIV = imageView;
    }
    return _storeRestIV;
}

- (UILabel *)storeRestLB {
    if (!_storeRestLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.ffffff;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = SALocalizedString(@"cart_resting", @"Resting");
        _storeRestLB = label;
    }
    return _storeRestLB;
}

- (HDLabel *)limitLB {
    if (!_limitLB) {
        _limitLB = HDLabel.new;
        _limitLB.hidden = YES;
        _limitLB.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(8), 0, kRealWidth(8));
        _limitLB.textColor = UIColor.whiteColor;
        _limitLB.layer.backgroundColor = HDAppTheme.WMColor.B6.CGColor;
        _limitLB.layer.cornerRadius = kRealWidth(2);
        _limitLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _limitLB.text = WMLocalizedString(@"wm_no_in_range", @"不在配送范围内");
    }
    return _limitLB;
}

@end
