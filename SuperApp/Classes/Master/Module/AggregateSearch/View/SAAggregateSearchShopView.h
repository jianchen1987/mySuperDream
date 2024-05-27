//
//  SAAggregateSearchShopView.h
//  SuperApp
//
//  Created by Tia on 2022/11/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAggregateSearchShopView : SAView
/// 点击回调
@property (nonatomic, copy) dispatch_block_t clickBlock;

@end

NS_ASSUME_NONNULL_END
