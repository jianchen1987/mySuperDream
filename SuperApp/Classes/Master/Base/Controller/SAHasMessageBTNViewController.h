//
//  SAHasMessageBTNViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/6/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 如果界面上需要显示消息按钮则继承此控制器
@interface SAHasMessageBTNViewController : SALoginlessViewController
/// 客户端类型
@property (nonatomic, copy) SAClientType clientType;
@end

NS_ASSUME_NONNULL_END
