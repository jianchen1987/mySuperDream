//
//  TNCategoryModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryModel.h"
#import "HDAppTheme+TinhNow.h"
#import <NSString+HD_Size.h>


@implementation TNCategoryModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageWidth = kRealWidth(50);
    }
    return self;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": [TNCategoryModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"menuId": @"id", @"menuName": @"nameLocales"};
}
- (CGFloat)cellWidth {
    return ceil((kScreenWidth - kRealWidth(80) - kRealWidth(45) - kRealWidth(40)) / 3);
}
- (void)setImageWidth:(CGFloat)imageWidth {
    _imageWidth = imageWidth;
    CGFloat height = self.imageWidth;
    height += kRealWidth(10);
    CGFloat titleHeight = [@"1\n2" boundingAllRectWithSize:CGSizeMake(self.imageWidth, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0].height;
    height += titleHeight;
    self.itemHeight = height;
}
- (BOOL)hasSelectedSecondCategory {
    BOOL bingo = NO;
    if (!HDIsArrayEmpty(self.children)) {
        for (TNCategoryModel *model in self.children) {
            if (model.isSelected) {
                bingo = YES;
                break;
            }
        }
    }
    return bingo;
}
@end
