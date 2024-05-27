//
//  TNWholesaleHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNWholesalePriceAndBatchNumberModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWholesaleHeaderView : TNView
/// 阶梯价
@property (strong, nonatomic) NSArray<TNWholesalePriceAndBatchNumberModel *> *list;
/// 命中了价格区间
- (void)bingoBatchNumberModel:(TNWholesalePriceAndBatchNumberModel *)model;
/// 重置
- (void)reset;
@end

NS_ASSUME_NONNULL_END
