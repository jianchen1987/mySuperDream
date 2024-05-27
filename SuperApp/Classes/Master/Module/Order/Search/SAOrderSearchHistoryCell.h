//
//  SAOrderSearchHistoryCell.h
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderSearchHistoryCell : SATableViewCell
/// 数据源
@property (nonatomic, strong) NSArray *dataSource;
/// 选择tag回调
@property (nonatomic, copy) void (^clickItemBlock)(NSString *itemStr);
/// 清除历史搜素记录i回调
@property (nonatomic, copy) dispatch_block_t clearAllHistoryBlock;

@end

NS_ASSUME_NONNULL_END
