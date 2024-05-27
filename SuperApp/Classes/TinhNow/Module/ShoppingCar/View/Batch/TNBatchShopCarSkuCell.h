//
//  TNBatchShopCarSkuCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNShoppingCarItemModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNBatchShopCarSkuCell : SATableViewCell
/// 模型
@property (nonatomic, strong) TNShoppingCarItemModel *model;
/// 点击了删除按钮
@property (nonatomic, copy) void (^clickedDeleteBTNBlock)(void);
/// 点击了加号
@property (nonatomic, copy) void (^clickedPlusBTNBlock)(NSUInteger addDelta, NSUInteger forwardCount);
/// 点击了减号
@property (nonatomic, copy) void (^clickedMinusBTNBlock)(NSUInteger deleteDelta, NSUInteger currentCount);
/// 点击加时数量达到最大事件回调
@property (nonatomic, copy) void (^maxCountLimtedHandler)(NSUInteger count);
/// 点击了选中按钮
@property (nonatomic, copy) void (^clickedSelectBTNBlock)(void);

///// 只是刷新列表
//@property (nonatomic, copy) void (^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
