//
//  PNWalletBalanceCell.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/2.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"

@class PNWalletAcountModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletBalanceCell : PNCollectionViewCell
@property (nonatomic, strong) PNWalletAcountModel *model;
@end

NS_ASSUME_NONNULL_END
