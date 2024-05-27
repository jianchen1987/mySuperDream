//
//  WMOrderDetailCancelReasonView.h
//  SuperApp
//
//  Created by wmz on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAView.h"
#import "WMOrderCancelReasonModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailCancelReasonView : SAView <HDCustomViewActionViewProtocol>

@property (nonatomic, assign) BOOL fromUnCancelView;

@property (nonatomic, copy) NSArray<WMOrderCancelReasonModel *> *dataSource;
/// 选中
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMOrderCancelReasonModel *model);

@end


@interface WMOrderDetailCancelReasonCell : SATableViewCell

@property (nonatomic, strong) WMOrderCancelReasonModel *model;

@end

NS_ASSUME_NONNULL_END
