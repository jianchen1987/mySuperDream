//
//  TNProductChooseSpecificationsView.h
//  SuperApp
//
//  Created by seeu on 2020/7/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN

@class TNSkuSpecModel;
@class TNItemModel;


@interface TNProductChooseSpecificationsView : HDActionAlertView

/// 创建规格选择弹窗
/// @param model 商品规格数据
/// @param buyType 立即购买 or 加入购物车
- (instancetype)initWithProductModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType;

/// 添加购物车回调
@property (nonatomic, copy) void (^addToCartBlock)(TNItemModel *itemModel);

@end

NS_ASSUME_NONNULL_END
