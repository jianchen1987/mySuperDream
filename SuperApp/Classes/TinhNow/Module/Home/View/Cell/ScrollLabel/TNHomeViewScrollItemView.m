//
//  TNHomeViewScrollItemView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeViewScrollItemView.h"
#import "SAInternationalizationModel.h"
#import "TNScrollContentModel.h"


@interface TNHomeViewScrollItemView ()

/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 内容
@property (nonatomic, strong) SALabel *contentLabel;

@end


@implementation TNHomeViewScrollItemView

- (void)hd_setupViews {
    [self addSubview:self.iconView];
    [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.height.mas_equalTo(kRealWidth(17));
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.contentLabel sizeToFit];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(kRealWidth(2));
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(CGRectGetWidth(self.contentLabel.frame));
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(TNScrollContentModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.iconUrl placeholderImage:[UIImage imageNamed:@"tinhnow_home_check"] imageView:self.iconView];
    self.contentLabel.text = model.text.desc;
    [self setNeedsUpdateConstraints];
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
    }
    return _contentLabel;
}
#pragma mark - config
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
@end
