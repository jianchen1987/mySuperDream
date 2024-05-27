//
//  SAMCListCell.h
//  SuperApp
//
//  Created by Tia on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SASystemMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMCListCell : SATableViewCell

@property (nonatomic, strong) SASystemMessageModel *model;

@end

NS_ASSUME_NONNULL_END
