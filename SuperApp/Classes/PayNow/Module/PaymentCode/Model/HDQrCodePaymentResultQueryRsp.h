//
//  HDQrCodePaymentResultQueryRsp.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPaymentCodeCouponModel.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 查询付款码支付结果 */
@interface HDQrCodePaymentResultQueryRsp : SAModel
@property (nonatomic, assign) PNCollectionWayType collectionWay;             ///< 收款方式(10-扫码,11-收款码,12-钱包,13-APP支付,14-支付宝扫码支付,15-微信扫码支付)
@property (nonatomic, copy) NSString *date;                                  ///< 交易完成时间
@property (nonatomic, copy) NSString *merName;                               ///< 商户名称
@property (nonatomic, copy) NSString *operaName;                             ///< 收银员名称
@property (nonatomic, strong) SAMoneyModel *orderAmt;                        ///< 订单金额
@property (nonatomic, copy) NSString *orderNo;                               ///< 业务订单号
@property (nonatomic, copy) NSString *payerMp;                               ///< 付款人手机号
@property (nonatomic, strong) SAMoneyModel *payAmt;                          ///< 支付金额
@property (nonatomic, copy) NSString *outerBizNo;                            ///< 外部单号(小白盒)
@property (nonatomic, copy) NSString *payTypeStr;                            ///< 支付方式 VIPAY ALIPAY WXPAY
@property (nonatomic, assign) PNQrCodePaymentType payType;                   ///< 支付方式 VIPAY ALIPAY WXPAY
@property (nonatomic, assign) PNOrderStatus status;                          ///< 交易状态(11/支付处理中、12/支付成功、13/支付失败)
@property (nonatomic, copy) NSString *storeName;                             ///< 门店名
@property (nonatomic, copy) NSString *tradeNo;                               ///< 交易订单号
@property (nonatomic, copy) NSString *merchantNo;                            ///< 商户号
@property (nonatomic, assign) PNTransType tradeType;                         ///< 交易类型
@property (nonatomic, copy) NSArray<HDPaymentCodeCouponModel *> *couponList; ///< 优惠列表
@property (nonatomic, strong) SAMoneyModel *userFeeAmt;                      ///< 用户手续费
@end

NS_ASSUME_NONNULL_END
