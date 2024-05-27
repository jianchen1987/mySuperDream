//
//  TNProductBatchBuyPriceCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNProductBatchPriceInfoModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNProductBatchBuyPriceCellModel : NSObject
/// 阶梯价格部分
@property (strong, nonatomic) TNProductBatchPriceInfoModel *infoModel;
@end


@interface TNProductBatchBuyPriceCell : SATableViewCell
///
@property (strong, nonatomic) TNProductBatchBuyPriceCellModel *model;
@end

NS_ASSUME_NONNULL_END
