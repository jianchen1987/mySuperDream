//
//  userBillDetailModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/18.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "BizEntityModel.h"
#import "HDCheckStandEnum.h"
#import "HDJsonRspModel.h"
#import "PNEnum.h"
#import "PayHDCouponModel.h"
#import "SAMoneyModel.h"


@interface HDUserBillDetailRspModel : HDJsonRspModel

@property (nonatomic, copy) NSString *address;                                   ///< 充值地点
@property (nonatomic, copy) NSString *body;                                      ///< 订单备注信息
@property (nonatomic, assign) NSInteger cashDeduction;                           ///< 立减金额
@property (nonatomic, copy) NSString *channelCode;                               ///< 充值渠道 (VIPAY, PAYGO, CASHINCARD: 入金卡)
@property (nonatomic, strong) NSMutableArray<PayHDCouponModel *> *couponListArr; ///< 优惠列表
@property (nonatomic, copy) NSString *createTime;                                ///< 订单创建时间
@property (nonatomic, copy) NSString *currency;                                  ///< 交易币种 (USD, KHR)
@property (nonatomic, copy) NSString *productDesc;                               ///< 商品说明
@property (nonatomic, strong) NSNumber *discount;                                ///< 折扣金额
@property (nonatomic, assign) PNOrderStatus displayStatus;                       ///< 订单状态 (11-处理中,12-成功,13-失败,14-取消,15-已退款)
@property (nonatomic, strong) NSNumber *exchangeRate;                            ///< 汇率
@property (nonatomic, copy) NSString *incomeFlag;                                ///< 收益符号
@property (nonatomic, copy) NSString *merName;                                   ///< 商户名称
@property (nonatomic, strong) NSNumber *orderAmt;                                ///< 订单金额
@property (nonatomic, copy) NSString *originTradeNo;                             ///< 源订单号
@property (nonatomic, assign) PNTransType originTradeType; ///< 源交易类型 TradeBusiTypeEnum(10:消费,11:转账,12:收款,13:兑换,14:充值,15:退款,16:提现,17红包18酬劳)
@property (nonatomic, copy) NSString *payeeAmt;            ///< 汇兑金额
@property (nonatomic, copy) NSString *payeeCy;             ///< 汇兑币种/付款账户
@property (nonatomic, copy) NSString *payeeUsrMp;          ///< 收款方手机号
@property (nonatomic, copy) NSString *payeeUsrName;        ///< 收款方用户名
@property (nonatomic, copy) NSString *payerRealNameEnd;    ///< 付款方实名
@property (nonatomic, copy) NSString *payerRealNameFirst;  ///< 付款方实名姓
@property (nonatomic, copy) NSString *payerUsrMp;          ///< 付款方手机号
@property (nonatomic, copy) NSString *payeeUsrNo;
@property (nonatomic, copy) NSString *payerUsrName;  ///< 付款方用户名
@property (nonatomic, strong) NSNumber *realAmt;     ///< 实际金额
@property (nonatomic, copy) NSString *realNameEnd;   ///< 收款方实名
@property (nonatomic, copy) NSString *realNameFirst; ///< 收款方实名姓
@property (nonatomic, strong) NSNumber *serviceAmt;  ///< 手续费
@property (nonatomic, assign) PNOrderStatus status;  ///< 订单状态 (11-处理中,12-成功,13-失败,14-取消,15-已退款)
@property (nonatomic, copy) NSString *title;         ///< 标题
@property (nonatomic, copy) NSString *tmFinished;    ///< 交易时间
@property (nonatomic, copy) NSString *tradeNo;       ///< 订单号/退款订单号
@property (nonatomic, assign) PNTransType tradeType; ///< 交易类型 TradeBusiTypeEnum(10:消费,11:转账,12:收款,13:兑换,14:充值,15:退款,16:提现,17红包18酬劳)
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;
@property (nonatomic, strong) SAMoneyModel *userFeeAmt; ///< 用户手续费

//
@property (nonatomic, copy) NSString *receiveBankName; //收款银行
@property (nonatomic, copy) NSString *purpose;         //备注
@property (copy, nonatomic) NSString *payeeStoreName;
@property (copy, nonatomic) NSString *payeeStoreLocation;
@property (copy, nonatomic) NSString *transactionHash;

@property (strong, nonatomic) BizEntityModel *bizEntity; //
@property (nonatomic, strong) BizEntityModel *subBizEntity;

@property (nonatomic, strong) SAMoneyModel *orderFeeAmt;    /// 订单手续费
@property (nonatomic, strong) SAMoneyModel *discountFeeAmt; /// 活动减免

@property (nonatomic, copy) NSString *storeNo;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storeOperatorNo;
@property (nonatomic, copy) NSString *storeOperatorName;
/// 当subBizEntity = 23 才会返回下面这三个字段
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *bankName;

/// 提现码
@property (nonatomic, copy) NSString *withdrawCode;
/// 提现码状态
@property (nonatomic, assign) PNWithdrawCodeStatus withdrawStatus;
/// 提现码过期时间
@property (nonatomic, copy) NSString *withdrawOverdueTime;

///场景码
@property (nonatomic, copy) NSString *sceneId;
/// 场景码商户号
@property (nonatomic, copy) NSString *sceneMerNo;
/// 场景码门店名称
@property (nonatomic, copy) NSString *sceneStoreName;
/// 场景码店员名称
@property (nonatomic, copy) NSString *sceneOperaName;

@property (nonatomic, copy) NSString *customerNo;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) SAMoneyModel *usdBalance;
@property (nonatomic, copy) SAMoneyModel *khrBalance;

@end
