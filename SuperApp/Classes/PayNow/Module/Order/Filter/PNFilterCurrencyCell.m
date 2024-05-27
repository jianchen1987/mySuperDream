//
//  PNFilterCurrencyCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNFilterCurrencyCell.h"
#import "PNBillFilterModel.h"


@interface PNFilterCurrencyCell ()
@property (nonatomic, strong) SALabel *titleLabel;
@end


@implementation PNFilterCurrencyCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width + kRealWidth(30);
    newFrame.size.height = size.height + kRealWidth(10);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setModel:(PNBillFilterModel *)model {
    _model = model;
    self.titleLabel.text = model.titleName;
    if (self.model.isSelected) {
        self.titleLabel.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.titleLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
    } else {
        self.titleLabel.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        self.titleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
    }
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.backgroundColor = HDAppTheme.PayNowColor.cF6F6F6;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;

        _titleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5)];
        };
    }
    return _titleLabel;
}

@end
