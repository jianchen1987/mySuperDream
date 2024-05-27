//
//  SAChooseZoneView.h
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAddressZoneModel;


@interface SAChooseZoneView : SAView

- (void)setupLocation:(SAAddressZoneModel *)zoneModel;
- (void)setupHotCitys:(NSArray<SAAddressZoneModel *> *)hotCitys;

@end

NS_ASSUME_NONNULL_END
