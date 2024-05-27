//
//  PNPacketDetailModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketDetailListItemModel : PNModel
@property (nonatomic, copy) NSString *hearUrl;
@property (nonatomic, copy) NSString *currentAmt;
@property (nonatomic, copy) NSString *createTimel;
@property (nonatomic, copy) NSString *sendName;
@property (nonatomic, copy) NSString *recevierName;
@end


@interface PNPacketDetailModel : PNModel
@property (nonatomic, copy) NSString *hearUrl;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *sendName;
@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *currentAmt;
@property (nonatomic, copy) NSString *packetKey;

@property (nonatomic, assign) PNPacketReceiveStatus status;
@property (nonatomic, assign) PNPacketMessageStatus currentStatus;
@property (nonatomic, assign) NSInteger qty;
@property (nonatomic, copy) NSString *amt;
/// 已领取个数
@property (nonatomic, assign) NSInteger receivedQty;
/// 已领取金额
@property (nonatomic, copy) NSString *receivedAmt;

@property (nonatomic, strong) NSArray<PNPacketDetailListItemModel *> *records;
@end

NS_ASSUME_NONNULL_END
