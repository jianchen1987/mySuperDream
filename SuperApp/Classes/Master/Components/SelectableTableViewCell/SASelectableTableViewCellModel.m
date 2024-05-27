//
//  SASelectableTableViewCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASelectableTableViewCellModel.h"


@implementation SASelectableTableViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageSize = CGSizeMake(kRealWidth(40), kRealWidth(40));
        self.textColor = HDAppTheme.color.G1;
        self.textFont = HDAppTheme.font.standard2Bold;
        self.subTitleColor = HDAppTheme.color.G3;
        self.subTitleFont = HDAppTheme.font.standard3;
    }
    return self;
}
@end
