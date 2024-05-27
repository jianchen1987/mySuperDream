//
//  PNComfrimSubmitAlertView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuarateenBuildOrderPaymentRspModel.h"
#import "PNView.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ComfrimBlock)(void);


@interface PNComfrimSubmitAlertView : HDActionAlertView
///初始化
- (instancetype)initWithBalanceModel:(PNGuarateenBuildOrderPaymentRspModel *)model;

@property (nonatomic, copy) ComfrimBlock comfrimBlock;

@end

NS_ASSUME_NONNULL_END
