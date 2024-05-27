//
//  WMStoreCateCacheModel.h
//  SuperApp
//
//  Created by wmz on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreCateCacheModel : WMModel
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSources;
/// 偏移量
@property (nonatomic, assign) CGFloat offset;
/// 是否有下一页
@property (nonatomic, assign) BOOL hasNest;
@end

NS_ASSUME_NONNULL_END
