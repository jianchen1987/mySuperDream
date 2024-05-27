//
//  PNPacketRecordRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordListItemModel : PNModel
@property (nonatomic, copy) NSString *packetSn;
@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, copy) NSString *receiverNo;
@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, copy) NSString *amt;
@property (nonatomic, copy) NSString *senderNo;
@property (nonatomic, copy) NSString *createTimel;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, assign) PNPacketReceiveStatus status;
@property (nonatomic, assign) NSInteger tradeStatus;
@property (nonatomic, copy) NSString *sendHeadUrl;
@property (nonatomic, copy) NSString *receiverHeadUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger qty;
@end


@interface PNPacketRecordRspModel : PNModel

@property (nonatomic, strong) NSString *totalAmt;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<PNPacketRecordListItemModel *> *records;

@end

NS_ASSUME_NONNULL_END
