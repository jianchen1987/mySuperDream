//
//  PNInterTransferRecordRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransRecordModel.h"
#import "PNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferRecordRspModel : PNPagingRspModel
///
@property (strong, nonatomic) NSArray<PNInterTransRecordModel *> *list;
@end

NS_ASSUME_NONNULL_END
