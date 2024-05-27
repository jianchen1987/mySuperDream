//
//  HDCheckStandChoosePaymentMethodViewModel.m
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandChoosePaymentMethodViewModel.h"
#import "HDCheckstandDTO.h"
#import "HDOnlinePaymentToolsModel.h"
#import "HDPaymentMethodType.h"
#import "HDQueryAnnoncementRspModel.h"
#import "SACacheManager.h"
#import "SAInternationalizationModel.h"
#import "SAQueryPaymentAvailableActivityRspModel.h"
#import "SAWalletDTO.h"
#import "SAInternationalizationModel.h"
#import "SAPaymentDTO.h"


@interface HDCheckStandChoosePaymentMethodViewModel ()

///< walletDTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;
///< checkstand
@property (nonatomic, strong) HDCheckstandDTO *standDTO;

///< 公告
@property (nonatomic, copy) NSString *paymentAnnoncement;
///< 可用的支付方式
@property (nonatomic, strong) NSArray<HDCheckStandPaymentMethodCellModel *> *availablePaymentMethods;
///< 可用的支付营销活动
@property (nonatomic, strong) NSArray<SAPaymentToolsActivityModel *> *activitys;
/// paymentDTO
@property (nonatomic, strong) SAPaymentDTO *paymentDTO;

@end


@implementation HDCheckStandChoosePaymentMethodViewModel

/// 收银台初始化数据，查支付公告，查可用的支付方式，查钱包余额，查可用的支付营销
- (void)initialize {
    [self.view showloading];

    dispatch_group_t taskGroup = dispatch_group_create();
    @HDWeakify(self);
    [self queryPaymentAnnouncementCompletion:^(NSString *announcement) {
        @HDStrongify(self);
        self.paymentAnnoncement = announcement;
    }];

    dispatch_group_enter(taskGroup);
    [self queryUserWalletBalanceCompletion:^(SAWalletBalanceModel *_Nullable walletModel) {
        @HDStrongify(self);
        self.userWallet = walletModel;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self queryAvailablePaymentActivitysCompletion:^(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys) {
        @HDStrongify(self);
        self.activitys = activitys;
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_notify(taskGroup, dispatch_get_global_queue(0, 0), ^{
        @HDStrongify(self);
        @HDWeakify(self);
        [self queryAvaliableOnlinePaymentToolsCompletion:^(NSArray<HDPaymentMethodType *> *_Nullable paymentTools) {
            @HDStrongify(self);
            [self.view dismissLoading];
            // 转换模型
            NSArray<HDCheckStandPaymentMethodCellModel *> *tmp = [paymentTools mapObjectsUsingBlock:^id _Nonnull(HDPaymentMethodType *_Nonnull obj, NSUInteger idx) {
                HDCheckStandPaymentMethodCellModel *cellModel = nil;

                if (obj.method == SAOrderPaymentTypeOnline) {
                    // 在线支付才有活动
                    // 找到之前选过的，或者最优的活动
                    __block SAPaymentActivityModel *bingoRule = nil;
                    SAPaymentToolsActivityModel *paymentToolsActivity = nil;
                    if (!HDIsArrayEmpty(self.activitys)) {
                        // 找到当前支付工具的活动
                        paymentToolsActivity = [self.activitys hd_filterWithBlock:^BOOL(SAPaymentToolsActivityModel *_Nonnull item) {
                                                   return [item.vipayCode isEqualToString:obj.toolCode];
                                               }].firstObject;
                        // 当前有活动
                        if (paymentToolsActivity && !HDIsArrayEmpty(paymentToolsActivity.rule)) {
                            if (self.isPre) {
                                HDLog(@"支付工具:%@ 存在营销活动数:%zd", obj.toolName, paymentToolsActivity.rule.count);
                            }
                            // 如果有选择支付方式和营销
                            if (self.lastChoosedMethod && HDIsStringNotEmpty(self.lastChoosedMethod.ruleNo)) {
                                // 筛选
                                bingoRule = [paymentToolsActivity.rule hd_filterWithBlock:^BOOL(SAPaymentActivityModel *_Nonnull activityRule) {
                                                return (activityRule.fulfill == HDPaymentActivityStateAvailable) && [activityRule.ruleNo isEqualToString:self.lastChoosedMethod.ruleNo];
                                            }].firstObject;

                                // 为空，说明没有匹配到，自动选择最大值
                                if (!bingoRule) {
                                    bingoRule = nil;
                                    [paymentToolsActivity.rule enumerateObjectsUsingBlock:^(SAPaymentActivityModel *_Nonnull activityRule, NSUInteger idx, BOOL *_Nonnull stop) {
                                        if (activityRule.fulfill != HDPaymentActivityStateAvailable) {
                                            return;
                                        }
                                        if (!bingoRule) {
                                            bingoRule = activityRule;
                                        } else if (activityRule.discountAmt.cent.integerValue > bingoRule.discountAmt.cent.integerValue) {
                                            bingoRule = activityRule;
                                        }
                                    }];
                                    if (self.isPre) {
                                        HDLog(@"当前选中的支付工具:%@ 选中的活动无效，默认选择优惠力度最大的活动:%@", obj.toolName, bingoRule.title);
                                    }
                                } else {
                                    if (self.isPre) {
                                        HDLog(@"当前选中的支付工具:%@ 选中的活动有效:%@", obj.toolName, bingoRule.title);
                                    }
                                }
                            } else if (!self.isPre && self.lastChoosedMethod && HDIsStringEmpty(self.lastChoosedMethod.ruleNo)) {
                                // 如果有预选支付方式，但是活动为空，有可能是主动不使用优惠
                                // 这里不再为客户自动选择
                                bingoRule = nil;
                            } else {
                                // 如果没有预选支付方式，自动选择可用的最大活动
                                bingoRule = nil;
                                [paymentToolsActivity.rule enumerateObjectsUsingBlock:^(SAPaymentActivityModel *_Nonnull activityRule, NSUInteger idx, BOOL *_Nonnull stop) {
                                    if (activityRule.fulfill != HDPaymentActivityStateAvailable) {
                                        return;
                                    }
                                    if (!bingoRule) {
                                        bingoRule = activityRule;
                                    } else if (activityRule.discountAmt.cent.integerValue > bingoRule.discountAmt.cent.integerValue) {
                                        bingoRule = activityRule;
                                    }
                                }];

                                if (self.isPre) {
                                    HDLog(@"当前没有预选的支付工具，或者没有预选的活动，默认为当前工具:%@ 选择优惠力度最大的活动:%@", obj.toolName, bingoRule.title);
                                }
                            }
                        }
                    }

                    cellModel = [HDCheckStandPaymentMethodCellModel modelWithPaymentMethodModel:obj balance:self.userWallet
                                                                                      payAmount:HDIsObjectNil(bingoRule) ? self.payableAmount : [self.payableAmount minus:bingoRule.discountAmt]];
                    cellModel.paymentActivitys = paymentToolsActivity;
                    cellModel.currentActivity = bingoRule;

                    if (obj.isShow) {
                        // 上一次支付成功状态
                        HDPaymentMethodType *lastSuccessPaymentMethod = [SACacheManager.shared objectForKey:kCacheKeyCheckStandLastTimeChoosedPaymentMethod type:SACacheTypeDocumentNotPublic];
                        if ([cellModel.toolCode isEqualToString:lastSuccessPaymentMethod.toolCode]) {
                            cellModel.isRecentlyUsed = YES;
                        }
                    }

                    cellModel.marketing = [obj.marketing copy];
                    //没有开通钱包，而且支付配了营销活动，优先使用支付营销的文案
                    if ([cellModel.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
                        if (self.userWallet && !self.userWallet.walletCreated && self.userWallet.marketinginfoList.count) {
                            SAInternationalizationModel *m = self.userWallet.marketinginfoList.firstObject;
                            if (HDIsStringNotEmpty(m.desc)) {
                                cellModel.marketing = @[m.desc];
                            }
                        }
                    }
                } else {
                    cellModel = [HDCheckStandPaymentMethodCellModel modelWithPaymentMethodModel:obj];
                }
                // 选中状态
                if (self.lastChoosedMethod && self.lastChoosedMethod.method == SAOrderPaymentTypeOnline) {
                    if ([self.lastChoosedMethod.toolCode isEqualToString:cellModel.toolCode] && cellModel.isUsable && cellModel.isShow) {
                        cellModel.isSelected = YES;
                    }
                } else if (self.lastChoosedMethod) {
                    if (self.lastChoosedMethod.method == cellModel.paymentMethod) {
                        cellModel.isSelected = YES;
                    }
                }

                return cellModel;
            }];

            self.availablePaymentMethods = tmp;
        }];
    });
}

- (void)submitPaymentParamsWithPaymentTools:(HDCheckStandPaymentTools)tools
                                    orderNo:(NSString *_Nonnull)orderNo
                              outPayOrderNo:(NSString *_Nonnull)outPayOrderNo
                                    success:(void (^)(HDCheckStandOrderSubmitParamsRspModel *_Nonnull rspModel))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock {
    [self.standDTO submitOrderParamsWithPaymentMethod:tools orderNo:orderNo tradeNo:outPayOrderNo success:successBlock failure:failureBlock];
}

- (void)getQRCodePayDetailWithAggregateOrderNo:(NSString *)aggregateOrderNo success:(void (^)(HDCheckStandQRCodePayDetailRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.standDTO getQRCodePayDetailWithAggregateOrderNo:aggregateOrderNo success:successBlock failure:failureBlock];
}

- (void)createPayOrderWithOrderNo:(NSString *_Nonnull)orderNo
                          trialId:(NSString *_Nullable)trialId
                    payableAmount:(SAMoneyModel *_Nonnull)payableAmount
                   discountAmount:(SAMoneyModel *_Nullable)discountAmount
                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    [self.standDTO createPayOrderWithReturnUrl:[NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", self.businessLine] orderNo:orderNo trialId:trialId
                                 payableAmount:payableAmount
                                discountAmount:discountAmount
                                       success:successBlock
                                       failure:failureBlock];
}

- (void)createPayOrderWithOrderNo:(NSString *)orderNo
                          trialId:(NSString *)trialId
                    payableAmount:(SAMoneyModel *)payableAmount
                   discountAmount:(SAMoneyModel *)discountAmount
                 isCashOnDelivery:(BOOL)isCashOnDelivery
                          success:(void (^)(HDCreatePayOrderRspModel *_Nonnull))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    [self.standDTO createPayOrderWithReturnUrl:[NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", self.businessLine] orderNo:orderNo trialId:trialId
                                 payableAmount:payableAmount
                                discountAmount:discountAmount
                              isCashOnDelivery:isCashOnDelivery
                                       success:successBlock
                                       failure:failureBlock];
}


#pragma mark - private methods
/// 查余额
/// @param completion 完成回调
- (void)queryUserWalletBalanceCompletion:(void (^_Nullable)(SAWalletBalanceModel *_Nullable walletModel))completion {
    [self.walletDTO queryBalanceSuccess:^(SAWalletBalanceModel *_Nonnull rspModel) {
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(nil);
    }];
}

/// 查公告
/// @param completion 完成回调
- (void)queryPaymentAnnouncementCompletion:(void (^_Nullable)(NSString *announcement))completion {
    [self.standDTO queryPaymentAnnouncementSuccess:^(HDQueryAnnoncementRspModel *_Nullable announcement) {
        !completion ?: completion(announcement.content);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(@"");
    }];
}

/// 查可用的支付方式
/// @param completion 完成回调
- (void)queryAvaliableOnlinePaymentToolsCompletion:(void (^_Nullable)(NSArray<HDPaymentMethodType *> *_Nullable paymentMethods))completion {
    @HDWeakify(self);
    [self.standDTO queryAvaliableOnlinePaymentToolsWithMerchantNo:self.merchantNo success:^(NSArray<HDOnlinePaymentToolsModel *> *_Nullable paymentTools) {
        @HDStrongify(self);
        NSMutableArray<HDPaymentMethodType *> *paymentMethods = [[NSMutableArray alloc] initWithCapacity:2];
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodOnline]) {
            [paymentMethods addObjectsFromArray:[paymentTools mapObjectsUsingBlock:^id _Nonnull(HDOnlinePaymentToolsModel *_Nonnull obj, NSUInteger idx) {
                                //                                    return [HDPaymentMethodType onlineMethodWithPaymentTool:obj.vipayCode marketing:obj.marketing];
                                return [HDPaymentMethodType onlineMethodWithPaymentModel:obj];
                            }]];
        }
        // 货到付款
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodCashOnDelivery]) {
            [paymentMethods addObject:[HDPaymentMethodType cashOnDelivery]];
        }

        // 禁止货到付款
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodCashOnDeliveryForbidden]) {
            [paymentMethods addObject:[HDPaymentMethodType cashOnDeliveryForbidden]];
        }
        // 禁止到店自取货到付款
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore]) {
            [paymentMethods addObject:[HDPaymentMethodType cashOnDeliveryForbiddenByToStore]];
        }

        // 线下转账
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodTransfer]) {
            [paymentMethods addObject:[HDPaymentMethodType cashOnTransfer]];
        }

        // 扫码支付
        if ([self.supportedPaymentMethod containsObject:HDSupportedPaymentMethodQRCode]) {
            [paymentMethods addObject:[HDPaymentMethodType qrCodePay]];
        }

        !completion ?: completion(paymentMethods);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !completion ?: completion(@[]);
    }];
}

/// 查可用的支付营销
/// @param completion 完成回调
- (void)queryAvailablePaymentActivitysCompletion:(void (^_Nullable)(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys))completion {
    [self.standDTO queryPaymentAvailableActivityWithMerchantNo:self.merchantNo storeNo:self.storeNo businessLine:self.businessLine goods:self.goods payableAmount:self.payableAmount
        aggregateOrderNo:self.isPre ? @"" : self.orderNo success:^(NSArray<SAPaymentToolsActivityModel *> *_Nullable activitys) {
            !completion ?: completion(activitys);
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            !completion ?: completion(@[]);
        }];
}


/// 查询支付结果
- (void)queryOrderPaymentStateSuccess:(void (^)(SAQueryPaymentStateRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.paymentDTO queryOrderPaymentStateWithOrderNo:self.orderNo success:successBlock failure:failureBlock];
}

#pragma mark - lazy load
/** @lazy walletDTO */
- (SAWalletDTO *)walletDTO {
    if (!_walletDTO) {
        _walletDTO = [[SAWalletDTO alloc] init];
    }
    return _walletDTO;
}

/** @lazy checkStandDTO */
- (HDCheckstandDTO *)standDTO {
    if (!_standDTO) {
        _standDTO = [[HDCheckstandDTO alloc] init];
    }
    return _standDTO;
}

- (SAPaymentDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = [[SAPaymentDTO alloc] init];
    }
    return _paymentDTO;
}

@end
