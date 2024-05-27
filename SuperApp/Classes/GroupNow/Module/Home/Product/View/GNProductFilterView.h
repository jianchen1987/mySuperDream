//
//  GNProductFilterView.h
//  SuperApp
//
//  Created by wmz on 2021/7/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNProductModel.h"
#import "GNTableView.h"
#import "GNTableViewCell.h"
#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNFilterTextCell : GNTableViewCell

@end


@interface GNProductFilterView : GNView
///初始frame
@property (nonatomic, assign) CGRect normalRect;
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
/// 展示
@property (nonatomic, assign, getter=isShow) BOOL show;
/// 数据源
@property (nonatomic, copy) NSArray<GNProductModel *> *dataSource;
/// 阴影
@property (nonatomic, strong) UIView *shadomView;
/// dafavIEW
@property (nonatomic, strong) UIView *dataView;
/// 头部
@property (nonatomic, strong) UIView *headView;
/// viewWillAppear
@property (nonatomic, copy) void (^viewWillAppear)(UIView *view);
/// viewWillDisappear
@property (nonatomic, copy) void (^viewWillDisappear)(UIView *view);
/// 弹出
- (void)show:(UIView *)parentView;

/// 消失
- (void)dissmiss;

@end

NS_ASSUME_NONNULL_END
