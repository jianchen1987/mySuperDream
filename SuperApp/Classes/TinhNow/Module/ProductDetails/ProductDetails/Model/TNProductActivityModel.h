//
//  TNProductActivityModel.h
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductActivityModel : TNModel
/// 商品id，拼团要用到
@property (nonatomic, strong) NSString *goodsId;
/// 商品 id
@property (nonatomic, strong) NSString *productId;
/// 活动id
@property (nonatomic, strong) NSString *activityId;
/// 价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 商品类型 0-砍价,1-拼团
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
