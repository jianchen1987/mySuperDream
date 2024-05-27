//
//  SAChooseAddressTipView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseAddressTipView.h"


@interface SAChooseAddressTipView ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;
/// 子标题
@property (nonatomic, strong) SALabel *subTitleLB;
@end


@implementation SAChooseAddressTipView
- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;

    [self addSubview:self.titleLB];
    [self addSubview:self.iconIV];
    [self addSubview:self.subTitleLB];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.isHidden) {
            make.top.equalTo(self).offset(kRealWidth(15));
            make.left.equalTo(self).offset(kRealWidth(15));
            make.right.equalTo(self).offset(-kRealWidth(15));
        }
    }];
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.left.equalTo(self).offset(kRealWidth(15));
        make.centerY.equalTo(self.subTitleLB);
    }];
    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (void)updateUIWithSubTitle:(NSString *)subTitle {
    if (HDIsStringNotEmpty(subTitle)) {
        self.iconIV.image = [UIImage imageNamed:@"address_icon"];
        self.subTitleLB.text = subTitle;
        @HDWeakify(self);
        void (^updateConstraintsWithAnimation)(void) = ^(void) {
            @HDStrongify(self);
            [self setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.4 animations:^{
                [self layoutIfNeeded];
            }];
        };
        updateConstraintsWithAnimation();
    }
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.text = SALocalizedString(@"your_location", @"你的位置");
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"warning"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)subTitleLB {
    if (!_subTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.text = SALocalizedString(@"locatin_disabled", @"无法获取定位");
        _subTitleLB = label;
    }
    return _subTitleLB;
}
@end
