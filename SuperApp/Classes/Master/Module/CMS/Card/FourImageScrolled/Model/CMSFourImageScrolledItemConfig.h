//
//  CMSFourImageScrolledItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SACMSNode;


@interface CMSFourImageScrolledItemConfig : SAModel

/// 图片
@property (nonatomic, copy) NSString *imageUrl;
/// 跳转链接
@property (nonatomic, copy) NSString *link;

/// 绑定的Node
@property (nonatomic, strong) SACMSNode *node;
@end

NS_ASSUME_NONNULL_END
