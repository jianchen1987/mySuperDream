//
//  GNArticleDetailBindCell.m
//  SuperApp
//
//  Created by wmz on 2022/10/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleDetailBindCell.h"
#import "GNArticleModel.h"


@interface GNArticleDetailBindCell ()
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;

@end


@implementation GNArticleDetailBindCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(108.0 / 375 * kScreenWidth);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNArticleModel *)data {
    if ([data isKindOfClass:GNArticleModel.class]) {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.boundImage] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, 216.0 / 375 * kScreenWidth)]];
    }
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconIV;
}

@end
