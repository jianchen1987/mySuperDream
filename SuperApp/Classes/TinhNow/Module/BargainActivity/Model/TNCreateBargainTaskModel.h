//
//  TNCreateBargainTaskModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNCreateBargainTaskModel : TNModel
/// 活动ID
@property (nonatomic, copy) NSString *activityId;
/// skuID
@property (nonatomic, copy) NSString *skuId;
/// addressId
@property (nonatomic, copy) NSString *addressId;
/// 操作人id
@property (nonatomic, copy) NSString *operatorNo;
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
///// 收货地区 收货大区，以后用来计算运费
@property (nonatomic, copy) NSString *addressArea;

@end

NS_ASSUME_NONNULL_END
