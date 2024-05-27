//
//  PNInterTransferPayerInfoModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN
//转账目的
@interface PNPurposeRemittanceModel : PNModel
/// 转账目的码值
@property (nonatomic, copy) NSString *purposeCode;
/// 转账目的名称
@property (nonatomic, copy) NSString *purposeName;
/// 转账目的ID
@property (nonatomic, copy) NSString *purposeId;
@end

//资金来源
@interface PNSourceFundModel : PNModel
/// 资金来源码值
@property (nonatomic, copy) NSString *sourceCode;
/// 资金来源名称
@property (nonatomic, copy) NSString *sourceName;
/// 资金来源ID
@property (nonatomic, copy) NSString *sourceId;
@end


@interface PNInterTransferPayerInfoModel : PNModel
/// 报价单id
@property (nonatomic, copy) NSString *quotationId;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 转账目的
@property (strong, nonatomic) NSArray<PNPurposeRemittanceModel *> *purposeRemittanceInfoList;
/// 资金来源
@property (strong, nonatomic) NSArray<PNSourceFundModel *> *sourceFundInfoList;

@end

NS_ASSUME_NONNULL_END
