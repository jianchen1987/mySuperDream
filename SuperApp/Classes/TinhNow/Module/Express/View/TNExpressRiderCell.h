//
//  TNExpressRiderCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNExpressRiderModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressRiderCell : SATableViewCell
/// 骑手信息
@property (strong, nonatomic) TNExpressRiderModel *riderModel;
/// 运单号
@property (nonatomic, copy) NSString *trackingNo;
@end

NS_ASSUME_NONNULL_END
