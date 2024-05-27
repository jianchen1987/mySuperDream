//
//  SAMCChatListCell.h
//  SuperApp
//
//  Created by Tia on 2023/4/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SAMessageModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMCChatListCell : SATableViewCell

@property (nonatomic, strong) SAMessageModel *model; ///< 数据模型

@end

NS_ASSUME_NONNULL_END
