//
//  SAChooseCityView.h
//  SuperApp
//
//  Created by seeu on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressZoneModel;


@interface SAChooseCityView : SAView
- (void)setupLocation:(SAAddressZoneModel *)zoneModel;
- (void)setupHotCitys:(NSArray<SAAddressZoneModel *> *)hotCitys;
@end

NS_ASSUME_NONNULL_END
