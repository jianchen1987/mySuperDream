//
//  SAVersionAlertViewConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAVersionAlertViewConfig : SACodingModel

@property (nonatomic, strong) UIImage *illustrationImage;     ///< 插画
@property (nonatomic, copy) NSString *updateVersion;          ///< 最新版本号
@property (nonatomic, copy) NSString *updateInfo;             ///< 更新内容
@property (nonatomic, copy) NSString *versionId;              ///< 更新记录ID
@property (nonatomic, copy) NSString *AppId;                  ///< 跳转store的ID
@property (nonatomic, copy) SAVersionUpdateModel updateModel; ///< 更新方式
@property (nonatomic, copy) NSString *packageLink;            ///< 包链接
@property (nonatomic, assign) BOOL ignoreCache;               ///< 忽略缓存, YES 每次都弹，NO 有缓存就不弹

@end

NS_ASSUME_NONNULL_END
