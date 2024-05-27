//
//  GNStoreView.m
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreView.h"
#import "GNStarView.h"


@interface GNStoreView ()
/// 图片
@property (nonatomic, strong) UIImageView *iconIV;
/// 名字
@property (nonatomic, strong) SALabel *nameLb;
/// 距离
@property (nonatomic, strong) SALabel *distanceLb;
/// 评分图标
@property (nonatomic, strong) GNStarView *rateBTN;
/// 评分内容
@property (nonatomic, strong) SALabel *rateLB;
/// 人均
@property (nonatomic, strong) HDLabel *perCapitaLB;
/// xian
@property (nonatomic, strong) UIView *lineIV;
/// 优惠列表
@property (nonatomic, strong) YYLabel *conponListView;
/// 展开
@property (nonatomic, strong) HDUIButton *openBTN;

@end


@implementation GNStoreView

- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLb];
    [self addSubview:self.distanceLb];
    [self addSubview:self.rateBTN];
    [self addSubview:self.perCapitaLB];
    [self addSubview:self.rateLB];
    [self addSubview:self.conponListView];
    [self addSubview:self.openBTN];
    [self addSubview:self.lineIV];
}

- (void)updateConstraints {
    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.iconIV).offset(-kRealWidth(4));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.rateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateBTN.hidden) {
            make.left.equalTo(self.nameLb);
            make.top.equalTo(self.nameLb.mas_bottom).offset(self.model.offset);
        }
    }];

    [self.rateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateLB.hidden) {
            if (!self.rateBTN.isHidden) {
                make.left.equalTo(self.rateBTN.mas_right).offset(kRealWidth(4));
                make.centerY.equalTo(self.rateBTN);
            } else {
                make.left.equalTo(self.nameLb);
                make.top.equalTo(self.nameLb.mas_bottom).offset(self.model.offset);
            }
        }
    }];

    [self.perCapitaLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.perCapitaLB.hidden) {
            make.centerY.equalTo(self.rateLB);
            make.right.equalTo(self.nameLb);
        }
    }];

    self.distanceLb.hidden = !self.distanceLb.text.length;
    [self.distanceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateLB.mas_bottom).offset(self.model.offset);
        make.left.right.equalTo(self.nameLb);
    }];

    [self.conponListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.conponListView.isHidden) {
            make.top.equalTo(self.distanceLb.mas_bottom).offset(self.model.offset);
            make.left.right.equalTo(self.nameLb);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        }
    }];

    [self.openBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.openBTN.isHidden) {
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(4));
            make.top.equalTo(self.conponListView.mas_bottom).offset(kRealWidth(4));
            make.centerX.mas_equalTo(0);
        }
    }];

    [self.lineIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
        make.left.equalTo(self.nameLb);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.rateLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setModel:(GNStoreCellModel *)model {
    _model = model;
    model.notCacheHeight = YES;
    /// 关键词高亮
    if (GNStringNotEmpty(model.keyWord)) {
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
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.gn_333Color, NSFontAttributeName: [HDAppTheme.font gn_boldForSize:16]}];
            for (NSTextCheckingResult *result in [matches objectEnumerator]) {
                [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.color.gn_mainColor, NSFontAttributeName: [HDAppTheme.font gn_boldForSize:16]} range:[result range]];
            }
            self.nameLb.attributedText = attrStr;
        } else {
            self.nameLb.textColor = HDAppTheme.color.gn_333Color;
            self.nameLb.font = [HDAppTheme.font gn_boldForSize:16];
            self.nameLb.text = model.storeName.desc;
        }
    } else {
        self.nameLb.textColor = HDAppTheme.color.gn_333Color;
        self.nameLb.font = [HDAppTheme.font gn_boldForSize:16];
        self.nameLb.text = model.storeName.desc;
    }

    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80)) logoWidth:kRealWidth(40)]];

    NSMutableString *distanceStr = [NSMutableString stringWithFormat:@"%@%@", GNLocalizedString(@"gn_store_sold", @"已售"), model.ordered];
    if (model.commercialDistrictName) {
        [distanceStr appendFormat:@"%@%@", @"  ", model.commercialDistrictName.desc];
    }
    if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
        [distanceStr appendFormat:@"%@%@", @"  ", [SACaculateNumberTool gnDistanceStringFromNumber:model.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown]];
    }
    self.distanceLb.text = distanceStr;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    for (int i = 0; i < self.model.productList.count; i++) {
        GNProductModel *productModel = self.model.productList[i];
        UIImage *image = [UIImage imageNamed:@"gn_home_group"];
        if ([productModel.productType.codeId isEqualToString:GNProductTypeP2]) {
            image = [UIImage imageNamed:@"gn_home_coupon"];
        }
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeLeft
                                                                                           attachmentSize:CGSizeMake(image.size.width + kRealWidth(4), image.size.height)
                                                                                              alignToFont:self.conponListView.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        [text yy_appendString:GNFillEmpty(productModel.name.desc)];
        [text yy_appendString:@"\n"];
    }
    text.yy_paragraphSpacing = kRealWidth(4);
    //    self.conponListView.lineBreakMode = self.model.isSelected ? NSLineBreakByClipping : NSLineBreakByWordWrapping;
    self.conponListView.numberOfLines = self.model.isSelected ? 0 : 2;
    self.conponListView.attributedText = text;

    self.rateBTN.score = model.score.floatValue;
    self.rateBTN.hidden = (model.score.floatValue == 0);
    self.rateLB.text = model.score.doubleValue > 0 ? [NSString stringWithFormat:@"%.1f", model.score.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分");
    self.perCapitaLB.text = [NSString stringWithFormat:@"%@/%@", GNFillMonEmpty(model.perCapita), GNLocalizedString(@"gn_per_capita", @"人均")];
    self.perCapitaLB.hidden = (model.perCapita.doubleValue == 0);
    self.openBTN.hidden = model.productList.count <= 2;
    self.openBTN.selected = model.isSelected;
    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
    }
    return _iconIV;
}

- (SALabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [SALabel new];
        _nameLb.numberOfLines = 1;
    }
    return _nameLb;
}

- (SALabel *)distanceLb {
    if (!_distanceLb) {
        _distanceLb = [SALabel new];
        _distanceLb.textAlignment = NSTextAlignmentLeft;
        _distanceLb.textColor = HDAppTheme.color.gn_999Color;
        _distanceLb.font = HDAppTheme.font.gn_12;
    }
    return _distanceLb;
}

- (GNStarView *)rateBTN {
    if (!_rateBTN) {
        _rateBTN = GNStarView.new;
        _rateBTN.defaultImage = @"gn_home_star_nor";
        _rateBTN.selectImage = @"gn_home_star_sel";
        _rateBTN.space = 1;
        _rateBTN.maxValue = 5;
        _rateBTN.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightHeavy];
    }
    return _rateBTN;
}

- (HDLabel *)perCapitaLB {
    if (!_perCapitaLB) {
        _perCapitaLB = [HDLabel new];
        _perCapitaLB.textColor = HDAppTheme.color.gn_666Color;
        _perCapitaLB.font = HDAppTheme.font.gn_12;
    }
    return _perCapitaLB;
}

- (SALabel *)rateLB {
    if (!_rateLB) {
        _rateLB = SALabel.new;
        _rateLB.textColor = HDAppTheme.color.gn_mainColor;
        _rateLB.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightHeavy];
    }
    return _rateLB;
}

- (UIView *)lineIV {
    if (!_lineIV) {
        _lineIV = UIView.new;
        _lineIV.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _lineIV;
}

- (HDUIButton *)openBTN {
    if (!_openBTN) {
        _openBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_openBTN setImage:[UIImage imageNamed:@"gn_home_down"] forState:UIControlStateNormal];
        [_openBTN setImage:[UIImage imageNamed:@"gn_home_close"] forState:UIControlStateSelected];
        @HDWeakify(self)[_openBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) self.model.select = !self.model.isSelected;
            UIView *view = self;
            while (view.superview) {
                if ([view isKindOfClass:UITableView.class]) {
                    UITableView *tableView = (UITableView *)view;
                    [tableView reloadData];
                    break;
                }
                view = view.superview;
            }
        }];
    }
    return _openBTN;
}

- (YYLabel *)conponListView {
    if (!_conponListView) {
        _conponListView = YYLabel.new;
        _conponListView.lineBreakMode = NSLineBreakByClipping;
        _conponListView.textColor = HDAppTheme.color.gn_333Color;
        _conponListView.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(116);
        _conponListView.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
    }
    return _conponListView;
}

@end
