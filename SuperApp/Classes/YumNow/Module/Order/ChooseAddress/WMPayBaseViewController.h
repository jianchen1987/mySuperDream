//
//  WMModifyAddressPayBaseViewController.h
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandPresenter.h"
#import "HDTradeBuildOrderModel.h"
#import "SAViewController.h"
#import "WMModifyAddressListModel.h"
#import "WMModifyAddressSubmitOrderModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMModifyAddressPayBaseViewController : SAViewController <HDCheckStandViewControllerDelegate>
/// orderNo
@property (nonatomic, copy, readonly) NSString *orderNo;
/// payableAmount
@property (nonatomic, strong, readonly) SAMoneyModel *payableAmount;
/// storeNo
@property (nonatomic, copy, readonly) NSString *storeNo;
/// merchantNo
@property (nonatomic, copy, readonly) NSString *merchantNo;
/// parentOrderNo
@property (nonatomic, copy) NSString *parentOrderNo;
///调起收银台
- (void)payActionWithOrderNo:(NSString *)orderNo merchantNo:(NSString *)merchantNo storeNo:(NSString *)storeNo payableAmount:(SAMoneyModel *)payableAmount;
@end

NS_ASSUME_NONNULL_END
