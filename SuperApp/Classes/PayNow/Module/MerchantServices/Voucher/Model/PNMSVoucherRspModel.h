//
//  PNMSVoucherRspModel.h
//  SuperApp
//
//  Created by xixi on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherInfoModel.h"
#import "PNPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSVoucherRspModel : PNPagingRspModel

@property (strong, nonatomic) NSArray<PNMSVoucherInfoModel *> *list;

@end

NS_ASSUME_NONNULL_END
