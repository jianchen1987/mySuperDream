//
//  TNProductSpecificationCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductSpecificationCollectionViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNProductSpecPropertieModel.h"


@interface TNProductSpecificationCollectionViewCell ()
/// title
@property (nonatomic, strong) HDLabel *titleLabel;
@end


@implementation TNProductSpecificationCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(28.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.titleLabel.frame));
    }];
    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    if (size.width < kRealWidth(40)) {
        size.width = kRealWidth(40);
    }
    if (size.width > kScreenWidth - 50) {
        size.width = kScreenWidth - 50;
    }

    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(TNProductSpecPropertieModel *)model {
    _model = model;
    self.titleLabel.text = _model.propValue;
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected {
    HDLog(@"%@被猪选中啦!%d", self.model.propValue, selected);
    if (selected) {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.C1;
        self.titleLabel.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;
    } else {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.titleLabel.layer.borderColor = HDAppTheme.TinhNowColor.C3.CGColor;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hd_edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _titleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 4.0f;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = HDAppTheme.TinhNowColor.G3.CGColor;
        };
    }
    return _titleLabel;
}

@end
