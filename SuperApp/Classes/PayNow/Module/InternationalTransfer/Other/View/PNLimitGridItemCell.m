//
//  PNLimitGridItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLimitGridItemCell.h"
#import "PNGrideItemModel.h"


@interface PNLimitGridItemCell ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *rightline;
@end


@implementation PNLimitGridItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.rightline];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.bottom.equalTo(self.contentView);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.bottom.right.equalTo(self.contentView);
    }];

    [self.rightline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(1));
        make.right.height.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark
- (void)setModel:(PNGrideItemModel *)model {
    _model = model;
    self.titleLabel.text = self.model.value;
    self.titleLabel.textColor = self.model.valueColor;
    self.titleLabel.font = self.model.valueFont;
    self.contentView.backgroundColor = self.model.cellBackgroudColor;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _bottomLine = view;
    }
    return _bottomLine;
}

- (UIView *)rightline {
    if (!_rightline) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _rightline = view;
    }
    return _rightline;
}

@end
