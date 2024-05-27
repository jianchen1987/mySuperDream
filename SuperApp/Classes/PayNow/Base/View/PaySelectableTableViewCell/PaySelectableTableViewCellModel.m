//
//  PaySelectableTableViewCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "PaySelectableTableViewCellModel.h"


@implementation PaySelectableTableViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedTextColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        self.selectedTextFont = [HDAppTheme.font boldForSize:15];
        self.checkImage = [UIImage imageNamed:@"paySheet_unchecked"];
        self.selectedCheckImage = [UIImage imageNamed:@"paySheet_checked"];
    }
    return self;
}
@end
