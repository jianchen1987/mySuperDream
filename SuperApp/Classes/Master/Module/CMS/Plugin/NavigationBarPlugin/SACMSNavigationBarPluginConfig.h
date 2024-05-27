//
//  SACMSNavigationBarPluginConfig.h
//  SuperApp
//
//  Created by seeu on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSNavigationBarPluginConfig : SACodingModel

///< 图标
@property (nonatomic, copy) NSString *icon;
///< 点击图标跳转
@property (nonatomic, copy) NSString *link;
///< 背景颜色
@property (nonatomic, copy) NSString *backgroundColor;
///< 背景图片
@property (nonatomic, copy) NSString *backgroundImage;
///< 是否开启搜索栏
@property (nonatomic, assign) BOOL enableSearch;
///< 是否开启定位
@property (nonatomic, assign) BOOL enableLocation;
///<  右边坑位
@property (nonatomic, copy) NSString *rightImage;
///< 右边坑位跳转
@property (nonatomic, copy) NSString *rightImageLink;

@end

NS_ASSUME_NONNULL_END
