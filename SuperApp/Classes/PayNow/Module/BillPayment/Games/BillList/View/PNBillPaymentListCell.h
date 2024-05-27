//
//  PNBillPaymentListCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
@class PNBillPaymentItemModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNBillPaymentListCell : PNTableViewCell
///
@property (strong, nonatomic) PNBillPaymentItemModel *model;
@end

NS_ASSUME_NONNULL_END
