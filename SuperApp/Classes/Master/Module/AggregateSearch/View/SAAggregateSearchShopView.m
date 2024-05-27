//
//  SAAggregateSearchShopView.m
//  SuperApp
//
//  Created by Tia on 2022/11/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAggregateSearchShopView.h"


@interface SAAggregateSearchShopView ()
/// 提示文言
@property (nonatomic, strong) UILabel *label;

@end


@implementation SAAggregateSearchShopView

- (void)hd_setupViews {
    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self addSubview:self.label];
}

- (void)hd_clickedViewHandler {
    !self.clickBlock ?: self.clickBlock();
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self);
    }];

    [super updateConstraints];
}

- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.textColor = HDAppTheme.color.sa_C333;
        _label.font = HDAppTheme.font.sa_standard11;
        _label.text = SALocalizedString(@"search_click_me_to_try", @"搜不出商店？点我试试");
    }
    return _label;
}

@end
