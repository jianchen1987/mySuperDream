//
//  SACouponListViewController.h
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponFilterView.h"
#import "SATableView.h"
#import "SAViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface SACouponListViewController : SAViewController <HDCategoryListContentViewDelegate>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 业务线
@property (nonatomic, copy) SAClientType businessLine;

@property (nonatomic, strong, readonly) SACouponFilterView *filterView; ///< 筛选栏

@end

NS_ASSUME_NONNULL_END
