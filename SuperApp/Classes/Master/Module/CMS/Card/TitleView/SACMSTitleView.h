//
//  SACMSTitleView.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSTitleViewConfig.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSTitleView : SAView

/// 点击回调
@property (nonatomic, copy) void (^clickTitleView)(NSString *_Nullable link, NSString *_Nullable spm);
/// 配置
@property (nonatomic, strong) SACMSTitleViewConfig *config;

- (CGFloat)heightOfTitleView;

@end

NS_ASSUME_NONNULL_END
