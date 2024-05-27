//
//  TNRedZoneActivityModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRedZoneActivityModel.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+HD_Size.h"


@implementation TNRedZoneAdressForActivityModel
- (CGFloat)cellHeight {
    CGFloat height = 10;
    if (self.deliveryValid) {
        NSString *text = HDIsStringNotEmpty(self.address) ? self.address : @"";
        CGFloat nameHeight = [text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(75), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontMedium:12] lineSpacing:0].height;
        height += nameHeight;
        height += kRealWidth(10);
        height += kRealWidth(22);
        height += kRealWidth(7);
    } else {
        NSString *text = HDIsStringNotEmpty(self.address) ? self.address : @"";
        CGFloat nameHeight = [text boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(40), MAXFLOAT) font:[HDAppTheme.TinhNowFont fontMedium:12] lineSpacing:0].height;
        height += nameHeight;
        height += kRealWidth(15);
        height += kRealWidth(14);
        height += kRealWidth(15);
    }
    return height;
}
@end


@implementation TNRedZoneRecommendActivityModel

@end


@implementation TNRedZoneActivityModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"storeSpecialDTOList": [TNRedZoneRecommendActivityModel class],
        @"addressSpecialDTOList": [TNRedZoneAdressForActivityModel class],
    };
}
@end
