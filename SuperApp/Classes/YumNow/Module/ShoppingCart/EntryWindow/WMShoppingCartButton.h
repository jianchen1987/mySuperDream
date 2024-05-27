//
//  WMShoppingCartButton.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartButton : UIButton
/// 更新购物车按钮指示器标识
- (void)updateIndicatorDotWithCount:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
