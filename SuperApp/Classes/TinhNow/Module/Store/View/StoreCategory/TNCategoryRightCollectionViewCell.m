//
//  TNCategoryRightCollectionViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryRightCollectionViewCell.h"
#import "TNCategoryModel.h"
#import "HDAppTheme+TinhNow.h"


@interface TNCategoryRightCollectionViewCell ()
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// icon
@property (nonatomic, strong) UIImageView *icon;
@end


@implementation TNCategoryRightCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.icon.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.contentView);
    }];
}

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
    NSString *imageUrl = model.icon;
    if (HDIsStringEmpty(imageUrl)) {
        imageUrl = model.logo;
    }
    [HDWebImageManager setImageWithURL:imageUrl placeholderImage:[HDHelper placeholderImageWithSize:[self itemWidth]] imageView:self.icon];
}

#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
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
