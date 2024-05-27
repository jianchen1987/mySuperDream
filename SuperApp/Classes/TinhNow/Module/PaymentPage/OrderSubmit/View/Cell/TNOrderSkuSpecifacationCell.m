//
//  TNSkuSpecifacationCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderSkuSpecifacationCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderSkuSpecifacationCell ()
/// sku图片
@property (strong, nonatomic) UIImageView *logoImageView;
/// 遮罩图片  库存异常使用
@property (strong, nonatomic) UIView *grayLogoView;
/// 规格文本
@property (strong, nonatomic) UILabel *specsLabel;
/// 数量
@property (strong, nonatomic) UILabel *quantityLabel;
/// 价格
@property (nonatomic, copy) UILabel *priceLabel;
/// 底部线条
@property (nonatomic, strong) UIView *bottomLine;
/// 提示文案
@property (strong, nonatomic) UILabel *skuTipsLabel;

@end


@implementation TNOrderSkuSpecifacationCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView addSubview:self.grayLogoView];
    [self.contentView addSubview:self.specsLabel];
    [self.contentView addSubview:self.quantityLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.skuTipsLabel];
    [self.contentView addSubview:self.bottomLine];
}
- (void)setCellModel:(TNOrderSkuSpecifacationCellModel *)cellModel {
    _cellModel = cellModel;
    [HDWebImageManager setImageWithURL:cellModel.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(25), kRealWidth(25))] imageView:self.logoImageView];
    self.specsLabel.text = HDIsStringNotEmpty(cellModel.spec) ? cellModel.spec : TNLocalizedString(@"tn_page_default_title", @"默认");
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@", cellModel.quantity];
    self.priceLabel.text = cellModel.price.thousandSeparatorAmount;
    if (HDIsStringNotEmpty(cellModel.invalidMsg)) {
        self.skuTipsLabel.hidden = NO;
        self.skuTipsLabel.text = cellModel.invalidMsg;
        self.grayLogoView.hidden = NO;
        self.specsLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        self.quantityLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        self.priceLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
    } else {
        self.skuTipsLabel.hidden = YES;
        self.grayLogoView.hidden = YES;
        self.specsLabel.textColor = HDAppTheme.TinhNowColor.G3;
        self.quantityLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.priceLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(25), kRealWidth(25)));
    }];
    if (!self.grayLogoView.isHidden) {
        [self.grayLogoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.logoImageView);
        }];
    }
    [self.specsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView.mas_centerY);
        make.left.equalTo(self.logoImageView.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.quantityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specsLabel.mas_left);
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.logoImageView.mas_bottom).offset(kRealWidth(15));

        if (self.skuTipsLabel.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }
    }];
    if (!self.skuTipsLabel.isHidden) {
        [self.skuTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.specsLabel.mas_left);
            make.top.equalTo(self.priceLabel.mas_bottom).offset(kRealWidth(5));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    if (self.cellModel.lineHeight > 0) {
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(self.cellModel.lineHeight);
        }];
    }
    [super updateConstraints];
}
/** @lazy logoImageView */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _logoImageView;
}
/** @lazy grayLogoView */
- (UIView *)grayLogoView {
    if (!_grayLogoView) {
        _grayLogoView = [[UIView alloc] init];
        //        _grayLogoView.alpha = 0.6;
        _grayLogoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _grayLogoView;
}
/** @lazy specsLabel */
- (UILabel *)specsLabel {
    if (!_specsLabel) {
        _specsLabel = [[UILabel alloc] init];
        _specsLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _specsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _specsLabel.numberOfLines = 2;
    }
    return _specsLabel;
}
/** @lazy quantityLabel */
- (UILabel *)quantityLabel {
    if (!_quantityLabel) {
        _quantityLabel = [[UILabel alloc] init];
        _quantityLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _quantityLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _quantityLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontRegular:15];
    }
    return _priceLabel;
}
/** @lazy skuTipsLabel */
- (UILabel *)skuTipsLabel {
    if (!_skuTipsLabel) {
        _skuTipsLabel = [[UILabel alloc] init];
        _skuTipsLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _skuTipsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _skuTipsLabel.numberOfLines = 0;
    }
    return _skuTipsLabel;
}
/** @lazy bottomLine */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end


@implementation TNOrderSkuSpecifacationCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineHeight = 0;
    }
    return self;
}
@end
