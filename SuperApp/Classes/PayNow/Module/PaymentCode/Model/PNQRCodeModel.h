//
//  PNQRCodeModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNQRCodeModel : PNModel

@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *payeeName;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, assign) BOOL isHideSaveBtn; //控制下载收款码显示

///钱包存款限额
@property (nonatomic, strong) SAMoneyModel *usdLimit;
@property (nonatomic, strong) SAMoneyModel *khrLimit;
@end

NS_ASSUME_NONNULL_END
