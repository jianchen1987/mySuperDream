//
//  SAShareImageObject.h
//  SuperApp
//
//  Created by Chaos on 2020/12/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShareObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAShareImageObject : SAShareObject

/** 分享单个图片（支持UIImage以及图片链接Url ）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, strong) id shareImage;

/** 分享图片数据
 * @note 微信最终分享时使用（facebook使用shareImage），外部传入则优先使用，否则会自动使用shareImage转换
 */
@property (nonatomic, strong) NSData *shareImageData;

@end

NS_ASSUME_NONNULL_END
