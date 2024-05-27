//
//  TNTool.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNTool.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDVendorKit.h>


@implementation TNTool
+ (void)startDispatchTimerWithCountDown:(NSInteger)countDown callBack:(void (^)(NSInteger, dispatch_source_t _Nonnull))callBack {
    __block NSInteger second = countDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !callBack ?: callBack(second, timer);
            if (second == 0) {
                dispatch_cancel(timer);
            }
            second -= 1;
        });
    });
    dispatch_resume(timer);
}
+ (NSString *)getOrderStateNameByState:(TNOrderState)state {
    NSString *name;
    if ([state isEqualToString:TNOrderStatePendingReview]) {
        name = TNLocalizedString(@"yrT0b3vt", @"待审核");
    } else if ([state isEqualToString:TNOrderStatePendingPayment]) {
        name = TNLocalizedString(@"tn_pending_payment", @"待付款");
    } else if ([state isEqualToString:TNOrderStatePendingShipment]) {
        name = TNLocalizedString(@"tn_pending_shipment", @"待发货");
    } else if ([state isEqualToString:TNOrderStateShipped]) {
        name = TNLocalizedString(@"tn_shipped", @"待收货");
    } else if ([state isEqualToString:TNOrderStateCompleted]) {
        name = TNLocalizedString(@"tn_order_completed", @"已完成");
    } else if ([state isEqualToString:TNOrderStateCanceled]) {
        name = TNLocalizedString(@"tn_order_canced", @"已取消");
    }
    return name;
}

+ (void)startAddProductToCartAnimationWithImage:(NSString *)image startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint inView:(UIView *)inView completion:(void (^)(void))completion {
    // 创建UIImageView并添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    CGSize size = CGSizeMake(kRealWidth(56), kRealWidth(56));
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.center = startPoint;

    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = size.width / 2;
    [inView addSubview:imageView];
    [HDWebImageManager setImageWithURL:image placeholderImage:[HDHelper placeholderImageWithSize:size] imageView:imageView];

    // 计算抛物线路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGFloat x = (endPoint.x + startPoint.x) / 2 - 80;
    CGFloat y = MIN(startPoint.y, endPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, x, y, endPoint.x, endPoint.y);

    // 创建动画并设置相关属性
    CAKeyframeAnimation *parabolicAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    parabolicAnimation.path = path;
    parabolicAnimation.duration = 0.8;
    parabolicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    parabolicAnimation.removedOnCompletion = NO;
    parabolicAnimation.fillMode = kCAFillModeForwards;

    // 添加动画完成后的回调
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [imageView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    // 将抛物线动画添加到UIImageView的layer上
    [imageView.layer addAnimation:parabolicAnimation forKey:@"parabolicAnimation"];
    [CATransaction commit];

    // 缩小图片的动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.2;
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(0.4);
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [imageView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
@end
