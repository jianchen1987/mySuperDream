//
//  GNCouPonImageView.m
//  SuperApp
//
//  Created by wmz on 2021/7/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCouPonImageView.h"
#import "GNTheme.h"
#import "Masonry.h"


@implementation GNCouPonImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.leftOffset = kRealWidth(2);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = HDAppTheme.value.gn_radius6;
        [self addSubview:self.couponLB];
    }
    return self;
}

- (void)updateConstraints {
    [self.couponLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftOffset);
        make.right.mas_equalTo(-(self.rightOffset ?: self.leftOffset));
        make.top.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (void)setLeftOffset:(CGFloat)leftOffset {
    _leftOffset = leftOffset;
    [self setNeedsUpdateConstraints];
}

- (HDLabel *)couponLB {
    if (!_couponLB) {
        _couponLB = HDLabel.new;
        _couponLB.numberOfLines = 3;
        _couponLB.textAlignment = NSTextAlignmentCenter;
        _couponLB.textColor = HDAppTheme.color.gn_333Color;
        _couponLB.font = [HDAppTheme.font gn_boldForSize:13.0f];
    }
    return _couponLB;
}
@end
