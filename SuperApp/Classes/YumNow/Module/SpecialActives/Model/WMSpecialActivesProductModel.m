//
//  WMSpecialActivesProductModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesProductModel.h"
#import "HDAppTheme+YumNow.h"
#import "SAInternationalizationModel.h"
#import <HDKitCore/HDKitCore.h>
#import "SAAppTheme.h"


@implementation WMSpecialActivesProductModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(10), kRealWidth(10), kRealWidth(10));
    }
    return self;
}

- (void)hd_configCellHeight {
    CGFloat maxLabelWidth = self.preferredWidth - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);

    CGFloat height = 0;
    //上下间距
    height += UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
    // 图片长宽1：1
    height += self.preferredWidth;
    // 图片到商品名
    height += kRealHeight(8);
    // 商品名
    if (HDIsStringNotEmpty(self.name.desc)) {
        CGSize size = [self.name.desc boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:[HDAppTheme.WMFont wm_boldForSize:14] lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:[HDAppTheme.WMFont wm_boldForSize:14] lineSpacing:0];

        height += size.height < towRowsSize.height ? size.height : towRowsSize.height;
    }
    // 商品名到销量
    height += kRealHeight(5);
    CGSize soldSize = [@"一" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.font.standard4 lineSpacing:0];
    height += soldSize.height;

    // 销量到价格
    height += kRealHeight(8);
    CGSize priceSize = [@"$10" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.font.standard2Bold];
    height += priceSize.height;

    // 价格到logo
    height += kRealHeight(10);
    // logo 高度
    height += kRealHeight(30);

    _cellHeight = height;
}

- (void)hd_configCellNewHeight {
    CGFloat maxLabelWidth = self.preferredWidth - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);

    CGFloat height = 0;
    //上下间距
    height += UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
    // 图片长宽1：1
    height += self.preferredWidth;
    // 图片到商品名
    height += kRealHeight(8);
    // 商品名
    if (HDIsStringNotEmpty(self.name.desc)) {
        
        NSString *deliveryTime = self.deliveryTime;
        if (self.estimatedDeliveryTime) {
            if (self.estimatedDeliveryTime.integerValue > 60) {
                deliveryTime = @">60";
            } else {
                deliveryTime = self.estimatedDeliveryTime;
            }
        }
        deliveryTime = [NSString stringWithFormat:@"%@min", deliveryTime];

        CGSize size = [deliveryTime boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.font.sa_standard12 lineSpacing:0];
        
        CGFloat nameMaxWidth = maxLabelWidth - (size.width + 12 + 3 +self.contentEdgeInsets.left);
//        HDLog(@"size.width = %f,nameMaxWidth = %f",size.width,nameMaxWidth);
//        HDLog(@"%@,%@",self.name.desc,deliveryTime);
         size = [self.name.desc boundingAllRectWithSize:CGSizeMake(nameMaxWidth, MAXFLOAT) font:HDAppTheme.font.sa_standard14 lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(nameMaxWidth, MAXFLOAT) font:HDAppTheme.font.sa_standard14 lineSpacing:0];

        height += size.height < towRowsSize.height ? size.height : towRowsSize.height;
    }


    // 销量到价格
    height += kRealHeight(8);
    CGSize priceSize = [@"$10" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:HDAppTheme.font.sa_standard14B];
    height += priceSize.height;
    //
    //    // 价格到logo
    //    height += kRealHeight(10);
    //    // logo 高度
    //    height += kRealHeight(30);

    _cellNewHeight = height;
}

- (void)setPreferredWidth:(CGFloat)preferredWidth {
    _preferredWidth = preferredWidth;
    [self hd_configCellHeight];
    [self hd_configCellNewHeight];
}

#pragma mark - getter
- (SAMoneyModel *)showPrice {
    return self.discountPrice;
}

- (SAMoneyModel *)linePrice {
    if (self.salePrice.cent.integerValue == self.discountPrice.cent.integerValue) {
        return nil;
    }
    return self.salePrice;
}

@end
