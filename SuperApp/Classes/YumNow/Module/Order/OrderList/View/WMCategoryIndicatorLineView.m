//
//  WMCategoryIndicatorLineView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMCategoryIndicatorLineView.h"
#import <HDKitCore/HDKitCore.h>


@interface WMCategoryIndicatorLineView ()

@property (nonatomic, strong) HDCategoryIndicatorParamsModel *model;

@end


@implementation WMCategoryIndicatorLineView

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == HDCategoryViewAutomaticDimension) {
        NSString *title = self.titles[self.model.selectedIndex];
        CGFloat width = [title boundingAllRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:HDAppTheme.font.standard2].width;
        return width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

#pragma mark - HDCategoryIndicatorProtocol
- (void)hd_refreshState:(HDCategoryIndicatorParamsModel *)model {
    self.model = model;
    [super hd_refreshState:model];
}

- (void)hd_contentScrollViewDidScroll:(HDCategoryIndicatorParamsModel *)model {
    self.model = model;
    [super hd_contentScrollViewDidScroll:model];
}

- (void)hd_selectedCell:(HDCategoryIndicatorParamsModel *)model {
    self.model = model;
    [super hd_selectedCell:model];
}

@end
