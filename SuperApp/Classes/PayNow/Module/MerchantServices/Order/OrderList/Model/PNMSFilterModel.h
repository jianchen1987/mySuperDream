//
//  PNMSFilterModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSFilterModel : PNModel

@property (nonatomic, assign) PNTransType transType;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) PNOrderStatus transferStatus;
@property (nonatomic, copy) NSString *storeNo;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *operatorValue;
@end

NS_ASSUME_NONNULL_END
