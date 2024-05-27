//
//  SAInfoAlertView.m
//  SuperApp
//
//  Created by seeu on 2022/4/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAInfoAlertView.h"


@interface SAInfoAlertView ()
///< 标题
@property (nonatomic, strong) SALabel *titleLabel;
@end


@implementation SAInfoAlertView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.model.titleEdgeInsets);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAInfoAlertViewModel *)model {
    _model = model;
    if (model.attributeString) {
        self.titleLabel.attributedText = model.attributeString;
    } else {
        self.titleLabel.text = model.text;
        self.titleLabel.font = model.textFont;
        self.titleLabel.textColor = model.textColor;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    CGFloat height = 0;
    height += UIEdgeInsetsGetVerticalValue(self.model.titleEdgeInsets);
    CGFloat maxWidth = CGRectGetWidth(self.frame) - UIEdgeInsetsGetHorizontalValue(self.model.titleEdgeInsets);
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    height += titleSize.height;

    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
}

#pragma mark - lazy load
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = SALabel.new;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end


@implementation SAInfoAlertViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textFont = HDAppTheme.font.standard2;
        self.textColor = HDAppTheme.color.G2;
        self.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(30), HDAppTheme.value.padding.left, kRealHeight(50), HDAppTheme.value.padding.right);
    }
    return self;
}

@end
