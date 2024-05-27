//
//  WMShoppingCartEntryWindow.h
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNShoppingCartRootViewController : UIViewController
@end


@interface TNShoppingCartEntryWindow : UIView
+ (instancetype)sharedInstance;
/// 禁用拖动。默认开启手势，即不禁用
@property (nonatomic, assign) BOOL disablePanGesture;
/// 去单买购物车还是批量购物车
@property (nonatomic, copy) TNSalesType salesType;
/// 埋点回调
@property (nonatomic, copy) void (^cartClickTrackEventCallback)(void);
/// 展开
- (void)expand;
/// 收起
- (void)shrink;
/// 更新购物车按钮指示器标识
- (void)updateIndicatorDotWithCount:(NSUInteger)count;
/// 展示
- (void)show;
/// 隐藏
- (void)dismiss;
/// 设置购物车的Y坐标
- (void)setShoppintCarOffsetY:(CGFloat)offsetY;
///重置还原
- (void)resetShoppintCarOffsetY;

///获取相对定位
- (CGPoint)getCartButtonConvertPoint;
//购物车抖动一下
- (void)shake;

@end

NS_ASSUME_NONNULL_END
