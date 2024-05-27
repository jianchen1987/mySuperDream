//
//  TNHomeViewScrollItemView.h
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class TNScrollContentModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNHomeViewScrollItemView : SAView

/// 模型
@property (nonatomic, strong) TNScrollContentModel *model;

@end

NS_ASSUME_NONNULL_END
