//
//  SAChoosePaymentMethodPresenter.h
//  SuperApp
//
//  Created by seeu on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDPaymentMethodType.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SAMoneyModel;
@class SAGoodsModel;


@interface SAChoosePaymentMethodPresenter : NSObject

/// 查询可用的支付营销公告
/// @param merchantNo 商户号
/// @param storeNo 门店号
/// @param businessLine 业务线
/// @param goods 商品数据
/// @param payableAmount 应付金额
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)queryAvailablePaymentActivityAnnouncementWithMerchantNo:(NSString *_Nonnull)merchantNo
                                                        storeNo:(NSString *_Nonnull)storeNo
                                                   businessLine:(SAClientType)businessLine
                                                          goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                                  payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                                        success:(void (^)(NSArray<NSString *> *_Nonnull activitys))successBlock
                                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 试算，外卖在有预选页面，需要做个试算
/// @param payableAmount 应付金额
/// @param businessLine 业务线
/// @param supportedPaymentMethods 支持的支付方式
/// @param merchantNo 商户号
/// @param storeNo 门店号
/// @param goods 商品列表
/// @param selectedMethod 当前选中的支付方式
/// @param completion 完成回调
+ (void)trialWithPayableAmount:(SAMoneyModel *)payableAmount
                  businessLine:(SAClientType)businessLine
       supportedPaymentMethods:(NSArray<HDSupportedPaymentMethod> *)supportedPaymentMethods
                    merchantNo:(NSString *)merchantNo
                       storeNo:(NSString *)storeNo
                         goods:(NSArray<SAGoodsModel *> *)goods
         selectedPaymentMethod:(HDPaymentMethodType *)selectedMethod
                    completion:(void (^)(BOOL available, NSString *ruleNo, SAMoneyModel *_Nullable discountAmount))completion;

+ (void)showPreChoosePaymentMethodViewWithPayableAmount:(SAMoneyModel *)payableAmount
                                           businessLine:(SAClientType)businessLine
                                supportedPaymentMethods:(NSArray<HDSupportedPaymentMethod> *)supportedPaymentMethods
                                             merchantNo:(NSString *)merchantNo
                                                storeNo:(NSString *)storeNo
                                                  goods:(NSArray<SAGoodsModel *> *)goods
                                  selectedPaymentMethod:(HDPaymentMethodType *)selectedMethod
                             choosedPaymentMethodHander:(void (^)(HDPaymentMethodType *paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount))handler;

@end

NS_ASSUME_NONNULL_END
