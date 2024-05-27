//
//  TNExpressDetailsModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"

//物流跟踪信息
//按时间倒序
@interface TNExpressEventInfoModel : TNModel
/// 订单来源
@property (nonatomic, copy) NSString *orderSource;
/// 外部订单号
@property (nonatomic, copy) NSString *outOrderCode;
///事件编码： 25 Pickup_Finished   30 Inbound   38 Outbound   40 Departure
@property (nonatomic, copy) NSString *eventCode;
/// 事件时间
@property (nonatomic, copy) NSString *eventTime;
/// 事件地址
@property (nonatomic, copy) NSString *eventAddress;
/// 事件描述
@property (nonatomic, copy) NSString *eventDesc;
/// 签收人
@property (nonatomic, copy) NSString *consignee;
/// 物流单状态
@property (nonatomic, copy) NSString *status;
@end


@interface TNExpressDetailsModel : TNModel
/// sn 对应快递单的outOrderCode
@property (nonatomic, copy) NSString *sn;
/// 配送方式
@property (nonatomic, copy) NSString *shippingMethod;
/// 物流公司
@property (nonatomic, copy) NSString *deliveryCorp;
/// 物流公司网址
@property (nonatomic, copy) NSString *deliveryCorpUrl;
/// 物流公司代码  ce CambodianExpress    外卖骑手 yumnow
@property (nonatomic, copy) TNDeliveryCorpCode deliveryCorpCode;
/// 运单号
@property (nonatomic, copy) NSString *trackingNo;
/// 商户填写的物流费用
@property (nonatomic, strong) SAMoneyModel *freight;
/// 收货人
@property (nonatomic, copy) NSString *consignee;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 邮编
@property (nonatomic, copy) NSString *zipCode;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// 备注
@property (nonatomic, copy) NSString *memo;
/// 平台配送时填写的物流成本($)       请注意不要给商户和用户看到这个字段
@property (nonatomic, strong) SAMoneyModel *cost;
/// 代收手续费($)
@property (nonatomic, strong) SAMoneyModel *serviceCharge;
/// 保价费($)
@property (nonatomic, strong) SAMoneyModel *premium;
///
@property (nonatomic, strong) NSString *createdDate;
/// 物流节点模型
@property (nonatomic, strong) NSArray<TNExpressEventInfoModel *> *events;
/// 物流跟踪状态
@property (nonatomic, copy) NSString *expressTxt;
/// 物流单状态
@property (nonatomic, copy) NSString *status;
/// CE运费
@property (nonatomic, strong) SAMoneyModel *ceFreight;
/// CE实重
@property (nonatomic, copy) NSString *ceActualWeight;
/// CE保险费
@property (nonatomic, strong) SAMoneyModel *ceSafeWorth;
/// CE附加费
@property (nonatomic, strong) SAMoneyModel *ceRemoteCost;
/// CE增值服务
@property (nonatomic, strong) SAMoneyModel *ceVasCost;
/// CE应付总额
@property (nonatomic, strong) SAMoneyModel *ceWorth;
/// CE实重  显示字段
@property (nonatomic, copy) NSString *ceActualWeightUnit;
/// 电话数组
@property (strong, nonatomic) NSArray *telephone;
/// tg联系人数组
@property (strong, nonatomic) NSArray *telegrams;

/// 运费相关
@property (nonatomic, strong) NSArray<NSDictionary *> *pricingItems;

@end


@interface TNExpressDetailsRspModel : TNModel
///
@property (nonatomic, strong) NSArray<TNExpressDetailsModel *> *expressOrder;
@end
