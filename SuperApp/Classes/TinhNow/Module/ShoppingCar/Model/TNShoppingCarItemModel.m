//
//  TNShoppingCarItemModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCarItemModel.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "TNShoppingCarBatchGoodsModel.h"
#import <HDKitCore.h>


@implementation TNShoppingCarItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"quantity": @"purchaseQuantity"};
}
- (CGFloat)cellHeight {
    CGFloat height = kRealWidth(110);
    if (self.goodsState == TNStoreItemStateOffSale) { //商品下架
        CGFloat tipsHeight = [@" " boundingAllRectWithSize:CGSizeMake(300, MAXFLOAT) font:HDAppTheme.font.standard4].height;
        height += tipsHeight + kRealWidth(10);
    } else if (self.goodsState == TNStoreItemStateOnSale) {
        if (self.availableStock.integerValue == 0 || self.quantity.integerValue > self.availableStock.integerValue) {
            CGFloat tipsHeight = [@" " boundingAllRectWithSize:CGSizeMake(300, MAXFLOAT) font:HDAppTheme.font.standard4].height;
            height += tipsHeight + kRealWidth(10);
        }
    }
    return height;
}
- (void)setWeight:(NSNumber *)weight {
    _weight = weight;
    if (!HDIsObjectNil(weight)) {
        double freight = [weight doubleValue];
        if (freight > 0) {
            double roundFreight = freight / 1000;
            if (roundFreight < 0.01) {
                roundFreight = 0.01;
            }
            self.showWight = [NSString stringWithFormat:@"%.2fkg", roundFreight];
        }
    }
}
- (NSString *)trackPrefixName {
    NSString *trackName;
    if ([self.productType isEqualToString:TNGoodsTypeOverseas]) {
        trackName = TNTrackEventPrefixNameOverseas;
    } else if ([self.productType isEqualToString:TNGoodsTypeGeneral]) {
        trackName = TNTrackEventPrefixNameFastConsume;
    } else {
        trackName = TNTrackEventPrefixNameOther;
    }
    return trackName;
}
//-(void)setTempSelected:(BOOL)tempSelected{
//    _tempSelected = tempSelected;
//    if (tempSelected) {
//        //只有没有下架才能设置
//        if (self.goodsState == TNStoreItemStateOnSale) {
//            //批量购买 还得判断购买数量是否 超过起批量
//            if (!HDIsObjectNil(self.goodModel) && self.goodModel.productCatDTO.mixWholeSale) {
//                NSInteger startQuantity = 0;
//                if (self.goodModel.productCatDTO.quoteType == TNProductQuoteTypeNoSpecByNumber || self.goodModel.productCatDTO.quoteType == TNProductQuoteTypeHasSpecByNumber) {
//                    //阶梯价
//                    if (!HDIsArrayEmpty(self.goodModel.productCatDTO.priceRanges)) {
//                        TNPriceRangesModel *first = self.goodModel.productCatDTO.priceRanges.firstObject;
//                        startQuantity = first.startQuantity;
//                    }
//                    if (self.quantity.integerValue > startQuantity) {
//                        self.isSelected = tempSelected;
//                    }
//
//                }else{
//                    self.isSelected = tempSelected;
//                }
//
//            }else{
//                self.isSelected = tempSelected;
//            }
//        }
//    }else{
//        self.isSelected = tempSelected;
//    }
//
//}

@end
