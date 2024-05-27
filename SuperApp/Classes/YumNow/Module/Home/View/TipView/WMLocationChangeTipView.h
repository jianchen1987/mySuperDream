//
//  WMLocationChangeTipView.h
//  SuperApp
//
//  Created by Tia on 2023/7/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMLocationChangeTipView : SAView
/// 重新定位回调
@property (nonatomic, copy) dispatch_block_t relocationBlock;

- (void)show;

- (void)dissmiss;

@end

NS_ASSUME_NONNULL_END
