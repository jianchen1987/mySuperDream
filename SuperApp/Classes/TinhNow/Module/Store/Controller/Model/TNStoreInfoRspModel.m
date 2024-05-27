//
//  TNStoreInfoRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNStoreInfoRspModel.h"
#import "HDAppTheme+TinhNow.h"
#import "TNActionImageModel.h"
#import <NSString+HD_Size.h>


@implementation TNStoreInfoRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeNo": @"id", @"storeType": @"type", @"adImages": @"storeAdImageRespDTOS", @"name": @"nameLocales"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"adImages": [TNActionImageModel class]};
}
- (CGFloat)storeIntroductionViewHeight {
    CGFloat height = 0;
    //上间距
    height += kRealWidth(15);
    //图片高度
    height += kRealWidth(70);
    //图片下间距
    height += kRealWidth(15);
    //地址高度
    if (HDIsStringNotEmpty(self.address)) {
        height += [self.address boundingAllRectWithSize:CGSizeMake(kScreenWidth - kRealWidth(30) - 25, MAXFLOAT) font:HDAppTheme.TinhNowFont.standard12 lineSpacing:0].height;
    }

    return height;
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    //店铺介绍
    height += self.storeIntroductionViewHeight;

    if (HDIsStringNotEmpty(self.images)) {
        //广告图
        height += kRealWidth(10);
        height += kRealWidth(140);
    }
    //底部间距  有地址或者门头照 才有底部间距
    if (HDIsStringNotEmpty(self.address) || HDIsStringNotEmpty(self.images)) {
        height += kRealWidth(15);
    }

    // section间距
    height += kRealWidth(10);
    if (!HDIsArrayEmpty(self.adImages)) {
        //广告图
        height += kRealWidth(10);
        height += kRealWidth(140);
        height += kRealWidth(10);
    }
    if (self.hasStoreLive) {
        //按钮菜单
        height += kRealWidth(50);
    }
    return height;
}
@end
