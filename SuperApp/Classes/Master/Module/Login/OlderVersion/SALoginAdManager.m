//
//  SALoginAdManager.m
//  SuperApp
//
//  Created by Tia on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginAdManager.h"
#import "HDFileUtil.h"
#import "HDNetworkRequest.h"
#import "SACacheManager.h"
#import "SAEnum.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit/HDWebImageManager.h>

NSString *const kCacheKeyLoginAdConfigsLinks = @"links";

NSString *const kCacheKeyLoginAdConfigsFileType = @"fileType";

NSString *const kCacheKeyLoginAdConfigsLinkDic = @"linkDic";

NSString *const kCacheKeyLoginAdConfigsFileTypePicture = @"picture";

NSString *const kCacheKeyLoginAdConfigsFileTypeVideo = @"video";


@implementation SALoginAdManager

+ (void)saveLoginAdConfigs:(NSDictionary *)configs {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 恢复数据展示状态，下载图片及视频
        [self regainDataAndDownloadResourceWithConfigs:(NSDictionary *)configs];
    });
}

// 恢复数据展示状态，下载图片及视频
+ (void)regainDataAndDownloadResourceWithConfigs:(NSDictionary *)configs {
    NSMutableDictionary *mDic = configs.mutableCopy;
    NSMutableDictionary *newLinkDic = NSMutableDictionary.new;

    NSArray *links = configs[kCacheKeyLoginAdConfigsLinks];
    NSString *fileType = configs[kCacheKeyLoginAdConfigsFileType];

    NSDictionary *oldConfigs = [SACacheManager.shared objectForKey:kCacheKeyLoginAdConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
    //判断有没有缓存
    if (oldConfigs) {
        //        HDLog(@"有登录广告缓存");
        NSArray *oldLinks = oldConfigs[kCacheKeyLoginAdConfigsLinks];
        NSDictionary *oldLinkDic = oldConfigs[kCacheKeyLoginAdConfigsLinkDic];
        NSString *oldFileType = oldConfigs[kCacheKeyLoginAdConfigsFileType];

        if ([fileType isEqualToString:oldFileType]) {
            for (NSString *urlStr in oldLinks) { //获取旧模型的url
                NSString *path = oldLinkDic[urlStr];
                if (HDIsStringNotEmpty(path)) {
                    //                    HDLog(@"有缓存路径 path =%@",path);
                    if ([links containsObject:urlStr]) {
                        if ([HDFileUtil isFileExistedFilePath:[NSString stringWithFormat:@"%@%@", DocumentsPath, path]]) {
                            //                            HDLog(@"有缓存文件");
                            newLinkDic[urlStr] = path;
                        } else {
                            //                            HDLog(@"没有缓存文件");
                        }
                    } else {
                        // 删除过期的图片、视频文件
                        [HDFileUtil removeFileOrDirectory:[NSString stringWithFormat:@"%@%@", DocumentsPath, path]];
                        //                        HDLog(@"移除旧文件 path =%@",path);
                    }
                } else {
                    //                    HDLog(@"没有缓存路径 url =%@",urlStr);
                }
            }
        }
    }

    //    HDLog(@"newLinkDic = %@",newLinkDic);

    dispatch_group_t taskGroup = dispatch_group_create();

    for (NSString *urlStr in links) {
        NSString *path = newLinkDic[urlStr];
        if (HDIsStringEmpty(path)) { //没有获取路径

            if ([fileType isEqualToString:kCacheKeyLoginAdConfigsFileTypePicture]) {
                dispatch_group_enter(taskGroup);
                //                HDLog(@"下载登录广告图片 url = %@", urlStr);
                [self downloadImageWithUrl:urlStr completion:^(NSString *_Nullable imagePath) {
                    //                                    HDLog(@"下载完成登录广告图片 path = %@", imagePath);
                    newLinkDic[urlStr] = imagePath;
                    dispatch_group_leave(taskGroup);
                }];
            } else if ([fileType isEqualToString:kCacheKeyLoginAdConfigsFileTypeVideo]) {
                dispatch_group_enter(taskGroup);
                //                HDLog(@"下载登录广告视频 url = %@", urlStr);
                [self downloadVideoWithUrl:urlStr completion:^(NSString *_Nullable filePath) {
                    //                                    HDLog(@"下载完成登录广告视频 path = %@", filePath);
                    newLinkDic[urlStr] = filePath;
                    dispatch_group_leave(taskGroup);
                }];
            }
        }
    }

    //    HDLog(@"newLinkDic = %@",newLinkDic);
    // 所有资源下载完成再存储
    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^() {
        mDic[kCacheKeyLoginAdConfigsLinkDic] = newLinkDic;
        //        HDLog(@"mDic = %@",mDic);
        [SACacheManager.shared setObject:mDic forKey:kCacheKeyLoginAdConfigs type:SACacheTypeDocumentPublic];
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
