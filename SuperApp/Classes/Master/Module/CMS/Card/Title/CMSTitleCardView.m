//
//  CMSHeaderlineCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTitleCardView.h"
#import "CMSTitleItemConfig.h"


@interface CMSTitleCardView ()

/// 左边图片
@property (strong, nonatomic) UIImageView *leftImageView;
/// 右边图片
@property (strong, nonatomic) UIImageView *rightImageView;
/// 文案
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic, strong) CMSTitleItemConfig *itemConfig;

@end


@implementation CMSTitleCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.leftImageView];
    [self.containerView addSubview:self.rightImageView];
    [self.containerView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.containerView);
        make.bottom.lessThanOrEqualTo(self.containerView);
        make.width.lessThanOrEqualTo(@(kScreenWidth - kRealWidth(60)));
        if (self.itemConfig.style == CMSTitleCardStyleMiddle) {
            make.centerX.equalTo(self.containerView);
        } else if (self.itemConfig.style == CMSTitleCardStyleLeft) {
            if (self.leftImageView.isHidden) {
                make.left.equalTo(self.containerView);
            } else {
                make.left.equalTo(self.leftImageView.mas_right).offset(kRealWidth(4));
            }
        } else if (self.itemConfig.style == CMSTitleCardStyleRight) {
            if (self.rightImageView.isHidden) {
                make.right.equalTo(self.containerView);
            } else {
                make.right.equalTo(self.rightImageView.mas_left).offset(-kRealWidth(4));
            }
        }
    }];
    [self.leftImageView sizeToFit];
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftImageView.isHidden) {
            make.top.greaterThanOrEqualTo(self.containerView);
            make.bottom.lessThanOrEqualTo(self.containerView);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            if (self.itemConfig.style == CMSTitleCardStyleLeft) {
                make.left.equalTo(self.containerView);
            } else {
                make.right.equalTo(self.titleLabel.mas_left).offset(-kRealWidth(4));
            }
        }
    }];
    [self.rightImageView sizeToFit];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightImageView.isHidden) {
            make.top.greaterThanOrEqualTo(self.containerView);
            make.bottom.lessThanOrEqualTo(self.containerView);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            if (self.itemConfig.style == CMSTitleCardStyleRight) {
                make.right.equalTo(self.containerView);
            } else {
                make.left.equalTo(self.titleLabel.mas_right).offset(kRealWidth(4));
            }
        }
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;

    [self.titleLabel sizeToFit];
    height = MAX(height, self.titleLabel.frame.size.height);
    [self.leftImageView sizeToFit];
    height = MAX(height, self.leftImageView.frame.size.height);
    [self.rightImageView sizeToFit];
    height = MAX(height, self.rightImageView.frame.size.height);
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

- (void)setConfig:(SACMSCardViewConfig *)config {
    config.titleConfig = nil;
    [super setConfig:config];

    self.itemConfig = [CMSTitleItemConfig yy_modelWithJSON:self.config.getAllNodeContents.firstObject];

    self.titleLabel.text = self.itemConfig.title;
    self.titleLabel.font = [UIFont systemFontOfSize:self.itemConfig.titleFont weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor hd_colorWithHexString:self.itemConfig.titleColor];

    if (HDIsStringNotEmpty(self.itemConfig.leftIcon)) {
        self.leftImageView.hidden = false;
        [HDWebImageManager setImageWithURL:self.itemConfig.leftIcon placeholderImage:nil imageView:self.leftImageView];
    } else {
        self.leftImageView.hidden = true;
    }

    if (HDIsStringNotEmpty(self.itemConfig.rightIcon)) {
        self.rightImageView.hidden = false;
        [HDWebImageManager setImageWithURL:self.itemConfig.rightIcon placeholderImage:nil imageView:self.rightImageView];
    } else {
        self.rightImageView.hidden = true;
    }

    [self setNeedsUpdateConstraints];
}

- (void)clickedOnView {
    if (HDIsStringEmpty(self.itemConfig.link)) {
        return;
    }

    !self.clickNode ?: self.clickNode(self, self.config.nodes.firstObject, self.itemConfig.link, @"node@0");
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnView)];
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}

@end
