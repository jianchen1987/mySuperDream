//
//  SASingleImageCollectionViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASingleImageCollectionViewCell.h"


@implementation SASingleImageCollectionViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cornerRadius = 5;
        self.placholderImage = [UIImage imageNamed:@"ic_found_banner_placeholder"];
    }
    return self;
}
@end


@interface SASingleImageCollectionViewCell ()

@property (nonatomic, strong) SDAnimatedImageView *imageView; ///< 图片
@property (nonatomic, strong) UIView *coverView;              ///< 覆盖层
@property (nonatomic, strong) UILabel *coverTitle;            ///< 覆盖层标题
@end


@implementation SASingleImageCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.coverView];
    [self.coverView addSubview:self.coverTitle];

    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.coverTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.width.equalTo(self.coverView).offset(-2 * kRealWidth(15));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.model.heightFullRounded) {
        // 圆角
        [self setRoundedCorners:UIRectCornerAllCorners radius:CGRectGetHeight(self.frame) * 0.5];
    } else {
        // 圆角
        [self setRoundedCorners:UIRectCornerAllCorners radius:self.model.cornerRadius];
    }
}

#pragma mark - getters and setters
- (void)setModel:(SASingleImageCollectionViewCellModel *)model {
    _model = model;

    if (model.isLocal) {
        self.imageView.image = [UIImage imageNamed:model.imageName];
    } else {
        [HDWebImageManager setGIFImageWithURL:model.url placeholderImage:model.placholderImage imageView:self.imageView];
    }
}

#pragma mark - lazy load
- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end
