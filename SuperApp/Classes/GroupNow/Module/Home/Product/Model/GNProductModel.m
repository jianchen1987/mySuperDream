//
//  GNProductModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNProductModel.h"
#import "GNTheme.h"
#import "NSString+HD_Size.h"


@implementation GNProductModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"codeId": @"code", @"newsImagePath": @"newImagePath"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"type": GNMessageCode.class, @"productStatus": GNMessageCode.class};
}

- (CGFloat)itemHeight {
    CGFloat height = kRealWidth(122);
    CGFloat imageW = (kScreenWidth - kRealWidth(40)) / 2.0;
    height += imageW;
    CGFloat maxH = [@"1\n2" boundingAllRectWithSize:CGSizeMake(imageW - kRealWidth(20), CGFLOAT_MAX) font:[HDAppTheme.font gn_boldForSize:14]].height;
    CGFloat textH = [self.name.desc boundingAllRectWithSize:CGSizeMake(imageW - kRealWidth(20), CGFLOAT_MAX) font:[HDAppTheme.font gn_boldForSize:14]].height;
    textH = MIN(maxH, textH);
    height += textH;
    return height;
}

- (NSArray<NSString *> *)imagePathArr {
    if (!_imagePathArr) {
        if ([self.newsImagePath isKindOfClass:NSString.class] && self.newsImagePath.length) {
            if ([self.newsImagePath containsString:@","]) {
                _imagePathArr = [self.newsImagePath componentsSeparatedByString:@","];
            } else {
                _imagePathArr = @[self.newsImagePath];
            }
        } else {
            if ([self.newsImagePath isKindOfClass:NSString.class]) {
                _imagePathArr = @[self.newsImagePath];
            }
        }
        if ([self.type.codeId isEqualToString:GNProductTypeP2]) {
            _imagePathArr = @[@"gn_product_icon_coupon"];
        }
        if (!_imagePathArr) {
            _imagePathArr = @[];
        }
    }
    return _imagePathArr;
}

@end
