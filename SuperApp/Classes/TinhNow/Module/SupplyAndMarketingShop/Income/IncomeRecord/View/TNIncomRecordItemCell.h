//
//  TNIncomRecordItemCell.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SANoDataCell.h"
#import "SATableViewCell.h"
#import "TNIncomeRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomRecordItemSkeletonCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>

@end


@interface TNIncomeNoDataCell : SANoDataCell

@end

///头部 时间金额展示
@interface TNIncomRecordItemCommonHeaderCell : SATableViewCell
/// 默认展示 1已结算 2预估
@property (nonatomic, assign) NSInteger queryMode;
@end


@interface TNIncomRecordItemCell : SATableViewCell

@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, strong) TNIncomeRecordItemModel *model;
@property (nonatomic, assign) BOOL isPreIncomeList; ///<  是否是预估收益页面  预估页面 需要展示状态
@end

NS_ASSUME_NONNULL_END
