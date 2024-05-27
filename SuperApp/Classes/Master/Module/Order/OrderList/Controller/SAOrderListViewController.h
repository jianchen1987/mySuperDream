//
//  SAOrderListViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListViewController : SAViewController <HDCategoryListContentViewDelegate>
@property (nonatomic, assign) SAOrderState orderState; ///< 查询的订单状态
@property (nonatomic, copy) SAClientType businessLine; ///< 业务线
@end

NS_ASSUME_NONNULL_END
