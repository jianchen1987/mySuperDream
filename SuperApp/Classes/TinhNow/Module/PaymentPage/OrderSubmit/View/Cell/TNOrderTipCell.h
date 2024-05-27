//
//  TNOrderSubmitTipCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderTipCellModel : TNModel
/// 显示文本
@property (nonatomic, copy) NSString *tipText;
/// 是否是订单详情的提示  订单详情的展示有差异
@property (nonatomic, assign) BOOL isFromOrderDetail;
/// 是否需要展示刷新按钮
@property (nonatomic, assign) BOOL isNeedShowRefreshBtn;
@end


@interface TNOrderTipCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNOrderTipCellModel *model;
/// 订单详情的提示文本  会有一个刷新按钮的点击
@property (nonatomic, copy) void (^refreshClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
