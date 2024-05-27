//
//  PNOutletViewModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNOutletViewModel : PNViewModel

@property (nonatomic, assign) BOOL refreshFlag;

@property (nonatomic, strong) NSMutableArray *coolcashDataSourceArray;

/// 用户选择的定位【搜索出来显示】- 搜索用到的坐标
@property (nonatomic, assign) CLLocationCoordinate2D selectCoordinate;
///// 用户定位的定位
//@property (nonatomic, assign) CLLocationCoordinate2D userLocationCoordinate;

/// 搜索附近的网点
- (void)searchNearCoolCashMerchant;
@end

NS_ASSUME_NONNULL_END
