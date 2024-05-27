//
//  PNWalletListRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletListItemModel : PNModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) PNCurrencyType currency;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *displayStatus;
@property (nonatomic, strong) SAMoneyModel *orderAmt;
@property (nonatomic, strong) SAMoneyModel *balance;
@property (nonatomic, copy) NSString *debitCreditFlag;
@property (nonatomic, copy) NSString *orderSerialNo;
@property (nonatomic, copy) NSString *accountSerialNo;
@end


@interface PNWalletListModel : PNModel
@property (nonatomic, copy) NSString *dayTime;
@property (nonatomic, strong) NSArray<PNWalletListItemModel *> *list;
@end


@interface PNWalletListRspModel : HDCommonPagingRspModel
@property (nonatomic, strong) NSArray<PNWalletListModel *> *list;
@end

NS_ASSUME_NONNULL_END
