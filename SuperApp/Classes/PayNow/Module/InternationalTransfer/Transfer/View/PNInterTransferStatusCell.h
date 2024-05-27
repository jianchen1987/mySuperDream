//
//  PNInterTransferStatusCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferStatusCellModel : PNModel
@property (nonatomic, assign) PNInterTransferOrderStatus status;
@property (nonatomic, copy) NSString *reason;

@end


@interface PNInterTransferStatusCell : PNTableViewCell
///
@property (strong, nonatomic) PNInterTransferStatusCellModel *model;
@end

NS_ASSUME_NONNULL_END
