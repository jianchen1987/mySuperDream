//
//  SAChoosePaymentMethodPresenter.m
//  SuperApp
//
//  Created by seeu on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChoosePaymentMethodPresenter.h"
#import "HDCheckstandDTO.h"
#import "HDOnlinePaymentToolsModel.h"
#import "SAChoosePaymentMethodViewController.h"
#import "SAGoodsModel.h"
#import "SAPaymentToolsActivityModel.h"
#import "SAQueryPaymentAvailableActivityAnnouncementRspModel.h"
#import "SAWalletBalanceModel.h"
#import <HDKitCore/HDKitCOre.h>
#import <HDUIKit/HDCustomViewActionView.h>
#import <HDUIKit/HDTips.h>


@implementation SAChoosePaymentMethodPresenter

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
                    completion:(void (^)(BOOL available, NSString *ruleNo, SAMoneyModel *_Nullable discountAmount))completion {
    // 货到付款or线下转账，没有支付营销，直接返回
    if (selectedMethod.method == SAOrderPaymentTypeTransfer || selectedMethod.method == SAOrderPaymentTypeCashOnDelivery) {
        !completion ?: completion(NO, nil, nil);
        return;
    }

    [HDTips showLoading];
    dispatch_group_t taskGroup = dispatch_group_create();

    __block NSArray<HDOnlinePaymentToolsModel *> *availablePaymentTools = nil;
    __block SAWalletBalanceModel *userBalanceModel = nil;
    __block NSArray<SAPaymentToolsActivityModel *> *paymentToolsActivitys = nil;
    dispatch_group_enter(taskGroup);
    [self queryAvaliableOnlinePaymentToolsWithMerchantNo:merchantNo completion:^(NSArray<HDOnlinePaymentToolsModel *> *_Nullable paymentTools) {
        availablePaymentTools = paymentTools;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self queryUserAccountBalanceCompletion:^(SAWalletBalanceModel *_Nullable model) {
        userBalanceModel = model;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self queryPaymentAvailableActivityWithMerchantNo:merchantNo storeNo:storeNo businessLine:businessLine goods:goods payableAmount:payableAmount
                                           completion:^(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys) {
                                               paymentToolsActivitys = activitys;
                                               dispatch_group_leave(taskGroup);
                                           }];

    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
        [HDTips hideAllTips];

        // 检查当前选择的支付工具是否可用
        NSArray<HDOnlinePaymentToolsModel *> *bingo = [availablePaymentTools hd_filterWithBlock:^BOOL(HDOnlinePaymentToolsModel *_Nonnull item) {
            return [item.vipayCode isEqualToString:selectedMethod.toolCode];
        }];
        // 不可用 返回
        if (HDIsArrayEmpty(bingo)) {
            completion(NO, nil, nil);
            return;
        }

        SAPaymentActivityModel *currentActivity = nil;
        // 检查是否有可用的支付营销
        NSArray<SAPaymentToolsActivityModel *> *bingoo = [paymentToolsActivitys hd_filterWithBlock:^BOOL(SAPaymentToolsActivityModel *_Nonnull item) {
            return [item.vipayCode isEqualToString:selectedMethod.toolCode];
        }];

        // 找出最优的活动
        SAPaymentActivityModel * (^bestActivity)(NSArray<SAPaymentActivityModel *> *) = ^SAPaymentActivityModel *(NSArray<SAPaymentActivityModel *> *activitys) {
            __block SAPaymentActivityModel *best = nil;
            [activitys enumerateObjectsUsingBlock:^(SAPaymentActivityModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.fulfill != HDPaymentActivityStateAvailable) {
                    return;
                }
                if (best) {
                    if (obj.discountAmt.cent.integerValue > best.discountAmt.cent.integerValue) {
                        best = obj;
                    }
                } else {
                    best = obj;
                }
            }];

            return best;
        };
        // 有可用营销
        if (!HDIsArrayEmpty(bingoo)) {
            if (HDIsStringNotEmpty(selectedMethod.ruleNo)) {
                // 检查之前的活动是否生效
                NSArray<SAPaymentActivityModel *> *selectedActivity = [bingoo.firstObject.rule hd_filterWithBlock:^BOOL(SAPaymentActivityModel *_Nonnull item) {
                    return [item.ruleNo isEqualToString:selectedMethod.ruleNo] && item.fulfill == HDPaymentActivityStateAvailable;
                }];
                if (!HDIsArrayEmpty(selectedActivity)) {
                    // 继续用之前的活动
                    currentActivity = selectedActivity.firstObject;
                } else {
                    // 之前的不可用,返回最优
                    currentActivity = bestActivity(bingoo.firstObject.rule);
                }
            } else {
                // 之前没选，默认用最优
                currentActivity = bestActivity(bingoo.firstObject.rule);
            }
        }

        if ([selectedMethod.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
            if (HDIsObjectNil(userBalanceModel)) {
                HDLog(@"试算:钱包对象为空，不可用");
                completion(NO, nil, nil);
            } else if (payableAmount.cent.integerValue - (HDIsObjectNil(currentActivity) ? 0 : currentActivity.discountAmt.cent.integerValue) > userBalanceModel.amountBalance.cent.integerValue) {
                // 余额不足
                HDLog(@"试算:钱包余额不足，不可用. 余额:%@, 营销减免:%@, 应付:%@",
                      userBalanceModel.amountBalance.thousandSeparatorAmount,
                      currentActivity.discountAmt.thousandSeparatorAmount,
                      payableAmount.thousandSeparatorAmount);
                completion(NO, nil, !HDIsObjectNil(currentActivity) ? currentActivity.discountAmt : nil);
            } else {
                // 余额足
                HDLog(@"试算:钱包可用");
                completion(YES, !HDIsObjectNil(currentActivity) ? currentActivity.ruleNo : nil, !HDIsObjectNil(currentActivity) ? currentActivity.discountAmt : nil);
            }
        } else {
            completion(YES, !HDIsObjectNil(currentActivity) ? currentActivity.ruleNo : nil, !HDIsObjectNil(currentActivity) ? currentActivity.discountAmt : nil);
        }
    });
}

+ (void)queryAvailablePaymentActivityAnnouncementWithMerchantNo:(NSString *_Nonnull)merchantNo
                                                        storeNo:(NSString *_Nonnull)storeNo
                                                   businessLine:(SAClientType)businessLine
                                                          goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                                  payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                                        success:(void (^)(NSArray<NSString *> *_Nonnull activitys))successBlock
                                                        failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    HDCheckstandDTO *checkstandDTO = HDCheckstandDTO.new;
    [checkstandDTO queryPaymentAvailableActivityAnnouncementWithMerchantNo:merchantNo storeNo:storeNo businessLine:businessLine goods:goods payableAmount:payableAmount
                                                                   success:^(SAQueryPaymentAvailableActivityAnnouncementRspModel *_Nonnull rspModel) {
                                                                       successBlock(rspModel.bulletinList);
                                                                   }
                                                                   failure:failureBlock];
}

+ (void)showPreChoosePaymentMethodViewWithPayableAmount:(SAMoneyModel *)payableAmount
                                           businessLine:(SAClientType)businessLine
                                supportedPaymentMethods:(NSArray<HDSupportedPaymentMethod> *)supportedPaymentMethods
                                             merchantNo:(NSString *)merchantNo
                                                storeNo:(NSString *)storeNo
                                                  goods:(NSArray<SAGoodsModel *> *)goods
                                  selectedPaymentMethod:(HDPaymentMethodType *)selectedMethod
                             choosedPaymentMethodHander:(void (^)(HDPaymentMethodType *paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount))handler {
    SAChoosePaymentMethodViewController *vc = [[SAChoosePaymentMethodViewController alloc] initWithRouteParameters:@{
        @"merchantNo": merchantNo,
        @"supportedPaymentMethods": supportedPaymentMethods,
        @"payableAmount": payableAmount,
        @"storeNo": storeNo,
        @"businessLine": businessLine,
        @"goods": goods,
        @"selectedPaymentMethod": selectedMethod
    }];
    vc.choosedPaymentMethodHandler = handler;

    [SAWindowManager navigateToViewController:vc];
}

#pragma mark - private methods

/// 查当前用户余额
/// @param completion 完成回调
+ (void)queryUserAccountBalanceCompletion:(void (^_Nullable)(SAWalletBalanceModel *_Nullable model))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/super-payment/sa/wallet/check/statusAndBalance.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SAUser.getUserMobile forKey:@"loginName"];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !completion ?: completion([SAWalletBalanceModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(nil);
    }];
}

/// 查询当前商户可用的支付工具
/// @param merchantNo 商户号
/// @param completion 完成回调
+ (void)queryAvaliableOnlinePaymentToolsWithMerchantNo:(NSString *_Nonnull)merchantNo completion:(void (^_Nullable)(NSArray<HDOnlinePaymentToolsModel *> *_Nullable paymentTools))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/app/payTool/list";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchantNo"] = merchantNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<HDOnlinePaymentToolsModel *> *onlinePaymentTools = [NSArray yy_modelArrayWithClass:HDOnlinePaymentToolsModel.class json:rspModel.data];
        !completion ?: completion(onlinePaymentTools);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(@[]);
    }];
}

+ (void)queryPaymentAvailableActivityWithMerchantNo:(NSString *_Nonnull)merchantNo
                                            storeNo:(NSString *_Nonnull)storeNo
                                       businessLine:(SAClientType)businessLine
                                              goods:(NSArray<SAGoodsModel *> *_Nullable)goods
                                      payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                                         completion:(void (^)(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys))completion {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/marketing/findPaymentChannelAvailableActivity.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchantNo"] = merchantNo;
    params[@"storeNo"] = storeNo;
    params[@"businessLine"] = businessLine;
    params[@"payableAmount"] = @{@"cent": payableAmount.cent, @"currency": payableAmount.cy};
    params[@"goods"] = [goods mapObjectsUsingBlock:^id _Nonnull(SAGoodsModel *_Nonnull obj, NSUInteger idx) {
        return @{@"goodsId": obj.goodsId, @"snapshotId": obj.snapshotId, @"skuId": obj.skuId, @"propertyIds": HDIsArrayEmpty(obj.propertys) ? @[] : obj.propertys, @"quantity": @(obj.quantity)};
    }];
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        NSArray<SAPaymentToolsActivityModel *> *activitys = [NSArray yy_modelArrayWithClass:SAPaymentToolsActivityModel.class json:rspModel.data];
        !completion ?: completion(activitys);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !completion ?: completion(@[]);
    }];
}

@end
