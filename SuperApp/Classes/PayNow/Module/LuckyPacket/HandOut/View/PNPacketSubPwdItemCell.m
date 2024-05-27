//
//  PNPacketSubPwdItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketSubPwdItemCell.h"


@interface PNPacketSubPwdItemCell ()
@property (nonatomic, strong) SALabel *label;
@end


@implementation PNPacketSubPwdItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
//    CGSize size = [self systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = newFrame.size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setContent:(NSString *)content {
    _content = content;

    self.label.text = self.content;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)label {
    if (!_label) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.layer.cornerRadius = kRealWidth(4);
        label.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        label.layer.borderWidth = PixelOne;
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}
@end
