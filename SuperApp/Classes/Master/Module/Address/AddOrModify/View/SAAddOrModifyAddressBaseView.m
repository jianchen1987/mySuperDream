//
//  SAAddOrModifyAddressBaseView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressBaseView.h"


@interface SAAddOrModifyAddressBaseView ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SAAddOrModifyAddressBaseView

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.bottomLine];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.width.mas_equalTo(100);
        make.top.equalTo(self).offset(kRealWidth(15));
        make.bottom.lessThanOrEqualTo(self).offset(-kRealWidth(15));
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self.titleLB);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self);
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
