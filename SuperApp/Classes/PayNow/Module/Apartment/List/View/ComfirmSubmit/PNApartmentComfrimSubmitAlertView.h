//
//  PNGamePaymentAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentComfirmRspModel.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ComfrimBlock)(void);


@interface PNApartmentComfrimSubmitAlertView : HDActionAlertView

///初始化
- (instancetype)initWithBalanceModel:(PNApartmentComfirmRspModel *)model;

@property (nonatomic, copy) ComfrimBlock comfrimBlock;
@end

NS_ASSUME_NONNULL_END
