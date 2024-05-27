//
//  CMSMainEntranceCardViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSMainEntranceCardViewCell.h"


@interface CMSMainEntranceCardViewCell ()

///< 图标
@property (nonatomic, strong) SDAnimatedImageView *iconImageView;

@end


@implementation CMSMainEntranceCardViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImageView];
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)setModel:(CMSMainEntranceCardViewCellModel *)model {
    _model = model;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:model.cellSize] imageView:self.iconImageView];

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

@end


@implementation CMSMainEntranceCardViewCellModel

@end
