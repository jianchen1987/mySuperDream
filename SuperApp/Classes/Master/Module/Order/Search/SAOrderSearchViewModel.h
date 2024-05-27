//
//  SAOrderSearchViewModel.h
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderSearchViewModel : SAViewModel
/// 关键字
@property (nonatomic, copy) NSString *keyword;
/// 数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource; ///< 默认数据源
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 获取历史搜索记录
- (void)loadDefaultData;
/// 记录搜索记录
/// - Parameter keyword: 关键字
- (void)saveMerchantHistorySearchWithKeyword:(NSString *)keyword;

/// 清除搜索记录
- (void)removeAllHistorySearch;

@end

NS_ASSUME_NONNULL_END
