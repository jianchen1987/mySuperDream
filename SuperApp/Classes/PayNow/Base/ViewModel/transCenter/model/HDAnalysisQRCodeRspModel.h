//
//  HDAnalysisQRCodeRspModel.h
//  ViPay
//
//  Created by seeu on 2019/7/19.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDBaseCodingObject.h"
#import "PNEnum.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDAnalysisQRCodeRspModel : HDBaseCodingObject

@property (nonatomic, copy) NSString *payeeHeadUrl;   ///< 收款方头像
@property (nonatomic, copy) NSString *payeeName;      ///< 收款方名称
@property (nonatomic, copy) NSString *payeeNo;        ///< 收款方账号
@property (nonatomic, copy) NSString *storeNo;        ///< 门店编号
@property (nonatomic, copy) NSString *tradeNo;        ///< 订单号
@property (nonatomic, assign) PNTransType tradeType;  ///< 交易类型
@property (nonatomic, strong) SAMoneyModel *orderAmt; ///< 订单金额
@property (nonatomic, copy) NSString *qrCodeStr;      ///< 二维码

@end

NS_ASSUME_NONNULL_END
