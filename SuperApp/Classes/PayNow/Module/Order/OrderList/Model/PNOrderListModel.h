//
//  PNOrderListModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "BizEntityModel.h"
#import "PNEnum.h"
#import "PayHDCouponModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOrderListModel : SAModel

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *currency;      //交易币种 (USD, KHR)
@property (nonatomic, copy) NSString *incomeFlag;    //收益符号
@property (nonatomic, copy) NSString *payeeUsrMp;    // 收款方账号
@property (nonatomic, copy) NSString *payeeUsrName;  // 收款方昵称
@property (nonatomic, copy) NSString *payerUsrName;  //付款方用户名
@property (nonatomic, strong) NSNumber *realAmt;     //实际金额
@property (nonatomic, copy) NSString *realNameEnd;   //收款方实名
@property (nonatomic, copy) NSString *realNameFirst; //付款方实名姓
@property (nonatomic, strong) NSNumber *serviceAmt;  //手续费
@property (nonatomic, assign) PNOrderStatus status;
@property (nonatomic, copy) NSString *title;      //标题
@property (nonatomic, copy) NSString *tmFinished; //交易时间
@property (nonatomic, copy) NSString *tradeNo;    //订单号/退款订单号
@property (nonatomic, assign) PNTransType tradeType;

@property (nonatomic, copy) NSString *merName;            //商户名称
@property (nonatomic, copy) NSString *payerUsrMp;         //付款方手机号
@property (nonatomic, copy) NSString *payerRealNameFirst; //付款方实名姓
@property (nonatomic, copy) NSString *payerRealNameEnd;   //付款方实名
@property (nonatomic, copy) NSString *channelCode;        //充值渠道 (VIPAY, PAYGO, CASHINCARD: 入金卡)
@property (nonatomic, copy) NSString *address;            //充值地点
@property (nonatomic, copy) NSString *payeeAmt;           //汇兑金额
@property (nonatomic, copy) NSString *payeeCy;            //汇兑币种/付款账户
@property (nonatomic, copy) NSString *exchangeRate;       //汇率
@property (nonatomic, copy) NSString *displayStatus;      //订单状态 (11-处理中,12-成功,13-失败,14-取消,15-已退款)
@property (nonatomic, copy) NSString *originTradeType;    //源交易类型 TradeBusiTypeEnum(10:消费,11:转账,12:收款,13:兑换,14:充值,15:退款,16:提现,17红包18酬劳)
@property (nonatomic, copy) NSString *originTradeNo;      //源订单号
@property (nonatomic, copy) NSString *productDesc;

@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSNumber *discount; //折扣金额
@property (nonatomic, strong) NSNumber *orderAmt; //订单金额
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;

@property (nonatomic, strong) NSMutableArray<PayHDCouponModel *> *couponList;

@property (nonatomic, strong) BizEntityModel *bizEntity;

@end

NS_ASSUME_NONNULL_END
