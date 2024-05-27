//
//  WMShoppingCartButton.m
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartButton.h"
#import "SAView.h"


@interface WMShoppingCartButton ()
/// 指示器图
@property (nonatomic, strong) UIImageView *indicatorIV;
@end


@implementation WMShoppingCartButton
#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.indicatorIV];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)updateConstraints {
    [self.indicatorIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.centerX.equalTo(self.mas_right).offset(-17);
        make.centerY.equalTo(self.mas_top).offset(17);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - public methods
- (void)updateIndicatorDotWithCount:(NSUInteger)count {
    self.indicatorIV.hidden = count <= 0;
}

#pragma mark - lazy load
- (UIImageView *)indicatorIV {
    if (!_indicatorIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"red_dot"];
        imageView.hidden = true;
        _indicatorIV = imageView;
    }
    return _indicatorIV;
}
@end
