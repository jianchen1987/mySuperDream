//
//  WMNewHomeStoreListView.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAAddressModel.h"
#import "SANoDataCell.h"
#import "SAView.h"
#import "UITableView+RecordData.h"
#import "WMNewCNStoreTableViewCell.h"
#import "WMCategoryItem.h"
#import "WMNewHomeViewModel.h"
#import "WMNearbyFilterBarView.h"
#import "WMNearbyFilterModel.h"
#import "WMQueryNearbyStoreRspModel.h"
#import "WMNewStoreCell.h"
#import "WMStoreDTO.h"
#import "WMStoreSkeletonCell.h"
#import "WMTableView.h"
#import "WMZPageProtocol.h"
#import "WMStoreCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewHomeStoreListView : SAView <UITableViewDelegate, UITableViewDataSource, WMZPageProtocol>

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel columnModel:(WMHomeColumnModel *)columnModel;

@property (nonatomic, strong) WMHomeColumnModel *columnModel;

@property (nonatomic, strong) NSString *iocntype;
/// VM
@property (nonatomic, strong) WMNewHomeViewModel *viewModel;

@property (nonatomic, strong) WMTableView *tableView;
/// storeDTO
@property (nonatomic, strong) WMStoreDTO *storeDTO;
/// 筛选model
@property (nonatomic, strong) WMNearbyFilterModel *_Nullable filterModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 筛选头部
@property (nonatomic, strong) WMNearbyFilterBarView *filterBarView;
/// 筛选起始坐标Y
@property (nonatomic, assign) CGFloat startOffsetY;
/// 获取经纬度
- (CGPoint)getPosition;
/// 获取新数据
- (void)wm_getNewData;

@end

NS_ASSUME_NONNULL_END
