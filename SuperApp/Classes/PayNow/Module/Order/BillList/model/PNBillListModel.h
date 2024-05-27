//
//  HDBillListModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/9.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "BizEntityModel.h"
#import "PNEnum.h"
#import "PayHDCouponModel.h"
#import "SAModel.h"


@interface PNBillListModel : SAModel

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *incomeFlag;
@property (nonatomic, copy) NSString *payeeUsrMp;   // 收款方账号
@property (nonatomic, copy) NSString *payeeUsrName; // 收款方昵称
@property (nonatomic, copy) NSString *payerUsrName;
@property (nonatomic, strong) NSNumber *realAmt;
@property (nonatomic, copy) NSString *realNameEnd;
@property (nonatomic, copy) NSString *realNameFirst;
@property (nonatomic, strong) NSNumber *serviceAmt;
@property (nonatomic, assign) PNOrderStatus status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tmFinished;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, assign) PNTransType tradeType;

@property (nonatomic, copy) NSString *merName;
@property (nonatomic, copy) NSString *payerUsrMp;
@property (nonatomic, copy) NSString *payerRealNameFirst;
@property (nonatomic, copy) NSString *payerRealNameEnd;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *payeeAmt;
@property (nonatomic, copy) NSString *payeeCy;
@property (nonatomic, copy) NSString *exchangeRate;
@property (nonatomic, copy) NSString *displayStatus;
@property (nonatomic, copy) NSString *originTradeType;
@property (nonatomic, copy) NSString *originTradeNo;
@property (nonatomic, copy) NSString *productDesc;

@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *orderAmt;
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;

@property (nonatomic, strong) NSMutableArray<PayHDCouponModel *> *couponList;
@property (nonatomic, strong) BizEntityModel *bizEntity;
@end

// couponList =                 (
//);

// address (string, optional): 充值地点 ,
// body (string, optional): 订单备注信息 ,
// channelCode (string, optional): 充值渠道 = ['VIPAY', 'PAYGO', 'CASH_IN_CARD']
// string
// Enum:    "VIPAY", "PAYGO", "CASH_IN_CARD"
//,
// couponList (Array[CouponRespDTO], optional): 优惠列表 ,
// createTime (string, optional): 订单创建时间 ,
// currency (string, optional): 交易币种 ,
// description (string, optional): 商品说明 ,
// discount (integer, optional): 折扣金额 ,
// displayStatus (integer, optional): 订单状态 ,
// exchangeRate (number, optional): 汇率 ,
// incomeFlag (string, optional): 收益符号 ,
// merName (string, optional): 商户名称 ,
// orderAmt (integer, optional): 订单金额 ,
// originTradeNo (string, optional): 源订单号 ,
// originTradeType (integer, optional): 源交易类型 TradeBusiTypeEnum(10:消费,11:转账,12:收款,13:兑换,14:充值,15:退款,16:提现) ,
// payeeAmt (integer, optional): 汇兑金额 ,
// payeeCy (string, optional): 汇兑币种/付款账户 ,
// payeeUsrMp (string, optional): 收款方手机号 ,
// payeeUsrName (string, optional): 收款方用户名 ,
// payerRealNameEnd (string, optional): 付款方实名 ,
// payerRealNameFirst (string, optional): 付款方实名姓 ,
// payerUsrMp (string, optional): 付款方手机号 ,
// payerUsrName (string, optional): 付款方用户名 ,
// realAmt (integer, optional): 实际金额 ,
// realNameEnd (string, optional): 收款方实名 ,
// realNameFirst (string, optional): 收款方实名姓 ,
// serviceAmt (integer, optional): 手续费 ,
// status (integer, optional): 交易状态(11: 处理中, 12: 成功, 13: 失败, 14: 取消, 15: 已退款) ,
// subTradeType (integer, optional): 二级交易类型 SubTradeBusiTypeEnum(10:手机充值,0:默认) ,
// title (string, optional): 标题 ,
// tmFinished (string, optional): 交易时间 ,
// tradeNo (string, optional): 订单号/退款订单号 ,
// tradeType (integer, optional): 交易类型/账单分类
