//
//  TNOrderListRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAMoneyModel.h"
#import "TNModel.h"
#import "TNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderProductItemModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// skuid
@property (nonatomic, copy) NSString *skuId;
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 商品规格
@property (nonatomic, copy) NSString *specifications;
/// 商品图片
@property (nonatomic, copy) NSString *thumbnail;
/// 商品价格
@property (strong, nonatomic) SAMoneyModel *price;
/// 商品数量
@property (nonatomic, assign) NSInteger quantity;
@end


@interface TNOrderStoreInfo : TNModel
/// 店铺ID
@property (nonatomic, copy) NSString *storeId;
/// 店铺编号  带了TN 前缀
@property (nonatomic, copy) NSString *storeNo;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 店铺logo
@property (nonatomic, copy) NSString *storeLogo;
/// 店铺ID
@property (nonatomic, copy) TNStoreType storeType;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
@end


@interface TNOrderModel : TNModel
/// 订单id
@property (nonatomic, copy) NSString *unifiedOrderNo;
/// 支付单号  电商目前没有这个字段  在查询支付状态的接口去拿
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 订单状态
@property (nonatomic, copy) TNOrderState status;
/// 订单退款状态
@property (nonatomic, assign) TNOrderRefundStatus refundStatus;
/// 退款状态文本
@property (nonatomic, copy) NSString *refundStatusDes;
/// 订单创建时间
@property (nonatomic, assign) long createTime;
/// 订单数量
@property (nonatomic, assign) NSInteger quantity;
/// 订单金额
@property (strong, nonatomic) SAMoneyModel *amount;
/// 订单状态
@property (nonatomic, copy) TNOrderType type;
/// 店铺信息
@property (strong, nonatomic) TNOrderStoreInfo *storeInfo;
/// 可进行操作列表
@property (nonatomic, strong) NSArray<SAOrderListOperationEventName> *operationList;
/// 订单商品信息
@property (strong, nonatomic) NSArray<TNOrderProductItemModel *> *orderItems;
/// 送货时间
@property (nonatomic, copy) NSString *deliveryTime;
/// 状态文本
@property (nonatomic, copy) NSString *statusDes;
/// 在线支付渠道编码
@property (nonatomic, copy) HDCheckStandPaymentTools payChannelCode;

/// 自定义字段  订单列表状态颜色展示
@property (strong, nonatomic) UIColor *statusColor;

@end


@interface TNOrderListRspModel : TNPagingRspModel
/// 订单数组
@property (strong, nonatomic) NSArray<TNOrderModel *> *list;
@end

NS_ASSUME_NONNULL_END
