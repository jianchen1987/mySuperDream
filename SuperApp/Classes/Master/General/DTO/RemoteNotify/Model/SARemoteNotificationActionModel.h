//
//  SARemoteNotificationActionModel.h
//  SuperApp
//
//  Created by seeu on 2022/7/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SARemoteNotificationActionType) { SARemoteNotificationActionTypeAlert = 10, SARemoteNotificationActionTypeToast = 11 };


@interface SARemoteNotificationActionModel : SACodingModel
///< 类型
@property (nonatomic, assign) SARemoteNotificationActionType type;
///< 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
///< 副标题
@property (nonatomic, strong) SAInternationalizationModel *subTitle;
///< 背景图片
@property (nonatomic, strong) SAInternationalizationModel *image;
///< 内容
@property (nonatomic, strong) SAInternationalizationModel *content;
///< 跳转链接
@property (nonatomic, strong) SAInternationalizationModel *link;

@end

NS_ASSUME_NONNULL_END
