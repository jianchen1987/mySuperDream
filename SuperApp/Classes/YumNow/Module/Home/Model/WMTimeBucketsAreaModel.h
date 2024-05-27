//
//  WMTimeBucketsAreaModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMTimeBucketsModel;


@interface WMTimeBucketsAreaModel : WMModel
/// 推荐区名称
@property (nonatomic, copy) NSString *recommendAreaName;
/// 更多跳转链接
@property (nonatomic, copy) NSString *moreLink;
/// 门店列表
@property (nonatomic, strong) NSArray<WMTimeBucketsModel *> *recommendStores;
@end

NS_ASSUME_NONNULL_END
