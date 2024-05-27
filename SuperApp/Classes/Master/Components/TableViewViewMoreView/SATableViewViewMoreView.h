//
//  SATableViewViewMoreView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "SATableViewViewMoreViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 查看更多，设计为 UITableViewCell 是为了使用自动布局 */
@interface SATableViewViewMoreView : SATableViewCell
@property (nonatomic, strong) SATableViewViewMoreViewModel *model; ///< 数据
@property (nonatomic, copy) void (^clickedOperationButonHandler)(void);

@end

NS_ASSUME_NONNULL_END
