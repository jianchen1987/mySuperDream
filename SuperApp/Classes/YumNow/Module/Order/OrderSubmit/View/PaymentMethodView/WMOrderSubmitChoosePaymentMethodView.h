//
//  WMOrderSubmitChoosePaymentMethodView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderSubmitPaymentMethodCellModel;


@interface WMOrderSubmitChoosePaymentMethodView : SAView <HDCustomViewActionViewProtocol>

- (void)configureDataSource:(NSArray<WMOrderSubmitPaymentMethodCellModel *> *)dataSource;

/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(WMOrderSubmitPaymentMethodCellModel *model);

/// 当前支付方式
@property (nonatomic, copy) WMOrderAvailablePaymentType currentPaymentType;
@end

NS_ASSUME_NONNULL_END
