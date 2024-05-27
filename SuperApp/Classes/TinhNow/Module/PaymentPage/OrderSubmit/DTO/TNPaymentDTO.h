//
//  TNPaymentDTO.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TNCalcTotalPayFeeTrialRspModel;
@class TNGetPaymentMethodsRspModel;
@class TNShoppingCarStoreModel;
@class TNGetShippingMethodsRspModel;
@class SAMoneyModel;
@class TNPaymentMethodModel;
@class TNShippingMethodModel;
@class SAShoppingAddressModel;
@class WMOrderSubmitRspModel;
@class TNSubmitOrderNoticeModel;
@class TNShoppingCarItemModel;
@class TNCheckSumitOrderModel;
@class TNDeliveryComponyModel;


@interface TNPaymentDTO : TNModel

/// 试算
/// @param coupon 优惠码
/// @param shippingMethod 配送方式
/// @param groupBuyingId 团购码
/// @param invoiceId 开票id
/// @param address 地址
/// @param paymentMethod 支付方式
/// @param memo 备注
/// @param storeCar 门店购物车模型
/// @param platformCouponCode 优惠券编码
/// @param platformCouponDiscount 优惠券金额
/// @param deliveryTime 预计配送时间
/// @param appointment 预约类型
/// @param salesType 单买  批量
/// @param promotionCode 优惠码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)calculateTotalPayFeeTrialWithCouponCode:(NSString *_Nullable)coupon
                                 shippingMethod:(TNShippingMethodModel *_Nonnull)shippingMethod
                                  groupBuyingId:(NSString *_Nullable)groupBuyingId
                                      invoiceId:(NSString *_Nullable)invoiceId
                                        address:(SAShoppingAddressModel *_Nonnull)address
                                  paymentMethod:(TNPaymentMethodModel *_Nonnull)paymentMethod
                                           memo:(NSString *)memo
                             platformCouponCode:(NSString *)platformCouponCode
                         platformCouponDiscount:(NSString *)platformCouponDiscount
                          storeShoppingCarModel:(TNShoppingCarStoreModel *_Nonnull)storeCar
                                   deliveryTime:(NSString *)deliveryTime
                                    appointment:(TNOrderAppointmentType)appointment
                                      salesType:(TNSalesType)salesType
                                  promotionCode:(NSString *)promotionCode
                               deliveryCorpCode:(NSString *)deliveryCorpCode
                                        success:(void (^_Nullable)(TNCalcTotalPayFeeTrialRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取支付方式
/// @param successBlock 成功回调
/// @param storeNo 店铺id 店铺自定义支付方式
/// @param failureBlock 失败回调
- (void)getPaymentMethodsWithStoreNo:(NSString *)storeNo
                            latitude:(NSNumber *)latitude
                           longitude:(NSNumber *)longitude
                             Success:(void (^_Nullable)(TNGetPaymentMethodsRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取配送方式
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getShippingMethodsSuccess:(void (^_Nullable)(TNGetShippingMethodsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)orderSubmitWithStoreShoppingCar:(TNShoppingCarStoreModel *_Nonnull)storeShoppingCar
                                payType:(TNPaymentMethodModel *_Nonnull)paymentMethod
                           shippingType:(TNShippingMethodModel *_Nonnull)shippingMethod
                            orderAmount:(SAMoneyModel *_Nonnull)orderAmount
                         discountAmount:(SAMoneyModel *_Nonnull)discountAmount
                          paymentAmount:(SAMoneyModel *_Nonnull)paymentAmount
                             couponCode:(NSString *_Nullable)couponCode
                           addressModel:(SAShoppingAddressModel *_Nonnull)addressModel
                                   memo:(NSString *_Nullable)memo
                     platformCouponCode:(NSString *)platformCouponCode
                 platformCouponDiscount:(NSString *)platformCouponDiscount
                 verificationPromotions:(NSArray *)verificationPromotions
                              riskToken:(NSString *)riskToken
                           deliveryTime:(NSString *)deliveryTime
                            appointment:(TNOrderAppointmentType)appointment // 预约类型
                              salesType:(TNSalesType)salesType
                           randomString:(NSString *)randomString
                      freightPriceChina:(SAMoneyModel *_Nonnull)freightPriceChina // 中国段运费
                          promotionCode:(NSString *)promotionCode                 // 优惠码
                  promotionCodeDiscount:(NSString *)promotionCodeDiscount         // 优惠码折扣
                       deliveryCorpCode:(NSString *)deliveryCorpCode
                                success:(void (^_Nullable)(WMOrderSubmitRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取提交订单页面公告条款相关数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSubmitOrderNoticeDataSuccess:(void (^_Nullable)(TNSubmitOrderNoticeModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 通过提交订单页面生成的随机字符串 请求订单号
/// @param randomStr 随机字符串
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getUnifiedOrderNoByRandomStr:(NSString *)randomStr success:(void (^_Nullable)(NSString *orderNo))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 下单前检查  校验配送地址是否在配送范围内
/// @param latitude 纬度
/// @param longitude 经度
/// @param storeNo 店铺NO
/// @param paymentMethod 支付方式
/// @param scene =1订单详情
/// @param productItems  商品数据
- (void)checkOrderCanSubmitWithLatitude:(NSNumber *)latitude
                              longitude:(NSNumber *)longitude
                                storeNo:(NSString *)storeNo
                          paymentMethod:(TNPaymentMethod)paymentMethod
                                  scene:(NSString *)scene
                           productItems:(NSArray<TNShoppingCarItemModel *> *)productItems
                                success:(void (^_Nullable)(TNCheckSumitOrderModel *model))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;


/// 试算通过店铺ID 和商品id  获取物流公司
/// @param storeNo 店铺ID
/// @param productIds 商品ID数组
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryCalculateFreightStandardCostsByStoreNo:(NSString *)storeNo
                                         productIds:(NSArray *)productIds
                                            success:(void (^_Nullable)(NSArray<TNDeliveryComponyModel *> *_Nonnull))successBlock
                                            failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
