//
//  TNCategoryHeaderReusableView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryHeaderReusableView.h"
#import "HDAppTheme+TinhNow.h"


@interface TNCategoryHeaderReusableView ()
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation TNCategoryHeaderReusableView

- (void)updateConstraints {
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard15B;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _titleLabel;
}

@end
