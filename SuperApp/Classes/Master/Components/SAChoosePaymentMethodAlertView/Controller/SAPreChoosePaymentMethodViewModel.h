//
//  SAPreChoosePaymentMethodViewModel.h
//  SuperApp
//
//  Created by seeu on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "HDCheckStandPaymentMethodCellModel.h"
#import "HDCreatePayOrderRspModel.h"
#import "HDPaymentMethodType.h"
#import "SAGoodsModel.h"
#import "SAMoneyModel.h"
#import "SAViewModel.h"
#import "SAWalletBalanceModel.h"


NS_CLASS_DEPRECATED_IOS(1_0, 2_40_2, "SAPreChoosePaymentMethodViewModel is deprecated. Use HDCheckStandChoosePaymentMethodViewModel class instead");

NS_ASSUME_NONNULL_BEGIN


@interface SAPreChoosePaymentMethodViewModel : SAViewModel
///< 支付公告
@property (nonatomic, copy, readonly) NSString *paymentAnnoncement;
///< 可用的支付方式
@property (nonatomic, strong, readonly) NSArray<HDCheckStandPaymentMethodCellModel *> *availablePaymentMethods;

///< 商户号
@property (nonatomic, copy) NSString *merchantNo;
///< 门店号
@property (nonatomic, copy) NSString *storeNo;
///< 应付金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
///< 业务线
@property (nonatomic, copy) SAClientType businessLine;
///< 商品
@property (nonatomic, strong) NSArray<SAGoodsModel *> *goods;
///< 支持的支付方式
@property (nonatomic, strong) NSArray<HDSupportedPaymentMethod> *supportedPaymentMethod;
///< 上一次选中的支付方式
@property (nonatomic, strong) HDPaymentMethodType *lastChoosedMethod;
///< 用户钱包状态
@property (nonatomic, strong) SAWalletBalanceModel *userWallet;

- (void)initialize;

@end

NS_ASSUME_NONNULL_END
