//
//  WMProductReviewCountRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 不同类型的商品评论数量查询
@interface WMProductReviewCountRspModel : WMRspModel
/// 有图评论数量
@property (nonatomic, assign) NSUInteger pictures;
/// 点赞数量
@property (nonatomic, assign) NSUInteger likes;
/// 点踩数量
@property (nonatomic, assign) NSUInteger unlikes;
/// 有详情的
@property (nonatomic, assign) NSUInteger detailed;
/// 评论总数
@property (nonatomic, assign) NSUInteger total;
@end

NS_ASSUME_NONNULL_END
