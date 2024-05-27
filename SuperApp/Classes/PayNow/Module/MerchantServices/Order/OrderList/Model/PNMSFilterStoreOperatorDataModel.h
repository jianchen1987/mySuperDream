//
//  PNMSFilterStoreOperatorDataModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorInfoModel.h"
#import "PNMSStoreInfoModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSFilterStoreOperatorDataModel : PNModel

@property (nonatomic, strong) NSArray<PNMSStoreInfoModel *> *storeList;

@property (nonatomic, strong) NSArray<PNMSOperatorInfoModel *> *operList;
@end

NS_ASSUME_NONNULL_END
