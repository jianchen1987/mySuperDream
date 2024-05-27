//
//  SANavigationController.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SANavigationController : UINavigationController
/** 记录 TODO 事件 */
@property (nonatomic, copy) void (^toDoEventBlock)(void);
/// 是否登录逻辑的导航控制器
@property (nonatomic, assign) BOOL isLoginLogicAssociated;
@end

NS_ASSUME_NONNULL_END
