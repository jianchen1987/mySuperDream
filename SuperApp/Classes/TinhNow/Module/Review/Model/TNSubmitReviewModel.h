//
//  TNSubmitReviewModel.h
//  SuperApp
//
//  Created by xixi on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"


@class TNSubmitReviewItemModel;
@class HXPhotoModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNSubmitReviewModel : TNModel

///
@property (nonatomic, strong) NSArray<TNSubmitReviewItemModel *> *itemList;
/// 中台订单编号号
@property (nonatomic, strong) NSString *orderNo;
/// 物流服务评分 1-Bad,2-Not Bad,3-Good,4-Great,5-Excellent
@property (nonatomic, assign) NSInteger logisticsScore;
/// 服务态度评分 1-Bad,2-Not Bad,3-Good,4-Great,5-Excellent
@property (nonatomic, assign) NSInteger serviceScore;
@end


@interface TNSubmitReviewItemModel : TNModel

/// 商品ID
@property (nonatomic, strong) NSString *itemId;
/// sku
@property (nonatomic, strong) NSString *skuId;
/// 图片
@property (nonatomic, copy) NSString *thumbnail;
/// 商品名
@property (nonatomic, copy) NSString *name;
/// 发表图片
@property (nonatomic, strong) NSArray *imageUrls;
/// 商品评分
@property (nonatomic, assign) NSInteger score;
/// 手机号
@property (nonatomic, strong) NSString *mobile;
/// 评论内容
@property (nonatomic, copy) NSString *content;
/// 是否匿名10-匿名,11-非匿名
@property (nonatomic, assign) NSInteger anonymous;

/// 选择图片
@property (nonatomic, strong) NSArray<HXPhotoModel *> *selectedPhotos;

@end

NS_ASSUME_NONNULL_END
