//
//  WMStoreReviewCountRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 不同类型的门店评论数量查询
@interface WMStoreReviewCountRspModel : WMRspModel
/// 带图的
@property (nonatomic, assign) NSUInteger images;
/// 好评
@property (nonatomic, assign) NSUInteger praises;
/// 差评
@property (nonatomic, assign) NSUInteger criticals;
/// 中评
@property (nonatomic, assign) NSUInteger middles;
/// 有详情的
@property (nonatomic, assign) NSUInteger detailed;
/// 评论总数
@property (nonatomic, assign) NSUInteger total;
@end

NS_ASSUME_NONNULL_END
