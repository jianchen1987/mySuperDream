//
//  TNHelpBargainInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNHelpBargainInfoCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNBargainDetailModel *model;
/// 帮砍一刀回调
@property (nonatomic, copy) void (^helpBargainClickCallBack)(void);
/// 发起我的助力
@property (nonatomic, copy) void (^startMyBargainClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
