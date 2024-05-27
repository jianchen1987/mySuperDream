//
//  SANoDataCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANoDataCellModel.h"
#import <HDKitCore/HDKitCore.h>


@implementation SANoDataCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"no_data_placeholder"];
        self.descText = SALocalizedString(@"no_data", @"暂无数据");
        self.descColor = HDAppTheme.color.G3;
        self.descFont = HDAppTheme.font.standard3;
        self.bottomBtnTitleFont = HDAppTheme.font.standard3;
        self.bottomBtnTitleColor = HDColor(250, 29, 57, 1);
        self.marginImageToTop = kRealWidth(40);
        self.marginDescToImage = kRealWidth(10);
        self.marginBtnToDesc = kRealWidth(5);
        self.btnEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return self;
}

- (CGFloat)cellHeight {
    CGFloat height = 2 * self.marginImageToTop;
    if (self.imageSize.height > 0) {
        height += self.imageSize.height;
    } else {
        height += self.image.size.height;
    }
    CGSize descSize = [self.descText boundingAllRectWithSize:CGSizeMake(kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), CGFLOAT_MAX) font:self.descFont lineSpacing:0];
    height += descSize.height;
    height += self.marginDescToImage;

    if (HDIsStringNotEmpty(self.bottomBtnTitle)) {
        descSize = [self.bottomBtnTitle boundingAllRectWithSize:CGSizeMake(kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), CGFLOAT_MAX) font:self.bottomBtnTitleFont
                                                    lineSpacing:0];
        height += descSize.height;
        height += UIEdgeInsetsGetHorizontalValue(self.btnEdgeInsets);
        height += self.marginBtnToDesc;
    }
    return height;
}
@end
