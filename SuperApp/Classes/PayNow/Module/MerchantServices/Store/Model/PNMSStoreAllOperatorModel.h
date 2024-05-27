//
//  PNMSStoreAllOperatorModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorInfoModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreAllOperatorModel : PNModel

/// 门店ID
@property (nonatomic, copy) NSString *storeId;
/// 门店编号
@property (nonatomic, copy) NSString *storeNo;
/// 门店名称
@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSArray<PNMSStoreOperatorInfoModel *> *operatorArray;
@end

NS_ASSUME_NONNULL_END
