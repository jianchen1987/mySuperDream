//
//  PNUtilitiesViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

@class PNRecentBillListItemModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kUtilitiesTag = @"utilities_tag";
static NSString *const Tag_utilities = @"utilities";
static NSString *const Tag_recent_payment = @"recent_payment";


@interface PNUtilitiesViewModel : PNViewModel
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 总的数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 查询所有账单分类
- (void)getAllBillCategory;

/// 查询最近的交易账单记录
- (void)queryRecentBillList;

@end

NS_ASSUME_NONNULL_END
