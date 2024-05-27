//
//  PNMSStoreOperatorRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorInfoModel.h"
#import "PNPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreOperatorRspModel : PNPagingRspModel
@property (nonatomic, strong) NSArray<PNMSStoreOperatorInfoModel *> *list;
@end

NS_ASSUME_NONNULL_END
