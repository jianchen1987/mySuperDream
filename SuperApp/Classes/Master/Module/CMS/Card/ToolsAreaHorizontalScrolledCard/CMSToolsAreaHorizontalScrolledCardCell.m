//
//  CMSToolsAreaHorizontalScrolledCardCell.m
//  SuperApp
//
//  Created by seeu on 2022/4/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSToolsAreaHorizontalScrolledCardCell.h"


@interface CMSToolsAreaHorizontalScrolledCardCell ()

///< 图标
@property (nonatomic, strong) SDAnimatedImageView *iconImageView;
///< 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation CMSToolsAreaHorizontalScrolledCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(2));
        make.size.mas_equalTo(CGSizeMake(self.model.cellSize.width, self.model.cellSize.width));
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(kRealWidth(5));
        make.left.right.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.iconImageView.mas_centerX);
    }];

    [super updateConstraints];
}

- (void)setModel:(CMSToolsAreaHorizontalScrolledCardCellModel *)model {
    _model = model;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(model.cellSize.width, model.cellSize.width)] imageView:self.iconImageView];
    self.titleLabel.text = model.title;
    if (HDIsStringNotEmpty(model.titleColor)) {
        self.titleLabel.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    }
    if (model.titleFont > 0) {
        self.titleLabel.font = [UIFont systemFontOfSize:model.titleFont weight:UIFontWeightMedium];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[SDAnimatedImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

@end


@implementation CMSToolsAreaHorizontalScrolledCardCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#FFFFFF";
        self.titleFont = 12.0f;
    }
    return self;
}

@end
