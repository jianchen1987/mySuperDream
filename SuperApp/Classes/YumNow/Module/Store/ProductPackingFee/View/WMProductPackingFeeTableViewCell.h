//
//  WMProductPackingFeeTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMShoppingCartPayFeeCalProductModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMProductPackingFeeTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMShoppingCartPayFeeCalProductModel *model;
@end

NS_ASSUME_NONNULL_END
