//
//  TNCalcTotalPayFeeTrialRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"
#import "TNModel.h"
#import "TNRspModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;


@interface TNInvalidSkuModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// skuid
@property (nonatomic, copy) NSString *skuId;
/// 提示文案码
@property (nonatomic, copy) NSString *invalidCode;
/// 提示文案
@property (nonatomic, copy) NSString *invalidMsg;
@end


@interface TNInvalidProductModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 无效sku数组
@property (strong, nonatomic) NSArray<TNInvalidSkuModel *> *invalidSkus;
@end

///立即送达模型
@interface TNImmediateDeliveryModel : TNModel
///立即配送显示文案
@property (nonatomic, copy) NSString *immediateDeliveryStr;
///立即配送下拉列表展示文案
@property (nonatomic, copy) NSString *message;
///立即送达额外运费
@property (nonatomic, strong) SAMoneyModel *freight;

///同意立即送达
@property (nonatomic, assign) BOOL agreeImmediateDelivery;
///服务说明
@property (nonatomic, copy) NSString *serviceDesc;
@end


@interface TNCalculateSkuPriceModel : TNModel
/// 新的商品sku价格
@property (nonatomic, strong) SAMoneyModel *skuPrice;
///  skuid
@property (nonatomic, copy) NSString *skuId;
@end

/// 试算时间模型 包含运费
@interface TNCalcTimeModel : TNModel
/// 运费总额   基础运费 + 额外运费
@property (nonatomic, strong) SAMoneyModel *freight;
///
@property (nonatomic, assign) BOOL isSelected;
/// 拼接好的配送时间
@property (copy, nonatomic) NSString *timeStr;
/// 立即配送文案  是自定义字段  有立即送达的数据 赋值产生
@property (copy, nonatomic) NSString *immediateDeliveryStr;
/// 立即配送运费
@property (nonatomic, strong) SAMoneyModel *immediateDeliveryFreight;
/// 是否预约已满
@property (nonatomic, assign) BOOL full;
/// 额外运费
@property (nonatomic, strong) SAMoneyModel *additionalFreight;
/// 预约类型
@property (nonatomic, assign) TNOrderAppointmentType appointmentType;
/// 日期  格式为 日月年
@property (copy, nonatomic) NSString *date;
@end

/// 试算日期模型
@interface TNCalcDateModel : TNModel
/// 日期  格式为 日月年
@property (copy, nonatomic) NSString *date;
/// 显示日期格式  本地处理date字段  去除年份
@property (copy, nonatomic) NSString *showDate;
///
@property (strong, nonatomic) NSArray<TNCalcTimeModel *> *deliveryTimeList;
///
@property (nonatomic, assign) BOOL isSelected;
/// 是否预约已满
@property (nonatomic, assign) BOOL full;
/// 是否是立即送达选项
@property (nonatomic, assign) BOOL isImmediateDeliveryItem;
@end


@interface TNCalcTotalPayFeeTrialRspModel : TNRspModel
/// 优惠券折扣
@property (nonatomic, strong) SAMoneyModel *couponDiscount;
/// 促销折扣
@property (nonatomic, strong) SAMoneyModel *promotionDiscount;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 订单价格
@property (nonatomic, strong) SAMoneyModel *price;
/// 手续费
@property (nonatomic, strong) SAMoneyModel *fee;
/// 运费
@property (nonatomic, strong) SAMoneyModel *freight;
/// 运费优惠
@property (nonatomic, strong) SAMoneyModel *freightDiscount;
/// 应付金额
@property (nonatomic, strong) SAMoneyModel *amountPayable;
/// 税金
@property (nonatomic, strong) SAMoneyModel *tax;
/// 赠送积分
@property (nonatomic, copy) NSString *rewardPoint;
/// 兑换积分
@property (nonatomic, copy) NSString *exchangePoint;
/// 是否需要物流
@property (nonatomic, copy) NSString *isDelivery;
/// 营销活动数据
@property (strong, nonatomic) NSArray *verificationPromotions;
/// 优惠后的商品总金额  商品总金额扣除掉平台优惠活动后的金额- 不包含运费减免优惠- 不包含平台优惠券 用于请求中台的优惠券信息
@property (nonatomic, strong) SAMoneyModel *priceAfterDiscount;
/// 海外购运费
@property (nonatomic, strong) SAMoneyModel *overSeaFreightPrice;
/// 运费文案 显示
@property (nonatomic, strong) SAInternationalizationModel *freightMessageLocales;
/// 标签文本
@property (nonatomic, copy) NSString *storeLabelTxt;
/// 送货时间
@property (copy, nonatomic) NSString *deliveryTime;
/// 尽快配送文案   有值优先显示
@property (copy, nonatomic) NSString *soonDelivery;

/// 送货时间设置数据源
@property (strong, nonatomic) NSArray<TNCalcDateModel *> *deliveryTimeDTOList;
/// 在线支付的订单 根据这个字段判断是否需要审核   不需要审核的直接拉起支付
@property (nonatomic, assign) BOOL needVerify;
/// 订单需要审核的提示语
@property (nonatomic, copy) NSString *verifyMessage;
/// 中国段运费
@property (nonatomic, strong) SAMoneyModel *freightPriceChina;
/// 试算海外购商品 如果价格有变动 会在这个字段返回对应改价的sku  替换原有的商品价格下单
@property (strong, nonatomic) NSArray<TNCalculateSkuPriceModel *> *cartItemDTOS;
/// 基础运费  预约订单弹窗展示使用
@property (strong, nonatomic) SAMoneyModel *basicFreight;
/// 额外运费  预约订单弹窗展示使用
@property (strong, nonatomic) SAMoneyModel *addtionalFreight;
/// 下单优惠显示文案
@property (nonatomic, copy) NSString *freightPromotionTxt;
/// 立即送达数据
@property (strong, nonatomic) TNImmediateDeliveryModel *immediateDeliveryResp;
/// 汇率
@property (nonatomic, copy) NSString *khrExchangeRate;
/// 瑞尔应付金额
@property (nonatomic, copy) NSString *khrAmount;
/// 店铺是否能使用优惠码
@property (nonatomic, assign) BOOL canUsePromotionCode;
/// 优惠码Code
@property (nonatomic, copy) NSString *promotionCode;
/// 优惠码优惠金额
@property (strong, nonatomic) SAMoneyModel *promotionCodeDiscount;
/// 是否限制现金券叠加优惠码
@property (nonatomic, assign) BOOL voucherCouponLimit;
/// 是否限制运费券叠加优惠码
@property (nonatomic, assign) BOOL shippingCouponLimit;
/// 无效商品数组
@property (strong, nonatomic) NSArray<TNInvalidProductModel *> *invalidProducts;
@end


@interface TNCalcPaymentFeeGoodsModel : TNModel
/// 商品id
@property (nonatomic, copy) NSString *goodsId;
/// 商品数量
@property (nonatomic, strong) NSNumber *quantity;
/// sku
@property (nonatomic, copy) NSString *skuId;
/// 分享码
@property (nonatomic, copy) NSString *shareCode;
/// 分销码
@property (nonatomic, copy) NSString *sp;
@end

NS_ASSUME_NONNULL_END
