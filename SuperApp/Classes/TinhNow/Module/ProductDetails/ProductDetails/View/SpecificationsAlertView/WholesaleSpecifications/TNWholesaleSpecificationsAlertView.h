//
//  TNWholesaleSpecificationsAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNSkuSpecModel.h"
#import <HDUIKit/HDUIKit.h>
@class TNItemModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNWholesaleSpecificationsAlertView : HDActionAlertView

/// 初始化一个批发商品弹窗
/// @param model 批发数据
/// @param buyType 立即购买 or  加入购物车
- (instancetype)initWithSpecModel:(TNSkuSpecModel *)model buyType:(TNProductBuyType)buyType;
/// 立即购买回调
@property (nonatomic, copy) void (^buyNowCallBack)(TNItemModel *item);
/// 加入购物车回调
@property (nonatomic, copy) void (^addToCartCallBack)(TNItemModel *item);
@end

NS_ASSUME_NONNULL_END
