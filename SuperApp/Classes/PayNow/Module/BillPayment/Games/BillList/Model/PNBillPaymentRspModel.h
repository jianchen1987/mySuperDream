//
//  PNBillPaymentRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPagingRspModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNBillPaymentItemModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *outPayOrderNo;

@property (nonatomic, copy) NSString *billCode;

@property (nonatomic, strong) SAMoneyModel *totalAmount;

@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, copy) NSString *paymentCategoryIcon;

@property (nonatomic, copy) NSString *supplierName;

@property (nonatomic, assign) NSInteger paymentCategory;

@property (nonatomic, assign) NSInteger payStatus;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger billState;

@property (nonatomic, strong) SAMoneyModel *billAmount;

@property (nonatomic, copy) NSString *payFinished;

@property (nonatomic, copy) NSString *billNo;

@property (nonatomic, copy) NSString *supplierCode;
///订单状态
@property (nonatomic, copy) NSString *businessOrderState;
/// 注释
@property (nonatomic, copy) NSString *remark;

@end


@interface PNBillPaymentRspModel : PNPagingRspModel
@property (nonatomic, strong) NSArray<PNBillPaymentItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
