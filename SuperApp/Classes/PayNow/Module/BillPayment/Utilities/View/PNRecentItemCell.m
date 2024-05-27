//
//  PNRecentItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNRecentItemCell.h"


@interface PNRecentItemCell ()
@property (nonatomic, strong) UIImageView *leftIconImgView;
@property (nonatomic, strong) SALabel *leftTitleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation PNRecentItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.leftIconImgView];
    [self.bgView addSubview:self.leftTitleLabel];
    [self.bgView addSubview:self.arrowImgView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.leftIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(kRealWidth(25)));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(10));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.centerY.mas_equalTo(self.leftIconImgView.mas_centerY);
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-10));
    }];

    [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIconImgView.mas_right).offset(kRealWidth(5));
        make.centerY.mas_equalTo(self.leftIconImgView.mas_centerY);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(kRealWidth(-15));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(10));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-10));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-1));
        make.height.mas_equalTo(self.isLast ? @(0) : @(PixelOne));
    }];

    [super updateConstraints];
}

- (void)setItemModel:(PNRecentBillListItemModel *)itemModel {
    _itemModel = itemModel;
    [HDWebImageManager setImageWithURL:itemModel.paymentCategoryIcon size:CGSizeMake(kRealWidth(25), kRealWidth(25)) placeholderImage:[UIImage imageNamed:@"pn_placeholderImage_square"]
                             imageView:self.leftIconImgView];
    self.leftTitleLabel.text = self.itemModel.billCode;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard13;
        _leftTitleLabel = label;
    }
    return _leftTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

- (UIImageView *)leftIconImgView {
    if (!_leftIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _leftIconImgView = imageView;
    }
    return _leftIconImgView;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_arrow_gray_small"];
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

@end
