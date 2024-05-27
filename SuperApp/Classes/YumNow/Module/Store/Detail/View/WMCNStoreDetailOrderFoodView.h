//
//  WMCNStoreDetailOrderFoodView.h
//  SuperApp
//
//  Created by wmz on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableView.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCNStoreDetailOrderFoodView : SAView
///分类
@property (nonatomic, strong) SATableView *sortTableView;
///商品
@property (nonatomic, strong) SATableView *tableView;
///选中
@property (nonatomic, assign) NSInteger sortSelectIndex;
/// 限购提示文案
@property (strong, nonatomic) UIView *limitTipsView;

@end

NS_ASSUME_NONNULL_END
