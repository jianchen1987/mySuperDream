//
//  TNWithdrawBindModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawPayCompanyModel : TNModel
@property (nonatomic, copy) NSString *companyName; ///<  公司名称
@end


@interface TNWithdrawBindModel : TNModel
/// BANK、 THIRD_PARTY_PAYMENT、 CASH
@property (nonatomic, strong) TNPaymentWayCode paymentWay;                                     //支付名称
@property (strong, nonatomic) NSArray<TNWithdrawPayCompanyModel *> *paymentCompanyRespDTOList; ///< 支付公司名称
@end

NS_ASSUME_NONNULL_END
