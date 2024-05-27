//
//  TNMicroShopPricePolicyModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopPricePolicyModel.h"


@implementation TNMicroShopPricePolicyModel
- (instancetype)init {
    if (self = [super init]) {
        self.operationType = TNMicroShopPricePolicyTypeNone; //默认是未设置
    }
    return self;
}
+ (TNMicroShopPricePolicyModel *)copyPricePolicyModelWithOriginalModel:(TNMicroShopPricePolicyModel *)originalModel {
    TNMicroShopPricePolicyModel *model = [[TNMicroShopPricePolicyModel alloc] init];
    model.operationType = originalModel.operationType;
    model.additionValue = originalModel.additionValue;
    model.additionPercent = originalModel.additionPercent;
    return model;
}
@end
