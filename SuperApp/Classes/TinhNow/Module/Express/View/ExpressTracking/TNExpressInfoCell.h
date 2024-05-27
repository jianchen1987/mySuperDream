//
//  TNExpressInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressInfoCellModel : TNModel
/// 物流公司名称
@property (nonatomic, copy) NSString *deliveryCorp;
/// 物流单号
@property (nonatomic, copy) NSString *trackingNo;
/// 物流官网
@property (nonatomic, copy) NSString *deliveryCorpUrl;
@end


@interface TNExpressInfoCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNExpressInfoCellModel *model;
@end

NS_ASSUME_NONNULL_END
