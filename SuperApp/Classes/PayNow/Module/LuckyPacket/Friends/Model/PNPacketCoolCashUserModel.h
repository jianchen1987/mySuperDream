//
//  PNPacketCoolCashUserModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketCoolCashUserModel : PNModel
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *surname;
@property (nonatomic, assign) BOOL walletOpened;
@property (nonatomic, copy) NSString *businessTypeCode;
@property (nonatomic, copy) NSString *businessTypeStatus;
@property (nonatomic, copy) NSString *headUrl;
@end

NS_ASSUME_NONNULL_END
