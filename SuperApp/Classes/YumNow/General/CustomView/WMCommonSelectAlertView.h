//
//  WMCommonSelectAlertView.h
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAView.h"
#import "WMSelectRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCommonSelectAlertView : SAView <HDCustomViewActionViewProtocol>
/// 数据源
@property (nonatomic, copy) NSArray<WMSelectRspModel *> *dataSource;
/// 选中
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMSelectRspModel *model);
/// selectModel
@property (nonatomic, strong) WMSelectRspModel *selectModel;

@end


@interface WMCommonSelectAlertCell : SATableViewCell

@end

NS_ASSUME_NONNULL_END
