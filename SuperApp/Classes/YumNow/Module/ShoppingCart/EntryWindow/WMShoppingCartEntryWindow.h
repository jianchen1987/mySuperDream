//
//  WMShoppingCartEntryWindow.h
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartButton.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartRootViewController : UIViewController
@end


@interface WMShoppingCartEntryWindow : UIWindow
+ (instancetype)sharedInstance;
/// 按钮
@property (nonatomic, strong) WMShoppingCartButton *entryBtn;
/// 禁用拖动。默认开启手势，即不禁用
@property (nonatomic, assign) BOOL disablePanGesture;
/// 数量
@property (nonatomic, assign) NSInteger count;
/// 展开
- (void)expand;
/// 收起
- (void)shrink;
/// 更新购物车按钮指示器标识
- (void)updateIndicatorDotWithCount:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
