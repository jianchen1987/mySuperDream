//
//  TNProductDetailExpressCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNDeliverFlowModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailExpressCell : SATableViewCell
/// 物流流向模型
@property (strong, nonatomic) TNDeliverFlowModel *model;
@end

NS_ASSUME_NONNULL_END
