//
//  CMSToolsAreaCardNode.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSToolsAreaCardNode.h"
#import "CMSToolsAreaItemConfig.h"


@interface CMSToolsAreaCardNode ()

@property (nonatomic, strong) SDAnimatedImageView *logoIV; ///< logo
@property (nonatomic, strong) UILabel *nameLB;             ///< 名称
@property (nonatomic, strong) UIImageView *remarkIV;       ///< 备注图片
@property (nonatomic, strong) UILabel *remarkLabel;        ///< 角标文字

@end


@implementation CMSToolsAreaCardNode

- (void)hd_setupViews {
    [super hd_setupViews];
    [self addSubview:self.logoIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.remarkIV];
    [self.remarkIV addSubview:self.remarkLabel];

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewHandler)]];
}

- (void)updateConstraints {
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(44);
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - setter
- (void)setModel:(CMSToolsAreaItemConfig *)model {
    _model = model;

    const CGFloat scale = UIScreen.mainScreen.scale;
    [HDWebImageManager setGIFImageWithURL:model.imageUrl size:CGSizeMake(44 * scale, 44 * scale) placeholderImage:[HDHelper placeholderImageWithCornerRadius:22 size:CGSizeMake(44, 44) logoWidth:22]
                                imageView:self.logoIV];
    self.nameLB.text = model.title;
    self.nameLB.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.nameLB.font = [UIFont systemFontOfSize:model.titleFont];

    self.remarkIV.hidden = HDIsStringEmpty(model.cornerMarkText) || model.cornerMarkStyle == 0;
    if (!self.remarkIV.isHidden) {
        UIImage *image = [UIImage imageNamed:@"corner_bubble_1"];
        if (model.cornerMarkStyle == CMSAppCornerIconStyle2) {
            image = [UIImage imageNamed:@"corner_bubble_2"];
        } else if (model.cornerMarkStyle == CMSAppCornerIconStyle3) {
            image = [UIImage imageNamed:@"corner_bubble_3"];
        }
        self.remarkIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5)
                                                    resizingMode:UIImageResizingModeStretch];
        self.remarkLabel.text = model.cornerMarkText;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickViewHandler {
    !self.clickHandler ?: self.clickHandler(self.model);
}

#pragma mark - lazy load
- (SDAnimatedImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = SDAnimatedImageView.new;
    }
    return _logoIV;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.numberOfLines = 2;
        _nameLB.textColor = HDAppTheme.color.G1;
        _nameLB.font = HDAppTheme.font.standard4;
        _nameLB.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLB;
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

@end
