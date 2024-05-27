//
//  SAChooseZoneHeaderView.h
//  SuperApp
//
//  Created by Chaos on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressZoneModel;


@interface SAChooseZoneHeaderView : SAView

/// 当前定位城市
@property (nonatomic, strong) SAAddressZoneModel *locationModel;
/// 热门城市
@property (nonatomic, strong) NSArray<SAAddressZoneModel *> *hotCitys;
/// 选择城市回调
@property (nonatomic, copy) void (^chooseCityBlock)(SAAddressZoneModel *model);

@end

NS_ASSUME_NONNULL_END
