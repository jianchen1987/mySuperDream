//
//  TNSellerProductRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
@class TNSellerProductModel;
@class TNCategoryModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerSearchAggsModel : NSObject
/// 推荐分类数据
@property (strong, nonatomic) NSArray<TNCategoryModel *> *categorys;
@end


@interface TNSellerProductRspModel : TNPagingRspModel
/// 搜索扩充数据  第三方卖家分类数据
@property (strong, nonatomic) TNSellerSearchAggsModel *aggs;
/// 商品列表
@property (nonatomic, strong) NSArray *list;
@end

NS_ASSUME_NONNULL_END
