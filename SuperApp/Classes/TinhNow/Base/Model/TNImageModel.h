//
//  TNImageModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNImageModel : TNCodingModel

/// 缩略图
@property (nonatomic, copy) NSString *thumbnail;
/// 大图
@property (nonatomic, copy) NSString *large;
/// 原图
@property (nonatomic, copy) NSString *source;
/// 中图
@property (nonatomic, copy) NSString *medium;
/// 排序
@property (nonatomic, assign) NSUInteger order;

@end

NS_ASSUME_NONNULL_END
