//
//  CMSKingKongAreaAppView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaItemConfig.h"
#import "SAView.h"
#import <SDWebImage/SDAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN


@interface CMSKingKongAreaAppView : SAView
@property (nonatomic, strong) CMSKingKongAreaItemConfig *config;            ///< 动态配置
@property (nonatomic, strong, readonly) UILabel *nameLabel;                 ///< 名称
@property (nonatomic, strong, readonly) SDAnimatedImageView *logoImageView; ///< 图
@end

NS_ASSUME_NONNULL_END
