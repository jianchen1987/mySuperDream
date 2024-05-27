//
//  TNContactCustomerServiceModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNTransferItemModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNContactCustomerServiceModel : TNModel
/// Telegram
@property (strong, nonatomic) NSArray<TNTransferItemModel *> *Telegram;
///电话
@property (strong, nonatomic) NSArray<TNTransferItemModel *> *PhoneCall;
///其它
@property (strong, nonatomic) NSArray<TNTransferItemModel *> *Other;
@end

NS_ASSUME_NONNULL_END
