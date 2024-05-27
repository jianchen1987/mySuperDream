//
//  SAChangeCountryViewProvider.h
//  SuperApp
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACountryModel.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kCacheKeyUserLastChoosedCountry;
FOUNDATION_EXPORT NSString *const kCacheKeyUserLastChoosedAreaCode;


@interface SAChangeCountryViewProvider : NSObject
///< 数据源
+ (NSArray<SACountryModel *> *)dataSource;
///< 数据源2
+ (NSArray<SACountryModel *> *)areaCodedataSource;
@end

NS_ASSUME_NONNULL_END
