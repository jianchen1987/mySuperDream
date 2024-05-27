//
//  PNMSBillListRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "PNMSBillListGroupModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBillListRspModel : HDCommonPagingRspModel

@property (nonatomic, strong) NSMutableArray<PNMSBillListGroupModel *> *list;

@end

NS_ASSUME_NONNULL_END
