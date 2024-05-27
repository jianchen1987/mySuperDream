//
//  WMAdadvertisingModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAdadvertisingModel.h"
#import "SAMultiLanguageManager.h"


@implementation WMAdadvertisingModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nImages": @"newImages"};
}

- (NSString *)showContent {
    if (SAMultiLanguageManager.isCurrentLanguageCN)
        return self.showContentZh;
    if (SAMultiLanguageManager.isCurrentLanguageKH)
        return self.showContentKm;
    return self.showContentEn;
}

- (CGFloat)showContentWidth {
    if (_showContentWidth != 0)
        return _showContentWidth;
    _showContentWidth = [self.showContent boundingAllRectWithSize:CGSizeMake(MAXFLOAT, 16) font:[UIFont systemFontOfSize:11]].width + 1;
    return _showContentWidth;
}

@end
