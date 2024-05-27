//
//  TNCheckSumitOrderModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNCheckRegionModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCheckDuplicteModel : TNModel
/// 10分钟内是否有重复订单标识 true：有重复订单  false：没有重复订单
@property (nonatomic, assign) BOOL result;
@end


@interface TNCheckSumitOrderModel : TNModel
/// 检验经纬度是否可以购买
@property (strong, nonatomic) TNCheckRegionModel *regionStoreRespDTO;
/// 检查是否有重复下单
@property (strong, nonatomic) TNCheckDuplicteModel *createOrderDuplicateCheckRes;
@end

NS_ASSUME_NONNULL_END
