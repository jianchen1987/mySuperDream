//
//  SACMSPluginView.h
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSPluginViewConfig.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSPluginView : SAView
///< config
@property (nonatomic, strong) SACMSPluginViewConfig *config;

- (instancetype)initWithConfig:(SACMSPluginViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
