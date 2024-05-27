//
//  WMStoreReviewGoodsModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

typedef NS_ENUM(NSUInteger, WMStoreReviewGoodsStatus) {
    WMStoreReviewGoodsStatusLike = 10,
    WMStoreReviewGoodsStatusUnlike = 11,
};

@class SAInternationalizationModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreReviewGoodsModel : WMModel

/// id
@property (nonatomic, copy) NSString *itemId;
/// 踩/赞
@property (nonatomic, assign) WMStoreReviewGoodsStatus disLike;
/// 商品名称
@property (nonatomic, copy) NSString *itemName;

#pragma mark - 绑定属性
/// 用来展示的名称
@property (nonatomic, strong) SAInternationalizationModel *goodName;

@end

NS_ASSUME_NONNULL_END
