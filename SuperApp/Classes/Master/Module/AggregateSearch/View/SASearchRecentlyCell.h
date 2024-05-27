//
//  SASearchRecentlyCell.h
//  SuperApp
//
//  Created by Tia on 2022/12/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAImageLabelCollectionViewCellModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchRecentlyCell : SATableViewCell
/// 数据源
@property (nonatomic, strong) NSArray<SAImageLabelCollectionViewCellModel *> *dataSource;
/// 选择tag回调
@property (nonatomic, copy) void (^clickItemBlock)(NSString *itemStr);
/// 清除历史搜素记录i回调
@property (nonatomic, copy) dispatch_block_t clearAllHistoryBlock;

@end

NS_ASSUME_NONNULL_END
