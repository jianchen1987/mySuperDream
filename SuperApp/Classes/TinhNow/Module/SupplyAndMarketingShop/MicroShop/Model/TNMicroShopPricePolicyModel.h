//
//  TNMicroShopPricePolicyModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
//加价类型
typedef NS_ENUM(NSInteger, TNMicroShopPricePolicyType) {
    TNMicroShopPricePolicyTypeNone = -1,   //没有设置过
    TNMicroShopPricePolicyTypePercent = 0, //按比例加
    TNMicroShopPricePolicyTypePrice = 1,   //按固定金额加
    TNMicroShopPricePolicyTypeMixTure = 2, //按比例金额一起
};
NS_ASSUME_NONNULL_BEGIN


@interface TNMicroShopPricePolicyModel : TNModel
///加价类型,0:按比例加;1:按固定金额加价;2:先用比例计算再加上固定金额 以上是批量修改加入传参    3单个商品修改价格
@property (nonatomic, assign) TNMicroShopPricePolicyType operationType;
///固定加价金额，单位：美元，保留两位小数
@property (nonatomic, copy) NSString *additionValue;
///加价比例，单位：%，保留两位小数
@property (nonatomic, copy) NSString *additionPercent;

//深拷贝一份模型
+ (TNMicroShopPricePolicyModel *)copyPricePolicyModelWithOriginalModel:(TNMicroShopPricePolicyModel *)originalModel;
@end

NS_ASSUME_NONNULL_END
