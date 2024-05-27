//
//  WMNewStoreCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewStoreCell : SATableViewCell
/// 数据
@property (nonatomic, strong) WMStoreModel *model;

@end

NS_ASSUME_NONNULL_END
