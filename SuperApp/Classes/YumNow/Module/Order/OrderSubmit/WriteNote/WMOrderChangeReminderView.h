//
//  WMOrderChangeReminderView.h
//  SuperApp
//
//  Created by wmz on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderChangeReminderView : SAView <HDCustomViewActionViewProtocol>
/// 是否显示不在提醒按钮
@property (nonatomic, assign) BOOL isShowDontshowBTN;
/// 应支付
@property (nonatomic, strong) SAMoneyModel *payModel;
/// 选中回调
@property (nonatomic, copy) void (^clickedConfirmBlock)(NSString *inputStr);

@end

NS_ASSUME_NONNULL_END
