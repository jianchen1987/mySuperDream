//
//  WMAddressCell.m
//  SuperApp
//
//  Created by wmz on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMAddressCell.h"


@implementation WMAddressCell

#pragma mark - setter
- (void)setModel:(SAShoppingAddressModel *)model {
    [super setModel:model];
    self.titleLabel.textColor = HDAppTheme.color.G1;
    self.detailTitleLabel.textColor = HDAppTheme.color.G3;
    self.iconView.image = self.select ? [UIImage imageNamed:@"address_check_selected"] : [UIImage imageNamed:@"address_check_normal"];
    self.iconView.hidden = self.hide;
}
- (void)setSelect:(BOOL)select {
    _select = select;
    self.iconView.image = select ? [UIImage imageNamed:@"address_check_selected"] : [UIImage imageNamed:@"address_check_normal"];
}
@end
