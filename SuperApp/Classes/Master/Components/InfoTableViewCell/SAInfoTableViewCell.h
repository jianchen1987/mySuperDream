//
//  SAInfoTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInfoViewModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAInfoTableViewCell : SATableViewCell
@property (nonatomic, strong) SAInfoViewModel *model; ///< 模型

- (void)showRightButton:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
