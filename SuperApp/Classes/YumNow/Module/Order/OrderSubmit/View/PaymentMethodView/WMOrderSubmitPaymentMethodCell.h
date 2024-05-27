//
//  WMOrderSubmitPaymentMethodCell.h
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMOrderSubmitPaymentMethodCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitPaymentMethodCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMOrderSubmitPaymentMethodCellModel *model;
@end

NS_ASSUME_NONNULL_END
