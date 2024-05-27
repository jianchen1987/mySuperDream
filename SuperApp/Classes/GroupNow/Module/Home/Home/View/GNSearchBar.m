//
//  GNSearchBar.m
//  SuperApp
//
//  Created by wmz on 2021/9/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchBar.h"
#import "Masonry.h"
#import "UIColor+HDKitCore.h"


@interface GNSearchBar ()

@property (nonatomic, strong) UIImageView *gnImageView;

@property (nonatomic, strong) UIImageView *gnCntenView;

@property (nonatomic, strong) UIView *gnImageBg;

@end


@implementation GNSearchBar

- (void)updateConstraints {
    [super updateConstraints];

    self.gnCntenView = [self valueForKey:@"contentView"];
    self.gnImageView = [self valueForKey:@"imageView"];
    self.gnImageView.image = [UIImage imageNamed:@"gn_cell_search"];

    [self.gnCntenView insertSubview:self.gnImageBg belowSubview:self.gnImageView];
    [self.gnImageBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];

    [self.gnImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gnImageBg.mas_centerX);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(self.gnImageView.image.size);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gnImageBg.mas_right).offset(8);
        make.right.mas_equalTo(-8);
        make.height.equalTo(self.gnCntenView);
        make.centerY.mas_equalTo(self.gnCntenView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gnCntenView.layer.borderWidth = 1;
    self.gnCntenView.layer.borderColor = [UIColor hd_colorWithHexString:@"#FF6447"].CGColor;
    self.gnCntenView.layer.cornerRadius = 8;
}

- (UIView *)gnImageBg {
    if (!_gnImageBg) {
        _gnImageBg = UIView.new;
        _gnImageBg.backgroundColor = UIColor.orangeColor;
    }
    return _gnImageBg;
}

///防止崩溃
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
