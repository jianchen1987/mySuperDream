//
//  PNMSBillListGroupModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillListModel.h"
#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSBillListGroupModel : PNModel
/// 日期
@property (nonatomic, copy) NSString *dayTime;
/// 收入USD
@property (nonatomic, copy) NSNumber *inUsdAmt;
/// 收入KHR
@property (nonatomic, copy) NSNumber *inKhrAmt;
/// 支出USD
@property (nonatomic, copy) NSNumber *outUsdAmt;
/// 支出KHR
@property (nonatomic, copy) NSNumber *outKhrAmt;
/// USD笔数
@property (nonatomic, assign) NSInteger usdNum;
/// KHR笔数
@property (nonatomic, assign) NSInteger khrNum;

@property (nonatomic, strong) NSMutableArray<PNMSBillListModel *> *list;

@end

NS_ASSUME_NONNULL_END
