//
//  PNGameSubmitOderModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameSubmitOderRequestModel : PNModel
/// 原始code
@property (nonatomic, copy) NSString *billerCode;
/// 游戏id
@property (nonatomic, copy) NSString *userId;
/// 区域id
@property (nonatomic, copy) NSString *zoneId;
/// id  如果有 userId zoneId需要拼接 billerCode
@property (nonatomic, copy) NSString *billCode;
/// 用户号 如果有 userId zoneId需要拼接 billerCode
@property (nonatomic, copy) NSString *customerCode;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 账单来源（10：app,11:POS)
@property (nonatomic, strong) NSNumber *billingSource;
/// 账单总金额
@property (nonatomic, copy) SAMoneyModel *billAmount;
/// 用户
@property (nonatomic, copy) NSString *userNo;
/// 客户电话
@property (nonatomic, copy) NSString *customerPhone;
/// 对应娱乐缴费的group
@property (copy, nonatomic) NSString *billGroup;
/// 回调URL
@property (nonatomic, copy) NSString *returnUrl;
/// 分类id
@property (nonatomic, copy) NSString *categoryId;

@end

NS_ASSUME_NONNULL_END
