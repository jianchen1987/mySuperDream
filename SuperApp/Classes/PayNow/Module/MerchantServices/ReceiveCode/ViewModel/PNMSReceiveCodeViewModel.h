//
//  PNMSReceiveCodeViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorInfoModel.h"
#import "PNViewModel.h"

@class PNMSReceiveCodeRspModel;

typedef enum : NSInteger {
    PNMSReceiveCodeType_Merchant = 0,      ///< 商户码
    PNMSReceiveCodeType_Store = 1,         ///< 门店码
    PNMSReceiveCodeType_StoreOperator = 2, ///< 门店店员码
} PNMSReceiveCodeType;

NS_ASSUME_NONNULL_BEGIN


@interface PNMSReceiveCodeViewModel : PNViewModel

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) PNMSReceiveCodeRspModel *qrCodeRspModel;

@property (nonatomic, copy) NSString *storeNo;
@property (nonatomic, assign) PNMSReceiveCodeType type;
@property (nonatomic, strong) PNMSStoreOperatorInfoModel *storeOperatorInfoModel;

/// 获取收款码
- (void)genQRCode;
- (void)startTimerToGetQRCode;
- (void)cancelTimer;
@end

NS_ASSUME_NONNULL_END
