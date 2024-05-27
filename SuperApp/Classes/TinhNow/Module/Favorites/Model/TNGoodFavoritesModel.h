//
//  TNGoodFavoritesModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNGoodFavoritesModel : TNModel
/// 商品名称
@property (nonatomic, copy) NSString *name;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品缩略图
@property (nonatomic, copy) NSString *thumbnail;
/// 销售价
@property (nonatomic, copy) SAMoneyModel *price;
/// 市场价
@property (nonatomic, copy) SAMoneyModel *marketPrice;
/// 商品类型
@property (nonatomic, copy) TNGoodsType type;
/// 商品标签
@property (nonatomic, copy) NSString *labelTxt;
/// 商品收藏id
@property (nonatomic, copy) NSString *productFavoriteId;
/// 商品sp   有sp就是卖家的商品
@property (nonatomic, copy) NSString *sp;
@end

NS_ASSUME_NONNULL_END
