//
//  WMIndicatorSliderView.m
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMIndicatorSliderView.h"


@implementation WMIndicatorSliderView

- (void)hd_setupViews {
    [self addSubview:self.sliderView];

    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.equalTo(self.mas_width).multipliedBy(0.6);
    }];
    [self layoutIfNeeded];
}

- (void)setOffset:(CGFloat)offset {
    offset = MIN(1, MAX(0, offset));
    _offset = offset;
    CGFloat width = self.hd_width * 0.4;
    CGRect rect = self.sliderView.frame;
    rect.origin.x = width * offset;
    self.sliderView.frame = rect;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = UIView.new;
        _sliderView.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        _sliderView.layer.cornerRadius = kRealWidth(3.5);
    }
    return _sliderView;
}

@end
