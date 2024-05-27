//
//  TNWholesalePriceAndBatchNumberModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWholesalePriceAndBatchNumberModel : TNModel
/// 价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 展示用
@property (nonatomic, copy) NSString *showPrice;
/// 起批数量
@property (nonatomic, copy) NSString *batchNumber;
/// 是否在区间价格
@property (nonatomic, assign) BOOL isRangePrice;
/// 起始数量
@property (nonatomic, assign) NSInteger startNumber;
/// 区间截止 数量
@property (nonatomic, assign) NSInteger endNumber;

/// 验证是否在起批数量区间
- (BOOL)checkInsideRangeNumber:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
