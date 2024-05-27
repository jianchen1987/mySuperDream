//
//  TNCustomTabBarView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCustomTabBarConfig.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNCustomTabBarView : TNView
+ (instancetype)tabBarViewWithConfig:(TNCustomTabBarConfig *)config;
@property (nonatomic, copy) void (^tabBarItemClickCallBack)(NSInteger index); ///<
@property (nonatomic, assign) BOOL selectedIndex;                             ///< 选中
@end

NS_ASSUME_NONNULL_END
