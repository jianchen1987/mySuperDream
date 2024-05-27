//
//  PNInterTransferRecordCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransRecordModel.h"
#import "PNTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferRecordCell : PNTableViewCell
///
@property (strong, nonatomic) PNInterTransRecordModel *model;
@end

NS_ASSUME_NONNULL_END
