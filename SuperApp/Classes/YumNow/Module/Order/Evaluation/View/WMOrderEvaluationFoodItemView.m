//
//  WMOrderEvaluationFoodItemView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderEvaluationFoodItemView.h"
#import "WMOrderEvaluationGoodsModel.h"


@interface WMOrderEvaluationFoodItemView ()

/// icon
@property (nonatomic, strong) UIImageView *iconView;
/// leftView
@property (nonatomic, strong) HDLabel *nameLabel;
/// like
@property (nonatomic, strong) HDUIButton *likeBtn;
/// unlike
@property (nonatomic, strong) HDUIButton *unlikeBtn;
/// 当前按钮
@property (nonatomic, weak) UIButton *selectedBtn;

@end


@implementation WMOrderEvaluationFoodItemView

- (void)hd_setupViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconView];
    [self addSubview:self.likeBtn];
    [self addSubview:self.unlikeBtn];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.height.width.mas_equalTo(kRealWidth(36));
        make.top.bottom.equalTo(self);
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_left);
        make.right.equalTo(self.likeBtn.mas_left).offset(-kRealWidth(22));
        make.height.equalTo(self.iconView);
    }];

    [self.likeBtn sizeToFit];
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unlikeBtn.mas_left).offset(-kRealWidth(10));
        make.centerY.equalTo(self.unlikeBtn.mas_centerY);
        make.size.mas_equalTo(self.likeBtn.bounds.size);
    }];

    [self.unlikeBtn sizeToFit];
    [self.unlikeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(self.unlikeBtn.bounds.size);
    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - event response
- (void)hd_buttonClick:(UIButton *)btn {
    if (btn.isSelected)
        return;

    btn.selected = true;
    self.selectedBtn.selected = false;
    self.selectedBtn = btn;

    if (btn == self.likeBtn) {
        self.model.status = WMOrderEvaluationFoodItemViewStatusLike;
    } else if (btn == self.unlikeBtn) {
        self.model.status = WMOrderEvaluationFoodItemViewStatusUnlike;
    }
}

- (void)setModel:(WMOrderEvaluationGoodsModel *)model {
    _model = model;

    self.nameLabel.text = self.model.commodityName;
    [HDWebImageManager setImageWithURL:model.commodityPictureIds.firstObject placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(4) size:CGSizeMake(kRealWidth(36), kRealWidth(36))] imageView:self.iconView];
    if (model.status == WMOrderEvaluationFoodItemViewStatusLike) {
        self.likeBtn.selected = true;
        self.unlikeBtn.selected = false;
        self.selectedBtn = self.likeBtn;
    } else if (model.status == WMOrderEvaluationFoodItemViewStatusUnlike) {
        self.likeBtn.selected = false;
        self.unlikeBtn.selected = true;
        self.selectedBtn = self.unlikeBtn;
    } else {
        self.likeBtn.selected = false;
        self.unlikeBtn.selected = false;
        self.selectedBtn = nil;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
    }
    return _iconView;
}

- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.textColor = HDAppTheme.WMColor.B3;
        _nameLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        _nameLabel.layer.backgroundColor = HDAppTheme.WMColor.bgGray.CGColor;
        _nameLabel.layer.cornerRadius = kRealWidth(4);
        _nameLabel.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(44), 0, kRealWidth(12));
    }
    return _nameLabel;
}

- (HDUIButton *)likeBtn {
    if (!_likeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_like"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_like_select"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self hd_buttonClick:btn];
        }];
        _likeBtn = button;
    }
    return _likeBtn;
}

- (HDUIButton *)unlikeBtn {
    if (!_unlikeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_unlike"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_unlike_select"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self hd_buttonClick:btn];
        }];
        _unlikeBtn = button;
    }
    return _unlikeBtn;
}

@end
