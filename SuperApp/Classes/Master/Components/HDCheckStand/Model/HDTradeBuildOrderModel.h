//
//  HDTradeBuildOrderModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDPaymentMethodType.h"
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class SAGoodsModel;


@interface HDTradeBuildOrderModel : SACodingModel
/// 聚合订单号
@property (nonatomic, copy) NSString *orderNo;
///< coolCash 支付订单号，不是中台支付订单号
@property (nonatomic, copy, nullable) NSString *outPayOrderNo;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
///< 支持的支付方式
@property (nonatomic, copy) NSArray<HDSupportedPaymentMethod> *supportedPaymentMethods;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 门店号
@property (nonatomic, copy, nullable) NSString *storeNo;
///< 商品
@property (nonatomic, strong, nullable) NSArray<SAGoodsModel *> *goods;
///< 当前选中的支付方式
@property (nonatomic, strong, nullable) HDPaymentMethodType *selectedPaymentMethod;
///< 关联对象
@property (nonatomic, strong) id associatedObject;
/// 判断是否需要校验正在支付中，默认:NO
@property (nonatomic, assign) BOOL needCheckPaying;
/// 支付类型
@property (nonatomic, assign) SAOrderPaymentType payType;
/// 外卖自取为20的时候用到
@property (nonatomic, assign) NSInteger serviceType;

@end

NS_ASSUME_NONNULL_END
