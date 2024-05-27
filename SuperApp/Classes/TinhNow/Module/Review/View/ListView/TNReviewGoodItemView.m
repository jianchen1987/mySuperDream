//
//  TNReviewGoodItemView.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNReviewGoodItemView.h"
#import "TNProductReviewModel.h"


@interface TNReviewGoodItemView ()
/// 图片
@property (strong, nonatomic) UIImageView *goodImageView;
/// 标题
@property (strong, nonatomic) HDLabel *nameLabel;
/// 价格
@property (strong, nonatomic) HDLabel *priceLabel;
/// 数量
@property (strong, nonatomic) HDLabel *numLabel;
@end


@implementation TNReviewGoodItemView

- (void)hd_setupViews {
    [self addSubview:self.goodImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.numLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.goodImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(8));
        make.top.equalTo(self.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodImageView.mas_top);
        make.left.equalTo(self.goodImageView.mas_right).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.mas_right).offset(-kRealWidth(8));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodImageView.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(8));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNProductReviewModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(70), kRealWidth(70))] imageView:self.goodImageView];
    self.nameLabel.text = model.itemNameMap.desc;
    self.priceLabel.text = model.totalPrice.thousandSeparatorAmount;
    self.numLabel.text = [NSString stringWithFormat:@"x%ld", model.quantity];
    [self setNeedsUpdateConstraints];
}
- (void)itemClick:(UITapGestureRecognizer *)tap {
    [HDMediator.sharedInstance navigaveToTinhNowOrderDetailsViewController:@{@"orderNo": self.model.orderNo}];
}
/** @lazy goodImageView */
- (UIImageView *)goodImageView {
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
        _goodImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _goodImageView;
}
/** @lazy nameLabel */
- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.hd_lineSpace = 3;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _nameLabel;
}
/** @lazy priceLabel */
- (HDLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[HDLabel alloc] init];
        _priceLabel.textColor = HexColor(0xFF2323);
        _priceLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _priceLabel;
}
/** @lazy numLabel */
- (HDLabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[HDLabel alloc] init];
        _numLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _numLabel.font = HDAppTheme.TinhNowFont.standard15;
        _numLabel.numberOfLines = 2;
    }
    return _numLabel;
}
@end
