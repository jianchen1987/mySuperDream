//
//  PNMSWithdranBankListItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMSWithdranBankInfoModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSWithdranBankListItemCell : PNTableViewCell
@property (nonatomic, strong) PNMSWithdranBankInfoModel *model;
@end

NS_ASSUME_NONNULL_END
