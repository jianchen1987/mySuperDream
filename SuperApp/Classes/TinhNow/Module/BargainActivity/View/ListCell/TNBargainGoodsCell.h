//
//  TNBargainGoodsCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodModel.h"
#import "TNCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodsCellModel : NSObject
/// 商品列表数据
@property (strong, nonatomic) NSArray<TNBargainGoodModel *> *list;
@end


@interface TNBargainGoodsCell : TNCollectionViewCell
/// 商品模型数据
@property (strong, nonatomic) TNBargainGoodModel *model;
/// 是否来自砍价列表  砍价列表需要显示成交数  并判断是否已抢完  已抢完的不能跳转详情
@property (nonatomic, assign) BOOL isFromBargainList;
@end

NS_ASSUME_NONNULL_END
