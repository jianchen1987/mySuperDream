//
//  PNApartmentListRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNApartmentListItemModel : PNModel
@property (nonatomic, copy) NSString *paymentId;
/// 商户名称
@property (nonatomic, copy) NSString *merchantName;
/// 缴费单号
@property (nonatomic, copy) NSString *paymentSlipNo;
/// 用户全名
@property (nonatomic, copy) NSString *fullName;
/// coolcash账号（登录的loginName）
@property (nonatomic, copy) NSString *coolcashAccount;
/// 缴费项目（房租）
@property (nonatomic, copy) NSString *paymentItems;
/// 房间号
@property (nonatomic, copy) NSString *roomNo;
/// 缴费金额
@property (nonatomic, strong) SAMoneyModel *paymentAmount;
/// 币种(KHR/USD)
@property (nonatomic, strong) PNCurrencyType currency;
/// 付款方式(10--->线下付款;11--->在线支付)
@property (nonatomic, assign) NSInteger payType;
/// 缴费状态
@property (nonatomic, assign) PNApartmentPaymentStatus paymentStatus;
/// 结算状态：10-->待结算；11-->结算中；12-->已结算
@property (nonatomic, assign) NSInteger settlementStatus;
/// 缴费完成时间
@property (nonatomic, copy) NSString *paymentFinishTime;
/// 结算完成时间
@property (nonatomic, copy) NSString *settlementFinishTime;
/// 账单备注
@property (nonatomic, copy) NSString *remark;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;

/// 凭证地址
@property (nonatomic, strong) NSArray *voucherImgUrl;
/// 凭证备注
@property (nonatomic, copy) NSString *voucherRemark;


/// 操作
@property (nonatomic, assign) BOOL isSelected;

@end


@interface PNApartmentListRspModel : HDCommonPagingRspModel
@property (nonatomic, strong) NSArray<PNApartmentListItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
