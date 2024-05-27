//
//  TNOrderDetailsGoodsSummarizeTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SATableViewCell.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsGoodsSummarizeTableViewCellModel : TNModel
/// 商品总数
@property (nonatomic, assign) NSUInteger goodsQuantity;
/// 商品总价
@property (nonatomic, strong) SAMoneyModel *totalPrice;
/// 改价原因
@property (nonatomic, copy) NSString *changeReason;
/// 店铺id
@property (nonatomic, strong) NSString *storeNo;
@end


@interface TNOrderDetailsGoodsSummarizeTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) TNOrderDetailsGoodsSummarizeTableViewCellModel *model;

@end

NS_ASSUME_NONNULL_END
