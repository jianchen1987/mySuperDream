//
//  PNGameDetailCardCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailRspModel.h"
#import "PNTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameDetailCardCell : PNTableViewCell
///
@property (strong, nonatomic) PNGameDetailRspModel *model;
/// 点击回调
@property (nonatomic, copy) void (^itemClickCallBack)(PNGameItemModel *model);
@end

NS_ASSUME_NONNULL_END
