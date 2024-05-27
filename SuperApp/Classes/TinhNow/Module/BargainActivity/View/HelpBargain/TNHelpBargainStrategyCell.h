//
//  TNHelpBargainStrategyCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/3/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNHelpBargainStrategyCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNBargainDetailModel *model;
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示
@property (nonatomic, copy) void (^getRealImageSizeCallBack)(void);
@end

NS_ASSUME_NONNULL_END
