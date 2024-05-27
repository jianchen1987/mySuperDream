//
//  WMNearbyStoreTagCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMNearbyStoreTagCollectionViewCell.h"
#import "WMNearbyStoreTagsModel.h"


@interface WMNearbyStoreTagCollectionViewCell ()

/// label
@property (nonatomic, strong) HDLabel *titleLabel;

@end


@implementation WMNearbyStoreTagCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(kRealHeight(20));
    }];
    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(WMNearbyStoreTagsModel *)model {
    _model = model;
    self.titleLabel.text = _model.key;
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected {
    if (!selected) {
        self.titleLabel.backgroundColor = HDAppTheme.color.G5;
        self.titleLabel.textColor = HDAppTheme.color.G1;
    } else {
        self.titleLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#1AFEBF01"];
        self.titleLabel.textColor = HDAppTheme.color.mainColor;
    }
}

#pragma mark - lazy load
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard4;
        _titleLabel.textColor = HDAppTheme.color.G1;
        _titleLabel.backgroundColor = HDAppTheme.color.G5;
        _titleLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 17, 2, 17);
        _titleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _titleLabel;
}
@end
