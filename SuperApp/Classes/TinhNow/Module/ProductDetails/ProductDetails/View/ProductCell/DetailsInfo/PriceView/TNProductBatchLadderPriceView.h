//
//  TNProductBatchLadderPriceView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchPriceInfoModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductBatchLadderPriceView : TNView
/// 阶梯价格部分
@property (strong, nonatomic) TNProductBatchPriceInfoModel *infoModel;
@end

NS_ASSUME_NONNULL_END
