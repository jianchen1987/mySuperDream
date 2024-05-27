//
//  GNOrderRushBuyModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"
#import "GNEnum.h"
#import "GNMessageCode.h"
#import "GNPromoCodeRspModel.h"
#import "SAInternationalizationModel.h"
#import "WMEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderRushBuyModel : GNCellModel
/// 检测
@property (nonatomic, copy) NSString *checkNo;
///门店编号
@property (nonatomic, copy) NSString *storeNo;
///门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
///商户编号
@property (nonatomic, copy) NSString *merchantNo;
///增值税率
@property (nonatomic, assign) NSInteger theVat;
///佣金比例
@property (nonatomic, assign) NSInteger commissionRate;
///商品类型：常规：GP001，代金券：GP002
@property (nonatomic, strong) GNMessageCode *type;
///商品编号
@property (nonatomic, copy) NSString *codeId;
///商品名称
@property (nonatomic, strong) SAInternationalizationModel *name;
///商品图片路径
@property (nonatomic, copy) NSString *imagePath;
///原价
@property (nonatomic, strong) NSNumber *originalPrice;
///售价
@property (nonatomic, strong) NSNumber *price;
///删除标识符1:否 2:是
@property (nonatomic, assign) NSInteger isRecommended;
///限购数量
@property (nonatomic, assign) int homePurchaseRestrictions;
///有效期
@property (nonatomic, assign) NSInteger termOfValidity;
///商品状态：上架:GS001,下架：GS002
@property (nonatomic, strong) GNMessageCode *productStatus;
/// 是否限购 1限购 2不限购
@property (nonatomic, assign) GNHomePurchaseRestrictionsType whetherHomePurchaseRestrictions;
///支持的支付方式
@property (nonatomic, strong) GNMessageCode *paymentMethod;
///优惠码是否可用
@property (nonatomic, assign) BOOL couponCodeUsage;
///库存
@property (nonatomic, strong) NSString *inventory;
/// '是否退款 1:是, 2:否'
@property (nonatomic, assign) NSInteger whetherRefund;

/// custom
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
///聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;

@property (nonatomic, assign) NSInteger customAmount;
///增值税 原价*增值税率
@property (nonatomic, strong) NSDecimalNumber *vat;
///总价
@property (nonatomic, strong) NSDecimalNumber *allPrice;
///单价*数量
@property (nonatomic, strong) NSDecimalNumber *subPrice;
///原价*数量
@property (nonatomic, strong) NSDecimalNumber *orginAllPrice;
///向上取整
@property (nonatomic, strong) NSDecimalNumberHandler *roundPlain;
///优惠码model
@property (nonatomic, strong, nullable) GNPromoCodeRspModel *promoCodeRspModel;
///选择的支付方式
@property (nonatomic, strong) WMOrderAvailablePaymentType payType;

@end

NS_ASSUME_NONNULL_END
