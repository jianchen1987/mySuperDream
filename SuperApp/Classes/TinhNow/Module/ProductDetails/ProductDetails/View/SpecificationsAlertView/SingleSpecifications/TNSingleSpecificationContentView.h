//
//  TNSingleSpecificationContentView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNItemModel;
@class TNSkuSpecModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSingleSpecificationContentView : TNView
/// 创建规格选择弹窗
/// @param model 商品规格数据
/// @param buyType 立即购买 or 加入购物车
- (instancetype)initWithProductModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType;
/// 添加购物车回调
@property (nonatomic, copy) void (^addToCartBlock)(TNItemModel *itemModel);
/// 点击了关闭按钮
@property (nonatomic, copy) void (^clickCloseCallBack)(void);
@end

NS_ASSUME_NONNULL_END
