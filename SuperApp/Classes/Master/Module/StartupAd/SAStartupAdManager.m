//
//  SAStartupAdManager.m
//  SuperApp
//
//  Created by Chaos on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAStartupAdManager.h"
#import "SACacheManager.h"
#import "SAStartupAdController.h"
#import "SAStartupAdModel.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDWebImageManager.h>
#import <UIKit/UIKit.h>

#pragma mark - SAStartupAdWindow


@interface SAStartupAdWindow : UIWindow

@end


@implementation SAStartupAdWindow
- (void)becomeKeyWindow {
    UIWindow *appWindow = SAWindowManager.keyWindow;
    [appWindow makeKeyWindow];
}
@end

#pragma mark - SAStartupAdManager


@implementation SAStartupAdManager
UIWindow *__startupAdWindow = nil;

+ (BOOL)isVisible {
    return !HDIsObjectNil(__startupAdWindow);
}

+ (void)adjustShouldShowStartupAdWindow {
    // 需要展示的广告模型
    SAStartupAdModel *adModel = [self getNeedShowAdModel];
    // 全部变量 block 不会捕获
    void (^destoryWindowAnimated)(BOOL, NSString *) = ^(BOOL animated, NSString *openUrl) {
        if (!__startupAdWindow) {
            return;
        }
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                __startupAdWindow.top = UIScreen.mainScreen.bounds.size.height;
            } completion:^(BOOL finished) {
                // 使原来的 rootViewController 释放
                __startupAdWindow = nil;
                if (HDIsStringNotEmpty(openUrl)) {
                    [SAWindowManager openUrl:openUrl withParameters:nil];
                }
            }];
        } else {
            // 使原来的 rootViewController 释放
            __startupAdWindow = nil;
            if (HDIsStringNotEmpty(openUrl)) {
                [SAWindowManager openUrl:openUrl withParameters:nil];
            }
        }
    };

    if (HDIsObjectNil(adModel)) {
        destoryWindowAnimated(false, nil);
        return;
    }

    destoryWindowAnimated(false, nil);
    SAStartupAdController *vc = SAStartupAdController.new;
    vc.adModel = adModel;
    vc.closeBlock = ^(NSString *_Nullable routeForClose) {
        destoryWindowAnimated(true, routeForClose);
    };
    vc.clickAdBlock = ^(NSString *_Nonnull openUrl) {
        destoryWindowAnimated(true, openUrl);
    };
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.rootViewController = vc;
    // 确保最顶层显示
    window.windowLevel = HDActionAlertViewWindowLevel + 6;

    @HDWeakify(window);
    [HDAlertQueueManager showWithObserver:window priority:HDAlertQueuePriorityHigh showInController:nil showBlock:^{
        @HDStrongify(window);
        __startupAdWindow = window;
        [__startupAdWindow makeKeyAndVisible];
    } dismissBlock:^{
        destoryWindowAnimated(true, nil);
    }];
}

+ (void)saveAdModels:(NSArray<SAStartupAdModel *> *)adModels {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 恢复数据展示状态，下载图片及视频
        [self regainDataAndDownloadResourceWithAdModels:adModels];
    });
}

#pragma mark - private methods
// 获取当前需要展示的广告
+ (SAStartupAdModel *)getNeedShowAdModel {
    NSArray<SAStartupAdModel *> *cacheAdModels = [SACacheManager.shared objectForKey:kCacheKeyStartupAdCache type:SACacheTypeDocumentPublic];
    if (HDIsArrayEmpty(cacheAdModels)) {
        return nil;
    }
    // 当前可以展示的所有广告
    NSArray<SAStartupAdModel *> *inShowQueueModels = [cacheAdModels hd_filterWithBlock:^BOOL(SAStartupAdModel *_Nonnull item) {
        return item.isEligible;
    }];
    // 当前可以展示的广告队列不为空，返回第一个，并移至缓存最后
    if (!HDIsArrayEmpty(inShowQueueModels)) {
        SAStartupAdModel *showModel = inShowQueueModels.firstObject;
        NSMutableArray<SAStartupAdModel *> *newCache = cacheAdModels.mutableCopy;
        [newCache removeObject:showModel];
        [newCache addObject:showModel];
        [SACacheManager.shared setObject:newCache forKey:kCacheKeyStartupAdCache type:SACacheTypeDocumentPublic];
        return showModel;
    }
    return nil;
}

// 恢复数据展示状态，下载图片及视频
+ (void)regainDataAndDownloadResourceWithAdModels:(NSArray<SAStartupAdModel *> *)adModels {
    NSMutableArray<SAStartupAdModel *> *newCache = [NSMutableArray arrayWithCapacity:adModels.count];
    // 先插入缓存中未过期的配置
    NSArray<SAStartupAdModel *> *cacheAdModels = [SACacheManager.shared objectForKey:kCacheKeyStartupAdCache type:SACacheTypeDocumentPublic];
    for (SAStartupAdModel *cacheModel in cacheAdModels) {
        // 重写了SAStartupAdModel的 isEqual 方法，id、链接、时间都相同，则认为是同一个广告
        if ([adModels containsObject:cacheModel]) {
            // 如果缓存中的图片或视频文件不存在，则置空
            if (HDIsStringNotEmpty(cacheModel.imagePath) && ![HDFileUtil isFileExistedFilePath:[NSString stringWithFormat:@"%@%@", DocumentsPath, cacheModel.imagePath]]) {
                cacheModel.imagePath = nil;
            }
            if (HDIsStringNotEmpty(cacheModel.videoPath) && ![HDFileUtil isFileExistedFilePath:[NSString stringWithFormat:@"%@%@", DocumentsPath, cacheModel.videoPath]]) {
                cacheModel.videoPath = nil;
            }
            [newCache addObject:cacheModel];
        } else {
            // 删除过期的图片、视频文件
            if (HDIsStringNotEmpty(cacheModel.imagePath)) {
                [HDFileUtil removeFileOrDirectory:[NSString stringWithFormat:@"%@%@", DocumentsPath, cacheModel.imagePath]];
            }
            if (HDIsStringNotEmpty(cacheModel.videoPath)) {
                [HDFileUtil removeFileOrDirectory:[NSString stringWithFormat:@"%@%@", DocumentsPath, cacheModel.videoPath]];
            }
        }
    }
    // 再将新配置中多的部分放到数组末尾
    for (SAStartupAdModel *model in adModels) {
        if (![newCache containsObject:model]) {
            [newCache addObject:model];
        }
    }

    dispatch_group_t taskGroup = dispatch_group_create();
    for (SAStartupAdModel *model in newCache) {
        if ([model.mediaType isEqualToString:SAStartupAdTypeImage]) {
            // 如果图片已下载或图片链接为空，则跳过
            if (HDIsStringNotEmpty(model.imagePath) || HDIsStringEmpty(model.url)) {
                continue;
            }
            dispatch_group_enter(taskGroup);
            [self downloadImageWithUrl:model.url completion:^(NSString *_Nullable imagePath) {
                model.imagePath = imagePath;
                dispatch_group_leave(taskGroup);
            }];
        } else if ([model.mediaType isEqualToString:SAStartupAdTypeVideo]) {
            // 如果视频已下载，则跳过
            if (HDIsStringNotEmpty(model.videoPath)) {
                continue;
            }
            dispatch_group_enter(taskGroup);
            [self downloadVideoWithUrl:model.url completion:^(NSString *_Nullable filePath) {
                model.videoPath = filePath;
                dispatch_group_leave(taskGroup);
            }];
        }
    }
    // 所有资源下载完成再存储
    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^() {
        //        for (SAStartupAdModel *m in newCache) {
        //            HDLog(@"2222-%@--%@",m.mediaType,m.url);
        //        }
        NSArray<SAStartupAdModel *> *cacheAdModels2 = [SACacheManager.shared objectForKey:kCacheKeyStartupAdCache type:SACacheTypeDocumentPublic];
        //        for (SAStartupAdModel *m in cacheAdModels2) {
        //            HDLog(@"3333-%@--%@",m.mediaType,m.url);
        //        }
        //
        //处理启动广告重复播放问题，重新再处理一次
        if (newCache.count > 1 && cacheAdModels2.count > 1 && [cacheAdModels2.lastObject isEqual:newCache.firstObject]) {
            SAStartupAdModel *m = newCache.firstObject;
            [newCache removeObject:m];
            [newCache addObject:m];
        }
        //
        //        for (SAStartupAdModel *m in newCache) {
        //            HDLog(@"4444-%@--%@",m.mediaType,m.url);
        //        }

        [SACacheManager.shared setObject:newCache forKey:kCacheKeyStartupAdCache type:SACacheTypeDocumentPublic];
    });
}

// 下载图片
+ (void)downloadImageWithUrl:(NSString *)url completion:(void (^)(NSString *_Nullable imagePath))completion {
    // HDWebImageManager需要在主线程给UIImageView设置image
    dispatch_async(dispatch_get_main_queue(), ^{
        [HDWebImageManager setImageWithURL:url placeholderImage:nil imageView:UIImageView.new
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     if (error) {
                                         completion(nil);
                                         return;
                                     }
                                     dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                         NSString *downloadPath = [self downloadPathWithUrl:url type:SAStartupAdTypeImage];
                                         if ([image.hd_rawData writeToFile:downloadPath atomically:true]) {
                                             completion([self deleteDocumentDirectoryWithDownloadPath:downloadPath]);
                                         } else {
                                             completion(nil);
                                         }
                                     });
                                 }];
    });
}

// 下载视频
+ (void)downloadVideoWithUrl:(NSString *)url completion:(void (^)(NSString *_Nullable filePath))completion {
    NSString *downloadPath = [self downloadPathWithUrl:url type:SAStartupAdTypeVideo];
    HDNetworkRequest *request = HDNetworkRequest.new;
    request.baseURI = url;
    request.requestURI = @"";
    request.downloadPath = downloadPath;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        completion([self deleteDocumentDirectoryWithDownloadPath:downloadPath]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        completion(nil);
    }];
}

// 视频/图片存储地址（完整地址）
+ (NSString *)downloadPathWithUrl:(NSString *)url type:(SAStartupAdType)type {
    NSString *fileDirectory = [NSString stringWithFormat:@"%@/%@/", DocumentsPath, @"startupAd".hd_md5];
    if (fileDirectory && [[NSFileManager defaultManager] fileExistsAtPath:fileDirectory] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *fileType = @"";
    if ([type isEqualToString:SAStartupAdTypeImage]) {
        fileType = @"jpg";
    } else if ([type isEqualToString:SAStartupAdTypeVideo]) {
        fileType = @"mp4";
    }
    return [NSString stringWithFormat:@"%@%@.%@", fileDirectory, url.hd_md5, fileType];
}

// 存储地址去除Document目录（每次运行Document目录不一致，存储完整路径的话会找不到资源，需要后续自己拼接Document目录）
+ (NSString *)deleteDocumentDirectoryWithDownloadPath:(NSString *)downloadPath {
    return [downloadPath stringByReplacingOccurrencesOfString:DocumentsPath withString:@""];
}

@end
