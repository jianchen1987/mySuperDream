//
//  TNPictureDiscoveryView.h
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNPictureDiscoveryView : TNView
/// 关闭回调
@property (nonatomic, copy) void (^dimissCallBack)(void);

/// 目标图片
@property (strong, nonatomic) id targetImage;
@end

NS_ASSUME_NONNULL_END
