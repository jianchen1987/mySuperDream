//
//  TNStoreBannerCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreBannerCollectionViewCell.h"


@interface TNStoreBannerCollectionViewCell ()
/// imageView
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation TNStoreBannerCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [HDWebImageManager setImageWithURL:url placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, 140) logoWidth:100] imageView:self.imageView];
    [self setNeedsUpdateConstraints];
}

/** @lazy imageview */
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
