//
//  HDLocationAuthResult.h
//  ViPay
//
//  Created by VanJay on 2019/6/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDLocationAuthResult : NSObject
@property (nonatomic, assign) double latitude;  ///< 纬度
@property (nonatomic, assign) double longitude; ///< 经度
@property (nonatomic, assign) BOOL isSuccess;   ///< 是否成功
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude isSuccess:(BOOL)isSuccess;
@end

NS_ASSUME_NONNULL_END
