//
//  CMSSixImageCardItemView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSSixImageCardItemView.h"
#import "CMSSixImageItemConfig.h"


@interface CMSSixImageCardItemView ()

/// 图片
@property (strong, nonatomic) UIImageView *imageView;
/// 文本
@property (strong, nonatomic) UILabel *textLabel;

@end


@implementation CMSSixImageCardItemView

- (void)hd_setupViews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.textLabel sizeToFit];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.textLabel.isHidden) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(kRealWidth(5));
            make.height.mas_equalTo(25);
        }
    }];
    [super updateConstraints];
}
#pragma mark - setter
- (void)setModel:(CMSSixImageItemConfig *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(105), kRealWidth(105))] imageView:self.imageView];
    self.textLabel.text = model.title;
    self.textLabel.font = [UIFont systemFontOfSize:model.titleFont weight:UIFontWeightMedium];
    self.textLabel.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.textLabel.hidden = HDIsStringEmpty(model.title);
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _imageView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

@end
