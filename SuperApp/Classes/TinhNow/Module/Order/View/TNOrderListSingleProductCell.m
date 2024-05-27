//
//  TNOrderListCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListSingleProductCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderListSingleProductCell ()
/// productsPic
@property (nonatomic, strong) UIImageView *productsImageView;
/// productName
@property (nonatomic, strong) UILabel *productsNameLabel;
/// productsPropertity
@property (nonatomic, strong) UILabel *productsPropertyLabel;
/// products quantiity
@property (nonatomic, strong) UILabel *quantityAndPriceLabel;
/// 退款状态
@property (strong, nonatomic) UILabel *refundStatusLabel;
@end


@implementation TNOrderListSingleProductCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.productsImageView];
    [self.contentView addSubview:self.productsNameLabel];
    [self.contentView addSubview:self.productsPropertyLabel];
    [self.contentView addSubview:self.quantityAndPriceLabel];
    [self.contentView addSubview:self.refundStatusLabel];
}
- (void)setModel:(TNOrderProductItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(110), kRealWidth(110))] imageView:self.productsImageView];
    self.productsNameLabel.text = model.name;
    self.productsPropertyLabel.text = model.specifications;
    self.quantityAndPriceLabel.text = [NSString stringWithFormat:@"%@ x%ld", model.price.thousandSeparatorAmount, model.quantity];
}
- (void)setRefundStatusDes:(NSString *)refundStatusDes {
    _refundStatusDes = refundStatusDes;
    if (HDIsStringNotEmpty(refundStatusDes)) {
        self.refundStatusLabel.hidden = NO;
        self.refundStatusLabel.text = refundStatusDes;
    } else {
        self.refundStatusLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.productsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(110), kRealWidth(110)));
    }];
    [self.productsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productsImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.productsImageView.mas_top);
    }];
    [self.productsPropertyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productsImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.productsNameLabel.mas_bottom).offset(kRealWidth(10));
    }];
    [self.quantityAndPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productsImageView.mas_right).offset(kRealWidth(10));
        if (!self.refundStatusLabel.isHidden) {
            make.right.lessThanOrEqualTo(self.refundStatusLabel.mas_left).offset(-kRealWidth(15));
        } else {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }
        make.bottom.equalTo(self.productsImageView.mas_bottom);
    }];
    if (!self.refundStatusLabel.isHidden) {
        [self.refundStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.quantityAndPriceLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }

    [super updateConstraints];
}
/** @lazy productsImageView */
- (UIImageView *)productsImageView {
    if (!_productsImageView) {
        _productsImageView = [[UIImageView alloc] init];
        _productsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        };
    }
    return _productsImageView;
}
/** @lazy productsNameLabel */
- (UILabel *)productsNameLabel {
    if (!_productsNameLabel) {
        _productsNameLabel = [[UILabel alloc] init];
        _productsNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _productsNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _productsNameLabel.numberOfLines = 2;
    }
    return _productsNameLabel;
}
/** @lazy productsPropertity */
- (UILabel *)productsPropertyLabel {
    if (!_productsPropertyLabel) {
        _productsPropertyLabel = [[UILabel alloc] init];
        _productsPropertyLabel.font = HDAppTheme.TinhNowFont.standard12;
        _productsPropertyLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _productsPropertyLabel.numberOfLines = 1;
    }
    return _productsPropertyLabel;
}
/** @lazy quantityAndPriceLabel */
- (UILabel *)quantityAndPriceLabel {
    if (!_quantityAndPriceLabel) {
        _quantityAndPriceLabel = [[UILabel alloc] init];
        _quantityAndPriceLabel.font = HDAppTheme.TinhNowFont.standard12;
        _quantityAndPriceLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _quantityAndPriceLabel.numberOfLines = 1;
    }
    return _quantityAndPriceLabel;
}

/** @lazy refundStatusLabel */
- (UILabel *)refundStatusLabel {
    if (!_refundStatusLabel) {
        _refundStatusLabel = [[UILabel alloc] init];
        _refundStatusLabel.font = HDAppTheme.TinhNowFont.standard14;
        _refundStatusLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _refundStatusLabel.numberOfLines = 1;
    }
    return _refundStatusLabel;
}
@end


@implementation TNOrderListSingleProductCellModel

@end
