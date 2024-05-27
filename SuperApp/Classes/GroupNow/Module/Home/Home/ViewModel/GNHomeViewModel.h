//
//  GNHomeViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNColumnModel.h"
#import "GNHomeDTO.h"
#import "GNTagViewCellModel.h"
#import "GNViewModel.h"
#import "SACommonConst.h"
#import "SAWindowModel.h"
#import "SAWindowRspModel.h"
#import "WMHomeLayoutModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNHomeViewModel : GNViewModel
/// 栏目列表
@property (nonatomic, strong) NSArray<GNColumnModel *> *columnDataSource;
/// 默认数据源
@property (nonatomic, strong) NSMutableArray<GNCellModel *> *dataSource;
/// 网络请求
@property (nonatomic, strong) GNHomeDTO *homeDTO;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 获取信息
- (void)getInfoData;

@end

NS_ASSUME_NONNULL_END
