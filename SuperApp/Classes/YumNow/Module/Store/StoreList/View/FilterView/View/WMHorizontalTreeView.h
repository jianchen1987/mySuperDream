//
//  WMHorizontalTreeView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreFilterTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHorizontalTreeView : SAView <HDCustomViewActionViewProtocol>
@property (nonatomic, assign) CGFloat minHeight; ///< 最小高度
@property (nonatomic, assign) CGFloat maxHeight; ///< 最大高度
///<
///<
///一层嵌套模式
@property (nonatomic, assign) BOOL oneNest;
///自定义cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat maxWidth;
/// <#名称#>
@property (nonatomic, assign) CGFloat mainTableViewContentSizeHeight;

@property (nonatomic, copy) NSArray<WMStoreFilterTableViewCellModel *> *dataSource; ///< 数据源
/** 当前选中的表单 cell 模型，如果只有一级，会返回一级的模型 */
@property (nonatomic, strong, readonly) WMStoreFilterTableViewCellBaseModel *selectedSubCellModel;
/** 当前选中的表单 cell 一级模型 */
@property (nonatomic, strong, readonly) WMStoreFilterTableViewCellBaseModel *selectedMainCellModel;

- (instancetype)initWithDataSource:(NSArray<WMStoreFilterTableViewCellModel *> *)dataSource;

/// 选择了 item 回调
@property (nonatomic, copy) void (^didSelectMainTableViewRowAtIndexPath)(WMStoreFilterTableViewCellModel *model, NSIndexPath *indexPath);

/// 选择了 item 回调
@property (nonatomic, copy) void (^didSelectSubTableViewRowAtIndexPath)(WMStoreFilterTableViewCellBaseModel *model, NSIndexPath *indexPath);
@end

NS_ASSUME_NONNULL_END
