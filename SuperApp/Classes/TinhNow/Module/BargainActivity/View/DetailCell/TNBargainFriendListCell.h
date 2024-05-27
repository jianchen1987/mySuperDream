//
//  TNBargainFriendListCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainFriendListCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNBargainDetailModel *model;
/// 分享点击
@property (nonatomic, copy) void (^shareClickCallBack)(void);
/// 查看订单点击
@property (nonatomic, copy) void (^orderDetailClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
