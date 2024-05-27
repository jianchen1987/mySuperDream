//
//  WMSpecialActivesStoreListView.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMTableView.h"
#import "WMNearbyFilterBarView.h"
#import "WMNearbyFilterModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialActivesStoreListView : SAView
/// tableview
@property (nonatomic, strong, readonly) WMTableView *tableView;
/// 筛选头部
@property (nonatomic, strong) WMNearbyFilterBarView *filterBarView;
/// 筛选model
@property (nonatomic, strong) WMNearbyFilterModel *_Nullable filterModel;
/// 视图是否显示在窗口   新增的点击首页tanbar 的回调  在别的页面也会触发  以此判断显示才执行事件
@property (nonatomic, assign) BOOL isShowingInWindow;

@end

NS_ASSUME_NONNULL_END
