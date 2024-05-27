//
//  PNApartmentListCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"
#import "PNApartmentListRspModel.h"

typedef enum : NSUInteger {
    PNApartmentListCellType_Default,    /// 带右边箭头 可以点击
    PNApartmentListCellType_MoreSelect, /// 左边多出 checkBox 可以多选 ， 不带右边箭头
    PNApartmentListCellType_OnlyShow,   /// 纯粹展示 【不带右边箭头】
    PNApartmentListCellType_OrderList,  /// 跟默认的一样
} PNApartmentListCellType;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectBtnBlock)(PNApartmentListItemModel *model);


@interface PNApartmentListCell : PNTableViewCell
@property (nonatomic, copy) PNCurrencyType currency;
@property (nonatomic, assign) PNApartmentListCellType cellType;

@property (nonatomic, strong) PNApartmentListItemModel *model;

@property (nonatomic, copy) SelectBtnBlock selectBtnBlock;
@end

NS_ASSUME_NONNULL_END
