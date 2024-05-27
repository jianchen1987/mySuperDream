//
//  PNInterTransferCreateOrderModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferCreateOrderModel : PNModel
/// 转出国家
@property (nonatomic, copy) NSString *payoutCountry;
/// 报价单id
@property (nonatomic, copy) NSString *quotationId;
/// 收款人信息id
@property (nonatomic, copy) NSString *beneficiaryId;
/// 服务类型 1钱包，2银行   v1.0.0.0默认银行
@property (nonatomic, copy) NSNumber *serverType;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 转账目的id
@property (nonatomic, copy) NSString *purposeRemittanceId;
/// 其它转账目的
@property (nonatomic, copy) NSString *otherPurposeRemittance;
/// 资金来源
@property (nonatomic, copy) NSString *sourceFundId;
/// 其他来源 选取其他时必输项
@property (nonatomic, copy) NSString *otherSourceOfFund;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;
@end

NS_ASSUME_NONNULL_END
