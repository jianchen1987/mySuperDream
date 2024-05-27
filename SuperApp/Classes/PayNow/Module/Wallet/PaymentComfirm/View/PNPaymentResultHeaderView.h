//
//  PNPaymentResultHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentResultRspModel.h"
#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentResultHeaderView : SATableHeaderFooterView

@property (nonatomic, strong) PNPaymentResultRspModel *model;

@end

NS_ASSUME_NONNULL_END
