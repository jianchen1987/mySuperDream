//
//  SAUserBillListHeaderView.h
//  SuperApp
//
//  Created by seeu on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAUserBillListHeaderView : SATableHeaderFooterView
///< model
@property (nonatomic, strong) HDTableHeaderFootViewModel *model;

/// 点击标题回调
@property (nonatomic, copy, nullable) void (^titleClickedHander)(HDTableHeaderFootViewModel *headerModel);

@end

NS_ASSUME_NONNULL_END
