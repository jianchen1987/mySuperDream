//
//  WMStoreProductReviewTagView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewTagView.h"


@implementation WMStoreProductReviewTagModel

@end

static CGFloat kIconWidth;


@interface WMStoreProductReviewTagView ()
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 流式布局 View
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@end


@implementation WMStoreProductReviewTagView
- (void)hd_setupViews {
    kIconWidth = kRealWidth(12);
    self.font = HDAppTheme.font.standard3;
    [self addSubview:self.iconIV];
    [self addSubview:self.floatLayoutView];
}

#pragma mark - event response
- (void)clickedTagButtonHandler:(HDUIGhostButton *)btn {
    !self.clickedTagButtonBlock ?: self.clickedTagButtonBlock(btn, btn.tag < self.tags.count ? self.tags[btn.tag] : nil);
}

#pragma mark - public methods
- (void)setTags:(NSArray<WMStoreProductReviewTagModel *> *)tags {
    _tags = tags;
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [tags enumerateObjectsUsingBlock:^(WMStoreProductReviewTagModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        button.tag = idx;
        [button setTitleColor:HDAppTheme.color.G3 forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.C1 forState:UIControlStateSelected];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = self.font;
        button.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:1.0];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button sizeToFit];
        button.hd_associatedObject = model.title;
        [button addTarget:self action:@selector(clickedTagButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.floatLayoutView addSubview:button];
    }];

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kIconWidth, kIconWidth));
        make.left.equalTo(self);
        // 取出第一个标签，语气 centerY 对齐
        if (self.floatLayoutView.subviews.firstObject) {
            make.centerY.equalTo(self.floatLayoutView.subviews.firstObject);
        } else {
            make.top.equalTo(self).offset(3);
        }
    }];
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth - 2 * HDAppTheme.value.padding.left - kIconWidth;
        make.left.equalTo(self.iconIV.mas_right).offset(5);
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)]);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.floatLayoutView setNeedsLayout];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;

    self.iconIV.image = [UIImage imageNamed:self.iconName];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"order_detail_merchant_icon"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 5);
    }
    return _floatLayoutView;
}
@end
