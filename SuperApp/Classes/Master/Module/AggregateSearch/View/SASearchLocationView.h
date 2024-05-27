//
//  SASearchLocationView.h
//  SuperApp
//
//  Created by Tia on 2023/7/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchLocationView : SAView
/// 详细地址
@property (nonatomic, strong) SALabel *detailAddressLB;
/// 点击事件
@property (nonatomic, copy) dispatch_block_t clickedHandler;
/// 点击返回事件
@property (nonatomic, copy) dispatch_block_t clickedBackHandler;

- (void)updateCurrentAdddress;

@end

NS_ASSUME_NONNULL_END
