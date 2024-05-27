//
//  bankListModel.h
//  ViPay
//
//  Created by Quin on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNBankListModel : PNModel
@property (nonatomic, copy) NSString *logo; ///< 图标
@property (nonatomic, copy) NSString *bin;  ///< 标题
@property (nonatomic, copy) NSString *participantCode;
@property (nonatomic, copy) NSString *irohaAccountId;

@end

NS_ASSUME_NONNULL_END
