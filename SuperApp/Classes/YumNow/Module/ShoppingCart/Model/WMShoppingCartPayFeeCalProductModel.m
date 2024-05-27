//
//  WMShoppingCartPayFeeCalProductModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartPayFeeCalProductModel.h"


@implementation WMShoppingCartPayFeeCalProductModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"properties": WMShoppingCartStoreProductProperty.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"status": @"shelfStatus"};
}

- (NSUInteger)count {
    return _count > 0 ? _count : 1;
}

- (SAMoneyModel *)totalPackageFee {
    SAMoneyModel *moneyModel = SAMoneyModel.new;
    moneyModel.cy = self.packageFee.cy;

    long total = self.packageFee.cent.integerValue * ceil(self.count / (self.packageShare * 1.0));
    moneyModel.cent = [NSString stringWithFormat:@"%ld", total];
    return moneyModel;
}
@end
