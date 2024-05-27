//
//  SACMSTitleView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSTitleView.h"


@interface SACMSTitleView ()

/// 图标
@property (nonatomic, strong) UIImageView *iconIV;
/// 主标题
@property (nonatomic, strong) UILabel *titleLB;
/// 主标题副标题分隔符
@property (nonatomic, strong) UIView *separatedView;
/// 副标题
@property (nonatomic, strong) UILabel *subTitleLB;

@end


@implementation SACMSTitleView

- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.separatedView];
    [self addSubview:self.subTitleLB];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.top.greaterThanOrEqualTo(self).offset(self.config.getContentEdgeInsets.top);
            make.bottom.lessThanOrEqualTo(self).offset(-self.config.getContentEdgeInsets.bottom);
            make.left.equalTo(self).offset(self.config.getContentEdgeInsets.left);
            make.centerY.equalTo(self);
        }
    }];
    [self.titleLB sizeToFit];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.isHidden) {
            make.top.greaterThanOrEqualTo(self).offset(self.config.getContentEdgeInsets.top);
            make.bottom.lessThanOrEqualTo(self).offset(-self.config.getContentEdgeInsets.bottom);
            make.width.mas_equalTo(self.titleLB.width);
            if (self.iconIV.isHidden) {
                make.left.equalTo(self).offset(self.config.getContentEdgeInsets.left);
            } else {
                make.left.equalTo(self.iconIV.mas_right).offset(8);
            }
        }
    }];
    [self.separatedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.separatedView.isHidden) {
            make.left.equalTo(self.titleLB.mas_right).offset(8);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(self.titleLB);
            make.width.mas_equalTo(PixelOne);
        }
    }];
    [self.subTitleLB sizeToFit];
    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.subTitleLB.isHidden) {
            make.width.mas_equalTo(self.subTitleLB.width);
            if (self.titleLB.isHidden) {
                make.top.greaterThanOrEqualTo(self).offset(self.config.getContentEdgeInsets.top);
                make.bottom.lessThanOrEqualTo(self).offset(-self.config.getContentEdgeInsets.bottom);
            } else {
                make.centerY.equalTo(self.titleLB);
            }
            if ([self.config.getStyle isEqualToString:CMSTitleViewStyleValue1]) {
                make.right.equalTo(self).offset(-self.config.getContentEdgeInsets.right);
            } else if ([self.config.getStyle isEqualToString:CMSTitleViewStyleValue2]) {
                make.left.equalTo(self.separatedView.mas_right).offset(8);
            }
        }
    }];
    [super updateConstraints];
}

- (CGFloat)heightOfTitleView {
    CGFloat height = 0;
    CGFloat titleHeight = HDIsStringEmpty(self.config.getTitle) ? 0 : [self.config.getTitle boundingAllRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) font:self.config.getTitleFont].height;
    CGFloat subTitleHeight
        = HDIsStringEmpty(self.config.getSubTitle) ? 0 : [self.config.getSubTitle boundingAllRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) font:self.config.getSubTitleFont].height;
    CGFloat iconHeight = HDIsStringEmpty(self.config.getIcon) ? 0 : 18;
    height = MAX(height, iconHeight);     // icon
    height = MAX(height, titleHeight);    // title
    height = MAX(height, subTitleHeight); // subtitle
    if (height > 0) {
        height += UIEdgeInsetsGetVerticalValue(self.config.getContentEdgeInsets);
    }

    return height;
}

#pragma mark - setter
- (void)setConfig:(SACMSTitleViewConfig *)config {
    _config = config;

    NSString *iconUrl = [config getIcon];
    self.iconIV.hidden = HDIsStringEmpty(iconUrl);
    if (HDIsStringNotEmpty(iconUrl)) {
        [HDWebImageManager setImageWithURL:iconUrl placeholderImage:nil imageView:self.iconIV];
    }
    self.titleLB.hidden = HDIsStringEmpty(config.getTitle);
    self.titleLB.text = config.getTitle;
    self.titleLB.font = config.getTitleFont;
    self.titleLB.textColor = config.getTitleColor;

    self.subTitleLB.hidden = HDIsStringEmpty(config.getSubTitle);
    self.subTitleLB.text = config.getSubTitle;
    self.subTitleLB.font = config.getSubTitleFont;
    self.subTitleLB.textColor = config.getSubTitleColor;

    self.separatedView.hidden = !([config.getStyle isEqualToString:CMSTitleViewStyleValue2] && HDIsStringNotEmpty(config.getSubTitle));
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickTitleHandler {
    !self.clickTitleView ?: self.clickTitleView(self.config.getTitleLink, @"title");
}
- (void)clickSubTitleHandler {
    !self.clickTitleView ?: self.clickTitleView(self.config.getSubTitleLink, @"subTitle");
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.hidden = true;
    }
    return _iconIV;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = UILabel.new;
        _titleLB.hidden = true;
        _titleLB.userInteractionEnabled = true;
        [_titleLB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleHandler)]];
    }
    return _titleLB;
}

- (UILabel *)subTitleLB {
    if (!_subTitleLB) {
        _subTitleLB = UILabel.new;
        _subTitleLB.hidden = true;
        _subTitleLB.userInteractionEnabled = true;
        [_subTitleLB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSubTitleHandler)]];
    }
    return _subTitleLB;
}

- (UIView *)separatedView {
    if (!_separatedView) {
        _separatedView = UIView.new;
        _separatedView.backgroundColor = HDAppTheme.color.G2;
        _separatedView.hidden = true;
    }
    return _separatedView;
}

@end
