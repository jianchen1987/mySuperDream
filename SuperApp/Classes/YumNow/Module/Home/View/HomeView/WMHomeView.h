//
//  WMHomeView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMHomeNoticeTipView.h"
#import "WMTableView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeView : SAView
/// 视图是否显示在窗口   新增的点击首页tanbar 的回调  在别的页面也会触发  以此判断显示才执行事件
@property (nonatomic, assign) BOOL isShowingInWindow;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 重新定位回调
@property (nonatomic, copy) dispatch_block_t relocationBlock;
///当前正在显示的通知
@property (strong, nonatomic) WMHomeNoticeTipView *noticeView;
/// 获取新数据
- (void)wm_getNewData:(BOOL)scrollTop;
@end

NS_ASSUME_NONNULL_END
