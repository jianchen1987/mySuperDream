//
//  PNAgentServicesCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAgentServicesCell.h"


@interface PNAgentServicesCell ()
@property (nonatomic, strong) SALabel *keyWordLabel;
@end


@implementation PNAgentServicesCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.keyWordLabel];
}

- (void)updateConstraints {
    [self.keyWordLabel sizeToFit];
    [self.keyWordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(23.0f);
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
    newFrame.size.width = size.width > kScreenWidth - 50 ? kScreenWidth - 50 : size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.keyWordLabel.text = titleStr;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy  */
- (SALabel *)keyWordLabel {
    if (!_keyWordLabel) {
        _keyWordLabel = [[SALabel alloc] init];
        _keyWordLabel.layer.borderColor = HDAppTheme.PayNowColor.c343B4D.CGColor;
        _keyWordLabel.layer.borderWidth = PixelOne;
        _keyWordLabel.layer.cornerRadius = kRealWidth(2);
        _keyWordLabel.font = HDAppTheme.PayNowFont.standard12;
        _keyWordLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _keyWordLabel.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _keyWordLabel.textAlignment = NSTextAlignmentCenter;
        _keyWordLabel.numberOfLines = 1;
        _keyWordLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(6), kRealWidth(3), kRealWidth(6));
    }
    return _keyWordLabel;
}
@end
