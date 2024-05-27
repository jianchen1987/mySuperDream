//
//  TNBargainGoodInfoCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodInfoCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNBargainDetailModel *model;
/// 是否来自帮砍页面
@property (nonatomic, assign) BOOL isFromHelpBargain;
@end

NS_ASSUME_NONNULL_END
