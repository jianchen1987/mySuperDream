//
//  TNSellerProductModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerProductModel.h"
#import "HDAppTheme+TinhNow.h"
#import "TNDecimalTool.h"


@implementation TNSellerProductModel
- (NSString *)showDisCount {
    NSString *disCount = nil;
    double price = self.price.cent.doubleValue;
    double marketPrice = self.marketPrice.cent.doubleValue;
    if (marketPrice <= 0) {
        return nil; //市场价未设置 也不显示
    }
    if (price > marketPrice) {
        return nil; //高于市场价 不计算折扣
    }
    NSDecimalNumber *disCountValue = [TNDecimalTool decimslDisCountNumber:self.price.cent num2:self.marketPrice.cent];
    if (disCountValue.doubleValue > 0) {
        disCount = [NSString stringWithFormat:@"-%ld%%", disCountValue.integerValue];
    }
    return disCount;
}
- (CGFloat)cellHeight {
    if (self.sale && (self.promotion || self.freightSetting || self.stagePrice)) {
        return kRealWidth(205);
    } else {
        return kRealWidth(175);
    }
}
- (CGFloat)microShopCellHeight {
    return self.microShopContentStackHeight + kRealWidth(80) + kRealWidth(10);
}
- (CGFloat)microShopContentStackHeight {
    CGFloat height = kRealWidth(142);
    // 商品名
    if (HDIsStringNotEmpty(self.productName)) {
        NSString *sizeName = self.productName;
        if ([self.typeName isEqualToString:TNGoodsTypeOverseas] || [self.typeName isEqualToString:@"4"]) {
            sizeName = [TNStoreTagGlobal stringByAppendingString:sizeName];
        }
        CGFloat maxLabelWidth = kScreenWidth - kRealWidth(80) - kRealWidth(100) - kRealWidth(13) - kRealWidth(25);
        CGSize size = [sizeName boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:[HDAppTheme.TinhNowFont fontSemibold:15] lineSpacing:0];
        CGSize towRowsSize = [@"一\n二" boundingAllRectWithSize:CGSizeMake(maxLabelWidth, MAXFLOAT) font:[HDAppTheme.TinhNowFont fontSemibold:15] lineSpacing:0];
        if (self.promotion || self.freightSetting || self.stagePrice) {
            height = size.height < towRowsSize.height ? kRealWidth(120) : kRealWidth(132);
        } else {
            height = kRealWidth(120);
        }
    }
    return height;
}
@end
