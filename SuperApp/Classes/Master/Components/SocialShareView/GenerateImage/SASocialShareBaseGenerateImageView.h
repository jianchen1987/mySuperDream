//
//  SASocialShareBaseGenerateImageView.h
//  SuperApp
//
//  Created by Chaos on 2021/1/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAShareMacro.h"

NS_ASSUME_NONNULL_BEGIN

// 分享顶部自定义视图基类，需要继承该类自定义布局
@interface SASocialShareBaseGenerateImageView : SAView

// 根据分享渠道生成图片
- (UIImage *)generateImageWithChannel:(SAShareChannel)channel;

@end

NS_ASSUME_NONNULL_END
