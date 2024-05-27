//
//  PNWalletViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"
#import "SACollectionViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kAccountFlag = @"account";
static NSString *const kLevelInfoFlag = @"level_info";
static NSString *const kTopFunctionFlag = @"top_function";
static NSString *const kBottomFunctionFlag = @"bottom_function";
static NSString *const kBannerFlag = @"banner_function";


@interface PNWalletViewModel : PNViewModel
@property (nonatomic, assign) BOOL settingRefreshFlag;
@property (nonatomic, assign) BOOL refreshFlag;
@property (nonatomic, strong) NSMutableArray<SACollectionViewSectionModel *> *dataSource;

/// 后续的 跳转路由
@property (nonatomic, strong) NSString *routPath;

@property (nonatomic, assign) NSInteger packetMessageCount;
/// 获取钱包首页信息
- (void)getNewData;

/// 重置数据源
- (void)resetDataSource;

@end

NS_ASSUME_NONNULL_END
