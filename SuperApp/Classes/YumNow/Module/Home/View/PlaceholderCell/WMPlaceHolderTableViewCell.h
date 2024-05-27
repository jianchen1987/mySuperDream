//
//  WMPlaceHolderTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/8/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMPlaceHolderTableViewCellModel : WMModel

@end


@interface WMPlaceHolderTableViewCell : SATableViewCell
/// model
@property (nonatomic, strong) WMPlaceHolderTableViewCellModel *model;
@end

NS_ASSUME_NONNULL_END
