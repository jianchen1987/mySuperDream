//
//  CMSParentHalfChildHalfParentItemView.m
//  SuperApp
//
//  Created by Tia on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSParentHalfChildHalfParentItemView.h"


@interface CMSParentHalfChildHalfParentItemView ()

@property (nonatomic, strong) SALabel *titleLB;

@property (nonatomic, strong) SALabel *subTitleLB;

@property (nonatomic, strong) SDAnimatedImageView *imageView;

@end


@implementation CMSParentHalfChildHalfParentItemView


- (void)hd_setupViews {
    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self addSubview:self.titleLB];
    [self addSubview:self.subTitleLB];
    [self addSubview:self.imageView];
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.clickView ?: self.clickView();
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(5));
        make.top.equalTo(self).offset(kRealWidth(5));
        make.right.equalTo(self).offset(-kRealWidth(5));
    }];
    [self.subTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealHeight(5));
    }];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.subTitleLB.mas_bottom).offset(kRealHeight(5));
        make.bottom.equalTo(self).offset(-kRealHeight(5));
    }];

    [super updateConstraints];
}


- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        //        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)subTitleLB {
    if (!_subTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard5;
        label.textColor = HDAppTheme.color.G3;
        //        label.numberOfLines = 0;
        _subTitleLB = label;
    }
    return _subTitleLB;
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
    }
    return _imageView;
}

@end
