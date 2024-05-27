//
//  HDCheckStandOrderSubmitParamsRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandOrderSubmitParamsRspModel : SARspModel
/// 凭证号
@property (nonatomic, copy) NSString *voucherNo;
/// 交易订单号
@property (nonatomic, copy) NSString *tradeNo;
/// 外部件订单号
@property (nonatomic, copy) NSString *outBizNo;
/// H5: 支付地址 APP: 支付参数
@property (nonatomic, copy) NSString *payUrl;

@property (nonatomic, copy) NSString *deeplink; ///< aba唤起app链接
///
@property (nonatomic, copy) NSString *tokenStr; ///< 太子银行唤起订单号
///汇旺支付会用到的订单信息
@property (nonatomic, copy) NSString *orderInfoStr;
/// ABA KHQR没有安装aba app的情况下使用
@property (nonatomic, copy) NSString *checkoutQrUrl;
@end


@interface HDCheckStandQRCodePayDetailRspModel : SARspModel
/// qrCode
@property (nonatomic, copy) NSString *qrData;
/// 实付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
/// 店名
@property (nonatomic, copy) NSString *merchantName;
/// 失效分钟
@property (nonatomic, assign) NSInteger timeOut;
/// 支付创建时间
@property (nonatomic, assign) NSTimeInterval createTime;

@end

NS_ASSUME_NONNULL_END
