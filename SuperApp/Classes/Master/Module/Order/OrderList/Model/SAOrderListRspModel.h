//
//  SAOrderListRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SAOrderModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListRspModel : SACommonPagingRspModel
/// 订单列表
@property (nonatomic, copy) NSArray<SAOrderModel *> *list;
@end

NS_ASSUME_NONNULL_END
