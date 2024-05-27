//
//  WMReviewFilterView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMReviewFilterButtonConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMReviewFilterView : SAView
/// 是否设置 fittingSize，默认为 true
@property (nonatomic, assign) BOOL shouldLayoutSizeFittingSize;
/// 是否显示底部分割线，默认否
@property (nonatomic, assign) BOOL showBottomSepLine;
/// 数据源
@property (nonatomic, copy) NSArray<WMReviewFilterButtonConfig *> *dataSource;
/// 当前 config
@property (nonatomic, strong, readonly) WMReviewFilterButtonConfig *config;
/// 默认选中是否必须有评论
@property (nonatomic, assign) BOOL defaultHasContentButtonStatus;
/// 当前是否选中必须有评论
@property (nonatomic, assign, readonly) BOOL hasContentButtonSelected;
/// 选中了按钮回调
@property (nonatomic, copy) void (^clickedFilterButtonBlock)(HDUIGhostButton *button, WMReviewFilterButtonConfig *config);
/// 点击了是否必须有评论按钮
@property (nonatomic, copy) void (^clickedHasContentButtonBlock)(BOOL isSelected);

/// 刷新，更新标题和属性
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
