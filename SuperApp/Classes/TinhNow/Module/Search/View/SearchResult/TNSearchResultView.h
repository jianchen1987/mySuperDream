//
//  TNSearchResultView.h
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN
@class TNSearchSortFilterModel;

typedef void (^SortFilterDidChangedHandler)(TNSearchSortFilterModel *);


@interface TNSearchResultView : TNView <HDCategoryListContentViewDelegate>

/// 初始化
/// @param viewModel viewModel
/// @param scopeType 搜索范围  默认全部商城
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel scopeType:(TNSearchScopeType)scopeType;
///拉取所有数据
- (void)requestNewData;
///重置数据
- (void)resetData;
///拉取商品列表数据
- (void)requestGoodListData;
@end

NS_ASSUME_NONNULL_END
