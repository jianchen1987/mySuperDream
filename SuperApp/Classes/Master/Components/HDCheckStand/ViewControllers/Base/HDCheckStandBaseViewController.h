//
//  HDCheckStandBaseViewController.h
//  SuperApp
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandCustomNavBarView.h"
#import "HDCheckStandViewController.h"
#import "HDCheckstandDTO.h"
#import "HDTradeBuildOrderModel.h"
#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandBaseViewController : SAViewController
@property (nonatomic, strong, readonly) UIView *containerView;                    ///< 容器
@property (nonatomic, strong, readonly) HDCheckstandDTO *checkStandDTO;           ///< 收银台 DTO
@property (nonatomic, strong, readonly) HDCheckStandViewController *checkStand;   ///< 收银台
@property (nonatomic, strong, readonly) HDCheckStandCustomNavBarView *navBarView; ///< 导航栏
@property (nonatomic, assign) HDCheckStandViewControllerStyle style;              ///< 风格

- (void)setTitleBtnImage:(NSString *_Nullable)imageName title:(NSString *_Nullable)title font:(UIFont *_Nullable)font;
/**
 动画隐藏界面并 dismiss 收银台，调用关闭订单接口
 */
- (void)hideContainerViewAndDismissCheckStand;
- (void)hideContainerViewAndDismissCheckStandFinshed:(void (^__nullable)(void))finishedHandler;
/**
 动画隐藏界面并 dismiss 收银台，不调用关闭订单接口
 */
- (void)hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:(void (^__nullable)(void))finishedHandler;
/** 关闭订单 */
- (void)closePaymentFinshed:(void (^)(void))finished;
@end

NS_ASSUME_NONNULL_END
