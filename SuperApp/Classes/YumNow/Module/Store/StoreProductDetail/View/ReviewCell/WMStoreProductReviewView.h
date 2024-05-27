//
//  WMStoreProductReviewView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreProductReviewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductReviewView : SAView
/// 模型
@property (nonatomic, strong) WMStoreProductReviewModel *model;
/// 点击了商家回复查看更多或更少
@property (nonatomic, copy) void (^clickedMerchantReplyReadMoreOrReadLessBlock)(void);
/// 点击了用户评论查看更多或更少
@property (nonatomic, copy) void (^clickedUserReviewContentReadMoreOrReadLessBlock)(void);
/// 点击了标签
@property (nonatomic, copy) void (^clickedProductItemBlock)(NSString *goodsId, NSString *storeNo);
/// 点击了门店
@property (nonatomic, copy) void (^clickedStoreInfoBlock)(NSString *storeNo);
@end

NS_ASSUME_NONNULL_END
