//
//  SAOrderDetailRowView.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderDetailRowView.h"
#import "SAInfoView.h"
#import "SAShadowBackgroundView.h"


@interface SAOrderDetailRowView ()
/// 内容
@property (nonatomic, strong) SAInfoView *contentView;
/// 背景
@property (nonatomic, strong) SAShadowBackgroundView *bgView;
@end


@implementation SAOrderDetailRowView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.color.G5;
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
}

- (void)updateConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(7.5));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(7.5));
    }];
    [super updateConstraints];
}

#pragma mark - public methods
- (void)setNeedsUpdateContent {
    [self.contentView setNeedsUpdateContent];

    [self setNeedsUpdateConstraints];
}

#pragma mark - getter
- (SAInfoViewModel *)model {
    return self.contentView.model;
}

#pragma mark - lazy load
- (SAShadowBackgroundView *)bgView {
    if (!_bgView) {
        SAShadowBackgroundView *view = SAShadowBackgroundView.new;
        view.clipsToBounds = true;
        view.shadowRoundRadius = 0;
        _bgView = view;
    }
    return _bgView;
}

- (SAInfoView *)contentView {
    if (!_contentView) {
        _contentView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyColor = HDAppTheme.color.G3;
        model.valueColor = HDAppTheme.color.G1;
        model.lineWidth = 0;
        model.enableTapRecognizer = true;
        _contentView.model = model;
    }
    return _contentView;
}

@end
