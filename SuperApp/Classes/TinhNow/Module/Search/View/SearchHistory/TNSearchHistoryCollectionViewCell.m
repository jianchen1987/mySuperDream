//
//  TNSearchHistoryCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchHistoryCollectionViewCell.h"
#import "TNSearchHistoryModel.h"
#import <HDLabel.h>


@interface TNSearchHistoryCollectionViewCell ()
/// keyword label
@property (nonatomic, strong) HDLabel *keyWordLabel;
@end


@implementation TNSearchHistoryCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.keyWordLabel];
}

- (void)updateConstraints {
    [self.keyWordLabel sizeToFit];
    [self.keyWordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(28.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.keyWordLabel.frame));
    }];
    [super updateConstraints];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width > kScreenWidth - kRealWidth(30) ? kScreenWidth - 50 : size.width;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(TNSearchHistoryModel *)model {
    _model = model;
    self.keyWordLabel.text = _model.keyWord;
    [self setNeedsUpdateConstraints];
}
#pragma mark - lazy load
/** @lazy  */
- (HDLabel *)keyWordLabel {
    if (!_keyWordLabel) {
        _keyWordLabel = [[HDLabel alloc] init];
        _keyWordLabel.font = HDAppTheme.font.standard4Bold;
        _keyWordLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _keyWordLabel.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _keyWordLabel.textAlignment = NSTextAlignmentCenter;
        _keyWordLabel.numberOfLines = 1;
        _keyWordLabel.hd_edgeInsets = UIEdgeInsetsMake(5, 18, 5, 18);
        _keyWordLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 4.0f;
            view.layer.masksToBounds = YES;
        };
    }
    return _keyWordLabel;
}

@end
