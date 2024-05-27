//
//  TNSearchGoodsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGoodsTagModel.h"
#import "TNPagingRspModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TNGoodsModel;
@class TNBargainGoodModel;


@interface TNESAggsModel : TNCodingModel
/// 专题标签数组
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *productLabel;
@end


@interface TNQueryGoodsRspModel : TNPagingRspModel
/// ES扩展字段
@property (strong, nonatomic) TNESAggsModel *aggs;
/// 商品列表
@property (nonatomic, strong) NSArray<TNGoodsModel *> *list;
/// 商品模型转换为砍价活动商品模型
+ (NSArray<TNBargainGoodModel *> *)modelArrayWithGoodModelList:(NSArray<TNGoodsModel *> *)list;
@end

NS_ASSUME_NONNULL_END
