//
//  CMSKingKongAreaAppView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaAppView.h"


@interface CMSKingKongAreaAppView ()
@property (nonatomic, strong) UIView *containerView;       ///< 容器，控制整体垂直居中
@property (nonatomic, strong) SDAnimatedImageView *logoIV; ///< logo
@property (nonatomic, strong) UILabel *brandLB;            ///< 品牌名称
@property (nonatomic, strong) UIImageView *remarkIV;       ///< 备注图片
@property (nonatomic, strong) UILabel *remarkLabel;        ///< 角标文字
@end


@implementation CMSKingKongAreaAppView
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    self.contentMode = UIViewContentModeCenter;

    [self addSubview:self.containerView];
    [self.containerView addSubview:self.logoIV];
    [self.containerView addSubview:self.brandLB];
    [self addSubview:self.remarkIV];
    [self.remarkIV addSubview:self.remarkLabel];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(self).offset(8);
        // make.centerY.equalTo(self).offset(5);
        make.top.equalTo(self.logoIV);
        make.bottom.equalTo(self.brandLB);
    }];

    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.55);
        make.height.equalTo(self.logoIV.mas_width);
    }];

    [self.brandLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIV.mas_bottom).offset(2);
        make.centerX.equalTo(self);
        make.width.equalTo(self).offset(-4);
    }];

    if (!self.remarkIV.isHidden) {
        [self.remarkIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoIV.mas_centerX);
            make.centerY.equalTo(self.logoIV.mas_top);
            make.right.equalTo(self.remarkLabel).offset(6);
            make.right.lessThanOrEqualTo(self);
        }];

        [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remarkIV).offset(6);
            make.right.lessThanOrEqualTo(self).offset(-6);
            make.centerY.equalTo(self.remarkIV);
        }];
    }
    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setConfig:(CMSKingKongAreaItemConfig *)config {
    _config = config;

    _remarkIV.hidden = HDIsStringEmpty(config.cornerMarkText) || config.cornerMarkStyle == 0;
    if (!_remarkIV.isHidden) {
        UIImage *image = [UIImage imageNamed:@"corner_bubble_1"];
        if (config.cornerMarkStyle == CMSAppCornerIconStyle2) {
            image = [UIImage imageNamed:@"corner_bubble_2"];
        } else if (config.cornerMarkStyle == CMSAppCornerIconStyle3) {
            image = [UIImage imageNamed:@"corner_bubble_3"];
        }
        _remarkIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5)
                                                resizingMode:UIImageResizingModeStretch];
        _remarkLabel.text = config.cornerMarkText;
    }

    const CGFloat scale = UIScreen.mainScreen.scale;
    [HDWebImageManager setGIFImageWithURL:config.imageUrl size:CGSizeMake(60 * scale, 60 * scale) placeholderImage:HDHelper.circlePlaceholderImage imageView:self.logoIV];
    self.brandLB.text = config.title;
    self.brandLB.textColor = [UIColor hd_colorWithHexString:config.titleColor];
    self.brandLB.font = [UIFont systemFontOfSize:config.titleFont];

    [self setNeedsUpdateConstraints];
}

- (UILabel *)nameLabel {
    return self.brandLB;
}

- (SDAnimatedImageView *)logoImageView {
    return self.logoIV;
}

#pragma mark - lazy load
- (UIView *)containerView {
    return _containerView ?: ({ _containerView = UIView.new; });
}

- (SDAnimatedImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = SDAnimatedImageView.new;
        _logoIV.runLoopMode = NSRunLoopCommonModes;
    }
    return _logoIV;
}

- (UIImageView *)remarkIV {
    if (!_remarkIV) {
        _remarkIV = UIImageView.new;
        _remarkIV.hidden = true;
    }
    return _remarkIV;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = UILabel.new;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.textColor = UIColor.whiteColor;
        _remarkLabel.font = [HDAppTheme.font boldForSize:11];
        _remarkLabel.lineBreakMode = NSLineBreakByClipping;
    }
    return _remarkLabel;
}

- (UILabel *)brandLB {
    if (!_brandLB) {
        _brandLB = [[UILabel alloc] init];
        _brandLB.font = HDAppTheme.font.standard4;
        _brandLB.textColor = HDAppTheme.color.G2;
        _brandLB.numberOfLines = 2;
        _brandLB.textAlignment = NSTextAlignmentCenter;
    }
    return _brandLB;
}
@end
