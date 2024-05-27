//
//  PNRecentBillListItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNRecentBillListItemModel : PNModel
/// 供应商名称
@property (nonatomic, strong) NSString *supplierName;
/// 供应商code
@property (nonatomic, strong) NSString *supplierCode;
/// 账单编码
@property (nonatomic, strong) NSString *billNo;
/// 账单编号
@property (nonatomic, strong) NSString *billCode;
/// 客户编号
@property (nonatomic, strong) NSString *customerCode;
/// 缴费类别
@property (nonatomic, assign) PNPaymentCategory paymentCategory;
/// 创建时间
@property (nonatomic, strong) NSString *createTime;
/// 付款至
@property (nonatomic, strong) NSString *payTo;
/// 账单供应商--API凭证枚举值
@property (nonatomic, strong) NSString *apiCredential;
/// icon
@property (nonatomic, strong) NSString *paymentCategoryIcon;
@end

NS_ASSUME_NONNULL_END
