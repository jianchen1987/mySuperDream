//
//  TNActivityHotSaleCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "TNModel.h"
@class TNGoodsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityHotSaleCellModel : TNModel
/// 数据源
@property (strong, nonatomic) NSArray<TNGoodsModel *> *list;
/// cell高度
@property (nonatomic, assign) CGFloat cellHeight;
/// 单个item宽度
@property (nonatomic, assign) CGFloat goodItemWidth;
/// 单个item高度
@property (nonatomic, assign) CGFloat goodItemHeight;
/// 是否打开加购按钮
@property (nonatomic, assign) BOOL isQuicklyAddToCart;
/// 显示样式
//@property (nonatomic, assign) TNActivityGoodsDisplayStyle style;
/// 是否有免邮或者
@property (nonatomic, assign) BOOL hasFreeShippingOrPromotion;
@end


@interface TNActivityHotSaleCell : TNCollectionViewCell
/// 数据源
@property (strong, nonatomic) TNActivityHotSaleCellModel *cellModel;
/// 滚动回调
@property (nonatomic, copy) void (^scrollViewDidScrollBlock)(UICollectionView *collectionView);
@end

NS_ASSUME_NONNULL_END
