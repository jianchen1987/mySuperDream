//
//  PNRecentPacketRecordsCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNPacketMessageListItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNRecentPacketRecordsCell : PNTableViewCell
@property (nonatomic, strong) PNPacketMessageListItemModel *model;
@end

NS_ASSUME_NONNULL_END
