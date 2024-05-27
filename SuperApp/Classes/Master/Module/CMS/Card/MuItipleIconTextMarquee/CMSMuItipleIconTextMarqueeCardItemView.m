//
//  CMSMuItipleIconTextMarqueeCardItemView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSMuItipleIconTextMarqueeCardItemView.h"
#import "CMSMuItipleIconTextMarqueeItemConfig.h"


@interface CMSMuItipleIconTextMarqueeCardItemView ()

/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 内容
@property (nonatomic, strong) SALabel *contentLabel;

@end


@implementation CMSMuItipleIconTextMarqueeCardItemView

- (void)hd_setupViews {
    [self addSubview:self.iconView];
    [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconView.isHidden) {
            make.left.equalTo(self.mas_left);
            make.width.height.mas_lessThanOrEqualTo(kRealWidth(17));
            make.centerY.equalTo(self.mas_centerY);
        }
    }];

    [self.contentLabel sizeToFit];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.iconView.isHidden) {
            make.left.equalTo(self);
        } else {
            make.left.equalTo(self.iconView.mas_right).offset(kRealWidth(2));
        }
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(CGRectGetWidth(self.contentLabel.frame));
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(CMSMuItipleIconTextMarqueeItemConfig *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.imageUrl placeholderImage:nil imageView:self.iconView];
    self.iconView.hidden = HDIsStringEmpty(self.model.imageUrl);
    self.contentLabel.text = model.title;
    self.contentLabel.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.contentLabel.font = [UIFont systemFontOfSize:model.titleFont];
    [self setNeedsUpdateConstraints];
}

#pragma mark - action
- (void)clickedOnView {
    if (HDIsStringEmpty(self.model.link)) {
        return;
    }
    !self.clickView ?: self.clickView(self.model, self.model.link);
}

#pragma mark - lazy load
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[SALabel alloc] init];
        _contentLabel.textColor = HDAppTheme.color.G2;
        _contentLabel.font = HDAppTheme.font.standard3;
        _contentLabel.numberOfLines = 1;
        _contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnView)];
        [_contentLabel addGestureRecognizer:tap];
    }
    return _contentLabel;
}
#pragma mark - config
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
