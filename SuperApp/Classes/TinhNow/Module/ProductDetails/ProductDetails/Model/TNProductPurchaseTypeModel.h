//
//  TNProductPurchaseTypeModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductPurchaseTypeModel : TNModel
/// 批量购买说明
@property (nonatomic, copy) NSString *batchPrice;
/// 单买说明
@property (nonatomic, copy) NSString *singlePrice;
@end

NS_ASSUME_NONNULL_END
