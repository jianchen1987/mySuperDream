//
//  SAOrderModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "TNEnum.h"
#import "WMEnum.h"

NS_ASSUME_NONNULL_BEGIN

//物流状态的模型
@interface SAOrderBusinessModel : SACodingModel
/// 配送状态, 10: 待分配, 20: 待接单, 30: 已接单, 40: 已到店, 50: 配送中, 60: 已送达, 70: 已取消
@property (nonatomic, assign) SADeliveryStatus deliveryStatus;
/**
TNStoreTypeGeneral = @"GENERAL";                                                  ///< 普通店铺
TNStoreTypeSelf = @"SELF";                                                                ///< 商家经营店铺
TNStoreTypePlatfromSelf = @"PLATFORM_SELF";                             ///< 平台直营店铺
TNStoreTypeOverseasShopping = @"OVERSEAS_SHOPPING";       ///< 海外购店铺
 */
@property (nonatomic, copy) TNStoreType storeType;

///业务类型 1 扫码点餐
@property (nonatomic, copy) WMBusinessType businessType;

@end


@interface SAOrderGoodListModel : SACodingModel
/// 门店名
@property (nonatomic, strong) SAInternationalizationModel *goodsName;

@property (nonatomic, copy) NSString *picUrl;

@end


@interface SAOrderModel : SACodingModel
/// 门店名
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 订单编号
@property (nonatomic, copy) NSString *orderNo;
/// 支付订单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 业务状态
/// 1.5 版本修改，后台直接返回字符串，直接展示
@property (nonatomic, copy) NSString *businessOrderState;
/// 图片 URL
@property (nonatomic, copy) NSString *showUrl;
/// 注释
@property (nonatomic, strong) SAInternationalizationModel *remark;
/// 门店id
@property (nonatomic, copy) NSString *storeNo;
///< 评价状态
@property (nonatomic, assign) SAOrderEvaluationStatus commentOrderState;
/// 可进行操作列表
@property (nonatomic, copy) NSArray<SAOrderListOperationEventName> *operationList;
/// 实付金额
@property (nonatomic, copy) SAMoneyModel *actualPayAmount;
/// 下单时间
@property (nonatomic, assign) NSTimeInterval orderTime;
/// 支付类型
@property (nonatomic, assign) SAOrderPaymentType payType;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// logo链接
@property (nonatomic, copy) NSString *storeLogo;
///< 退款状态
@property (nonatomic, assign) SAOrderListAfterSaleState refundOrderState;
/// 待支付过期时间（单位：分）
@property (nonatomic, assign) double expireTime;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 物流相关的数据
@property (strong, nonatomic) SAOrderBusinessModel *businessContent;
/// 业务线订单号
@property (nonatomic, copy) NSString *businessOrderNo;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 外部订单详情页
@property (nonatomic, copy) NSString *orderDetailUrl;
/// 为20时，为外卖自取订单
@property (nonatomic, assign) NSInteger serviceType;
/// 取餐码
@property (nonatomic, copy) NSString *pickupCode;
/// 外卖订单状态
@property (nonatomic, assign) NSInteger businessOrderStateEnum;


#pragma mark - 绑定属性
///< dd/MM/yyyy HH:mm
@property (nonatomic, copy, readonly) NSString *orderTimeStr;
/// 是否第一项
@property (nonatomic, assign) BOOL isFirstCell;
/// 是否最后一项
@property (nonatomic, assign) BOOL isLastCell;
/// 是否隐藏业务线 logo，默认不隐藏
@property (nonatomic, assign) BOOL hideBusinessLogo;
/// 是否为售后，为售后显示icon
@property (nonatomic, assign) BOOL isSale;
/// 商户跳转路径
@property (nonatomic, copy) NSString *merchantUrl;
/// 商户logo
@property (nonatomic, copy) NSString *merchantLogo;
/// 商品明细
@property (nonatomic, strong) NSArray *goodsInfoList;
/// 聚合单终态
@property (nonatomic, assign) SAAggregateOrderFinalState aggregateOrderFinalState;
/// 支付状态
@property (nonatomic, assign) SAAggregateOrderState aggregateOrderState;
/// 商品件数
@property (nonatomic, assign) NSInteger goodsNum;
/// 记录更多按钮当前位置
@property (nonatomic, strong) UIView *associatedTargetView;
/// 记录更多按钮需要展示的选项
@property (nonatomic, strong, nullable) NSArray *associatedTargetOptionArray;


@end

NS_ASSUME_NONNULL_END
