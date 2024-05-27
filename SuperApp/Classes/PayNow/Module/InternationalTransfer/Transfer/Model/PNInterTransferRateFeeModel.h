//
//  PNInterTransferRateFeeModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferAmountModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, PNInterTransFeeCalcType) {
    PNInterTransFeeCalcTypePercent = 10,     //百分比
    PNInterTransFeeCalcTypeFixedAmount = 11, //固定金额
};


@interface PNInterTransferRateInfoModel : PNModel
/// 目标金额
@property (strong, nonatomic) PNInterTransferAmountModel *sourceAmt;
/// 转换金额
@property (strong, nonatomic) PNInterTransferAmountModel *targetAmt;
@end


@interface PNInterTransferFeeRule : PNModel
/// 10-百分比 11-按固定额度
@property (nonatomic, assign) PNInterTransFeeCalcType feeCalcType;
/// 百分比展示的 百分比  后端要写成金额对象返回   显示的时候  加百分比显示
@property (strong, nonatomic) SAMoneyModel *feeRate;
/// 固定额度金额
@property (strong, nonatomic) SAMoneyModel *feeFixed;
@end


@interface PNInterTransferFeeInfoModel : PNModel
/// 金额范围起始金额  基本不用展示
@property (strong, nonatomic) SAMoneyModel *feeStartAmt;
/// 金额范围 截止金额
@property (strong, nonatomic) SAMoneyModel *feeEndAmt;
/// 展示规则
@property (strong, nonatomic) PNInterTransferFeeRule *personalRule;
@end


@interface PNInterTransferRateFeeModel : PNModel
/// 汇率数据
@property (strong, nonatomic) PNInterTransferRateInfoModel *rateInfo;
/// 手续费数据
@property (strong, nonatomic) NSArray<PNInterTransferFeeInfoModel *> *feeInfos;
/// 协议说明
@property (strong, nonatomic) NSArray<NSString *> *agreements;
@end

NS_ASSUME_NONNULL_END
