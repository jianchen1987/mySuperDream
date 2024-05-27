//
//  WMStoreReviewGoodsModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewGoodsModel.h"
#import "SAInternationalizationModel.h"


@implementation WMStoreReviewGoodsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"itemName": SAInternationalizationModel.class,
    };
}

- (void)setItemName:(NSString *)itemName {
    _itemName = itemName;

    NSDictionary *itemNameDict = itemName.hd_dictionary;
    if (itemNameDict) {
        self.goodName = [SAInternationalizationModel yy_modelWithJSON:self.itemName];
    }
}

@end
