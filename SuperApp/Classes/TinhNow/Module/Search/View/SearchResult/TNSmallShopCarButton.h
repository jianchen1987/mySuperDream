//
//  TNSmallShopCarButton.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TNGoodsModel;
@class TNItemModel;


@interface TNSmallShopCarButton : UIView
/// 商品模型
@property (strong, nonatomic) TNGoodsModel *goodModel;
/// 加入购物车埋点
@property (nonatomic, copy) void (^addShopCartTrackEventCallBack)(NSString *productId, TNItemModel *itemModel);

@end

NS_ASSUME_NONNULL_END
