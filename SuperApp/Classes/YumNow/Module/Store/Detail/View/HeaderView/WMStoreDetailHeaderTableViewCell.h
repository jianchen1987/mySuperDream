//
//  WMStoreDetailHeaderTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreDetailHeaderView.h"

@class WMCNStoreInfoView;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDetailHeaderTableViewCell : SATableViewCell
/// headView
@property (nonatomic, strong) WMStoreDetailHeaderView *headView;
/// 模型
@property (nonatomic, strong) WMStoreDetailRspModel *model;

@end

NS_ASSUME_NONNULL_END
