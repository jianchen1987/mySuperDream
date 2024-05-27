//
//  GNOrderTitleSectionView.m
//  SuperApp
//
//  Created by wmz on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderTitleSectionTitleCell.h"


@interface GNOrderTitleSectionTitleCell ()
@property (nonatomic, strong) HDLabel *label;
@end


@implementation GNOrderTitleSectionTitleCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.model.outInsets.left);
        make.right.mas_equalTo(-self.model.outInsets.right);
        make.bottom.mas_equalTo(-self.model.outInsets.bottom);
        make.top.mas_equalTo(self.model.outInsets.top);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)model {
    self.model = model;
    if (UIEdgeInsetsEqualToEdgeInsets(model.outInsets, UIEdgeInsetsZero)) {
        model.outInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(4), kRealWidth(12));
    }
    self.label.text = model.title;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.label.text];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.label.attributedText = mstr;
    [self setNeedsUpdateConstraints];
}

- (HDLabel *)label {
    if (!_label) {
        HDLabel *la = HDLabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_ForSize:16 weight:UIFontWeightHeavy];
        _label = la;
    }
    return _label;
}

@end
