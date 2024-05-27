//
//  SALogoTitleHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SALogoTitleHeaderView.h"


@implementation SALogoTitleHeaderViewModel
- (instancetype)init {
    if (self = [super init]) {
        _titleColor = HDAppTheme.color.G1;
        _titleFont = HDAppTheme.font.numberOnly;
        _marginImageToTitle = kRealWidth(14);
        _marginTitleToSubTitle = kRealWidth(8);
        _subTitleColor = HDAppTheme.color.G2;
        _subTitleFont = HDAppTheme.font.standard3;
    }
    return self;
}

@end


@interface SALogoTitleHeaderView ()
@property (nonatomic, strong) UIImageView *imageView; ///< 图片
@property (nonatomic, strong) SALabel *titleLB;       ///< 标题
@property (nonatomic, strong) SALabel *subTitleLB;    ///< 子标题
@end


@implementation SALogoTitleHeaderView
- (void)hd_setupViews {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLB];
    [self addSubview:self.subTitleLB];

    [self adjustContent];
}

#pragma mark - getters and setters
- (void)setModel:(SALogoTitleHeaderViewModel *)model {
    _model = model;

    [self adjustContent];
}

- (void)updateTitle:(NSString *)title {
    _model.title = title;

    [self adjustContent];
}

- (void)updateSubTitle:(NSString *)subTitle {
    _model.subTitle = subTitle;

    [self adjustContent];
}

#pragma mark - private methods
- (void)adjustContent {
    self.imageView.hidden = HDIsObjectNil(self.model.image);
    if (!self.imageView.isHidden) {
        self.imageView.image = self.model.image;
    }
    self.titleLB.hidden = HDIsStringEmpty(self.model.title);
    if (!self.titleLB.isHidden) {
        self.titleLB.text = self.model.title;
    }
    self.titleLB.textColor = self.model.titleColor;
    self.titleLB.font = self.model.titleFont;

    self.subTitleLB.hidden = HDIsStringEmpty(self.model.subTitle);
    if (!self.subTitleLB.isHidden) {
        self.subTitleLB.text = self.model.subTitle;
    }
    self.subTitleLB.textColor = self.model.subTitleColor;
    self.subTitleLB.font = self.model.subTitleFont;

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageView.isHidden) {
            make.top.left.equalTo(self);
            const CGFloat height = kRealWidth(80);
            const CGFloat width = height * (self.imageView.image.size.width / (CGFloat)(self.imageView.image.size.height));
            make.size.mas_equalTo(CGSizeMake(width, height));
            if (self.titleLB.isHidden && self.subTitleLB.isHidden) {
                make.bottom.equalTo(self);
            }
        }
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleLB.isHidden) {
            make.left.equalTo(self.imageView);
            if (self.imageView.isHidden) {
                make.top.left.equalTo(self);
            } else {
                make.top.mas_equalTo(self.imageView.mas_bottom).offset(self.model.marginImageToTitle);
            }

            make.width.equalTo(self);
            if (self.subTitleLB.isHidden) {
                make.bottom.equalTo(self);
            }
        }
    }];

    UIView *subTitleLBRefView = !self.titleLB.isHidden ? self.titleLB : self.imageView;
    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.subTitleLB.isHidden) {
            make.left.equalTo(self.imageView);
            make.top.mas_equalTo(subTitleLBRefView.mas_bottom).offset(self.model.marginTitleToSubTitle);
            make.width.equalTo(self);
            make.bottom.equalTo(self);
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = UIImageView.new;
        _imageView = imageView;
    }
    return _imageView;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)subTitleLB {
    if (!_subTitleLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        _subTitleLB = label;
    }
    return _subTitleLB;
}
@end
