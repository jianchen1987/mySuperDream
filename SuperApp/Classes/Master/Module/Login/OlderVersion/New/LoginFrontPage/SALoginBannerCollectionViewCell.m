//
//  SALoginBannerCollectionViewCell.m
//  SuperApp
//
//  Created by Tia on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginBannerCollectionViewCell.h"


@interface SALoginBannerCollectionViewCell ()

@property (nonatomic, strong) SDAnimatedImageView *imageView; ///< 图片

@end


@implementation SALoginBannerCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];

    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
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
