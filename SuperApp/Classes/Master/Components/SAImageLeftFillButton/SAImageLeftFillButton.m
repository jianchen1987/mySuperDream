//
//  SAImageLeftFillButton.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAImageLeftFillButton.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/HDFrameLayout.h>
#import <HDUIKit/HDAppTheme.h>


@implementation SAImageLeftFillButton

#pragma mark - life cycle
- (void)commonInit {
    self.layer.borderColor = HexColor(0x1679EF).CGColor;
    self.borderWidth = 1;
    self.backgroundColor = UIColor.whiteColor;
    [self setTitleColor:HexColor(0x1679EF) forState:UIControlStateNormal];
    self.titleLabel.font = HDAppTheme.font.standard2Bold;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(5), kRealWidth(12), kRealWidth(15));
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

- (void)sizeToFit {
    [super sizeToFit];

    // 如果有图，高度设置为图片高度
    if (self.imageView.image) {
        self.height = self.imageView.image.size.height;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.left = 0;
    if (self.imageView.width + self.titleLabel.width * 0.5 < self.width * 0.5) {
        self.titleLabel.centerX = self.width * 0.5;
    }
}
@end
