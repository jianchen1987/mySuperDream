//
//  WMOrderFeedBackView.h
//  SuperApp
//
//  Created by wmz on 2021/11/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackView : SAView
/// 点击
@property (nonatomic, copy) void (^clickedBlock)(void);
/// 用户是否创建过售后反馈单
@property (nonatomic, assign) BOOL hasPostSale;
/// 反馈进度
@property (nonatomic, copy) WMOrderFeedBackHandleStatus handleStatus;
/// 售后反馈状态展示类型
@property (nonatomic, copy) WMOrderFeedBackStepShowType postSaleShowType;

- (void)updateContent;
@end

NS_ASSUME_NONNULL_END
