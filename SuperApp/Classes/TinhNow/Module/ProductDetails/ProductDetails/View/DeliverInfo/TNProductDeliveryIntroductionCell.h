//
//  TNProductDeliveryIntroductionCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNDeliverInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDeliveryIntroductionCell : SATableViewCell
/// 配送数据
@property (strong, nonatomic) TNDeliverInfoModel *infoModel;
@end

NS_ASSUME_NONNULL_END
