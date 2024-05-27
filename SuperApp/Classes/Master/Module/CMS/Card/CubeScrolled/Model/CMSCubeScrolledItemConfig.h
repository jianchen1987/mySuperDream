//
//  CMSCubeScrolledItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSCubeScrolledItemConfig : SAModel

/// 图片
@property (nonatomic, copy) NSString *imageUrl;
/// 跳转链接
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END
