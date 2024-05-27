//
//  PNWalletOrderListCell.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNWalletListRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletOrderListCell : PNTableViewCell
@property (nonatomic, strong) PNWalletListItemModel *model;
@end

NS_ASSUME_NONNULL_END
