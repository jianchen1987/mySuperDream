//
//  PNGameDetailRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameRspModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameItemModel : PNModel
/// 金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 备注
@property (nonatomic, copy) NSString *remark;
/// 编号
@property (nonatomic, copy) NSString *code;
/// 图片
@property (nonatomic, copy) NSString *image;
/// 分组  group = direct 时缴费类型是 pinless，group = voucher 缴费类型是 pinbase
@property (nonatomic, copy) NSString *group;
/// 币种
@property (nonatomic, copy) NSString *currency;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 折扣前金额
@property (nonatomic, strong) SAMoneyModel *amountBeforeDiscount;

/// 是否需要展示游戏ID  游戏区域   账单类型为 PINLESS时，页面展示该两字段
@property (nonatomic, assign) BOOL isPinless;
/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end


@interface PNGameDetailRspModel : PNModel
///
@property (strong, nonatomic) NSArray<PNGameItemModel *> *item;
/// 数据
@property (nonatomic, strong) PNGameCategoryModel *category;
@end

NS_ASSUME_NONNULL_END
