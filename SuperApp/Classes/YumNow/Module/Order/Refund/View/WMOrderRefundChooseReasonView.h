//
//  WMOrderRefundChooseReasonView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMOrderRefundReasonCellModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderRefundChooseReasonView : SAView <HDCustomViewActionViewProtocol>
/// 选择了 item 回调
@property (nonatomic, copy) void (^selectedItemHandler)(WMOrderRefundReasonCellModel *model);
@end

NS_ASSUME_NONNULL_END
