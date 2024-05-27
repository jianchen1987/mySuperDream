//
//  PNMSStepItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStepItemView.h"
#import "PNLabel.h"
#import "PNMSStepItemModel.h"


@interface PNMSStepItemView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) PNLabel *titleLabel;
@property (nonatomic, strong) PNLabel *subTitleLabel;
@end


@implementation PNMSStepItemView

- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(self.model.titleEdgeInsets.top);
    }];

    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(self.model.subTitleEdgeInsets.top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [self.subTitleLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

    [super updateConstraints];
}

- (void)setModel:(PNMSStepItemModel *)model {
    _model = model;

    self.iconImgView.image = model.iconImage;

    self.titleLabel.text = self.model.titleStr;
    self.titleLabel.textColor = self.model.titleColor;
    self.titleLabel.font = self.model.titleFont;

    self.subTitleLabel.text = self.model.subTitleStr;
    self.subTitleLabel.textColor = self.model.subTitleColor;
    self.subTitleLabel.font = self.model.subTitleFont;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (PNLabel *)titleLabel {
    if (!_titleLabel) {
        PNLabel *label = [[PNLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.verticalAlignment = PNVerticalAlignmentTop;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNLabel *)subTitleLabel {
    if (!_subTitleLabel) {
        PNLabel *label = [[PNLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.verticalAlignment = PNVerticalAlignmentTop;
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

@end
