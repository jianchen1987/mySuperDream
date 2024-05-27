//
//  CMSThreeImage1_1ItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSThreeImage1x1ItemConfig : SAModel

/// 图片
@property (nonatomic, copy) NSString *imageUrl;
/// 跳转链接
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END
