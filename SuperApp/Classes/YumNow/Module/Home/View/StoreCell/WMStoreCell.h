//
//  WMStoreCell.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreCell : SATableViewCell
/// 数据
@property (nonatomic, strong) WMBaseStoreModel *model;
@end

NS_ASSUME_NONNULL_END
