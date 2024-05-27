//
//  WMProductReviewListRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMStoreProductReviewModel.h"
#import "WMUserReviewStoreInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMProductReviewListRspModel : SACommonPagingRspModel
/// 商品评论列表
@property (nonatomic, copy) NSArray<WMStoreProductReviewModel *> *list;
/// 门店信息
@property (nonatomic, strong) WMUserReviewStoreInfoStoresModel *stores;
@end

NS_ASSUME_NONNULL_END
