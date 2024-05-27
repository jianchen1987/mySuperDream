//
//  PNWalletOrderDetailHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderDetailModel.h"
#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletOrderDetailHeaderView : SATableHeaderFooterView
@property (nonatomic, strong) PNWalletOrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
