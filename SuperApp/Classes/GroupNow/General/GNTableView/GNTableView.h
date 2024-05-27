//
//  GNTableView.h
//  SuperApp
//
//  Created by wGN on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSectionModel.h"
#import "GNTableHeaderFootView.h"
#import "GNTableViewCell.h"
#import "GNTableViewProtocol.h"
#import "UIViewPlaceholderViewModel.h"
#import <MJRefresh/MJRefresh.h>

typedef void (^GNCustomPlaceHolder)(UIViewPlaceholderViewModel *_Nonnull placeholderViewModel, BOOL showError);

NS_ASSUME_NONNULL_BEGIN


@interface GNTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
/// 实现协议
@property (nonatomic, weak) id<GNTableViewProtocol> GNdelegate;
/// 数据源
@property (nonatomic, strong) NSArray<GNSectionModel *> *dataArr;
/// 顶部不能滑动
@property (nonatomic, assign) IBInspectable BOOL topSop;
/// 刷新
@property (nonatomic, assign) BOOL refresh;
/// 复用
@property (nonatomic, assign) BOOL reuse;
/// 标记
@property (nonatomic, assign) BOOL click;
/// 需要刷新按钮
@property (nonatomic, assign) IBInspectable BOOL needRefreshBTN;
/// 需要下拉刷新
@property (nonatomic, assign) IBInspectable BOOL needRefreshHeader;
/// 需要上拉加载更多
@property (nonatomic, assign) IBInspectable BOOL needRefreshFooter;
/// 需要显示无数据占位
@property (nonatomic, assign) IBInspectable BOOL needShowNoDataView;
/// 需要显示网络错误占位
@property (nonatomic, assign) IBInspectable BOOL needShowErrorView;
/// 刷新
@property (nonatomic, assign, getter=isCanEdit) IBInspectable BOOL canEdit;
/// 数据为空占位图配置模型
@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel;
/// 刷新按钮回调
@property (nonatomic, copy) void (^tappedRefreshBtnHandler)(void);
/// 下拉刷新回调
@property (nonatomic, copy) void (^requestNewDataHandler)(void);
/// 上拉加载更多回调
@property (nonatomic, copy) void (^requestMoreDataHandler)(void);
/// 刷新按钮回调
@property (nonatomic, copy) GNCustomPlaceHolder customPlaceHolder;
/// 分页页码
@property (nonatomic, assign) NSInteger pageNum;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
/// 请求成功刷新
- (void)reloadData:(BOOL)isNoMore;

- (void)reloadData:(BOOL)isNoMore needEndHeadRefresh:(BOOL)needEndHeadRefresh;
/// 请求失败刷新
- (void)reloadFail;
/// 是否有数据
- (BOOL)hd_hasData;
/// 刷新cell
- (void)updateCell:(nullable NSIndexPath *)indexPath;
/// 刷新
- (void)updateUI;
///获取新数据
- (void)getNewData;
///直接显示占位图
- (void)showErrorPlacholderView;
@end

NS_ASSUME_NONNULL_END
