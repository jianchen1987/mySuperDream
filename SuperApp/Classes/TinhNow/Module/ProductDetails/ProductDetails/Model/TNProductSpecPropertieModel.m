//
//  TNProductSepcPropertieModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductSpecPropertieModel.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNProductSpecPropertieModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"propId": @"id",
        @"propName": @"name",
        @"propValue": @"value"

    };
}
- (void)setPropValue:(NSString *)propValue {
    _propValue = propValue;
    if (HDIsStringEmpty(propValue)) {
        return;
    }
    CGFloat width = [propValue boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(28)) font:[HDAppTheme.TinhNowFont fontSemibold:12.f] lineSpacing:0].width + 20;
    if (width > kScreenWidth - kRealWidth(30)) {
        width = kScreenWidth - kRealWidth(30);
    }
    self.nameWidth = width;

    //计算 规格宽高
    CGSize size = [propValue boundingAllRectWithSize:CGSizeMake(kRealWidth(120), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontMedium:14] lineSpacing:0];
    CGSize maxSize = [@"1 \n 2" boundingAllRectWithSize:CGSizeMake(kRealWidth(120), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontMedium:14] lineSpacing:0];
    CGFloat tempHeight = MIN(size.height, maxSize.height);
    CGFloat tempWidth = MIN(size.width, kRealWidth(120));
    self.nameSize = CGSizeMake(tempWidth, tempHeight);
}
- (void)setSelectedSkuCount:(NSInteger)selectedSkuCount {
    _selectedSkuCount = selectedSkuCount;
    NSString *text = [NSString stringWithFormat:@"x%ld", selectedSkuCount];
    self.selectedSkuCountLableWidth = [text boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(28)) font:[HDAppTheme.TinhNowFont fontSemibold:10.f] lineSpacing:0].width + 10;
}
@end
