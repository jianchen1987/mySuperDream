//
//  PNGuaranteeRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuaranteeListItemModel : PNModel
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *userNo;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *traderNo;
@property (nonatomic, copy) NSString *traderMobile;
@property (nonatomic, copy) NSString *traderName;
@property (nonatomic, strong) NSNumber *amt;
@property (nonatomic, copy) NSString *cy;
@property (nonatomic, strong) NSNumber *feeAmt;
@property (nonatomic, strong) NSNumber *paidAmt;
@property (nonatomic, strong) PNEnumModel *originator;
@property (nonatomic, strong) PNEnumModel *status;
@property (nonatomic, assign) BOOL paid;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *completeTime;

@end


@interface PNGuaranteeRspModel : HDCommonPagingRspModel
@property (nonatomic, strong) NSArray<PNGuaranteeListItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
