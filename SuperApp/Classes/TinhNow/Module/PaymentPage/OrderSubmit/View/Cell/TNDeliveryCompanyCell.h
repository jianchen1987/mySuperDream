//
//  TNDeliveryComponyCell.h
//  SuperApp
//
//  Created by 张杰 on 2023/7/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNDeliveryComponyModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface TNDeliveryCompanyCellModel : NSObject
///可用的支付方式
@property (nonatomic, strong) NSArray<TNDeliveryComponyModel *> *dataSource;
@end


@interface TNDeliveryCompanyCell : SATableViewCell
@property (nonatomic, strong) TNDeliveryCompanyCellModel *model;
/// 选择了item回调
@property (nonatomic, copy) void (^selectedItemHandler)(TNDeliveryComponyModel *model);
@end

NS_ASSUME_NONNULL_END
