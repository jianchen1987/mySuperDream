//
//  SAChooseCityViewModel.h
//  SuperApp
//
//  Created by seeu on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressZoneModel;


@interface SAChooseCityViewModel : SAViewModel
/// 选择完成回调
@property (nonatomic, copy) void (^callback)(SAAddressZoneModel *);
/// 标志，只要变化就刷新
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// tableview数据源
@property (nonatomic, strong, readonly) NSArray<SAAddressZoneModel *> *dataSource;

- (void)getNewData;
- (void)chooseZoneModel:(SAAddressZoneModel *)zoneModel;
// 根据点击的热门城市找到对应的分组
- (NSUInteger)findSectionWithChooseHotCity:(SAAddressZoneModel *)chooseHotCity;
@end

NS_ASSUME_NONNULL_END
