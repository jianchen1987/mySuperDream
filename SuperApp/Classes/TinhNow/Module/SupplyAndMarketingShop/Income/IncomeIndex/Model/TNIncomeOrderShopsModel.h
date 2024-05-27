//
//  TNIncomeOrderShopsModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeOrderShopsModel : TNModel
@property (nonatomic, copy) NSString *shopName;             ///<  商品名称
@property (nonatomic, copy) NSArray<NSString *> *shopSpecs; ///< 商品规格
@property (nonatomic, copy) NSString *shopQuantity;         ///< 商品数量
@end

NS_ASSUME_NONNULL_END
