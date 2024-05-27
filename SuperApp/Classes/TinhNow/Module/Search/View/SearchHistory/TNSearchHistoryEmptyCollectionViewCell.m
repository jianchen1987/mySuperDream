//
//  TNSearchHistoryEmptyCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchHistoryEmptyCollectionViewCell.h"


@implementation TNSearchHistoryEmptyModel
@end


@interface TNSearchHistoryEmptyCollectionViewCell ()
/// keyword label
@property (nonatomic, strong) HDLabel *titleLabel;
@end


@implementation TNSearchHistoryEmptyCollectionViewCell
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
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(TNSearchHistoryEmptyModel *)model {
    _model = model;
    [self setNeedsUpdateConstraints];
}
#pragma mark - lazy load
/** @lazy  */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _titleLabel.text = TNLocalizedString(@"tn_page_searchhistory_empty_title", @"No more searche history");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.hd_edgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    }
    return _titleLabel;
}
@end
