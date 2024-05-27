//
//  WMStoreSearchResultTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreListItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreSearchResultTableViewCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
/// 展示配送范围
@property (nonatomic, assign) BOOL range;

@property (nonatomic, strong) WMStoreListItemModel *model; ///< 模型

@property (nonatomic, strong) WMStoreListNewItemModel *nModel; ///< 模型

/// 是否处于编辑状态  编辑状态
@property (nonatomic, assign) BOOL onEditing;
/// 点击了商品
@property (nonatomic, copy) void (^clickedProductViewBlock)(NSString *menuId, NSString *productId);
/// 点击了更多
@property (nonatomic, copy) void (^clickedMoreViewBlock)(void);
/// 点击优惠展开或者收起
@property (nonatomic, copy) void (^BlockOnClickPromotion)(void);

@end

NS_ASSUME_NONNULL_END
