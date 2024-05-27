//
//  WMMineHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineHeaderView.h"


@interface WMMineHeaderView ()
///< 头像
@property (nonatomic, strong) UIImageView *headIV;
///< 昵称
@property (nonatomic, strong) SALabel *nicknameLB;
@end


@implementation WMMineHeaderView
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;

    [self addSubview:self.headIV];
    [self addSubview:self.nicknameLB];

    [self addGestureRecognizer:self.hd_tapRecognizer];

    self.headIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
    };
    self.frame = CGRectMake(0, 0, kScreenWidth, kRealWidth(88));
}

- (void)hd_languageDidChanged {
    self.nicknameLB.text = WMLocalizedString(@"set_nickname", @"请设置昵称");
}

- (void)updateConstraints {
    [self.headIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(53), kRealWidth(53)));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.nicknameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIV.mas_right).offset(kRealWidth(15));
        make.centerY.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - override
- (void)hd_clickedViewHandler {
    !self.tapEventHandler ?: self.tapEventHandler();
}

#pragma mark - public methods
- (void)setHeadImageWithUrl:(NSString *)url {
    if (HDIsStringNotEmpty(url)) {
        [HDWebImageManager setImageWithURL:url placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.headIV];
    } else {
        self.headIV.image = [UIImage imageNamed:@"neutral"];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setNickName:(NSString *)nickName {
    if (HDIsStringNotEmpty(nickName)) {
        self.nicknameLB.text = nickName;

        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

#pragma mark - lazy load
- (UIImageView *)headIV {
    if (!_headIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"neutral"];
        _headIV = imageView;
    }
    return _headIV;
}

- (SALabel *)nicknameLB {
    if (!_nicknameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 1;
        _nicknameLB = label;
    }
    return _nicknameLB;
}
@end
