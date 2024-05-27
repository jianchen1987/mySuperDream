//
//  TNCategoryMenuCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryMenuCollectionViewCell.h"
#import "TNCategoryModel.h"


@interface TNCategoryMenuCollectionViewCell ()
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// icon
@property (nonatomic, strong) UIImageView *icon;
@end


@implementation TNCategoryMenuCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo([self itemWidth]);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.contentView);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(kRealWidth(10));
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
}
//
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(TNCategoryModel *)model {
    _model = model;
    self.titleLabel.text = _model.name;
    [HDWebImageManager setImageWithURL:model.logo placeholderImage:[HDHelper placeholderImageWithSize:[self itemWidth]] imageView:self.icon];
    //    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard3;
        _titleLabel.textColor = HDAppTheme.color.G2;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[HDHelper placeholderImageWithSize:[self itemWidth]]];
        _icon.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _icon;
}
- (CGSize)itemWidth {
    return CGSizeMake(kRealWidth(70), kRealWidth(70));
}
@end
