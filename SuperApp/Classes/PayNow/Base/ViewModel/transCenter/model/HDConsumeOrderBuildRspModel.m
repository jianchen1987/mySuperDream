//
//  HDConsumeOrderBuildRspModel.m
//  ViPay
//
//  Created by seeu on 2019/7/19.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDConsumeOrderBuildRspModel.h"


@implementation HDConsumeOrderBuildRspModel

+ (instancetype)initWithAnalysisModel:(HDAnalysisQRCodeRspModel *)model {
    HDConsumeOrderBuildRspModel *rspModel = [HDConsumeOrderBuildRspModel new];
    rspModel.payeeName = model.payeeName;
    rspModel.payeeNo = model.payeeNo;
    rspModel.storeNo = model.storeNo;
    rspModel.tradeNo = model.tradeNo;
    rspModel.tradeType = model.tradeType;
    rspModel.orderAmt = model.orderAmt;
    return rspModel;
}

@end

//@property (nonatomic, copy) NSString *payeeName; ///< 收款方姓名
//@property (nonatomic, copy) NSString *payeeNo; ///<收款方账号
//@property (nonatomic, copy) NSString *storeNo; ///<分店编号
//@property (nonatomic, copy) NSString *tradeNo; ///<订单号
//@property (nonatomic, assign) HDTransType tradeType; ///<交易类型
//@property (nonatomic, strong) SAMoneyModel *orderAmt; ///< 订单金额
