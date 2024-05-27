//
//  GNArticleDetailStoreCell.m
//  SuperApp
//
//  Created by wmz on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailStoreCell.h"
#import "GNStarView.h"
#import "GNStoreCellModel.h"


@interface GNArticleDetailStoreCell ()
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

@end


@implementation GNArticleDetailStoreCell

- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.distanceLb];
    [self.contentView addSubview:self.rateBTN];
    [self.contentView addSubview:self.perCapitaLB];
    [self.contentView addSubview:self.rateLB];
}

- (void)updateConstraints {
    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.iconIV);
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.rateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateBTN.isHidden) {
            make.left.equalTo(self.nameLb);
            make.centerY.equalTo(self.iconIV);
        }
    }];

    [self.rateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateBTN.isHidden) {
            make.left.equalTo(self.rateBTN.mas_right).offset(kRealWidth(4));
            make.centerY.equalTo(self.rateBTN);
        } else {
            make.left.equalTo(self.nameLb);
            make.centerY.equalTo(self.iconIV);
        }
    }];

    [self.perCapitaLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.perCapitaLB.hidden) {
            make.centerY.equalTo(self.rateLB);
            make.right.equalTo(self.nameLb);
        }
    }];

    [self.distanceLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV);
        make.left.right.equalTo(self.nameLb);
        make.height.mas_equalTo(kRealWidth(18));
    }];

    [self.rateLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.perCapitaLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(GNStoreCellModel *)data {
    if ([data isKindOfClass:GNStoreCellModel.class]) {
        self.nameLb.text = data.storeName.desc;
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.logo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80)) logoWidth:kRealWidth(40)]];
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            if (GNStringNotEmpty(data.commercialDistrictName.desc)) {
                self.distanceLb.text = [data.commercialDistrictName.desc
                    stringByAppendingFormat:@" • %@", [SACaculateNumberTool gnDistanceStringFromNumber:data.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown]];
            } else {
                self.distanceLb.text = [SACaculateNumberTool gnDistanceStringFromNumber:data.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown];
            }
        } else {
            self.distanceLb.text = GNFillEmpty(data.commercialDistrictName.desc);
        }
        self.rateBTN.score = data.score.floatValue;
        self.rateBTN.hidden = (data.score.floatValue == 0);
        self.rateLB.text = data.score.floatValue > 0 ? [NSString stringWithFormat:@"%.1f", data.score.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分");
        self.perCapitaLB.text = [GNLocalizedString(@"gn_per_capita", @"人均") stringByAppendingString:GNFillMonEmpty(data.perCapita)];
        self.perCapitaLB.hidden = !data.perCapita;
        self.distanceLb.hidden = !self.distanceLb.text.length;
        [self setNeedsUpdateConstraints];
    }
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
        _nameLb.textColor = HDAppTheme.color.gn_333Color;
        _nameLb.font = [HDAppTheme.font gn_boldForSize:16];
        _nameLb.numberOfLines = 1;
    }
    return _nameLb;
}

- (SALabel *)distanceLb {
    if (!_distanceLb) {
        _distanceLb = [SALabel new];
        _distanceLb.textAlignment = NSTextAlignmentLeft;
        _distanceLb.textColor = HDAppTheme.color.gn_333Color;
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

@end
