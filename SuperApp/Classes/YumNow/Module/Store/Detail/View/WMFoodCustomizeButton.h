//
//  WMFoodCustomizeButton.h
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOperationButton.h"
#import "WMStoreStatusModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFoodCustomizeButton : WMOperationButton
/// 更新数量
- (void)updateUIWithCount:(NSUInteger)count storeStatus:(WMStoreStatus)storeStatus;
@end

NS_ASSUME_NONNULL_END
