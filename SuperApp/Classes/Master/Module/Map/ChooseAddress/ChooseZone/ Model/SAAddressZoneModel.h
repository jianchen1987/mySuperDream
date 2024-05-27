//
//  SAAddressZoneModel.h
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddressZoneModel : SAModel

/// 区域编码
@property (nonatomic, copy) NSString *code;
/// 父级编码
@property (nonatomic, copy) NSString *parent;
/// 经度
@property (nonatomic, strong) NSNumber *longitude;
/// 纬度
@property (nonatomic, strong) NSNumber *latitude;
/// 搜索半径
@property (nonatomic, assign) CGFloat radius;
/// 区域级别
@property (nonatomic, assign) SAAddressZoneLevel zlevel;
/// 国际化描述
@property (nonatomic, strong) SAInternationalizationModel *message;
/// 子集
@property (nonatomic, strong) NSArray<SAAddressZoneModel *> *children;
@end

NS_ASSUME_NONNULL_END
