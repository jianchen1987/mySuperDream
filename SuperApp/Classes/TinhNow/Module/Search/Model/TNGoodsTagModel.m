//
//  TNGoodsTagModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNGoodsTagModel.h"
#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation TNGoodsTagModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tagName": @"labelName", @"tagId": @"labelId"};
}
- (void)setTagName:(NSString *)tagName {
    _tagName = tagName;
    if (HDIsStringNotEmpty(tagName)) {
        CGSize size = [tagName boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(20), kRealWidth(25)) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0];
        self.itemSize = CGSizeMake(size.width + 20, kRealWidth(25));
    }
}
@end
