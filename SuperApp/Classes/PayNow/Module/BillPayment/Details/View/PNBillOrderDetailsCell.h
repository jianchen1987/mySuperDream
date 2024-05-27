//
//  PNBillOrderDetailsCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class SAInfoViewModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNBillOrderDetailsCell : PNTableViewCell
@property (nonatomic, strong) SAInfoViewModel *model;
@end

NS_ASSUME_NONNULL_END
