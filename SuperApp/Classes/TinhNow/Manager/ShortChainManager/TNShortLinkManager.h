//
//  ShortChainManager.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class TNShareModel;


@interface TNShortLinkModel : TNModel
/// 原始长链接
@property (nonatomic, copy) NSString *longUrl;
/// 常规短链接
@property (nonatomic, copy) NSString *shortUrl;
/// 针对FB等容易查封的动态链接
@property (nonatomic, copy) NSString *spareUrl;
/// 短链接code
@property (nonatomic, copy) NSString *shortCode;
/// 分享标题
@property (nonatomic, copy) NSString *shareTitle;
/// 分享内容
@property (nonatomic, copy) NSString *shareContent;
/// 分享图片
@property (nonatomic, copy) NSString *shareImage;
@end


@interface TNShortLinkManager : TNModel
+ (instancetype)sharedInstance;
/// 获取短链
/// @param originalLink 原始链接  必须有值
/// @param completion 返回短链
- (void)getShortLinkByOriginalLink:(NSString *)originalLink completion:(void (^__nullable)(TNShortLinkModel *linkModel))completion;

/// 获取短链  并返回相应的分享字段
/// @param shareModel 分享模型
/// @param completion 返回生成的分享字段
- (void)getShortLinkByShareModel:(TNShareModel *)shareModel completion:(void (^)(TNShortLinkModel *linkModel))completion;
@end

NS_ASSUME_NONNULL_END
