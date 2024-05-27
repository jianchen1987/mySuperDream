//
//  TNWholesaleSpecificationContentView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNItemModel.h"
#import "TNSkuSpecModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWholesaleSpecificationContentView : TNView
/// 初始化一个批发商品弹窗
/// @param model 批发数据
/// @param buyType 立即购买 or  加入购物车
- (instancetype)initWithSpecModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType;

/// 立即购买或者加入购物车回调
@property (nonatomic, copy) void (^buyNowOraddToCartCallBack)(TNItemModel *item);
/// 点击了关闭按钮
@property (nonatomic, copy) void (^clickCloseCallBack)(void);
@end

NS_ASSUME_NONNULL_END
