//
//  PNPacketMessageListRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "PNPacketMessageListItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPacketMessageListRspModel : HDCommonPagingRspModel

@property (nonatomic, strong) NSArray<PNPacketMessageListItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
