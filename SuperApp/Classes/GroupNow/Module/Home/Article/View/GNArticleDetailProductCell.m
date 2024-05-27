//
//  GNArticleDetailProductCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailProductCell.h"
#import "GNProductModel.h"
#import "SACaculateNumberTool.h"


@interface GNArticleDetailProductCell ()
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// storeIV
@property (nonatomic, strong) UIImageView *storeIV;
/// nameLB
@property (nonatomic, strong) HDLabel *nameLB;
/// detailLB
@property (nonatomic, strong) HDLabel *detailLB;
/// priceLB
@property (nonatomic, strong) HDLabel *priceLB;
///原价
@property (nonatomic, strong) HDLabel *originPirceLB;
///距离
@property (nonatomic, strong) HDLabel *distanceLB;
///已售
@property (nonatomic, strong) HDLabel *soldLB;
/// xian
@property (nonatomic, strong) UIView *lineIV;

@end


@implementation GNArticleDetailProductCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.storeIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.detailLB];
    [self.contentView addSubview:self.priceLB];
    [self.contentView addSubview:self.originPirceLB];
    [self.contentView addSubview:self.distanceLB];
    [self.contentView addSubview:self.soldLB];
    [self.contentView addSubview:self.lineIV];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.top.left.mas_equalTo(kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.iconIV);
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.storeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.size.mas_equalTo(self.storeIV.image.size);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(5));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeIV.mas_right).offset(kRealWidth(3));
        if (self.soldLB.isHidden) {
            make.right.mas_equalTo(-kRealWidth(12));
        } else {
            make.right.equalTo(self.soldLB.mas_left).offset(-kRealWidth(12));
        }
        make.centerY.equalTo(self.storeIV);
    }];

    [self.soldLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.soldLB.isHidden) {
            make.centerY.equalTo(self.detailLB);
            make.right.mas_equalTo(-kRealWidth(12));
        }
    }];
    if (!self.soldLB.isHidden) {
        [self.soldLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(-kRealWidth(2));
        make.height.mas_equalTo(kRealWidth(24));
    }];

    [self.originPirceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(8));
        make.centerY.equalTo(self.priceLB);
        make.right.equalTo(self.distanceLB.mas_left).offset(kRealWidth(-4));
    }];

    [self.distanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self.priceLB);
    }];

    [self.lineIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
        make.left.equalTo(self.nameLB);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.distanceLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.originPirceLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setGNModel:(GNProductModel *)data {
    if ([data isKindOfClass:GNProductModel.class]) {
        if ([data.productType.codeId isEqualToString:GNProductTypeP2]) {
            self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
        } else {
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.imagePath]
                           placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80)) logoWidth:kRealWidth(40)]];
        }
        self.nameLB.text = GNFillEmpty(data.productName.desc);
        self.detailLB.text = GNFillEmpty(data.storeName.desc);
        self.priceLB.text = GNFillMonEmpty(data.price);
        self.soldLB.text = [NSString stringWithFormat:@"%@%ld", GNLocalizedString(@"gn_store_sold", @"已售"), data.consumptionOrderCodeNum];
        self.soldLB.hidden = data.imageHide;
        NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.originalPrice)];
        [GNStringUntils attributedString:originalPriceStr font:[HDAppTheme.font gn_ForSize:12] fontRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr color:HDAppTheme.color.gn_999Color colorRange:originalPriceStr.string];
        [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
        self.originPirceLB.attributedText = originalPriceStr;
        self.originPirceLB.hidden = (!data.originalPrice || [data.originalPrice isKindOfClass:NSNull.class] || data.originalPrice.doubleValue == data.price.doubleValue);
        if (HDLocationManager.shared.isCurrentCoordinate2DValid) {
            self.distanceLB.text = [SACaculateNumberTool gnDistanceStringFromNumber:data.distance toFixedCount:1 roundingMode:SANumRoundingModeUpAndDown];
        } else {
            self.distanceLB.text = @"";
        }
        [self setNeedsUpdateConstraints];
    }
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = kRealWidth(8);
            view.clipsToBounds = YES;
        };
    }
    return _iconIV;
}

- (UIImageView *)storeIV {
    if (!_storeIV) {
        _storeIV = UIImageView.new;
        _storeIV.image = [UIImage imageNamed:@"gn_delicacy_shop"];
    }
    return _storeIV;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:12];
        _detailLB = la;
    }
    return _detailLB;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:16];
        _nameLB = la;
    }
    return _nameLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_mainColor;
        la.font = [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DIN-Bold"];
        _priceLB = la;
    }
    return _priceLB;
}

- (HDLabel *)soldLB {
    if (!_soldLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:12];
        la.textAlignment = NSTextAlignmentRight;
        _soldLB = la;
    }
    return _soldLB;
}

- (HDLabel *)originPirceLB {
    if (!_originPirceLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:12];
        _originPirceLB = la;
    }
    return _originPirceLB;
}

- (HDLabel *)distanceLB {
    if (!_distanceLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_999Color;
        la.font = [HDAppTheme.font gn_ForSize:12];
        _distanceLB = la;
    }
    return _distanceLB;
}

- (UIView *)lineIV {
    if (!_lineIV) {
        _lineIV = UIView.new;
        _lineIV.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _lineIV;
}

@end
