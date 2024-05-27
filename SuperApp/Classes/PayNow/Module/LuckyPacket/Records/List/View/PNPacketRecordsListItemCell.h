//
//  PNPacketRecordsListItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordRspModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordsListItemCell : PNTableViewCell
@property (nonatomic, strong) PNPacketRecordListItemModel *model;

@property (nonatomic, copy) NSString *viewType;
@end

NS_ASSUME_NONNULL_END
