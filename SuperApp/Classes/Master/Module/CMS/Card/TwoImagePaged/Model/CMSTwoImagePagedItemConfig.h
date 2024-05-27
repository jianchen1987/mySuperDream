//
//  CMSTwoImageScrolledItemConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSNode;


@interface CMSTwoImagePagedItemConfig : SAModel

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) NSUInteger titleFont;
@property (nonatomic, copy) NSString *link;

/// 绑定的Node
@property (nonatomic, strong) SACMSNode *node;
@end

NS_ASSUME_NONNULL_END
