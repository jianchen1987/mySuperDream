//
//  SAKingKongAreaAppView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppFunctionModel.h"
#import "SAKingKongAreaItemConfig.h"
#import "SANormalAppModel.h"
#import "SAView.h"
#import <SDWebImage/SDAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNKingKongAreaAppView : SAView
@property (nonatomic, strong) SAAppFunctionModel *model;                    ///< 本地配置
@property (nonatomic, strong) SAKingKongAreaItemConfig *config;             ///< 动态配置
@property (nonatomic, strong, readonly) UILabel *nameLabel;                 ///< 名称
@property (nonatomic, strong, readonly) SDAnimatedImageView *logoImageView; ///< 图
@property (nonatomic, strong, readonly, nullable) id currentConfig;         ///< 当前配置
@end

NS_ASSUME_NONNULL_END
