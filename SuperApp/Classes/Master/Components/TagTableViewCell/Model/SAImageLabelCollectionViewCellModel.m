//
//  SAImageLabelCollectionViewCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAImageLabelCollectionViewCellModel.h"


@implementation SAImageLabelCollectionViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.edgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(10), kRealWidth(5), kRealWidth(10));
        self.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithRed:184 / 255.0 green:184 / 255.0 blue:184 / 255.0 alpha:1.0];
        self.textColor = UIColor.whiteColor;
        self.textFont = HDAppTheme.font.standard3;
        self.iconTextMargin = 6;
    }
    return self;
}
@end
