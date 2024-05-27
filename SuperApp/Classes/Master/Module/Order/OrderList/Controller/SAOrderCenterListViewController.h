//
//  SAOrderCenterListViewController.h
//  SuperApp
//
//  Created by Tia on 2023/2/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACMSDefine.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderCenterListViewController : SAViewController <HDCategoryListContentViewDelegate>
@property (nonatomic, assign) SAOrderState orderState; ///< 查询的订单状态
@property (nonatomic, copy) SAClientType businessLine; ///< 业务线
/// 起始时间
@property (nonatomic, copy) NSString *orderTimeStart;
/// 结束时间
@property (nonatomic, copy) NSString *orderTimeEnd;
/// 搜索关键字
@property (nonatomic, copy) NSString *keyName;

@property (nonatomic, copy) CMSPageIdentify pageIdentify;

- (void)getNewData;

@end

NS_ASSUME_NONNULL_END
