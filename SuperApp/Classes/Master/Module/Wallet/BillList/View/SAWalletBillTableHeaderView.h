//
//  SAWalletBillTableHeaderView.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import "SAWalletBillTableHeaderViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillTableHeaderView : SATableHeaderFooterView
/// 模型
@property (nonatomic, strong) SAWalletBillTableHeaderViewModel *model;
@end

NS_ASSUME_NONNULL_END
