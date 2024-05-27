//
//  CMSImageItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSImageItemConfig : SAModel

/// 图片链接
@property (nonatomic, copy) NSString *imageUrl;
/// 广告名称
@property (nonatomic, copy) NSString *imageName;
/// 跳转链接
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END
