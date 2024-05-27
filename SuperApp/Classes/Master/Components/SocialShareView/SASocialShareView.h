//
//  SASocialShareView.h
//  SuperApp
//
//  Created by Chaos on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShareImageObject.h"
#import "SAShareMacro.h"
#import "SAShareWebpageObject.h"
#import "SASocialShareBaseGenerateImageView.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SAShareFunction NS_STRING_ENUM;
FOUNDATION_EXPORT SAShareFunction const SAShareFunctionlCopyLink;      ///< 复制链接
FOUNDATION_EXPORT SAShareFunction const SAShareFunctionlGenerateImage; ///< 生成图片
FOUNDATION_EXPORT SAShareFunction const SAShareFunctionlSaveImage;     ///< 保存图片

// 分享完成回调
typedef void (^ShareObjectCompletion)(BOOL success, NSString *_Nullable shareChannel);


@interface SASocialShareView : HDSocialShareAlertView

/// 弹出分享弹窗（分享链接的话自动添加复制链接按钮）
/// @param shareObject 分享模型
/// @param completion 回调
+ (void)showShareWithShareObject:(SAShareObject *)shareObject completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗（分享链接的话自动添加复制链接按钮）
/// @param shareObject 分享模型
/// @param channels 分享渠道
/// @param completion 回调
+ (void)showShareWithShareObject:(SAShareObject *)shareObject inChannels:(NSArray<SAShareChannel> *)channels completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗（分享链接的话自动添加复制链接按钮）
/// @param shareObject 分享模型
/// @param channels 分享渠道
/// @param completion 回调
/// @param functions 功能
+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                       functions:(NSArray<SAShareFunction> *)functions
                      completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗（分享链接的话自动添加复制链接按钮）
/// @param shareObject 分享模型
/// @param channels 分享渠道
/// @param completion 回调
/// @param functions 功能
/// @param hiddenFunctions 隐藏功能按键
+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                       functions:(NSArray<SAShareFunction> *)functions
                 hiddenFunctions:(BOOL)hiddenFunctions
                      completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗
/// @param shareObject 分享模型
/// @param functionModels 除去分享渠道的其他操作按钮模型
/// @param completion 回调
+ (void)showShareWithShareObject:(SAShareObject *)shareObject functionModels:(NSArray<HDSocialShareCellModel *> *)functionModels completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗
/// @param shareObject 分享模型
/// @param channels 分享渠道
/// @param functionModels 除去分享渠道的其他操作按钮模型
/// @param completion 回调
+ (void)showShareWithShareObject:(SAShareObject *)shareObject
                      inChannels:(NSArray<SAShareChannel> *)channels
                  functionModels:(NSArray<HDSocialShareCellModel *> *)functionModels
                      completion:(ShareObjectCompletion _Nullable)completion;

/// 弹出分享弹窗(顶部带自定义视图)
/// @param topCustomView 顶部自定义视图
/// @param completion 回调
+ (void)showShareWithTopCustomView:(SASocialShareBaseGenerateImageView *)topCustomView completion:(ShareObjectCompletion _Nullable)completion;

/// 复制链接按钮模型（只支持分享网页链接，其他情况会自动删除该按钮）
+ (HDSocialShareCellModel *)copyLinkFunctionModel;
/// 生成图片按钮模型（只支持分享网页链接，其他情况会自动删除该按钮）
+ (HDSocialShareCellModel *)generateImageFunctionModel;
/// 保存图片按钮模型（只支持分享图片，其他情况会自动删除该按钮）
+ (HDSocialShareCellModel *)saveImageFunctionModel;

@end

NS_ASSUME_NONNULL_END
