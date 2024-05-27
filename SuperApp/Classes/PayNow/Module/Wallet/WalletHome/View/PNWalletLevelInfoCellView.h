//
//  PNWalletLevelInfoViewCellModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNCollectionViewCell.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletLevelInfoViewCellModel : PNModel

@end


@interface PNWalletLevelInfoCellView : PNCollectionViewCell
@property (nonatomic, assign) BOOL refreshFlag;
@end

NS_ASSUME_NONNULL_END
