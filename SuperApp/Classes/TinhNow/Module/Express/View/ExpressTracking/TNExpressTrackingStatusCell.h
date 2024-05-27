//
//  TNExpressTrackingStatusCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNExpressTrackingStatusCellModel : TNModel
/// 文案
@property (nonatomic, copy) NSString *contentText;
/// 是否隐藏右箭头
@property (nonatomic, assign) BOOL isNeedHiddenArrowIV;
@end


@interface TNExpressTrackingStatusCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNExpressTrackingStatusCellModel *model;
@end

NS_ASSUME_NONNULL_END
