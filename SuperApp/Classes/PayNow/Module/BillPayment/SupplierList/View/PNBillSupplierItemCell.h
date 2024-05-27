//
//  PNBillSupplierItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNBillSupplierInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNBillSupplierItemCell : PNTableViewCell
@property (nonatomic, strong) PNBillSupplierInfoModel *model;
@end

NS_ASSUME_NONNULL_END
