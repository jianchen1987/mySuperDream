//
//  SAOrderNotLoginView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderNotLoginView : SAView
/// 点击了登录/注册
@property (nonatomic, copy) void (^clickedSignInSignUpBTNBlock)(void);
/// 图片
@property (nonatomic, strong, readonly) UIImageView *imageV;
/// 描述
@property (nonatomic, strong, readonly) SALabel *descLB;
/// 登录、注册按钮
@property (nonatomic, strong, readonly) HDUIGhostButton *signInSignUpBTN;
@end

NS_ASSUME_NONNULL_END
