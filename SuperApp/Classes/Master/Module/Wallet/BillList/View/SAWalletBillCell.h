//
//  SAWalletBillCell.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAWalletBillModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SAWalletBillModelDetail *model;
@end

NS_ASSUME_NONNULL_END
