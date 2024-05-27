//
//  TNAddImageView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAddImageView.h"


@interface TNAddImageView ()
/// 相机图片
@property (strong, nonatomic) UIImageView *cameraIV;
@end


@implementation TNAddImageView
- (void)hd_setupViews {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = HDAppTheme.TinhNowColor.G4.CGColor;
    [self addSubview:self.cameraIV];
}
- (void)updateConstraints {
    [self.cameraIV sizeToFit];
    [self.cameraIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [super updateConstraints];
}
/** @lazy cameraIV */
- (UIImageView *)cameraIV {
    if (!_cameraIV) {
        _cameraIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_camera"]];
    }
    return _cameraIV;
}
@end
