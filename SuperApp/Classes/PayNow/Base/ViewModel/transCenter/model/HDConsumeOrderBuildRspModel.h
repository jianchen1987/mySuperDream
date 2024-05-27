//
//  HDConsumeOrderBuildRspModel.h
//  ViPay
//
//  Created by seeu on 2019/7/19.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAnalysisQRCodeRspModel.h"
#import "HDBaseCodingObject.h"
#import "PNEnum.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDConsumeOrderBuildRspModel : HDBaseCodingObject

@property (nonatomic, copy) NSString *payeeName;      ///< 收款方姓名
@property (nonatomic, copy) NSString *payeeNo;        ///<收款方账号
@property (nonatomic, copy) NSString *storeNo;        ///<分店编号
@property (nonatomic, copy) NSString *tradeNo;        ///<订单号
@property (nonatomic, assign) PNTransType tradeType;  ///<交易类型
@property (nonatomic, strong) SAMoneyModel *orderAmt; ///< 订单金额

+ (instancetype)initWithAnalysisModel:(HDAnalysisQRCodeRspModel *)model;

@end

NS_ASSUME_NONNULL_END
