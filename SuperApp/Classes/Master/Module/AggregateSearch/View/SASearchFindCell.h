//
//  SASearchFindCell.h
//  SuperApp
//
//  Created by Tia on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAImageLabelCollectionViewCellModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchFindCell : SATableViewCell
/// 数据源
@property (nonatomic, strong) NSArray<SAImageLabelCollectionViewCellModel *> *dataSource;
/// 选择tag回调
@property (nonatomic, copy) void (^clickItemBlock)(NSString *itemStr);
/// 刷新ui回调
@property (nonatomic, copy) dispatch_block_t reloadCellBlock;
/// 是否展开，默认NO
@property (nonatomic) BOOL isShowAll;

@end

NS_ASSUME_NONNULL_END
