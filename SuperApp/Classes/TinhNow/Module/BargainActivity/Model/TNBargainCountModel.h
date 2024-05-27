//
//  TNBargainCountModel.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainCountModel : TNModel
/// 总助力人数
@property (nonatomic, assign) NSInteger allBargainedCount;
/// 未助力人数
@property (nonatomic, assign) NSInteger notBargainedCount;
/// 已助力人数
@property (nonatomic, assign) NSInteger hasBargainedCount;
/// 最低优惠价
@property (strong, nonatomic) SAMoneyModel *lowestMoney;
@end

NS_ASSUME_NONNULL_END
