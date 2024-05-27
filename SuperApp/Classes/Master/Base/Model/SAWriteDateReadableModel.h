//
//  SAWriteDateReadableModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWriteDateReadableModel : SAModel

@property (nonatomic, strong) id storeObj;                                ///< 存储对象
@property (nonatomic, assign) NSTimeInterval createTimeInterval;          ///< 创建时间
@property (nonatomic, assign) NSTimeInterval timeIntervalSinceCreateTime; ///< 存储时间至当前间隔

+ (instancetype)modelWithStoreObj:(id)storeObj;
- (instancetype)initWithStoreObj:(id)storeObj;

@end

NS_ASSUME_NONNULL_END
