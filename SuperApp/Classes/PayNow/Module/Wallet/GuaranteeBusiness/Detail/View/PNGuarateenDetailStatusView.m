//
//  PNGuarateenDetailStatusView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenDetailStatusView.h"


@interface PNGuarateenDetailStatusView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *statusLabel;
@end


@implementation PNGuarateenDetailStatusView

- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.statusLabel];
}

- (void)updateConstraints {
    [super updateConstraints];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_paycode_icon"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

@end
