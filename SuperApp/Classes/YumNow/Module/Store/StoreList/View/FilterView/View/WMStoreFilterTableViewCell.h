//
//  WMStoreFilterTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreFilterTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreFilterTableViewCell : SATableViewCell
@property (nonatomic, strong) WMStoreFilterTableViewCellBaseModel *model; ///< 数据模型
@end

NS_ASSUME_NONNULL_END
