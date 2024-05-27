//
//  WMOrderEvaluationFeedbackItemModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

typedef NS_ENUM(NSUInteger, WMOrderEvaluationFoodItemViewStatus) {
    WMOrderEvaluationFoodItemViewStatusLike,
    WMOrderEvaluationFoodItemViewStatusUnlike,
    WMOrderEvaluationFoodItemViewStatusNone,
};

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderEvaluationGoodsModel : WMModel

/// 商品id
@property (nonatomic, copy) NSString *commodityId;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 名称
@property (nonatomic, copy) NSString *commodityName;
/// 商品快照 id
@property (nonatomic, copy) NSString *commoditySnapshootId;
/// 商品规格id
@property (nonatomic, copy) NSString *commoditySpecificationId;
/// 商品规格名称
@property (nonatomic, copy) NSString *specificationName;
/// 业务线
@property (nonatomic, copy) SAClientType clientType;
/// 商品图片
@property (nonatomic, copy) NSArray<NSString *> *commodityPictureIds;

#pragma mark - 以下为绑定属性
/// 状态（踩/赞）
@property (nonatomic, assign) WMOrderEvaluationFoodItemViewStatus status;

/// 提交商品评价单个 item
@property (nonatomic, copy, readonly) NSDictionary *submitItem;

@end

NS_ASSUME_NONNULL_END
