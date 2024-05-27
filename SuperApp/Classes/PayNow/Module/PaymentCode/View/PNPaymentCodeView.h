//
//  PNPaymentCodeView.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOpenPaymentRspModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ScanBlock)(void);        //点击 扫码回调
typedef void (^ReceiveCodeBlock)(void); //点击 收款码 回调


@interface PNPaymentCodeView : PNView

@property (nonatomic, copy) ScanBlock scanBlock;
@property (nonatomic, copy) ReceiveCodeBlock receiveCodeBlock;

@property (nonatomic, strong) PNOpenPaymentRspModel *model;

- (void)stopTimer;
@end

NS_ASSUME_NONNULL_END
