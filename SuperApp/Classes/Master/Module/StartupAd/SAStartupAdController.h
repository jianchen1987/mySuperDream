//
//  SAStartupAdController.h
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SAStartupAdModel;


@interface SAStartupAdController : SAViewController
/// 展示的广告
@property (nonatomic, strong) SAStartupAdModel *adModel;
@property (nonatomic, copy) NSString *routeForClose; ///< 关闭后要跳转的路由，外部传入，解决带路由唤起app时被广告图拦截的问题

/// 点击广告
@property (nonatomic, copy) void (^clickAdBlock)(NSString *openUrl);
/// 关闭广告
@property (nonatomic, copy) void (^closeBlock)(NSString *_Nullable openUrl);
@end

NS_ASSUME_NONNULL_END
