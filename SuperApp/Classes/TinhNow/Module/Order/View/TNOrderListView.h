//
//  TNOrderListView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderListView : TNView <HDCategoryListContentViewDelegate>
/// 刷新订单tab数据
@property (nonatomic, copy) void (^reloadOrderCountCallBack)(void);
// 通过状态初始化
- (instancetype)initWithState:(TNOrderState)state;
@end

NS_ASSUME_NONNULL_END
