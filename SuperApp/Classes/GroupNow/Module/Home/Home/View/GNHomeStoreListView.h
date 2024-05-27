//
//  GNHomeStoreListView.h
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNEnum.h"
#import "GNFilterView.h"
#import "GNHomeCustomViewModel.h"
#import "GNTableView.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeStoreListView : GNView <GNTableViewProtocol>
/// columnCode
@property (nonatomic, copy) NSString *columnCode;
/// classCode
@property (nonatomic, strong) GNHomeColumnType columnType;
/// 可以更新了
@property (nonatomic, assign) BOOL updateMenuList;
/// tableView
@property (nonatomic, strong, readonly) GNTableView *tableView;
/// viewModel
@property (nonatomic, strong, readonly) GNHomeCustomViewModel *viewModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray<GNStoreCellModel *> *dataSource;
/// 筛选
@property (nonatomic, strong) GNFilterView *filterBarView;
/// 筛选起始坐标Y
@property (nonatomic, assign) CGFloat startOffsetY;
/// sectionModel
@property (nonatomic, strong) GNSectionModel *sectionModel;
@end

NS_ASSUME_NONNULL_END
