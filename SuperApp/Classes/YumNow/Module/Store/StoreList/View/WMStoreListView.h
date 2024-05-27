//
//  WMStoreListView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMTableView.h"

@class WMStoreFilterModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreListView : SAView
///< 当前筛选的模型
@property (nonatomic, strong, readonly) WMStoreFilterModel *filterModel;
/// 列表
@property (nonatomic, strong) WMTableView *tableView;
- (void)hd_getNewData;

/// 视图是否显示在窗口   新增的点击首页tanbar 的回调  在别的页面也会触发  以此判断显示才执行事件
@property (nonatomic, assign) BOOL isShowingInWindow;

@end

NS_ASSUME_NONNULL_END
