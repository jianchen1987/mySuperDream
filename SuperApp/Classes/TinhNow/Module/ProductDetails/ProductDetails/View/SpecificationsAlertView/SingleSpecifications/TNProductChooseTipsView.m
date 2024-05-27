//
//  TNProductChooseTipsView.m
//  SuperApp
//
//  Created by xixi on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductChooseTipsView.h"
#import "HDAppTheme+TinhNow.h"
#import <HDUIKit/HDMarqueeLabel.h>


@interface TNProductChooseTipsView ()
/// 喇叭
@property (nonatomic, strong) UIImageView *iconIV;
/// label
@property (nonatomic, strong) HDMarqueeLabel *textLabel;

@end


@implementation TNProductChooseTipsView

- (void)hd_setupViews {
    self.backgroundColor = [HDAppTheme.TinhNowColor.cFF8824 colorWithAlphaComponent:0.1f];

    [self addSubview:self.iconIV];
    [self addSubview:self.textLabel];

    [self addGestureRecognizer:self.hd_tapRecognizer];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
    }];

    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.userSetHeight) {
            make.top.equalTo(self).offset(kRealWidth(5));
        }
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.tappedHandler ?: self.tappedHandler();
}

#pragma mark - setter
- (void)setUserSetHeight:(BOOL)userSetHeight {
    _userSetHeight = userSetHeight;

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)setText:(NSString *)text {
    self.textLabel.text = text;

    [self.textLabel restartLabel];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"tinhnow-tips_k"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (HDMarqueeLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = HDMarqueeLabel.new;
        _textLabel.marqueeType = HDMarqueeTypeContinuous;
        _textLabel.trailingBuffer = 20;
        _textLabel.rate = 50;
        _textLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _textLabel.font = HDAppTheme.TinhNowFont.standard12M;
    }
    return _textLabel;
}
@end
