//
//  PNPacketMessageListItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketMessageListItemModel : PNModel
@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, copy) NSString *receiverNo;
@property (nonatomic, copy) NSString *receiverTime;
@property (nonatomic, copy) NSString *senderMobile;
@property (nonatomic, copy) NSString *receiverMobile;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderNo;
@property (nonatomic, assign) PNPacketMessageStatus messageStatus;
@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
