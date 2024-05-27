//
//  TNOrderListCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNOrderListRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListSingleProductCellModel : NSObject
///
@property (strong, nonatomic) TNOrderModel *orderModel;
@end


@interface TNOrderListSingleProductCell : SATableViewCell
/// 单个商品模型
@property (strong, nonatomic) TNOrderProductItemModel *model;
/// 退款状态文本展示  退款是整个订单的状态  产品要求再每个商品展示
@property (nonatomic, copy) NSString *refundStatusDes;
@end

NS_ASSUME_NONNULL_END
