//
//  TNStoreHomeView.h
//  SuperApp
//
//  Created by 张杰 on 2021/7/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNStoreHomeView : TNView
/// 更多分类点击
@property (nonatomic, copy) void (^moreCategoryClickCallback)(void);
@end

NS_ASSUME_NONNULL_END
