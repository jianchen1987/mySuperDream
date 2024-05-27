//
//  TNTool.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNEnum.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNTool : NSObject

/// 开启一个倒计时
/// @param countDown 倒计时秒数
/// @param callBack 回调
+ (void)startDispatchTimerWithCountDown:(NSInteger)countDown callBack:(void (^)(NSInteger second, dispatch_source_t timer))callBack;

/// 通过订单状态返回订单状态显示文案
+ (NSString *)getOrderStateNameByState:(TNOrderState)state;

/// 开启一个商品加入购物车的抛物线动画
/// @param image 需要加入购物车的图片
/// @param startPoint 开启的位置
/// @param endPoint 落点结束位置
/// @param inView 在哪个视图开启动画
/// @param completion 动画完成回调函数
+ (void)startAddProductToCartAnimationWithImage:(NSString *)image startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint inView:(UIView *)inView completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
