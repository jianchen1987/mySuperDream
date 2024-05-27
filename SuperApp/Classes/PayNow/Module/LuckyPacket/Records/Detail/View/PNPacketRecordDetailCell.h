//
//  PNPacketRecordDetailCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketDetailModel.h"
#import "PNTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketRecordDetailCell : PNTableViewCell
@property (nonatomic, strong) PNPacketDetailListItemModel *model;
@end

NS_ASSUME_NONNULL_END
