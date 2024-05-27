//
//  GNTableHeaderFootViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/12/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTableHeaderFootViewModel.h"
#import "GNTheme.h"


@implementation GNTableHeaderFootViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = HDAppTheme.color.G1;
        self.titleFont = HDAppTheme.font.standard3;
        self.edgeInsets = UIEdgeInsetsMake(0, HDAppTheme.value.gn_marginL, 0, HDAppTheme.value.gn_marginL);
        self.titleToImageMarin = kRealWidth(6);
        self.rightTitleToImageMarin = kRealWidth(6);
        self.rightViewAlignment = HDTableHeaderFootViewRightViewAlignmentTitleRightImageLeft;
        self.tagColor = UIColor.whiteColor;
        self.tagFont = [UIFont systemFontOfSize:12];
        self.tagBackgroundColor = UIColor.orangeColor;
        self.tagCornerRadius = 0;
        self.tagTitleEdgeInset = UIEdgeInsetsMake(2, 7, 2, 7);
        self.lineHeight = 0;
    }
    return self;
}
@end
