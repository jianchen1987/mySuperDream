//
//  CMSTwoImagePagedCellItemView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTwoImagePagedCellItemView.h"
#import "CMSTwoImagePagedItemConfig.h"


@interface CMSTwoImagePagedCellItemView ()

/// 容器
@property (nonatomic, strong) UIControl *bgControl;
/// 图片
@property (nonatomic, strong) UIImageView *iconView;
/// 名称
@property (nonatomic, strong) SALabel *nameLabel;

@end


@implementation CMSTwoImagePagedCellItemView

- (void)hd_setupViews {
    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self addSubview:self.bgControl];
    [self.bgControl addSubview:self.iconView];
    [self.bgControl addSubview:self.nameLabel];
}

- (void)updateConstraints {
    [self.bgControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgControl);
        make.height.equalTo(self.iconView.mas_width).multipliedBy(88.0 / 163.0);
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(kRealWidth(7));
        make.left.right.equalTo(self.iconView);
        make.bottom.equalTo(self.mas_bottom).offset(kRealWidth(-5));
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.clickedBlock ?: self.clickedBlock(self.model);
}

#pragma mark - setter
- (void)setModel:(CMSTwoImagePagedItemConfig *)model {
    _model = model;

    self.nameLabel.text = model.title;
    self.nameLabel.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.nameLabel.font = [UIFont systemFontOfSize:model.titleFont];
    [HDWebImageManager setImageWithURL:model.imageUrl placeholderImage:nil imageView:self.iconView];
}

#pragma mark - lazy load
- (UIControl *)bgControl {
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] init];
    }
    return _bgControl;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _iconView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[SALabel alloc] init];
        _nameLabel.textColor = HDAppTheme.color.G1;
        _nameLabel.font = HDAppTheme.font.standard3;
    }
    return _nameLabel;
}
@end
