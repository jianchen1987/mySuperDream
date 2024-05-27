//
//  TNShopCarTabView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNShopCarTabView : TNView
/// 单买 批量疑问点击回调
@property (nonatomic, copy) void (^buyQustionCallBack)(TNSalesType salesType);
/// 单买  批量切换点击
@property (nonatomic, copy) void (^toggleCallBack)(TNSalesType salesType);

/// 设置当前选中的
- (void)setCurrentSalesType:(TNSalesType)salesType;
/// 更新单买总数
- (void)updateSingleCount:(NSInteger)count;
/// 更新批量总数
- (void)updateBatchCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
