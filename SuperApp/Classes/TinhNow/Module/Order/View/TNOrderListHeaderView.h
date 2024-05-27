//
//  TNOrderListHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import "TNOrderListRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListHeaderView : SATableHeaderFooterView
@property (strong, nonatomic) TNOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
