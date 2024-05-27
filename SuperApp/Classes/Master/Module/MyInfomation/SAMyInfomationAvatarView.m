//
//  SAMyInfomationAvatarView.m
//  SuperApp
//
//  Created by Tia on 2023/6/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMyInfomationAvatarView.h"


@interface SAMyInfomationAvatarView ()

@property (nonatomic, strong) UIImageView *iconView;

@end


@implementation SAMyInfomationAvatarView

- (void)hd_setupViews {
    [self addSubview:self.avatarView];
    [self addSubview:self.iconView];
}

- (void)updateConstraints {
    [self.avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(88, 88));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(16);
        make.bottom.equalTo(self);
    }];

    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.bottom.equalTo(self.avatarView);
    }];

    [super updateConstraints];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neutral"]];
        _avatarView.layer.borderWidth = 1;
        _avatarView.layer.borderColor = [UIColor colorWithRed:233 / 255.0 green:234 / 255.0 blue:239 / 255.0 alpha:1.0].CGColor;
        _avatarView.layer.cornerRadius = 44;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_info_photo"]];
    }
    return _iconView;
}

@end
