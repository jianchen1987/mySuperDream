//
//  SAStartupAdManager.h
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SAStartupAdModel;


@interface SAStartupAdManager : NSObject
/// 内部决定是否显示启动广告页
+ (void)adjustShouldShowStartupAdWindow;
/// 是否正在展示
+ (BOOL)isVisible;
/// 缓存请求回来的启动广告数据并处理，下次启动时直接从缓存获取并展示
+ (void)saveAdModels:(NSArray<SAStartupAdModel *> *)adModels;
@end

NS_ASSUME_NONNULL_END
