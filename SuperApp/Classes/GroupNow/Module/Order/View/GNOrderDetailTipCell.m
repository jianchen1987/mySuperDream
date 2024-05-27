//
//  GNOrderDetailTipCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderDetailTipCell.h"


@interface GNOrderDetailTipCell ()
@property (nonatomic, strong) HDLabel *label;
@end


@implementation GNOrderDetailTipCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.label];
}

- (void)setGNModel:(GNCellModel *)data {
    self.label.text = data.title;
    self.contentView.backgroundColor = HDAppTheme.color.gn_tipBg;
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(kRealWidth(-12));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];
    [super updateConstraints];
}

- (HDLabel *)label {
    if (!_label) {
        _label = HDLabel.new;
        _label.textColor = HDAppTheme.color.gn_mainColor;
        _label.font = [HDAppTheme.font gn_ForSize:11];
        _label.numberOfLines = 0;
    }
    return _label;
}
@end
