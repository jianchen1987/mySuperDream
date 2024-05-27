//
//  TNOrderSubmitGoodsTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitGoodsTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import <YYText.h>


@implementation TNOrderSubmitGoodsTableViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineHeight = 0;
    }
    return self;
}
- (void)setWeight:(NSNumber *)weight {
    _weight = weight;
    if (!HDIsObjectNil(weight)) {
        double freight = [weight doubleValue];
        if (freight > 0) {
            double roundFreight = freight / 1000;
            if (roundFreight < 0.01) {
                roundFreight = 0.01;
            }
            self.showWight = [NSString stringWithFormat:@"%.2fkg", roundFreight];
        }
    }
}
@end


@interface TNOrderSubmitGoodsTableViewCell ()

/// goodsPic
@property (nonatomic, strong) UIImageView *goodsImageView;
/// goodName
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 重量或者体积
@property (strong, nonatomic) UILabel *weightLabel;
/// 退款状态
@property (strong, nonatomic) UILabel *refundStatusLabel;
/// 商品提示文案
//@property (strong, nonatomic) UILabel *goodTipsLabel;
///
@property (strong, nonatomic) UIView *goodImageMaskAlphaView;
///
@property (strong, nonatomic) HDLabel *expireTagLabel;
@end


@implementation TNOrderSubmitGoodsTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.goodsNameLabel];
    [self.contentView addSubview:self.weightLabel];
    [self.contentView addSubview:self.refundStatusLabel];
    [self.goodsImageView addSubview:self.goodImageMaskAlphaView];
    [self.goodImageMaskAlphaView addSubview:self.expireTagLabel];
}

- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];

    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(9);
        make.top.equalTo(self.goodsImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];

    if (!self.refundStatusLabel.isHidden) {
        [self.refundStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.equalTo(self.goodsImageView.mas_bottom);
        }];
    }

    if (!self.weightLabel.isHidden) {
        [self.weightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodsNameLabel.mas_leading);
            make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(10));
            make.bottom.equalTo(self.goodsImageView.mas_bottom);
        }];
    }

    if (!self.goodImageMaskAlphaView.isHidden) {
        [self.goodImageMaskAlphaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.goodsImageView);
        }];
        [self.expireTagLabel sizeToFit];
        [self.expireTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.goodImageMaskAlphaView.mas_centerY);
            make.left.equalTo(self.goodImageMaskAlphaView.mas_left).offset(kRealWidth(8));
            make.right.equalTo(self.goodImageMaskAlphaView.mas_right).offset(-kRealWidth(8));
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(TNOrderSubmitGoodsTableViewCellModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:_model.logoUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(80), kRealWidth(80)) logoWidth:kRealWidth(37)]
                             imageView:self.goodsImageView];
    self.goodsNameLabel.text = self.model.goodsName;
    if (HDIsStringNotEmpty(model.showWight)) {
        self.weightLabel.hidden = NO;
        self.weightLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"d3RQIY8O", @"商品重量"), model.showWight];
    } else {
        self.weightLabel.hidden = YES;
    }

    if (HDIsStringNotEmpty(model.invalidTips)) {
        self.goodImageMaskAlphaView.hidden = NO;
        self.expireTagLabel.text = model.invalidTips;
    } else {
        self.goodImageMaskAlphaView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
- (void)setRefundStatusDes:(NSString *)refundStatusDes {
    _refundStatusDes = refundStatusDes;
    if (HDIsStringNotEmpty(refundStatusDes)) {
        self.refundStatusLabel.hidden = NO;
        self.refundStatusLabel.text = refundStatusDes;
    } else {
        self.refundStatusLabel.hidden = YES;
    }
}
#pragma mark - lazy load
/** @lazy goodsImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5.0];
        };
    }
    return _goodsImageView;
}
/** @lazy goodsNameLabel */
- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _goodsNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _goodsNameLabel.numberOfLines = 2;
    }
    return _goodsNameLabel;
}

/** @lazy weightLabel */
- (UILabel *)weightLabel {
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] init];
        _weightLabel.font = HDAppTheme.TinhNowFont.standard12;
        _weightLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _weightLabel;
}
/** @lazy refundStatusLabel */
- (UILabel *)refundStatusLabel {
    if (!_refundStatusLabel) {
        _refundStatusLabel = [[UILabel alloc] init];
        _refundStatusLabel.font = HDAppTheme.TinhNowFont.standard14;
        _refundStatusLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _refundStatusLabel.numberOfLines = 1;
        _refundStatusLabel.hidden = YES;
    }
    return _refundStatusLabel;
}
/** @lazy goodImageMaskAlphaView */
- (UIView *)goodImageMaskAlphaView {
    if (!_goodImageMaskAlphaView) {
        _goodImageMaskAlphaView = [[UIView alloc] init];
        _goodImageMaskAlphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _goodImageMaskAlphaView;
}
/** @lazy expireTagLabel */
- (HDLabel *)expireTagLabel {
    if (!_expireTagLabel) {
        _expireTagLabel = [[HDLabel alloc] init];
        _expireTagLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _expireTagLabel.textColor = [UIColor whiteColor];
        _expireTagLabel.font = HDAppTheme.TinhNowFont.standard12;
        _expireTagLabel.textAlignment = NSTextAlignmentCenter;
        _expireTagLabel.hd_edgeInsets = UIEdgeInsetsMake(3, 4, 3, 4);
        _expireTagLabel.text = @"已失效";
        _expireTagLabel.numberOfLines = 2;
        _expireTagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _expireTagLabel;
}
///** @lazy goodTipsLabel */
//- (UILabel *)goodTipsLabel {
//    if (!_goodTipsLabel) {
//        _goodTipsLabel = [[UILabel alloc] init];
//        _goodTipsLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
//        _goodTipsLabel.font = HDAppTheme.TinhNowFont.standard12;
//        _goodTipsLabel.numberOfLines = 0;
//    }
//    return _goodTipsLabel;
//}
@end
