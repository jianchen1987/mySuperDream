//
//  SAWalletTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAWalletItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SAWalletItemModel *model;
@end

NS_ASSUME_NONNULL_END
