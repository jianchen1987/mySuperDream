//
//  TNBatchShopCarProductCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNShoppingCarBatchGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBatchShopCarProductCell : SATableViewCell
///
@property (strong, nonatomic) TNShoppingCarBatchGoodsModel *model;
/// 点击了选中按钮
@property (nonatomic, copy) void (^clickedSelectBTNBlock)(void);
/// 点击了删除按钮
@property (nonatomic, copy) void (^clickedDeleteBTNBlock)(void);
@end

NS_ASSUME_NONNULL_END
