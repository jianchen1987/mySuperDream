//
//  TNGoodsCollectionViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TNGoodsModel;
@class TNStoreInfoRspModel;
/// 商品展示样式
typedef NS_ENUM(NSUInteger, TNGoodsDisplayStyle) {
    /// 默认 瀑布流
    TNGoodsDisplayStyleWaterFallsFlow = 0,
    /// 横向 单个
    TNGoodsDisplayStyleHorizontal = 1,
};


@interface TNGoodsCollectionViewCell : TNCollectionViewCell
/// goodsModel
@property (nonatomic, strong) TNGoodsModel *model;
/// 点击店铺  埋点
@property (nonatomic, copy) void (^clickStoreTrackEventCallBack)(void);
/// 加入购物车埋点
@property (nonatomic, copy) void (^addShopCartTrackEventCallBack)(NSString *productId);
/// 展示样式
@property (nonatomic, assign) TNGoodsDisplayStyle displayStyle;
/// 是否需要展示热卖标签  目前专题热卖商品才需要  展示热卖则隐藏折扣显示
@property (nonatomic, assign) BOOL isNeedShowHotSale;
/// 是否是来自专题2 的商品展示
@property (nonatomic, assign) CGFloat isFromSpecialVercialStyle;
/// 是否需要展示卖家热卖图标
@property (nonatomic, assign) BOOL isNeedShowSellerHotSale;

// 是否来自专题
@property (nonatomic, assign) BOOL isFromSpecialActivityController;
@end

NS_ASSUME_NONNULL_END
